//
//  WYPlaceOrderAPI.m
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPlaceOrderAPI.h"
#import "WYPlaceOrderModel.h"

@implementation WYPlaceOrderAPI

- (void)getBuyerConfirmOrderWithItemId:(NSInteger)itemId quantity:(NSInteger)quantity skuId:(NSNumber *)skuId cartIds:(NSString *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure{
//    NSDictionary * dic = @{
//                           @"itemId":itemId,
//                           @"quantity":quantity,
//                           @"skuId" :skuId,
//                           @"cartIds" :cartIds,
//                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    if (itemId){
        [parameters setObject:@(itemId) forKey:@"itemId"];
    }
    if (quantity){
        [parameters setObject:@(quantity) forKey:@"quantity"];
    }
    if (cartIds){
        [parameters setObject:cartIds forKey:@"cartIds"];
    }
    
    [self getRequest:Get_buyer_confirmOrder_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYConfirmOrderInfoModel *model = [MTLJSONAdapter modelOfClass:[WYConfirmOrderInfoModel class] fromJSONDictionary:data error:error];
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

- (void)postBuyerCreatOrderAddress:(NSDictionary *)address orderList:(NSArray *)orderList success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary * parameters = @{@"req":@{
                           @"address"       :address,
                           @"orderList"     :orderList,
                           }};
    
    [self postRequest:buyer_createOrder_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYCreatOrderSuccessModel *model = [MTLJSONAdapter modelOfClass:[WYCreatOrderSuccessModel class] fromJSONDictionary:data error:error];
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

@end
