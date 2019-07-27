//
//  ExtendModel.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendModel.h"

@implementation ExtendAlertViewModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"redirect_url"               :   @"url",
             @"redirect_msg"                :   @"msg",
             @"redirect_btn1"              :   @"btn1",
             @"redirect_btn2"                 :   @"btn2",
             
             };
}
@end

@implementation ExtendModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"wordsNum"               :   @"wordsNum",
             @"cateNum"                :   @"cateNum",
             @"cateLevel"              :   @"cateLevel",
             @"picNum"                 :   @"picNum",
             @"sysCateIdLast"          :   @"sysCateIdLast",
             @"sysCateNameLast"        :   @"sysCateNameLast"

             };
}
@end


@implementation ExtendShopModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"icon"              :   @"icon",
             @"name"                :   @"name",
             @"EMid"              :   @"id",
             @"addr"               :   @"addr",
             @"qrCode"               :   @"qrCode",

             };
}
@end

@implementation ExtendSelectProcuctModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"url"              :   @"url",
             @"iid"                :   @"id",
             @"model"              :   @"model",
             @"name"               :   @"name",
             @"priceDisp"               :   @"priceDisp",
             @"mainPic"               :   @"mainPic",
             };
}
+ (NSValueTransformer *)mainPicJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:AliOSSPicUploadModel.class];
}
@end

@implementation ExtendUpLoadModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"p"              :   @"p",
             @"h"                :   @"h",
             @"w"              :   @"w",
             @"pid"               :   @"pid",
             };
}
@end

@implementation ExtendOldModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"intro"              :   @"intro",
             @"sysCateId"                :   @"sysCateId",
             @"sysCateName"                :   @"sysCateName",
             @"pics"              :   @"pics",
             };
}
+ (NSValueTransformer *)picsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ExtendOldPicModel class]];
}
@end

@implementation ExtendOldPicModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"p"              :   @"p",
             @"h"                :   @"h",
             @"w"              :   @"w",
             @"pid"               :   @"pid",
             @"url"               :   @"url",

             };
}
@end



