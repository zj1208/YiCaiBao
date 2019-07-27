//
//  OrderManagerModel.m
//  YiShangbao
//
//  Created by simon on 2017/9/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OrderManagerModel.h"

@implementation BaseOrderModel


@end

@implementation BaseOrderModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"subBizOrderId" :@"subBizOrderId",
             @"prodId"      :@"prodId",
             @"prodName" :@"prodName",
             @"prodPic" :@"prodPic",
             @"quantity" :@"quantity",
             @"skuInfo" :@"skuInfo",
             @"price" :@"price",
             @"finalPrice" :@"finalPrice",
             @"discount" :@"discount",
             @"storage" :@"storage",
             };
}



@end




@implementation GetOrderManagerModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId" :@"bizOrderId",
             @"entityId" :@"entityId",
             @"entityName" :@"entityName",
             @"entityUrl" :@"entityUrl",
             @"status" :@"status",
             @"statusV" :@"statusV",
             @"price"      :@"price",
             @"prodsPrice" :@"prodsPrice",
             @"discount" :@"discount",
             @"transFee" :@"transFee",
             @"finalPrice" :@"finalPrice",
             @"prodCount" : @"prodCount",
             
             @"subBizOrders" :@"subBizOrders",
             @"buttons" :@"buttons",

             @"subBizOrderNum":@"storage.total",
             @"showMore" :@"storage.showMore",
             @"buttonCall":@"buttonCall",
             };
}


+ (NSValueTransformer *)subBizOrdersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BaseOrderModelSub class]];
}


+ (NSValueTransformer *)buttonsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderButtonModel class]];
}

@end




@implementation GetOrderStautsCountModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"status":@"status",
             @"orderCount"  :@"count",
             };
}

@end


@implementation PostMdfConfirmOrderModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId":@"bizOrderId",
             @"transFee"  :@"transFee",
             @"prodsPrice":@"prodsPrice",
             
             @"orderProd" :@"orderProd"
             };
}

+ (NSValueTransformer *)orderProdJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PostMdfConfirmOrderModelSub class]];
}

@end

@implementation PostMdfConfirmOrderModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"subBizOrderId":@"subBizOrderId",
             @"nPrice"       :@"newPrice",
             @"quantity"     :@"quantity",
             };
}


@end


#pragma mrak -504102_确认订单获取

@implementation GetConfirmOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId" :@"bizOrderId",
             @"price"      :@"price",
             @"prodsPrice" :@"prodsPrice",
             @"discount"   :@"discount",
             @"transFee"   :@"transFee",
             @"finalPrice" :@"finalPrice",
             @"prodsPrice" :@"prodsPrice",

             @"subBizOrders" :@"subBizOrders",
             @"orderProd" :@"orderProd",
             @"nProdsPrice" :@"nProdsPrice",
             @"nPrice" :@"nPrice"

             };
}

+ (NSValueTransformer *)subBizOrdersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GetConfirmOrderModelSub class]];
}

+ (NSValueTransformer *)orderProdJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GetConfirmOrderModelSub class]];
}

@end


@implementation GetConfirmOrderModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"subBizOrderId" :@"subBizOrderId",
             @"prodId"      :@"prodId",
             @"prodName" :@"prodName",
             @"prodPic" :@"prodPic",
             @"quantity" :@"quantity",
             @"skuInfo" :@"skuInfo",
             @"price" :@"price",
             @"finalPrice" :@"finalPrice",
             @"discount" :@"discount",
             @"totalPrice" :@"totalPrice",
             @"nPrice" :@"newPrice",
             
             @"floatPrice" :@"floatPrice",
             @"ndiscount" :@"ndiscount"
             };
}


@end


#pragma mark - 商户-504110_立即发货接口(供应商)

@implementation GetOrderDeliveryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId" :@"bizOrderId",
             @"productCount" :@"productCount",
             @"orderPic" :@"orderPic",
             @"consignee" :@"consignee",
             @"consigneePhone" :@"consigneePhone",
             @"address":@"address"
             };
}


@end

@implementation PostOrderDeliveryModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId" :@"bizOrderId",
             @"deliveryType" :@"deliveryType",
             @"companyId" :@"companyId",
             @"companyName" :@"companyName",
             @"logisticsNum" :@"logisticsNum",
             };
}


@end
