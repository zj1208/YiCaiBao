//
//  WYDataCache.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/11/14.
//  Copyright © 2017年 yangjianliang. All rights reserved.
//


//待思考：存储数据是否需要加密
#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

typedef void(^completion)(NSString*description);
@interface WYDataCache : NSObject

/**
 *  获取缓存对象，用于沙盒硬盘缓存方案
 *
 *  @return 返回缓存对象（单利）
 */
+ (WYDataCache *)shareDataCache;

/**缓存时效（单位秒)*/
@property (nonatomic, assign)NSTimeInterval qfTime;
/**获取当前所有缓存大小，单位MB，保留两位小数eg:@"13.21"*/
@property (nonatomic, strong ,readonly )NSString *dataCacheSize;
/**
 清除缓存
 @param completion 缓存文件不存在，或缓存文件存在清除失败才会走block
 @return YES表示缓存文件存在且清除成功，NO失败然后会走block并返回错误信息
*/
-(BOOL)removeDataCache:(completion)completion;

#pragma mark - 获取数据
/**
 *  数据存储-JSONObject
 *
 *  @param jsonObj 要存储的json对象数据，例如AFNWorking请求返回封装好的json对象
 *  @param path 沙盒路径下WYDataCache缓存文件名称（缓存文件命名由URL转成MD5定义）
 */
- (BOOL)saveDataWithJSONObject:(nullable id)jsonObj path:(NSString *)path;
/**
 *  数据存储-NSData
 *
 *  @param data 要存储的NSData数据,例如原生NSURLSessionTask请求返回的NSData
 *  @param path 沙盒路径下WYDataCache缓存文件名称（缓存文件命名由URL转成MD5定义）
 */
- (BOOL)saveData:(nullable NSData *)data path:(NSString *)path;
/**
 *  数据存储-JSONObject
 *
 *  @param page 必须大于0页数123...用于存储分页数据
 */
- (BOOL)saveDataWithJSONObject:(nullable id )jsonObj path:(NSString *)path page:(nullable NSNumber*)page;
/**
 *  数据存储-NSData
 *
 *  @param page 必须大于0页数123...用于存储分页数据
 */
- (BOOL)saveData:(nullable NSData *)data path:(NSString *)path page:(nullable NSNumber*)page;

#pragma mark - 获取数据
/**
 *  数据获取-JSONObject
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @return 返回JSONObject对象
 */
- (nullable id)getJSONObjectWithPath:(NSString *)path;
/**
 *  数据获取-NSData
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @return 返回NSData数据
*/
- (nullable NSData *)getDataWithPath:(NSString *)path;
/**
 *  数据获取-JSONObject
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @param page 页数，用于获取分页缓存数据
 *  @return 返回JSONObject对象

 */
- (nullable id)getJSONObjectWithPath:(NSString *)path page:(nullable NSNumber*)page;
/**
 *  数据获取-NSData
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @param page 页数，用于获取分页缓存数据
 *  @return 返回NSData数据
 
 */
- (nullable NSData *)getDataWithPath:(NSString *)path page:(nullable NSNumber*)page;

/**
 *  获取分页所有缓存数据-NSData
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @param read 是否读取更早时间的分页数据;eg:上次用户操作只缓存了3页数据，此时缓存还存在第4.5.6页数据(更早时间缓存下来的)，NO只会读取三页数据
 *  @return 返回NSData数组,数组个数表示当前缓存的最大页数，中间页数无的话NSNull占位
 */
- (nullable NSArray<NSData*> *)getAllPageData:(NSString*)path readEarlierPages:(BOOL)read;
/**
 *  获取分页所有缓存数据-JSONObject
 *
 *  @param path 沙盒路径存下WYDataCache缓存文件夹需要取得文件名称，根据存入数据时传的path去取（缓存文件命名由URL转成MD5定义）
 *  @param read 是否读取更早时间的分页数据;eg:上次用户操作只缓存了3页数据，此时缓存还存在第4.5.6页数据(更早时间缓存下来的)，NO只会读取三页数据
 *  @return 返回JSONObject数组,数组个数表示当前缓存的最大页数，中间页数无的话NSNull占位
 */
- (nullable NSArray *)getAllPageJSONObjects:(NSString*)path readEarlierPages:(BOOL)read;

@end
NS_ASSUME_NONNULL_END
