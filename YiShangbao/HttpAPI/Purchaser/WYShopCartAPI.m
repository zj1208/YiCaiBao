//
//  WYShopCartAPI.m
//  YiShangbao
//
//  Created by light on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCartAPI.h"

#import "WYShopCartModel.h"

@implementation WYShopCartAPI

- (void)getBuyerShopCartSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:Get_buyer_cartInfo_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYShopCartModel *model = [MTLJSONAdapter modelOfClass:[WYShopCartModel class] fromJSONDictionary:data error:error];
            if (failure&&error){
                failure(*error);
            }else{
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
    
}

- (void)postBuyerModifyCartInfoCartId:(NSString *)cartId quantity:(NSInteger)quantity success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (cartId){
        [parameters setObject:cartId forKey:@"cartId"];
    }
    if (quantity){
        [parameters setObject:@(quantity) forKey:@"quantity"];
    }
    [self postRequest:Post_buyer_modifyCartInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYGoodsPriceModel *model = [MTLJSONAdapter modelOfClass:[WYGoodsPriceModel class] fromJSONDictionary:data error:error];
            if (failure&&error){
                failure(*error);
            }else{
                if (success) {
                    success(model);
                }
            }\
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)postBuyerDeleteProductCartIds:(NSArray *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (cartIds){
        [parameters setObject:cartIds forKey:@"cartIds"];
    }
    
    [self postRequest:Post_buyer_deleteProduct_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)postBuyerClearInvalidProductSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self postRequest:Post_buyer_clearInvalidProduct_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYShopCartModel *model = [MTLJSONAdapter modelOfClass:[WYShopCartModel class] fromJSONDictionary:data error:error];
            if (failure&&error){
                failure(*error);
            }else{
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)postBuySettleCartWithCartIds:(NSArray *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (cartIds){
        [parameters setObject:cartIds forKey:@"cartIds"];
    }
    [self postRequest:Post_buyer_settleCart_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

@end
