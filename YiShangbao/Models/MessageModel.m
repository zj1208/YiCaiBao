//
//  MessageModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageModel.h"





@implementation shareModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"title" : @"title",
             @"content" : @"content",
             @"pic" :@"pic",
             @"link" :@"link",
             };
}

@end

@implementation advArrModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"pic" : @"pic",
             @"desc" : @"desc",
             @"url" :@"url",
             @"iid" :@"id",
             @"areaId" :@"areaId"
             };
}

@end
@implementation AdvModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"type" : @"type",
             @"num" : @"num",
             @"advArr" :@"items"
             };
}

+ (NSValueTransformer *)advArrJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[advArrModel class]];
}

@end

@implementation FenLeiLunboAdvModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"catId" : @"catId",
             @"desc" : @"desc",
             @"url" :@"url",
             @"iid" :@"id",
             @"pic" :@"pic"

             };
}

@end


@implementation ShopMustReadAdvModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"advId"    : @"id",
             @"areaId"   : @"areaId",
             @"desc"     : @"desc",
             @"url"      : @"url",
             @"title"    : @"title",
             @"pic"      : @"pic",
             @"clickSum" : @"clickSum",
             };
}

@end


@implementation ShopMustReadAdvFatherModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"list"    : @"list",
             @"redDot"   : @"redDot"
             };
}

+ (NSValueTransformer *)listJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ShopMustReadAdvModel class]];
}

@end


@implementation VersionModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"version" : @"version",
             @"versionCode" : @"versionCode",
             @"desc" :@"desc",
             @"url" :@"url",
             @"isForce" :@"isForce"
             };
}

@end




@implementation SoundModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"enableSubject" : @"enableSubject",
             @"enableFan" : @"enableFan",
             @"enableVisitor" :@"enableVisitor"
             };
}

@end



@implementation SubMsgModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"abbr" : @"abbr",
             @"date" : @"date"
             };
}
@end


@implementation MessageModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"num" : @"num",
             @"type" : @"type",
             @"typeName" : @"typeName",
             @"typeIcon" : @"typeIcon",
             @"subMsg": @"subMsg",
             @"url" :@"url"
             };
}

+ (NSValueTransformer *)subMsgModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[SubMsgModel class]];
}
@end




@implementation MessageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"list" :@"list",
             @"grid" :@"grid",

             };
}

+ (NSValueTransformer *)listJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MessageModelSub class]];
}

+ (NSValueTransformer *)gridJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MessageModelSub class]];
}
@end


@implementation MessageDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
              @"title":@"title",
              @"image":@"image",
              @"abbr":@"abbr",
              @"date":@"date",
              @"url":@"url",
              @"dateYmd" :@"dateYmd"
             };
}
@end







@implementation IMChatInfoModelProSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"proId":@"id",
             @"pic":@"pic",
             @"url":@"url",
             @"name":@"name",
             @"price":@"price",
             };
}
@end

@implementation IMChatInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"uid":@"uid",
             @"accid":@"accid",
             @"url":@"url",
             @"shopUrl":@"shopUrl",
             @"product":@"product",
             };
}

//+ (NSValueTransformer *)productJSONTransformer
//{
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[IMChatInfoModelProSub class]];
//}
@end




