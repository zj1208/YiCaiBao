//
//  TranslationDataManager.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//


#import "TranslationDataManager.h"
#import <FMDB.h>

#define TraDataPath [NSHomeDirectory() stringByAppendingString:@"/Documents/WYTranslation"]

static NSString *const T_translation = @"T_translation";
static NSString *const T_translationDelete = @"T_translationDelete";
@interface TranslationDataManager ()
{
    FMDatabase *_dataBase;//目前不支持多线程，需要时用FMDatabaseQueue
}
@end

@implementation TranslationDataManager
+(TranslationDataManager *)shareTranslationDataManager
{
    static dispatch_once_t once;
    static TranslationDataManager *mInstance;
    dispatch_once(&once, ^{
        mInstance = [[TranslationDataManager alloc] init];
    });
    return mInstance;
}
- (instancetype)init
{
    if (self = [super init]) {
        [self creatDBTable];
    }
    return self;
}
#pragma mark - 创建表
-(void)creatDBTable
{
    //创建文件夹
    NSFileManager* fileManager = [NSFileManager defaultManager];
    [fileManager createDirectoryAtPath:TraDataPath withIntermediateDirectories:YES attributes:nil error:nil];
   
    //创建数据库
    NSString *dbPath = [TraDataPath stringByAppendingPathComponent:@"WYTranslation.db"];
    _dataBase = [[FMDatabase alloc] initWithPath:dbPath];
    NSLog(@"%@",TraDataPath);
    
    [_dataBase open];
    //创建数据表，一张实际展示、一张存储删除数据（删除暂不真删除,将来可能要数据恢复，因为翻译内容不上传公司服务器,删了就没了）
    NSString * T_translationSql = @"CREATE TABLE IF NOT EXISTS T_translation(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,languageType INTEGER,chinese TEXT,english TEXT,TranslationFailure TEXT,time TEXT)";
    if ([_dataBase executeUpdate:T_translationSql]){
        NSLog(@"T_translation success");
    }
    NSString * T_translationDeleteSql = @"CREATE TABLE IF NOT EXISTS T_translationDelete(ID INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,languageType INTEGER,chinese TEXT,english TEXT,TranslationFailure TEXT,time TEXT)";
    if ([_dataBase executeUpdate:T_translationDeleteSql]) {
        NSLog(@"T_translationDelete success");
    }
    [_dataBase close];
}
#pragma mark - 插入数据
-(long)insertDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        // 插入数据
       BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translation(languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?)",[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
        if (insertOK) {
            NSLog(@"MSCTranslationModel insert Success");
            
            long insertID = [_dataBase lastInsertRowId];//插入id
            [_dataBase close];
            return insertID;
        }else{
            NSLog(@"MSCTranslationModel insert Fail");
        }
        [_dataBase close];
    }
    return model.iid;
}
#pragma mark - 修改数据
-(void)updateDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        BOOL updateOK = [_dataBase executeUpdate:[NSString stringWithFormat:@"UPDATE %@ SET chinese = ? , english = ? , TranslationFailure = ? where ID = ? limit 1",T_translation],model.chinese,model.english,model.TranslationFailure,[NSNumber numberWithInt:model.iid]];
        if (updateOK) {
            NSLog(@"MSCTranslationModel updateData Success");
        }else{
            NSLog(@"MSCTranslationModel updateData Fail");
        }
        
        [_dataBase close];
    }
}
#pragma mark - 删除数据，同时将数据插入删除数据表
-(void)deleteDataWithModel:(MSCTranslationModel *)model
{
    if ([_dataBase open]) {
        NSString *delSQL = [NSString stringWithFormat:@"delete  from T_translation where ID = %d",model.iid];
        if ([_dataBase executeUpdate:delSQL]) {
            NSLog(@"MSCTranslationModel delete Success");
        }else{
            NSLog(@"MSCTranslationModel delete Fail");
        }
        
        //数据迁入删除表(暂时不管删除数据，存着后续数据恢复等)
        BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translationDelete(ID, languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?,?)",@(model.iid),[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
        if (insertOK) {
            NSLog(@"MSCTranslationModel Copy insert Success");
        }else{
            NSLog(@"MSCTranslationModel Copy insert Fail");
        }
        [_dataBase close];
    }
}
#pragma mark - 获取所有数据
-(NSArray<__kindof MSCTranslationModel *> *)queryAllData
{
    if ([_dataBase open]) {

        NSString *selSql = [NSString stringWithFormat:@"select * from T_translation"];
        NSMutableArray* arrayM = [NSMutableArray array];
        FMResultSet *set = [_dataBase executeQuery:selSql];
        if (set != nil) {
            NSLog(@"T_translation query Success");
            while ([set next]) {
                MSCTranslationModel *model = [[MSCTranslationModel alloc] initWithSet:set];
                [arrayM addObject:model];
            }
            [set close];
            [_dataBase close];
            return arrayM;
        }
    }
     [_dataBase close];
    return [NSArray array];
}
// 将删除的数据恢复
-(void)testRestoreData
{
    if ([_dataBase open]) {
        
        NSString *selSql = [NSString stringWithFormat:@"select * from T_translationDelete "];
        FMResultSet *set = [_dataBase executeQuery:selSql];
        if (set != nil) {
            NSLog(@"T_translationDelete query Success");
            while ([set next]) {
                MSCTranslationModel *model = [[MSCTranslationModel alloc] initWithSet:set];
                //存在更新、不存在插入，这只是测试用
                BOOL insertOK = [_dataBase executeUpdate:@"INSERT INTO T_translation(ID,languageType,chinese,english,TranslationFailure,time) VALUES (?,?,?,?,?,?)",@(model.iid),[NSNumber numberWithInteger:model.languageType],model.chinese,model.english,model.TranslationFailure,model.time];
                NSLog(@"%d",insertOK);

            }
            [set close];
        }
    }
    [_dataBase close];
}
#pragma mark 获取数据库数据，并将早先归档存储的数据迁移到数据库
-(NSArray<__kindof MSCTranslationModel *> *)getAllMSCTModelData
{
//    [self testRestoreData];
    
    NSArray *arrayDB = [self queryAllData];
    if (arrayDB.count>0) {
        return arrayDB;
    }else{
        BOOL resultHistory = [[NSFileManager defaultManager] fileExistsAtPath:kMSCTranslationDataPath];
        if (resultHistory) {
            NSArray *arrHistory = [self getTranslationData];
            if (arrHistory.count>0) {
                for (int i=0; i<arrHistory.count; ++i) {
                    MSCTranslationModel *model = arrHistory[i];
                    [self insertDataWithModel:model];
                }
                NSArray *arrayDBNow = [self queryAllData];
                if (arrayDBNow.count == arrHistory.count ) {
                    NSLog(@"migration and remove Data Success");//数据库第一个版本先不删除吧
//                    BOOL deleteOK = [[NSFileManager defaultManager] removeItemAtPath:kMSCTranslationDataPath error:nil];
//                    if (deleteOK) {
//                        NSLog(@"migration and remove Data Success");
//                    }else{
//                        NSLog(@"migration and remove Data Fail");
//                    }
                }
                return arrayDBNow;
            }
        }
    }
    return [NSArray array];
}



/**
 以下方法V3.4.0开始废弃
 */
-(void)saveTranslationDataWithModel:(MSCTranslationModel *)model
{
    NSMutableArray* arrayM = [NSMutableArray arrayWithArray:[self getTranslationData] ];
    [arrayM addObject:model];
    
    [self saveTranslationDataWithArray:arrayM];
}
-(void)replaceLastModelWithModel:(MSCTranslationModel *)model
{
    NSMutableArray* arrayM = [NSMutableArray arrayWithArray:[self getTranslationData] ];
    if (arrayM.count>0) {
        [arrayM replaceObjectAtIndex:arrayM.count-1 withObject:model];
    }
    [self saveTranslationDataWithArray:arrayM];
}
-(void)saveTranslationDataWithArray:(NSArray*)array
{
    //自定义对象不能直接存入文件，必须遵循NSCoding协议
    NSMutableData* data = [[NSMutableData alloc]init];
    //归档对象
    NSKeyedArchiver* keyedarchiver = [[NSKeyedArchiver alloc]initForWritingWithMutableData:data];
    //存储数据
    [keyedarchiver encodeObject:array forKey:@"TranslationData"];
    //封口
    [keyedarchiver finishEncoding];
    //写入磁盘
    [data writeToFile:kMSCTranslationDataPath atomically:YES];
    
}
-(NSArray *)getTranslationData
{
    //解档
    NSData* dataone = [[NSData alloc] initWithContentsOfFile:kMSCTranslationDataPath];
    //通过解档对象解档
    NSKeyedUnarchiver* keyedunarchiver = [[NSKeyedUnarchiver alloc]initForReadingWithData:dataone];
    //取出存储对象
    NSArray* array = [keyedunarchiver decodeObjectForKey:@"TranslationData"];
    //封口
    [keyedunarchiver finishDecoding];

    if (array) {
        return array;
    }else{
        return [NSArray array];
    }
}


@end
