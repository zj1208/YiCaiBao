 //
//  WYDataCache.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/11/14.
//  Copyright © 2017年 yangjianliang. All rights reserved.
//
//缓存路径
#define WYDataCachePath [NSHomeDirectory() stringByAppendingString:@"/Library/Caches/WYDataCache"]

#import "WYDataCache.h"

static WYDataCache *_dataCache;
@implementation WYDataCache
+ (WYDataCache *)shareDataCache
{
    if (_dataCache == nil) {
        _dataCache = [[WYDataCache alloc] init];
        NSLog(@"%@",WYDataCachePath);
    }
    return _dataCache;
}
- (instancetype)init
{
    if (self = [super init]) {
        _qfTime = 60*60*24*7;
    }
    return self;
}

- (BOOL)saveData:(NSData *)data path:(NSString *)path
{
   return [self saveData:data path:path page:nil];
}
-(BOOL)saveDataWithJSONObject:(id)jsonObj path:(NSString *)path
{
   //AFN的json转data写入
    NSData *databyJsonObj = [self exchangeByJSONObject:jsonObj];
    if (databyJsonObj) {
        return [self saveData:databyJsonObj path:path page:nil];
    }
    return NO;
}
-(BOOL)saveDataWithJSONObject:(id)jsonObj path:(NSString *)path page:(NSNumber *)page
{
    NSData *databyJsonObj = [self exchangeByJSONObject:jsonObj];
    if (databyJsonObj) {
        return [self saveData:databyJsonObj path:path page:page];
    }
    return NO;
}
#pragma mark 添加或重置更新某一页数据
- (BOOL)saveData:(NSData *)data path:(NSString *)path page:(NSNumber*)page
{
    return [self saveData:data path:path page:page AutoRemove:NO]; //default NO
}
/**remove 更新第二页时是否自动删除更早缓存的第3.4.5.页等。 未开放在.h*/
- (BOOL)saveData:(NSData *)data path:(NSString *)path page:(NSNumber*)page AutoRemove:(BOOL)remove
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error=nil;
    BOOL boo = [fileManager createDirectoryAtPath:WYDataCachePath withIntermediateDirectories:YES attributes:nil error:&error];
    if (!boo) {
        NSLog(@"自动创建缓存文件夹失败%@",error);
        return NO;
    }

    // filePath = 沙盒/Documents/WYDataCache + 文件的名字(url->MD5) + page
    NSString *pathMD5 = [NSString zhCreatedMD5String:path];
    NSString *filePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
    if (page) {
        NSString *pagePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
        NSError *error=nil;
        BOOL booCreat = [fileManager createDirectoryAtPath:pagePath withIntermediateDirectories:YES attributes:nil error:&error];
        if (!booCreat) {
            NSLog(@"创建分页缓存文件夹失败%@",error);
            return NO;
        }
        filePath = [pagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",pathMD5,page]];
    }
    
    if (remove && page) {
        [self removeLaterPagesDataWithPath:path page:page];
    }
    
    BOOL writeOK = [data writeToFile:filePath atomically:YES]; //data=nil写入文件返回失败，系统不会创建文件
    return writeOK;

}

-(NSData *)getDataWithPath:(NSString *)path
{
   return [self getDataWithPath:path page:nil];
}
-(id)getJSONObjectWithPath:(NSString *)path
{
    NSData* data = [self getDataWithPath:path page:nil];
    return [self exchangeByData:data];
}
-(id)getJSONObjectWithPath:(NSString *)path page:(NSNumber *)page
{
    NSData* data = [self getDataWithPath:path page:page];
    return [self exchangeByData:data];
}
-(NSArray *)getAllPageJSONObjects:(NSString *)path readEarlierPages:(BOOL)read
{
    NSMutableArray *arrayM = [NSMutableArray array];
    NSArray *array = [self getAllPageData:path readEarlierPages:read];
    for (int i = 0; i<array.count; ++i) {
        NSData *data = array[i];
        if (data) {
            id dict = [self exchangeByData:data];//data转Json对象
            if (dict) {
                [arrayM addObject:dict];
            }else{
                [arrayM addObject:[NSNull null]];
            }
        }else{
            [arrayM addObject:[NSNull null]];
        }
    }
    return [NSArray arrayWithArray:arrayM];
}

-(NSArray<NSData *> *)getAllPageData:(NSString *)path readEarlierPages:(BOOL)read
{
    NSString *pathMD5 = [NSString zhCreatedMD5String:path];
    NSString *filePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exixtBoo = [fileManager fileExistsAtPath:filePath];
    if (!exixtBoo) {
        return nil;
    }
    NSError* error = nil;
    NSArray* arrayPages =  [fileManager contentsOfDirectoryAtPath:filePath error:&error];//浅度遍历
    if (error || !arrayPages) {
        NSLog(@"\n未遍历到缓存的分页数据%@\n%@",filePath,error);
        return nil;
    }
    if (arrayPages.count>0) {
        
        NSMutableArray *arrayEffective = [NSMutableArray array];
        NSInteger maxPage = 0; //获取最大页码
        for (NSString *filstr in arrayPages) {//取出正确有效缓存文件
            NSLog(@"%@",filstr);
            NSArray* array = [filstr componentsSeparatedByString:@"_"];
            if (array.count == 2) {
                NSString *first = array.firstObject;
                NSString *second = array.lastObject;
                BOOL firstBo = first.length == 32?YES:NO;//MD5
                NSScanner* scan = [NSScanner scannerWithString:second];
                int val;
                BOOL secondBo = [scan scanInt:&val] && [scan isAtEnd];
                if (firstBo && secondBo) {
                    [arrayEffective addObject:filstr];
                    if (second.integerValue>maxPage) {
                        maxPage = second.integerValue;
                    }
                }
            }
        }
        NSMutableArray *arraySort = [NSMutableArray array];
        NSInteger maxPage_needReading = 0; 
        NSDate* lastDate = [NSDate dateWithTimeIntervalSince1970:0];
        for (int i = 1; i<= maxPage; ++i) { //排序正确有效缓存文件，并获取上次更新到第几页
            NSString *file = [NSString stringWithFormat:@"%@_%d",pathMD5,i];
            for (int j = 0; j<arrayEffective.count; ++j) {
                NSString* fileStr = [NSString stringWithString:arrayEffective[j]];
                if ([fileStr isEqualToString:file]) {
                    NSString *fileCurry = [filePath stringByAppendingPathComponent:file];
                    NSDictionary *dict = [fileManager attributesOfItemAtPath:fileCurry error:nil];
                    NSDate *fileUpadteDate = dict[NSFileModificationDate];
                    if ([lastDate compare:fileUpadteDate] == NSOrderedAscending || read) {//判断上次缓存的还是更早时间缓存
                        lastDate = fileUpadteDate;
                        [arraySort addObject:file];
                        NSArray* arraySep = [file componentsSeparatedByString:@"_"];
                        maxPage_needReading = [arraySep.lastObject integerValue]; //获取上次更新的最大页码数
                    }
                }
            }
        }
        NSMutableArray *arrayM = [NSMutableArray array];
        for (int i = 0; i< maxPage_needReading; ++i) { //自动NSNull填补中间丢失数据页码
            filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%d",pathMD5,i+1]];
            NSData *data = [self getDataWithPath:path page:@(i+1)];
            if (!data) {
                [arrayM addObject:[NSNull null]];
            }else{
                [arrayM addObject:data];
            }
        }
        return [NSArray arrayWithArray:arrayM];
    }
    return nil;
}
#pragma mark 读取某一页数据
-(NSData *)getDataWithPath:(NSString *)path page:(NSNumber *)page
{
   return [self getDataWithPath:path page:page readOutTimeData:YES];
}
/**readOutTime 是否有时间限制。未开放在.h */
-(NSData *)getDataWithPath:(NSString *)path page:(NSNumber *)page readOutTimeData:(BOOL)readOutTime
{
    NSString *pathMD5 = [NSString zhCreatedMD5String:path];
    NSString *filePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
    if (page) {
        NSString *pagePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
        filePath = [pagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",pathMD5,page]];
    }
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exixtBoo = [fileManager fileExistsAtPath:filePath];
    if (!exixtBoo) {
        return nil;
    }
    // 校验时效:获取文件最后修改的时间
    NSDictionary *dict = [fileManager attributesOfItemAtPath:filePath error:nil];
    NSDate *lastDate = dict[NSFileModificationDate];
    NSTimeInterval inte = [[NSDate date] timeIntervalSinceDate:lastDate];
    
    if (!readOutTime) {//是否读取所有数据，忽律超时的限制
        if (_qfTime < inte) {// 校验超出时效
            return nil;
        }
    }
    
    // 返回数据
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}
#pragma mark 根据完整路径删除缓存文件
-(BOOL)removeDataWithCacheFullPath:(NSString *)fullPath completion:(completion)completion
{
    NSFileManager* manager = [NSFileManager defaultManager];
    BOOL exixtBoo = [manager fileExistsAtPath:fullPath];
    if (!exixtBoo) {
        if (completion) {
            completion(@"文件不存在");
        }
        return NO;
    }
    NSError *error=nil;
    BOOL removeBool = [manager removeItemAtPath:fullPath error:&error];
    if (removeBool) {
        return YES;
    }else{
        if (completion) {
            completion([error localizedDescription]);
        }
        return NO;
    }
}
#pragma mark 清除某一页之后页数数据
-(void)removeLaterPagesDataWithPath:(NSString *)path page:(NSNumber*)page
{
    NSString *pathMD5 = [NSString zhCreatedMD5String:path];
    NSString *filePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL exixtBoo = [fileManager fileExistsAtPath:filePath];
    if (!exixtBoo) {
        NSLog(@"\n不存在可删除分页数据文件夹");
        return ;
    }
    NSError* error = nil;
    NSArray* arrayPages =  [fileManager contentsOfDirectoryAtPath:filePath error:&error];//浅度遍历
    if (error || !arrayPages) {
        NSLog(@"\n未遍历到缓存的可删除的分页数据%@\n%@",filePath,error);
        return ;
    }
    if (arrayPages.count>0) {
        for (NSString *filstr in arrayPages) {
            NSArray* array = [filstr componentsSeparatedByString:@"_"];
            if (array.count == 2) {
                NSString *first = array.firstObject;
                NSString *second = array.lastObject;
                BOOL firstBo = first.length == 32?YES:NO;//MD5
                NSScanner* scan = [NSScanner scannerWithString:second];
                int val;
                BOOL secondBo = [scan scanInt:&val] && [scan isAtEnd];
                if (firstBo && secondBo) {
                    if (second.integerValue > page.integerValue) {
                        [self removeDataWithPath:path  page:[NSNumber numberWithInteger:second.integerValue]];
                    }
                }
            }
        }
    }
    
}
#pragma mark 清除某一页数据
-(void)removeDataWithPath:(NSString *)path page:(NSNumber*)page
{
    NSString *pathMD5 = [NSString zhCreatedMD5String:path];
    NSString *filePath = [WYDataCachePath stringByAppendingPathComponent:pathMD5];
    if (page) {
        filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@",pathMD5,page]];
    }
    [self removeDataWithCacheFullPath:filePath completion:nil];
}
#pragma mark - NSData转JSON对象
-(id)exchangeByData:(NSData*)data
{
    if (data) {    //data转Json对象
        NSError *error=nil;
        id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error==nil && data)
        {
            return dic;
        }
        NSLog(@"NSData转JSON对象失败:%@",error);
    }
    return nil;
}
#pragma mark - JSON对象转NSData
-(NSData *)exchangeByJSONObject:(id)jsonObj
{
    if (jsonObj == nil || jsonObj == NULL || [jsonObj isKindOfClass:[NSNull class]]) {
        return nil;
    }
    //AFN的json转data写入
    NSError *error=nil;
    NSData* databyJsonObj = [NSJSONSerialization dataWithJSONObject:jsonObj options:NSJSONWritingPrettyPrinted error:&error];
    if (error==nil && databyJsonObj) {
        return databyJsonObj;
    }
    NSLog(@"JSON对象转NSData失败:%@",error);
    return nil;
}
#pragma mark - 清除缓存
-(BOOL)removeDataCache:(completion)completion
{
    BOOL removeBo = [self removeDataWithCacheFullPath:WYDataCachePath completion:^(NSString * _Nonnull description) {
        completion(description);
    }];
    return removeBo;
}
#pragma mark 获取缓存大小
-(NSString *)dataCacheSize
{
    float size = [self folderSizeAtPath:WYDataCachePath];
    NSString* str = [NSString stringWithFormat:@"%.2f",size];
    return str;
}
- (long long) fileSizeAtPath:(NSString*) filePath{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath]){
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
- (float ) folderSizeAtPath:(NSString*) folderPath{
    
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    long long folderSize = 0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil){
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    return folderSize/(1024.0*1024.0);
}
@end


