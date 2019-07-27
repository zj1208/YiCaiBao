//
//  QRModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "QRModel.h"

@implementation QRItemsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"pic"        :   @"pic",
             @"desc"       :   @"desc",
             @"url"        :   @"url",
             @"iid"        :   @"id"

             };
}
@end

@implementation TipModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"items"        :   @"items",
             @"type"       :   @"type",
             @"num"        :   @"num"
             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[QRItemsModel class]];
}
@end



@implementation QRModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"shopIcon"            :   @"shopIcon",
             @"shopName"            :   @"shopName",
//             @"serviceIcons"        :   @"serviceIcons",
             @"address"             :   @"address",
             @"qrBgPicUrl"          :   @"qrBgPicUrl",
             @"qrCodeUrl"           :   @"qrCodeUrl",
             @"shopInfoUrl"         :   @"shopInfoUrl",
             @"tip"                 :   @"tip",
             @"sellerBadges"        :  @"sellerBadges"
             };
}

+ (NSValueTransformer *)tipJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[TipModel class]];
}

+ (NSValueTransformer *)sellerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end
