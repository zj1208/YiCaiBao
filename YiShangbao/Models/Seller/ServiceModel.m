//
//  ServiceModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ServiceModel.h"

@implementation MenuListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"index"       :   @"index",
             @"name"        :   @"name",
             @"alias"       :   @"alias",
             @"icon"        :   @"icon",
             @"url"         :   @"url",
             @"login1st"    :   @"login1st",
             @"forceShop2nd":   @"forceShop2nd",
             @"idtf3rd"     :   @"idtf3rd",
             @"sideOfPic"     :   @"sideOfPic",

             
             };
}

@end




@implementation ServiceMenuModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"row"      :   @"row",
             @"menuList" :   @"menuList",
             };
}

+ (NSValueTransformer *)menuListJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MenuListModel class]];
}
@end



@implementation ServiceModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"zrzzID"      :   @"id",
             @"picOne"      :   @"picOne",
             @"boothno"     :   @"boothno",
             @"submarket"   :   @"submarket",
             @"subfloor"    :   @"subfloor",
             @"subindustry" :   @"subindustry",
             @"type"        :   @"type",
             @"boothmodel"  :   @"boothmodel",
             
             @"subindustryValue":@"subindustryValue",
             @"typeValue"   :   @"typeValue",
             @"submarketValue": @"submarketValue",
             @"createTimeValue":@"createTimeValue",
             @"boothmodelValue":@"boothmodelValue",
             @"titleValue"  :   @"titleValue",
             
             @"updateTimeValue":@"updateTimeValue",
             @"isRecommend":@"isRecommend"
             };
}
@end

@implementation SubletListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"records"             :@"records",
             @"subletDetailUrl"     :@"subletDetailUrl",
             @"subletListUrl"       :@"subletListUrl"
             };
}

+ (NSValueTransformer *)recordsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ServiceModel class]];
}

@end
