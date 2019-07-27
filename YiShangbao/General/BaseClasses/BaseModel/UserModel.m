//
//  UserModel.m
//  
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "UserModel.h"
@implementation BaseInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iconUrl"        :    @"iconUrl",
             @"nickname"       :    @"nickname",
             @"sex"            :    @"sex"
             };
}

@end

@implementation BuyerInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"sex"             :    @"sex",
             @"iconUrl"         :    @"iconUrl",
             @"companyName"     :    @"companyName",
             @"locationName"    :    @"locationName",
             @"buyProducts"     :    @"buyProducts",
             @"intro"           :    @"intro"
             };
}

@end

@implementation sellerInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shopId"              :    @"shopId",
             @"shopIconUrl"         :    @"shopIconUrl",
             @"shopName"            :    @"shopName",
             @"authStatus"          :    @"authStatus",
             @"specialSupplier"     :    @"specialSupplier",
             @"mgrPeriod"           :    @"mgrPeriod",
             @"mgrType"             :    @"mgrType",
             @"address"             :    @"address",
             @"mainSell"            :    @"mainSell"
             };
}

@end


@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"baseInfo"    :   @"baseInfo",
             @"buyerInfo"   :   @"buyerInfo",
             @"sellerInfo"  :   @"sellerInfo",
             
             @"userId" : @"userid",
             @"nickname" : @"nickname",
             @"sex" : @"sex",
             @"phone":@"phone",
             @"headURL":@"headIcon",
             @"province":@"pro",
             @"authStatus":@"authStatus",
             @"city":@"city",
             @"autograph":@"autograph",
             @"bindWechat":@"bindWechat",
             @"needSetPwd":@"needSetPwd",
             @"nickPhone":@"nickPhone",
             @"countryCode":@"countryCode",
             @"QQ":@"qq",
             @"score"           :@"score",
             @"scoreUrl"           :@"scoreUrl",
             @"record"           :@"record",
             };
}

+ (NSValueTransformer *)baseInfoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BaseInfoModel class]];
}
+ (NSValueTransformer *)buyerInfoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BuyerInfoModel class]];
}
+ (NSValueTransformer *)sellerInfoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[sellerInfoModel class]];
}

@end

@implementation RecordModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"prodCount"        :   @"prodCount",
             @"stockCount"      :   @"stockCount",
             @"bizCount"        :   @"bizCount",
             @"subjectCount"    :   @"subjectCount",
             };
}

@end

