//
//  WYPublicAPI.m
//  YiShangbao
//
//  Created by light on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPublicAPI.h"


@implementation WYPublicAPI

- (void)getBuyerDefaultDeliveryAddressSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:Get_buyer_getDefaultDeliveryAddress_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYDefaultDeliveryAddressModel *model = [MTLJSONAdapter modelOfClass:[WYDefaultDeliveryAddressModel class] fromJSONDictionary:data error:error];
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

- (void)postBuyerAddDeliveryName:(NSString *)deliveryName deliveryPhone:(NSString *)deliveryPhone provCode:(NSString *)prov cityCode:(NSString *)city townCode:(NSString *)town addressName:(NSString *)address success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary * dic = @{
                               @"deliveryName"      :deliveryName,
                               @"deliveryPhone"     :deliveryPhone,
                               @"provCode"          :prov,
                               @"address"           :address,
                               };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (city){
        [parameters setObject:city forKey:@"cityCode"];
    }
    if (town){
        [parameters setObject:town forKey:@"townCode"];
    }
    
    [self postRequest:Post_buyer_addDeliveryAddress_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYDefaultDeliveryAddressModel *model = [MTLJSONAdapter modelOfClass:[WYDefaultDeliveryAddressModel class] fromJSONDictionary:data error:error];
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

- (void)postBuyerUpdateAddressId:(NSNumber *)addressId deliveryName:(NSString *)deliveryName deliveryPhone:(NSString *)deliveryPhone provCode:(NSString *)prov cityCode:(NSString *)city townCode:(NSString *)town addressName:(NSString *)address success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary * dic = @{
                           @"addressId"         :addressId,
                           @"deliveryName"      :deliveryName,
                           @"deliveryPhone"     :deliveryPhone,
                           @"provCode"              :prov,
                           @"address"           :address,
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (city){
        [parameters setObject:city forKey:@"cityCode"];
    }
    if (town){
        [parameters setObject:town forKey:@"townCode"];
    }
    
    [self postRequest:Post_buyer_updateDeliveryAddress_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYDefaultDeliveryAddressModel *model = [MTLJSONAdapter modelOfClass:[WYDefaultDeliveryAddressModel class] fromJSONDictionary:data error:error];
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

- (void)getAccountPayWaySuccess:(CompleteBlock)success failure:(ErrorBlock)failure{ 
    [self getRequest:Get_account_payWays_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYPayWayModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            
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

- (void)getPaymentOrderByOrderId:(NSString *)orderId payType:(NSInteger)payType success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (orderId){
        [parameters setObject:orderId forKey:@"orderId"];
    }
    if (payType){
        [parameters setObject:@(payType) forKey:@"payType"];
    }
    [self getRequest:Get_account_paymentOrderSign_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            id model;
            if (payType == 1) {
                model = [data objectForKey:@"sign"];
            }else if(payType == 2) {
                model = [MTLJSONAdapter modelOfClass:[WYWechatPaymentModel class] fromJSONDictionary:data error:error];
            }
        
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

- (void)getDuibaLoginUrlSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:Get_account_DuibaLogin_URL parameters:nil success:^(id data) {
        if ([[data allKeys] containsObject:@"duibaUrl"]) {
            NSString *url = [data objectForKey:@"duibaUrl"];
            if (success) {
                success(url);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)getServiceManagerUrlSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:Get_account_ServiceManager_URL parameters:nil success:^(id data) {
        if ([[data allKeys] containsObject:@"serviceUrl"]) {
            NSString *url = [data objectForKey:@"serviceUrl"];
            if (success) {
                success(url);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)getServiceConfirmOrderByFuncType:(WYServiceFunctionType)funcType success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (funcType){
        [parameters setObject:@(funcType) forKey:@"funcType"];
    }
    [self getRequest:kService_buy_ssConfirmOrder_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYServicePlaceOrderModel *model = [MTLJSONAdapter modelOfClass:[WYServicePlaceOrderModel class] fromJSONDictionary:data error:error];
            
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

- (void)postCreatServiceOrderBycomboId:(NSInteger)comboId type:(WYServiceAuthenticationType)type funcType:(WYServiceFunctionType)funcType outOrderId:(NSString *)outOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (comboId){
        [parameters setObject:@(comboId) forKey:@"comboId"];
    }
    if (type){
        [parameters setObject:@(type) forKey:@"type"];
    }
    if (funcType){
        [parameters setObject:@(funcType) forKey:@"funcType"];
    }
    if (outOrderId){
        [parameters setObject:outOrderId forKey:@"outOrderId"];
    }
    [self postRequest:kService_buy_ssCreateOrder_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYServiceCreatOrderModel *model = [MTLJSONAdapter modelOfClass:[WYServiceCreatOrderModel class] fromJSONDictionary:data error:error];
            
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

- (void)getBuyQueryAuthenticationInfoComboId:(NSString *)comboId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (comboId){
        [parameters setObject:comboId forKey:@"comboId"];
    }
    [self getRequest:Get_buy_querySsInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            WYAuthenticationInfoModel *model = [MTLJSONAdapter modelOfClass:[WYAuthenticationInfoModel class] fromJSONDictionary:data error:error];
            
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


- (void)getHtmlStringsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kPublic_getSeoUrls_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            LocalHtmlStringManagersModel *model = [MTLJSONAdapter modelOfClass:[LocalHtmlStringManagersModel class] fromJSONDictionary:data error:error];
            if (error){
                if (failure) failure(*error);
            }else
            {
                if (success){
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
