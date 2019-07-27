//
//  SMCustomerModel.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMCustomerModel.h"


@implementation SMCustomerAddModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"              :   @"id",
             @"companyName"              :   @"companyName",
             @"contact"            :   @"contact",
             @"mobile"            :   @"mobile",
             @"fax"            :   @"fax",
             @"email"            :   @"email",
             @"address"            :   @"address",
             @"wechat"            :   @"wechat",
             @"remark"            :   @"remark",
             
             };
}
@end


@implementation SMCustomerSubModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"              :   @"id",
             @"mobile"            :   @"mobile",
             @"contact"            :   @"contact",
             @"companyName"            :   @"companyName",
             };
}
@end

@implementation SMCustomerModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"group"              :   @"group",
             @"list"            :   @"list",
             };
}

+ (NSValueTransformer *)listJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SMCustomerSubModel class]];
}
@end

@implementation SMCusArrdessBookModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"              :   @"contact",
             @"phone"            :   @"mobile",
             };
}
@end
