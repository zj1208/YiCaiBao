//
//  WYAttentionAPI.m
//  YiShangbao
//
//  Created by light on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYAttentionAPI.h"
#import "WYAttentionModel.h"

@implementation WYAttentionAPI

//100044_获取我关注的商铺动态列表
- (void)getFollowShopsDynamicsPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize type:(NSNumber *)type requestId:(NSString *)requestId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    if (!requestId) {
        requestId = @"";
    }
    NSDictionary *parameters = @{
                                 @"pageNo":pageNo,
                                 @"pageSize":pageSize,
                                 @"type":type,
                                 @"requestId":requestId
                                 };
    [self getRequest:kAttention_buyer_followShopsDynamics_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYAttentionsModel *model = [MTLJSONAdapter modelOfClass:[WYAttentionsModel class] fromJSONDictionary:data error:nil];
            if (failure&&error){
                failure(*error);
            }else{
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



//100045_获取关注中精选商铺

- (void)getBuyerPriseSuppliersType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"type":type,
                                 };
    [self getRequest:kAttention_buyer_priseSuppliers_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYSupplierModel class] fromJSONArray:[data objectForKey:@"priseSupplierVOs"] error:error];
            if (failure&&error){
                failure(*error);
            }else{
                if (success) {
                    success(array);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

@end
