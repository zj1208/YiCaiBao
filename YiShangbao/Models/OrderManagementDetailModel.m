//
//  OrderManagementDetailModel.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OrderManagementDetailModel.h"

@implementation OMOrderSelCommentInitModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"buyerPic"           :         @"buyerPic",
             @"buyerName"    :         @"buyerName",
             @"list"    :         @"list",
             };
}
@end

@implementation OMOrderPurCommentInitModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"prods"           :         @"prods",
             @"list"    :         @"list",
             };
}
+ (NSValueTransformer *)prodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMOrderPurCommentInitProModel class]];
}
@end
@implementation OMOrderPurCommentInitProModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"prodId"           :         @"prodId",
             @"prodPic"    :         @"prodPic",
             };
}
@end

@implementation OMRefundInitModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"bizOrderId"           :         @"bizOrderId",
             @"finalPrice"    :         @"finalPrice",
             @"transFee"    :         @"transFee",
             @"subBizOrders"    :         @"subBizOrders",

             };
}
+ (NSValueTransformer *)subBizOrdersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDSubBizOrdersMode class]];
}
@end


@implementation OMDRefundDetailButtonModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name"           :         @"name",
             @"code"          :         @"code",
             @"style"    :         @"style",
//             @"location"    :         @"location",
//             @"router"    :         @"router",
             @"url"    :         @"url",

             };
}

@end
@implementation OMRefundDetailInfoModel


+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"statusIcon"    :         @"statusIcon",
             @"statusDesp"    :         @"statusDesp",
             @"statusTimeAbout"    :         @"statusTimeAbout",
             @"reminders"    :         @"reminders",
             @"buttons"    :         @"buttons",
             
             @"iid"    :         @"id",
             @"bizOrderId"    :         @"bizOrderId",
             
             @"status"    :         @"status",
             @"finalPrice"    :         @"finalPrice",
             
             @"subBizOrders"    :         @"subBizOrders",
             @"applyTime"    :         @"applyTime",
             @"cancelTime"    :         @"cancelTime",
             @"refuseTime"    :         @"refuseTime",
             @"agreeTime"    :         @"agreeTime",
             @"finishTime"    :         @"finishTime",
             @"applyReason"    :         @"applyReason",
             @"refuseReason"    :         @"refuseReason",
             @"explain"    :         @"explain",
             
             @"buttonUid"   :       @"buttonUid",
             @"buttonCall"   :       @"buttonCall",
             @"buttonComplaint"   :       @"buttonComplaint",

             };
}
+ (NSValueTransformer *)buttonsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDRefundDetailButtonModel class]];
}
    
+ (NSValueTransformer *)subBizOrdersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDSubBizOrdersMode class]];
}
@end


@implementation OMDStatusHubModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"seq"           :         @"seq",
             @"value"    :         @"value",             
             };
}
@end

@implementation OMDSubBizOrdersMode
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"subBizOrderId"           :         @"subBizOrderId",
             @"discount"    :         @"discount",

             @"prodId"    :         @"prodId",
             @"prodUrl"    :         @"prodUrl",
             
             @"prodName"          :         @"prodName",
             @"prodPic"          :         @"prodPic",
             @"quantity"          :         @"quantity",
             @"skuInfo"          :         @"skuInfo",
             @"price"          :         @"price",
             @"finalPrice"          :         @"finalPrice",
             @"totalPrice"          :         @"totalPrice",

            };
}

@end


@implementation OMDStatusDescModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"desc1"           :         @"desc1",
             @"desc2"          :         @"desc2",
             @"pic"    :         @"pic",
             
             };
}

@end

@implementation OrderManagementDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"statusHubs"           :         @"statusHubs",
             @"statusSta"    :         @"statusSta",

             @"bizOrderId"    :         @"bizOrderId",
             @"entityId"          :         @"entityId",
             @"entityName"        :         @"entityName",
             @"entityUrl"        :         @"entityUrl",

             @"statusDesc"     :         @"statusDesc",

             @"consignee"   :       @"consignee",
             @"consigneePhone"   :       @"consigneePhone",
             @"address"   :       @"address",
             @"buyerWords"   :       @"buyerWords",
             @"remark"   :       @"remark",
             
             @"price"   :       @"price",
             @"prodsPrice"   :       @"prodsPrice",
             @"discount"   :       @"discount",
             @"transFee"   :       @"transFee",
             @"promotionFee"   :       @"promotionFee",
             @"orderFee"   :       @"orderFee",
             @"finalPrice"   :       @"finalPrice",

             @"subBizOrders"   :       @"subBizOrders",
             
             @"createTime"   :       @"createTime",
             @"confirmTime"   :       @"confirmTime",
             @"payTime"   :       @"payTime",
             @"deliveryTime"   :       @"deliveryTime",
             @"finishTime"   :       @"finishTime",
             @"upButtons"   :       @"upButtons",
             @"downButtons"   :       @"downButtons",
            
             @"buttonCall"   :       @"buttonCall",
             @"buttonComplaint"   :       @"buttonComplaint",

             };
}
//
+ (NSValueTransformer *)statusDescJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[OMDStatusDescModel class]];
}

+ (NSValueTransformer *)statusHubsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDStatusHubModel class]];
}
+ (NSValueTransformer *)subBizOrdersJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OMDSubBizOrdersMode class]];
}

+ (NSValueTransformer *)upButtonsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderButtonModel class]];
}
+ (NSValueTransformer *)downButtonsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[OrderButtonModel class]];
}

@end
