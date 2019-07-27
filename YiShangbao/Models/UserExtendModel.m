//
//  UserExtendModel.m
//  YiShangbao
//
//  Created by simon on 2018/4/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UserExtendModel.h"

@implementation UserExtendModel

@end

@implementation BaseBuyerModel

@end;


@implementation OnlineCustomerListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizUid"          :@"bizUid",
             @"nickName"        :@"nickName",
             @"headIcon"        :@"headIcon",
             @"companyName"     :@"companyName",
             
             @"buyerBadges"     :@"buyerBadges",
             
             };
}

+ (NSValueTransformer *)buyerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end

@implementation CustomerInfoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"icon"          :@"icon",
             @"nickName"        :@"nickName",
             @"companyName"        :@"companyName",
             @"remark"     :@"remark",
             @"mobile"     :@"mobile",
             @"address"     :@"address",
             @"describe"     :@"describe",
             @"buyProducts"     :@"buyProducts",
             };
}
@end


@implementation WYShareLinkmanModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"icon"        :@"icon",
             @"nick"        :@"nick",
             @"remark"      :@"remark",
             @"bizUid"      :@"bizUid",
             };
}

@end


@implementation WYShareLinkmanListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"imDay"               :@"imDay",
             @"imList"              :@"imList",
             @"fansDay"             :@"fansDay",
             @"fansList"            :@"fansList",
             @"visitorsDay"         :@"visitorsDay",
             @"visitorsList"        :@"visitorsList",
             };
}

+ (NSValueTransformer *)imListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShareLinkmanModel class]];
}

+ (NSValueTransformer *)fansListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShareLinkmanModel class]];
}

+ (NSValueTransformer *)visitorsListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShareLinkmanModel class]];
}

@end
