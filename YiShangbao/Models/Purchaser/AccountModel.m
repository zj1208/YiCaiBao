//
//  AccountModel.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AccountModel.h"

@implementation AccountSubmitModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"estimateArrivalTimeDesc"           :         @"estimateArrivalTimeDesc",
             @"bankName"    :         @"bankName",
             @"bankCardNo"    :         @"bankCardNo",
             @"amount"    :         @"amount",
             @"fee"    :         @"fee",

             };
}


@end

@implementation AccountConfirmPhoneModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"countryCode"           :         @"countryCode",
             @"phone"    :         @"phone",
            
             };
}


@end

@implementation AccountModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userCardId"           :         @"userCardId",
             @"bankId"    :         @"bankId",
             @"bankIcon"    :         @"bankIcon",
             @"bankName"    :         @"bankName",
             @"bankCardNo"    :         @"bankCardNo",
             @"bankAcctName"    :         @"bankAcctName",
             @"canWithdrawAmount"    :         @"canWithdrawAmount",
             @"freeQuota"    :         @"freeQuota",
             @"feeRate"    :         @"feeRate",
             @"desc"    :         @"desc",
             @"ruleDescUrl"    :         @"ruleDescUrl",

             };
}
@end

@implementation DouXinAccountModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"mobile"              :  @"mobile",
             @"inviteSource"        :   @"inviteSource",
             @"uid"                 :    @"uid",
             
             };
}

@end

