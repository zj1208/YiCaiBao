//
//  AccountApi.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//    ------资金账号管理-------

#import "AccountApi.h"
#import "AccountModel.h"

@implementation AccountApi
/**
 110002_获取提现信息接口
 
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAccountWithdrawalsInfoSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{

    [self getRequest:kAccount_getWithdrawalsInfo_URL parameters:nil success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            AccountModel *model = [MTLJSONAdapter modelOfClass:[AccountModel class] fromJSONDictionary:data error:error];
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
        if (failure)
        {
            failure(error);
        }
    }];

}


/**
 110003_确认提现申请接口
 
 @param userCardId string	用户银行卡信息id
 @param bankId string	银行id
 @param bankCardNo string	银行卡号
 @param bankAcctName string	银行账户名
 @param amount long 提现金额
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountConfirmWithdrawalsWithuserCardId:(NSString *)userCardId bankId:(NSString*)bankId bankCardNo:(NSString*)bankCardNo  bankAcctName:(NSString*)bankAcctName amount:(NSInteger)amount success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"userCardId":userCardId,
                                  @"bankId":bankId,
                                  @"bankCardNo":bankCardNo,
                                  @"bankAcctName":bankAcctName,
                                  @"amount":@(amount),

                                  };
    
    [self postRequest:kAccount_confirmWithdrawals_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            AccountConfirmPhoneModel *model = [MTLJSONAdapter modelOfClass:[AccountConfirmPhoneModel class] fromJSONDictionary:data error:error];

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
        if (failure)
        {
            failure(error);
        }
    }];

}

/**
 110003_确认提现申请接口(和上一个接口一样，只是传入参数把银行卡整理到一个字典了，方便处理“选择银行卡”选择后返回的数据模型不一样)

 @param bankInfoDcit 银行卡信息字典
 @param amount long 提现金额,单位为分
 */
- (void)PostAccountConfirmWithBankInfoDict:(NSDictionary*)bankInfoDcit amount:(NSDecimalNumber*)amount success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:bankInfoDcit];
    [parameters setObject:amount forKey:@"amount"];

    [self postRequest:kAccount_confirmWithdrawals_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            AccountConfirmPhoneModel *model = [MTLJSONAdapter modelOfClass:[AccountConfirmPhoneModel class] fromJSONDictionary:data error:error];
            
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
        if (failure)
        {
            failure(error);
        }
    }];
    

}

/**
 110004_提交提现申请接口
 
 @param userCardId string	用户银行卡信息id
 @param bankId string	银行id
 @param bankCardNo string	银行卡号
 @param bankAcctName string	银行账户名
 @param amount long 提现金额
 @param verificationCode 短信验证码
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountSubmitWithdrawalsWithuserCardId:(NSString *)userCardId bankId:(NSString*)bankId bankCardNo:(NSString*)bankCardNo  bankAcctName:(NSString*)bankAcctName amount:(NSDecimalNumber*)amount  verificationCode:(NSString*)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"userCardId":userCardId,
                                  @"bankId":bankId,
                                  @"bankCardNo":bankCardNo,
                                  @"bankAcctName":bankAcctName,
                                  @"amount":amount,
                                  @"verificationCode":verificationCode,

                                  };
    
    [self postRequest:kAccount_submitWithdrawals_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            AccountSubmitModel *model = [MTLJSONAdapter modelOfClass:[AccountSubmitModel class] fromJSONDictionary:data error:error];
            
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
        if (failure)
        {
            failure(error);
        }
    }];
    

}
/**
 110004_提交提现申请接口(2)--------------------
 (和上一个接口一样功能，只是传入参数把银行卡整理到一个字典了，方便处理“选择银行卡”的数据模型不一样问题)
 
 @param bankInfoDcit 银行卡信息字典
 @param amount 提现金额,单位为分
 @param verificationCode 短信验证码
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountSubmitWithBankInfoDict:(NSDictionary*)bankInfoDcit amount:(NSDecimalNumber*)amount  verificationCode:(NSString*)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSMutableDictionary * parameters = [NSMutableDictionary dictionaryWithDictionary:bankInfoDcit];
    [parameters setObject:amount forKey:@"amount"];
    [parameters setObject:verificationCode forKey:@"verificationCode"];

    [self postRequest:kAccount_submitWithdrawals_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            AccountSubmitModel *model = [MTLJSONAdapter modelOfClass:[AccountSubmitModel class] fromJSONDictionary:data error:error];
            
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
        if (failure)
        {
            failure(error);
        }
    }];

}

//100046_判断是否授权兜信
- (void)getCheckUserAuhtorizedWithType:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dict  = @{
                            @"type":type,
                            };
    
    [self getRequest:kAccount_checkUserAuhtorized_URL parameters:dict success:^(id data) {
        if (success){
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

//100047_确认授权
- (void)postConfirmUserAuthorizeWithType:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dict  = @{
                            @"type":type,
                            };
    [self postRequest:kAccount_confirmUserAuthorize_URL parameters:dict success:^(id data) {
        if (success){
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


//110009_开通兜信账户
- (void)postCreateDouxinAccountWithAddress:(NSString *)address latitude:(NSString *)latitude longitude:(NSString *)longitude success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (address) {
        [parameters setObject:address forKey:@"address"];
    }
    if (latitude) {
        [parameters setObject:latitude forKey:@"latitude"];
    }
    if (longitude) {
        [parameters setObject:longitude forKey:@"longitude"];
    }
    [self postRequest:kAccount_createDouxinAccount_URL parameters:parameters success:^(id data) {
        
        if (success){
            NSError *__autoreleasing *error = nil;
            DouXinAccountModel *model = [MTLJSONAdapter modelOfClass:[DouXinAccountModel class] fromJSONDictionary:data error:error];
            
            if (failure&&error){
                failure(*error);
            }else {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


@end
