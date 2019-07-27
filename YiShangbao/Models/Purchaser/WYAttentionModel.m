//
//  WYAttentionModel.m
//  YiShangbao
//
//  Created by light on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYAttentionModel.h"

@implementation WYAttentionModel

@end

@implementation WYSupplierModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopId"      :@"shopId",
             @"shopIcon"    :@"shopIcon",
             @"shopName"    :@"shopName",
             @"mainSell"    :@"mainSell",
             @"authStatus"  :@"authStatus",
             @"iconUrl"     :@"iconUrl",
             @"width"       :@"width",
             @"height"      :@"height",
             @"link"        :@"link",
             };
}

@end


@implementation WYAttentionProdutModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"produteId"   :@"id",
             @"picUrl"      :@"picUrl",
             @"linkUrl"     :@"linkUrl",
             };
}

@end

@implementation WYAttentionMessageModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopHeadPicUrl"      :@"shopHeadPicUrl",
             @"shopName"            :@"shopName",
             @"followType"          :@"followType",
             @"followTypeName"      :@"followTypeName",
             @"desc"                :@"desc",
             @"products"            :@"products",
             @"time"                :@"time",
             @"sellerId"            :@"sellerId",
             @"shopId"              :@"shopId",
             @"shopUrl"             :@"shopUrl",
             @"icons"               :@"icons",
             @"showFollow"          :@"showFollow",
             };
}

+ (NSValueTransformer *)productsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYAttentionProdutModel class]];
}

+ (NSValueTransformer *)iconsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}

@end

@implementation WYAttentionADVModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"advId"           :@"advId",
             @"aderIcon"        :@"aderIcon",
             @"aderInfo"        :@"aderInfo",
             @"adPics"          :@"adPics",
             @"adContentInfo"   :@"adContentInfo",
             @"adUrl"           :@"adUrl",
             @"mark"            :@"mark",
             };
}

@end

@implementation WYAttentionContentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"contentType"     :@"contentType",
             @"baseVO"          :@"baseVO",
             @"adVO"            :@"baseVO",
             };
}

@end

@implementation WYAttentionsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"remark"      :@"remark",
             @"responseId"  :@"responseId",
             @"list"        :@"list",
             @"page"        :@"page",
             };
}

+ (NSValueTransformer *)listJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYAttentionContentModel class]];
}

@end
