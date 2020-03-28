//
//  WYPublichModel.m
//  YiShangbao
//
//  Created by light on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPublicModel.h"

@implementation WYPublicModel

@end

@implementation WYDefaultDeliveryAddressModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"addressId"       :@"addressId",
             @"deliveryName"    :@"deliveryName",
             @"deliveryPhone"   :@"deliveryPhone",
             @"provCode"        :@"provCode",
             @"cityCode"        :@"cityCode",
             @"townCode"        :@"townCode",
             @"prov"            :@"prov",
             @"city"            :@"city",
             @"town"            :@"town",
             @"address"         :@"address",
             };
}

@end

@implementation WYPayWayModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"payWayId"    :@"id",
             @"way"         :@"way",
             @"intro"       :@"intro",
             @"icon"        :@"icon",
             @"pic"         :@"pic",
             };
}

@end

@implementation WYWechatPaymentModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"appid"           :@"appid",
             @"partnerid"       :@"partnerid",
             @"prepayid"        :@"prepayid",
             @"package"         :@"package",
             @"noncestr"        :@"noncestr",
             @"timestamp"       :@"timestamp",
             @"sign"            :@"sign",
             };
}

@end

@implementation WYAuthenticationPayInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"comboId"         :@"comboId",
             @"title"           :@"title",
             @"desc"            :@"desc",
             @"icon"            :@"icon",
             @"fee"             :@"fee",
             @"promFee"         :@"promFee",
             };
}

@end

@implementation WYAuthenticationInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"ssView"         :@"ssView",
             @"payJumpUrl"      :@"payJumpUrl",
             };
}

@end

#pragma mark- 服务下单

@implementation WYServicePackagesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"comboId"     :@"comboId",
             @"title"       :@"title",
             @"desc"        :@"desc",
             @"icon"        :@"icon",
             @"fee"         :@"fee",
             @"promFee"     :@"promFee",
             };
}

@end

@implementation WYServiceFunctionInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"title"   :@"title",
             @"desc"    :@"desc",
             @"pic"     :@"pic",
             };
}

@end

@implementation WYServiceExtMapModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"openBillTrialLeftDay"        :@"openBillTrialLeftDay",
             @"openBillFreeTrialJumpUrl"    :@"openBillFreeTrialJumpUrl",
             @"enableGoOnButton"            :@"enableGoOnButton",
             @"goOnButtonText"              :@"goOnButtonText",
             };
}

@end

@implementation WYServicePlaceOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"comboItemList"       :@"comboItemList",
             @"outOrderId"          :@"outOrderId",
             @"funcItemInfoList"    :@"funcItemInfoList",
             @"extMap"              :@"extMap",
             };
}

+ (NSValueTransformer *)comboItemListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYServicePackagesModel class]];
}

+ (NSValueTransformer *)funcItemInfoListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYServiceFunctionInfoModel class]];
}

@end

@implementation WYServiceCreatOrderModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"ssView"       :@"ssView",
             @"orderIds"     :@"orderIds",
             };
}

@end


