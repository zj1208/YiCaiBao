//
//  WYShopCartModel.m
//  YiShangbao
//
//  Created by light on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCartModel.h"

@implementation WYShopCartModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"productCount"            :@"productCount",
             @"quantityLimit"           :@"quantityLimit",
             @"shopUrl"                 :@"shopUrl",
             @"productUrl"              :@"productUrl",
             @"tipInfo"                 :@"tipInfo",
             @"list"                    :@"list",
             @"invalidProducts"         :@"invalidProducts",
             };
}

+ (NSValueTransformer *)listJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShopCartShopInfoModel class]];
}

+ (NSValueTransformer *)invalidProductsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShopCartLoseGoodsModel class]];
}

@end

@implementation WYShopCartShopInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopId"      :@"shopId",
             @"shopName"    :@"shopName",
             @"products"    :@"products",
             };
}

+ (NSValueTransformer *)productsJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYShopCartGoodsModel class]];
}

@end

@implementation WYShopCartGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"cartId"      :@"cartId",
             @"goodsId"     :@"id",
             @"name"        :@"name",
             @"picUrl"      :@"picUrl",
             @"price"       :@"price",
             @"price4Disp"  :@"price4Disp",
             @"spec"        :@"spec",
             @"moq"         :@"moq",
             @"unit"        :@"unit",
             @"quantity"    :@"quantity",
             };
}

@end

@implementation WYShopCartLoseGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"label"       :@"label",
             @"cartId"      :@"cartId",
             @"goodsId"     :@"id",
             @"name"        :@"name",
             @"picUrl"      :@"picUrl",
             @"spec"        :@"spec",
             @"desc"        :@"desc",
             };
}

@end

@implementation WYGoodsPriceModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"price"       :@"price",
             @"price4Disp"  :@"price4Disp",
             @"moq"         :@"moq",
             };
}

@end
