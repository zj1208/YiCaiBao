//
//  PurchaserAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserAPI.h"
#import "PurchaserModel.h"

#import "WYDataCache.h"

@implementation PurchaserAPI

- (void)getProdRecmdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameter = @{
                                @"v":@"2.0"
                                };
    [self getRequest:Get_mtop_shop_store_prodRecmd_URL parameters:parameter success:^(id data) {
        if (success) {
            [[WYDataCache shareDataCache] saveDataWithJSONObject:data path:Get_mtop_shop_store_prodRecmd_URL];
              
            NSError *__autoreleasing *error = nil;
            NSArray * array = [data objectForKey:@"list"];

            NSArray *arrayModel = [MTLJSONAdapter modelsOfClass:[prodRecmdModel class] fromJSONArray:array error:error];
            
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(arrayModel);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (id)getProdRecmdWithSuccess_DataCache
{
    id data = [[WYDataCache shareDataCache] getJSONObjectWithPath:Get_mtop_shop_store_prodRecmd_URL];
    NSArray *array = [data objectForKey:@"list"];
    NSArray *arrayModelCache = [MTLJSONAdapter modelsOfClass:[prodRecmdModel class] fromJSONArray:array error:nil];
    return arrayModelCache;
}
- (void)getShopStandAloneRecmdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure

{
    NSDictionary *parameter = @{
                                @"v":@"2.0"
                                };
    [self getRequest:Get_mtop_shop_store_shopStandAloneRecmd_URL parameters:parameter success:^(id data) {
        if (success) {
            [[WYDataCache shareDataCache] saveDataWithJSONObject:data path:Get_mtop_shop_store_shopStandAloneRecmd_URL];
            if ([data isEqual:[NSNull null]])
            {
                success(nil);
            }
            else
            {
                NSError *__autoreleasing *error = nil;
                NSArray * array = [data objectForKey:@"list"];
                
                NSArray *arrayModel = [MTLJSONAdapter modelsOfClass:[ShopStandAloneRecmdModel class] fromJSONArray:array error:error];
                
                if (failure&&error)
                {
                    failure(*error);
                }
                else
                {
                    success(arrayModel);
                }
            }

        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (id)getShopStandAloneRecmdWithSuccess_DataCache
{
    id data = [[WYDataCache shareDataCache] getJSONObjectWithPath:Get_mtop_shop_store_shopStandAloneRecmd_URL];
    NSArray *array = [data objectForKey:@"list"];
    NSArray *arrayModelCache = [MTLJSONAdapter modelsOfClass:[ShopStandAloneRecmdModel class] fromJSONArray:array error:nil];
    return arrayModelCache;
}




-(void)getPurchaserListWithTimestamp:(NSString *)timestamp preTimestamp:(NSString *)preTimestamp PageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSDictionary * dict = @{
                                  @"pageNo":@(pageNo),
                                  @"pageSize":pageSize,
                                  };
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
   
    if (preTimestamp) {
        [parameters setObject:preTimestamp forKey:@"preTimestamp"];
    }
    if (timestamp) {
        [parameters setObject:timestamp forKey:@"timestamp"];
    }
    
    [self getRequest:Get_search_getRecommendProductList_URL parameters:parameters success:^(id data) {
        
        if (success) {
//            [[WYDataCache shareDataCache] saveDataWithJSONObject:data path:Get_search_getRecommendProductList_URL page:@(pageNo)];

            NSError *__autoreleasing *error = nil;
            NSArray * dataArray = [data objectForKey:@"products"];

            NSArray *array = [MTLJSONAdapter modelsOfClass:[PurchaserListModel class] fromJSONArray:dataArray error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
-(void)getPurchaserListWithTimestamp_DataCache:(void (^)(NSInteger, NSArray *))success
{
//    缓存所有分页数据读取
//    NSMutableArray* arrayM = [NSMutableArray array];
//    NSArray *cacheDataArray = [[WYDataCache shareDataCache] getAllPageJSONObjects:Get_search_getRecommendProductList_URL readEarlierPages:NO];
//    for (int i=0; i<cacheDataArray.count; ++i) { //取出所有缓存数据
//        id data = cacheDataArray[i];
//        NSArray * dataArray = [data objectForKey:@"products"];
//        NSArray *arrayModelCache = [MTLJSONAdapter modelsOfClass:[PurchaserListModel class] fromJSONArray:dataArray error:nil];
//        if (arrayModelCache) {
//            [arrayM addObjectsFromArray:arrayModelCache];
//        }
//    }
//    if (success) {
//        success(cacheDataArray.count , [NSArray arrayWithArray:arrayM]);
//    }
    
//    第一页缓存读取
//    id data = [[WYDataCache shareDataCache] getJSONObjectWithPath:Get_search_getRecommendProductList_URL page:@1];
//    NSArray * dataArray = [data objectForKey:@"products"];
//    NSArray *arrayModelCache = [MTLJSONAdapter modelsOfClass:[PurchaserListModel class] fromJSONArray:dataArray error:nil];
//    return arrayModelCache;
}
- (void)getPurchaserIndexConfigWithMarketId:(NSString *)marketId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dict = @{
                           @"v":@"5.0"
                           
                           };
    
    NSMutableDictionary*parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    
    if (marketId) {
        [parameters setObject:marketId forKey:@"marketId"];
    }
    [self getRequest:Get_mtop_index_getConfig_URL parameters:parameters success:^(id data) {
        if (success) {
            //缓存数据
            [[WYDataCache shareDataCache] saveDataWithJSONObject:data path:[NSString stringWithFormat:@"%@4.0",Get_mtop_index_getConfig_URL]];
            
            NSError *__autoreleasing *error = nil;
//            NSLog(@"%@",[data objectForKey:@"funcBarInfo"]);
            PurchaserModel *model = [MTLJSONAdapter modelOfClass:[PurchaserModel class] fromJSONDictionary:data error:error];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(id)getPurchaserIndexConfigWithMarketId_DataCache
{
    id data = [[WYDataCache shareDataCache] getJSONObjectWithPath:[NSString stringWithFormat:@"%@4.0",Get_mtop_index_getConfig_URL]];
    PurchaserModel *modelCache = [MTLJSONAdapter modelOfClass:[PurchaserModel class] fromJSONDictionary:data error:nil];
    return modelCache;
}

-(void)getAppScanQRWithRoleType:(int)roleType qrOriginStr:(NSString *)qrOriginStr success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"roleType":@(roleType),
                                 @"qrOriginStr":qrOriginStr
                                 };
    [self getRequest:Get_appScanQR_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(data);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}


- (void)getSpreadWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_spread_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;

            SpreadModel *model = [MTLJSONAdapter modelOfClass:[SpreadModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getShopRecmdListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"v":@"2.0"
                                 };
    [self getRequest:Get_ShopRecmdList_URL parameters:parameters success:^(id data) {
        if (success) {
            //缓存数据
            [[WYDataCache shareDataCache] saveDataWithJSONObject:data path:Get_ShopRecmdList_URL];
            
            NSError *__autoreleasing *error = nil;
            NSArray* array = [data objectForKey:@"list"];
            
            NSArray *arrayModel = [MTLJSONAdapter modelsOfClass:[ShopRecmdListModel class] fromJSONArray:array error:error];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(arrayModel);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (id)getShopRecmdListWithSuccess_DataCache
{
    id data = [[WYDataCache shareDataCache] getJSONObjectWithPath:Get_ShopRecmdList_URL];
    NSArray *array = [data objectForKey:@"list"];
    NSArray *arrayModelCache = [MTLJSONAdapter modelsOfClass:[ShopRecmdListModel class] fromJSONArray:array error:nil];
    return arrayModelCache;
}


- (void)getBuyerInfoWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    [self getRequest:Get_BuyerInfo_URL parameters:nil success:^(id data) {
        
        if (success) {
            NSError *__autoreleasing *error = nil;
            BuyerUserModel *model = [MTLJSONAdapter modelOfClass:[BuyerUserModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
