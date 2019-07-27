//
//  CommonModel.m
//  YiShangbao
//
//  Created by simon on 17/1/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CommonModel.h"

@implementation CommonModel

@end


@implementation AliOSSPicUploadModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"h" : @"h",
             @"p" : @"p",
             @"w" : @"w",
             };
}
@end




@implementation AliOSSPicModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"height" : @"h",
             @"picURL" : @"p",
             @"width" : @"w",             
             };
}


@end


@implementation WYButtonModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"buttonTitle" : @"n",
             @"buttonType"  : @"v",
             @"url"         : @"p",
             };
}


@end

@implementation EvluateBtnModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"buttonTitle" : @"n",
             @"buttonType"  : @"v",
             @"url"         : @"p",
             };
}


@end


@implementation OrderButtonModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"name" : @"name",
             @"style" : @"style",
             @"code" : @"code",
             @"location" :@"location",
             @"url" :@"url"
             };
}


+ (NSValueTransformer *)codeJSONTransformer
{
    NSDictionary *dic = @{
                          @"confirmOrder1":@(ButtonCode_confirmOrder1),
                          @"modifyPrice1":@(ButtonCode_modifyPrice1),
                          @"delivery1":@(ButtonCode_delivery1),
                          @"handleRefund1":@(ButtonCode_handleRefund1),
                          @"showLogistics1":@(ButtonCode_showLogistics1),
                          @"evaluate1":@(ButtonCode_evaluate1),
                          @"evaluated1":@(ButtonCode_evaluated1),
                          @"detail1":@(ButtonCode_detail1),
                          @"closeOrder1":@(ButtonCode_closeOrder1),
                          @"agreeRefund1":@(ButtonCode_agreeRefund1),
                          @"refuseRefund1":@(ButtonCode_refuseRefund1),
                          @"refundFinish1":@(ButtonCode_refundFinish1),
                          
                          @"closeOrder2":@(ButtonCode_closeOrder2),
                          @"payOrder2":@(ButtonCode_payOrder2),
                          @"refund2":@(ButtonCode_refund2),
                          @"detail2":@(ButtonCode_detail2),
                          @"showLogistics2":@(ButtonCode_showLogistics2),
                          @"confirmReceipt2":@(ButtonCode_confirmReceipt2),
                          @"evaluate2":@(ButtonCode_evaluate2),
                          @"evaluated2" :@(ButtonCode_evaluated2),
                          @"cancelRefund2":@(ButtonCode_cancelRefund2),
                          @"refunding2":@(ButtonCode_refunding2),
                          @"refundFinish2":@(ButtonCode_refundFinish2),
                          
                          @"refundAndClose1" :@(ButtonCode_refundAndClose1),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}

@end

@implementation WYIconModlel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"scene" : @"scene",
             @"iconUrl" : @"iconUrl",
             @"width" : @"width",
             @"height" :@"height",
             };
}
@end


@implementation CodeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"value" :  @"value",
             @"code"  :  @"code",
             };
}
@end

