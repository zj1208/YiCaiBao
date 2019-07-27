//
//  MakeBillModel.m
//  YiShangbao
//
//  Created by light on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillModel.h"

@implementation MakeBillModel

@end

@implementation MakeBillGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"goodsId"     :@"id",
             @"goodsNo"     :@"goodsNo",
             @"goodsName"   :@"goodsName",
             @"totalNumStr" :@"totalNumStr",
             @"boxNum"      :@"boxNum",
             @"boxPerNum"   :@"boxPerNum",
             @"boxNumStr"   :@"boxNumStr",
             @"boxPerNumStr"    :@"boxPerNumStr",
             @"minUnit"     :@"minUnit",
             @"minPriceDisplay"    :@"minPriceDisplay",
             @"boxSize"     :@"boxSize",
             };
}

@end

@implementation MakeBillInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"BillId"          :@"id",
             @"customerId"      :@"customerId",
             @"customerName"    :@"customerName",
             @"billTime"        :@"billTime",
             @"deliveryTime"    :@"deliveryTime",
             @"remark"          :@"remark",
             @"billNo"          :@"billNo",
             @"planCollectTime" :@"planCollectTime",
             @"totalOrderStr"   :@"totalOrderStr",
             @"payStatus"       :@"payStatus",
             @"deliveryAddress" :@"deliveryAddress",
             };
}

@end


@implementation MakeBillPicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"picId"       :@"id",
             @"picUrl"      :@"picUrl",
             };
}

@end

@implementation MakeBillShareModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"title"       :@"title",
             @"content"      :@"content",
             @"pic"       :@"pic",
             @"link"       :@"link"
             
             };
}
@end



@implementation MakeBillUploadModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"billSale"            :@"billSale",
             @"billGoods"           :@"billGoods",
             @"billPics"            :@"billPics",
             };
}

+ (NSValueTransformer *)billGoodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MakeBillGoodsModel class]];
}

+ (NSValueTransformer *)billPicsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MakeBillPicModel class]];
}
@end

@implementation MakeBillHeadTipModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"show"            :@"show",
             @"contentLeft"     :@"contentLeft",
             @"contentRight"    :@"contentRight",
             };
}

@end

@implementation MakeBillHomeInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"billId"          :@"id",
             @"customerName"    :@"customerName",
             @"totalNum"        :@"totalNum",
             @"totalMoney"      :@"totalMoney",
             @"billTime"        :@"billTime",
             @"payStatus"       :@"payStatus",
             };
}

@end

@implementation MakeBillHomeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"remark"      :@"remark",
             @"list"        :@"list",
             @"page"        :@"page",
             };
}

+ (NSValueTransformer *)listJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[MakeBillHomeInfoModel class]];
}

@end
@implementation MBDisplayClauseModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"display"        :@"display",
             @"content"        :@"content",
             
             @"bankCard"        :@"bankCard",

             };
}
@end

#pragma mark - 数据
             
@implementation BillDataSaleAmountModelSub
             
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"date1" : @"date1",
             @"date2" : @"date2",
             @"totalFee" :@"totalFee",
             @"maxDay" :@"maxDay"
             };
}
             
@end

             
@implementation BillDataSaleGoodgraphModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"goodName" : @"goodName",
             @"percentage" : @"percentage",
             @"totalFee" :@"totalFee",
             };
}

@end

@implementation BillDataSaleClientgraphModelSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"clientName" : @"clientName",
             @"percentage" : @"percentage",
             @"totalFee" :@"totalFee",
             };
}
@end



@implementation BillDataAllDataModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saleDate" : @"saleDate",
             @"saleFee" : @"saleFee",
             @"saleAmount" :@"saleAmount",
             @"saleGoodgraph" :@"saleGoodgraph",
             @"saleClientgraph":@"saleClientgraph",
             };
}



+ (NSValueTransformer *)saleAmountJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleAmountModelSub class]];
}
+ (NSValueTransformer *)saleGoodgraphJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleGoodgraphModelSub class]];
}
+ (NSValueTransformer *)saleClientgraphJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleClientgraphModelSub class]];
}
@end


// 511002_销售额统计
@implementation BillDataSaleAmountModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saleDate" : @"saleDate",
             @"saleFee" : @"saleFee",
             @"saleAmount" :@"saleAmount",
             };
}


+ (NSValueTransformer *)saleAmountJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleAmountModelSub class]];
}

@end


// 511003_商品销售排行

@implementation BillDataSaleGoodsModelWithGoodsSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"goodName" : @"goodName",
             @"unit" : @"unit",
             @"totalFee" :@"totalFee",
             };
}

@end


@implementation BillDataSaleGoodsModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saleGoodgraph" :@"saleGoodgraph",
             @"saleGoods" : @"saleGoods",
             };
}

+ (NSValueTransformer *)saleGoodgraphJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleGoodgraphModelSub class]];
}

+ (NSValueTransformer *)saleGoodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleGoodsModelWithGoodsSub class]];
}
@end



// 511004_客户成交排行
@implementation BillDataSaleClientsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"saleClientgraph" :@"saleClientgraph",
             @"saleClients" : @"saleClients",
             };
}

+ (NSValueTransformer *)saleClientgraphJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleClientgraphModelSub class]];
}

+ (NSValueTransformer *)saleClientsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BillDataSaleClientgraphModelSub class]];
}
@end

@implementation BillOpenBillServiceStatusModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"boughtStatus"        :@"boughtStatus",
             @"trialLeftDay"        :@"trialLeftDay",
             @"freeTrialJumpUrl"    :@"freeTrialJumpUrl",
             @"needBoughtCheck"    :@"needBoughtCheck",

             };
}

@end

