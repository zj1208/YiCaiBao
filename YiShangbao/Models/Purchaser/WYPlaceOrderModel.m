//
//  WYPlaceOrderModel.m
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPlaceOrderModel.h"

@implementation WYPlaceOrderModel

@end

@implementation WYConfirmOrderInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"address"             :@"address",
             @"orderSumInfo"        :@"orderSumInfo",
             @"orderList"           :@"orderList",
             @"invalidOrderList"    :@"invalidOrderList",
             };
    
}

+ (NSValueTransformer *)orderListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYConfirmOrderModel class]];
}

+ (NSValueTransformer *)invalidOrderListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYConfirmInvalidOrderModel class]];
}

@end

@implementation WYAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"fullName"        :@"fields.fullName",
             @"mobile"          :@"fields.mobile",
             @"addressDetail"   :@"fields.addressDetail",
             @"storage"         :@"storage",
             };
}

@end

@implementation WYOrderSumInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"sumTotalPriceLabel"  :@"fields.sumTotalPriceLabel",
             @"sumTotalPrice"       :@"fields.sumTotalPrice",
             @"tipInfo"             :@"fields.tipInfo",
             };
}

@end

@implementation WYConfirmOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopName"                :@"fields.shopName",
             @"totalQuantityLabel"      :@"fields.totalQuantityLabel",
             @"totalQuantity"           :@"fields.totalQuantity",
             @"totalPriceLabel"         :@"fields.totalPriceLabel",
             @"totalPrice"              :@"fields.totalPrice",
             @"postageLabel"            :@"fields.postageLabel",
             @"postageFee"              :@"fields.postageFee",
             @"storage"                 :@"storage",
             @"itemList"                :@"itemList",
             };
}

+ (NSValueTransformer *)itemListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYConfirmOrderGoodsModel class]];
}

@end

@implementation WYConfirmOrderGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"itemPic"        :@"fields.itemPic",
             @"itemTitle"      :@"fields.itemTitle",
             @"itemPrice"      :@"fields.itemPrice",
             @"skuInfo"        :@"fields.skuInfo",
             @"minQuantity"    :@"fields.minQuantity",
             @"maxQuantity"    :@"fields.maxQuantity",
             @"quantity"       :@"fields.quantity",
             @"storage"        :@"storage",
             };
}

@end

@implementation WYConfirmInvalidOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopName"                :@"fields.shopName",
             @"totalQuantityLabel"      :@"fields.totalQuantityLabel",
             @"totalQuantity"           :@"fields.totalQuantity",
             @"totalPriceLabel"         :@"fields.totalPriceLabel",
             @"totalPrice"              :@"fields.totalPrice",
             @"itemList"                :@"itemList",
//             @"storage"                 :@"storage",
             };
}

+ (NSValueTransformer *)itemListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYConfirmOrderInvalidGoodsModel class]];
}

@end

@implementation WYConfirmOrderInvalidGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"itemPic"        :@"fields.itemPic",
             @"itemTitle"      :@"fields.itemTitle",
             @"itemPrice"      :@"fields.itemPrice",
             @"skuInfo"        :@"fields.skuInfo",
             @"quantity"       :@"fields.quantity",
             @"reason"         :@"fields.reason",
//             @"storage"        :@"storage",
             };
}

@end

@implementation WYCreatOrderExtraInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"jumpPage"        :@"jumpPage",
             };
}
@end

@implementation WYCreatOrderSuccessModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"address"             :@"address",
             @"orderSumInfo"        :@"orderSumInfo",
             @"title"               :@"tipMsg.title",
             @"subTitle"            :@"tipMsg.subTitle",
             @"orderIds"            :@"orderIds",
             @"extraInfo"           :@"extraInfo",
             };
}

@end

@implementation WYCreatOrderSuccessAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"fullName"        :@"fullName",
             @"mobile"          :@"mobile",
             @"addressDetail"   :@"addressDetail",
             };
}

@end

@implementation WYCreatOrderSuccessSumInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"sumTotalPriceLabel"  :@"sumTotalPriceLabel",
             @"sumTotalPrice"       :@"sumTotalPrice",
             @"tipInfo"             :@"tipInfo",
             };
}

@end

