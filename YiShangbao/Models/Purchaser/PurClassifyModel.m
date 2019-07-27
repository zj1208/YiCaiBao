//
//  PurClassifyModel.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurClassifyModel.h"

@implementation ClassifyAdvModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"     :       @"id",
             @"areaId"    :       @"areaId",
             @"pic"     :       @"pic",
             @"url"     :       @"url",
             @"title"     :       @"title",
             @"desc"     :       @"desc",

             };
}
@end

@implementation ClassifyHotModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"sysCateId"     :       @"sysCateId",
             @"sysCateName"    :       @"sysCateName",
             @"picUrl"     :       @"picUrl",
             @"hotRef"     :       @"hotRef",

             };
}
@end

@implementation BanModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"     :       @"name",
             @"ban"     :       @"list",
             };
}
+ (NSValueTransformer *)banJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ClassifyAdvModel class]];
}
@end

@implementation RecModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"     :       @"name",
             @"rec"    :       @"list",
             };
}
+ (NSValueTransformer *)recJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ClassifyAdvModel class]];
}
@end

@implementation HotModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"     :       @"name",
             @"hot"     :       @"list",
             };
}
+ (NSValueTransformer *)hotJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ClassifyHotModel class]];
}
@end

@implementation MarketNavModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"     :       @"name",
             @"url"     :       @"url",
             @"marketNav"     :       @"list",

             };
}
+ (NSValueTransformer *)marketNavJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ClassifyAdvModel class]];
}
@end

@implementation PurClassifyModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"banModel"     :       @"ban",
             @"recModel"    :       @"rec",
             @"hotModel"     :       @"hot",
             @"marketNavModel"     :       @"marketNav",
             };
}
+ (NSValueTransformer *)banModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[BanModel class]];
}
+ (NSValueTransformer *)recModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[RecModel class]];
}
+ (NSValueTransformer *)hotModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[HotModel class]];
}
+ (NSValueTransformer *)marketNavModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[MarketNavModel class]];
}



@end


