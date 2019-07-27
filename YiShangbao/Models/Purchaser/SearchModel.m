//
//  SearchModel.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"       :         @"id",
             @"picUrl"    :         @"picUrl",
             @"name"      :         @"name",
             @"specs"     :         @"specs",
             @"address"   :         @"address",
             @"price"     :         @"price",
             @"sourceType"     :       @"sourceType",
             @"sourceTypeName" :       @"sourceTypeName",
             @"payMark"      :         @"payMark",
             @"link"      :         @"link",
             };
}
+ (NSValueTransformer *)sourceTypeJSONTransformer
{
    NSDictionary *dic = @{
                          @(1):@(WYSearchProductTypeXianHuo),
                          @(2):@(WYSearchProductTypeDingZuo),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}
@end

@implementation SearchProMainModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"responseId"       :         @"responseId",
             @"flag"    :         @"flag",
             @"products"    :         @"products",
//             @"tryKeywords"    :         @"tryKeywords",

             };
}
+ (NSValueTransformer *)productsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchModel class]];
}
@end

@implementation SearchShopProductsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{
             @"iid"       :         @"id",
             @"picUrl"    :         @"picUrl",
             @"link"         :@"link",
             };
}
@end

@implementation SearchShopModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"           :         @"id",
             @"headPicUrl"    :         @"headPicUrl",
             @"name"          :         @"name",
             @"badges"        :         @"badges",
             @"icons"      :         @"icons",

             @"businessAgeAndMode"     :         @"businessAgeAndMode",
             @"address"      :         @"address",
             @"products"     :       @"products",
             @"resultDesc"   :       @"resultDesc",
             @"mainSell"   :       @"mainSell",
             @"payMark"      :         @"payMark",
             @"link"                :@"link",
             };
}
+ (NSValueTransformer *)productsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchShopProductsModel class]];
}
+ (NSValueTransformer *)iconsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end

@implementation SearchLunBoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"           :         @"id",
             @"headPicUrl"    :         @"headPicUrl",
             @"name"          :         @"name",
             @"badges"        :         @"badges",
             @"icons"        :         @"icons",

             @"businessAgeAndMode"     :         @"businessAgeAndMode",
             @"address"      :         @"address",
             @"payMark"      :         @"payMark",
             @"mainSell"      :         @"mainSell",
             @"link"                :@"link",

             };
}
+ (NSValueTransformer *)iconsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end

@implementation SearchLunBoMainModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shops"           :         @"shops",
             @"shopCnt"          :         @"shopCnt",
             };
}
+ (NSValueTransformer *)shopsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchLunBoModel class]];
}
@end


@implementation SearchLocationsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"           :         @"id",
             @"name"          :         @"name",
             
             };
}
@end
@implementation SearchCatesModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"           :         @"id",
             @"name"          :         @"name",
             
             };
}
@end
@implementation SearchProductSourcesModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"           :         @"id",
             @"name"          :         @"name",
             
             };
}
@end

@implementation SearchScreenModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"locations"           :         @"locations",
             @"cates"          :         @"cates",
             @"productSources"          :         @"productSources",

             };
}
+ (NSValueTransformer *)locationsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchLocationsModel class]];
}
+ (NSValueTransformer *)catesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchCatesModel class]];
}
+ (NSValueTransformer *)productSourcesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SearchProductSourcesModel class]];
}
@end

