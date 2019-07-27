//
//  WYTradeModel.m
//  YiShangbao
//
//  Created by simon on 17/1/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTradeModel.h"




@implementation TradeMoveTitleModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"num"              :   @"num",
             @"items"            :   @"items",
             @"type"             :   @"type",

             };
}

+ (NSValueTransformer *)itemsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TradeMoveTitleItemsModel class]];
}
@end

@implementation TradeMoveTitleItemsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"              :   @"id",
             @"pic"                :   @"pic",
             @"url"              :   @"url",
             @"desc"               :   @"desc",
             };
}
@end


@implementation BaseTradeModel

+ (NSValueTransformer *)certificationTypeJSONTransformer
{
    NSDictionary *dic = @{
                          @(0):@(WYCertificationType_no),
                          @(1):@(WYCertificationType_personage),
                          @(2):@(WYCertificationType_enterprise),
                          @(3):@(WYCertificationType_buyer),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}


+ (NSValueTransformer *)cellTypeJSONTransformer
{
    NSDictionary *dic = @{
                          @(1):@(WXCellType_Trade),
                          @(2):@(WXCellType_Adv),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}


+ (NSValueTransformer *)tradeTypeJSONTransformer
{
    NSDictionary *dic = @{
                          @(1):@(WYTradeType_foreignTrade),
                          @(2):@(WYTradeType_domesticTrade),
                          @(3):@(WYTradeType_inventory),
                          @(4):@(WYTradeType_foreignDirect),
                          @(9):@(WYTradeType_other),

                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}

+ (NSValueTransformer *)buyerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end





@implementation WYTradeModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postId" : @"id",
             @"unId" : @"uid",
             @"userName" :@"nn",
             @"URL" :@"tx",
             @"certificationType":@"at",
             @"companyName":@"cn",
             @"phoneNum" :@"mb",
             @"title" :@"pn",
             @"content" : @"ds",
             @"expirationTime" :@"et",
             @"publishTime" :@"pubdate",
             @"cellType":@"ad",
             @"h5Url":@"hr",
             
             @"orderingBtnModel":@"bt",
             
             @"photosArray" :@"ps",
             @"mark" : @"mark",
             
             @"tradeType":@"ste",
             @"tradeTypeTitle": @"sten",

             @"buyerBadges" :@"buyerBadges",
             };
}

+ (NSValueTransformer *)photosArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[AliOSSPicModel class]];
}

+ (NSValueTransformer *)orderingBtnModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[WYButtonModel class]];
}


@end
@implementation TradeDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postId" : @"id",
             @"unId" : @"uid",
             @"userName" :@"nn",
             @"URL" :@"tx",
             @"certificationType":@"at",
             @"companyName":@"cn",
             @"phoneNum" :@"mb",
             @"title" :@"pn",
             @"content" : @"ds",
             @"expirationTime" :@"et",
             @"publishTime" :@"ts",

             @"deliveryTime":@"ed",
             @"needCount" :@"no",
             @"myCommitModel" :@"bv",
             
             @"qouterAmout" :@"qouterAmout",
             @"ratio" : @"ratio",
             @"sellerIcons" :@"sellerIcons",

             @"photosArray" :@"ps",
             
             @"otherReplyModel":@"bidList",
             
             @"tradeType":@"ste",
             @"tradeTypeTitle": @"sten",
             @"totalNiches" :@"totalNiches",
             
             @"buyerBadges" :@"buyerBadges",
             
             @"mobile" :@"mobile",
             @"email" :@"email",

             };
}

+ (NSValueTransformer *)photosArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[AliOSSPicModel class]];
}


+ (NSValueTransformer *)myCommitModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[TradeMyCommintModel class]];
}


+ (NSValueTransformer *)otherReplyModelJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TradeOtherReplyModel class]];
}
@end




@implementation TradeOtherReplyModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shopName" : @"shopName",
             @"bidTimes" : @"bidTimes",
             @"authFlag" :@"authFlag",
             @"keyFlag" :@"keyFlag",
             @"shopIcon" :@"shopIcon",
             @"sellerBadges" :@"sellerBadges",
             };
}


+ (NSValueTransformer *)sellerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}

@end




@implementation TradeMyCommintModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"replyTime" : @"ts",
             @"sellGoodsType" : @"st",
             @"goodsPrice" :@"pr",
             @"replyContent" :@"sr",
             @"orderBeginCount" :@"mq",
             
             @"photosArray" :@"ps"
             };
}

+ (NSValueTransformer *)photosArrayJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[AliOSSPicModel class]];
}


@end






@implementation MYTradeUnderwayModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"postId" : @"id",
             @"unId" : @"uid",
             @"userName" :@"nn",
             @"URL" :@"tx",
             @"certificationType":@"at",
             @"companyName":@"cn",
             @"content" : @"ds",
             @"title" :@"pn",
             
             @"replyTime" :@"ts",
             //这种方法不建议，如果是空的，会崩溃；
             @"btnTitle" :@"iv.n",
             @"btnType" :@"iv.v",
             
             @"evluateBtnModel" :@"bt",
             
             @"tradeType":@"ste",
             @"tradeTypeTitle": @"sten",
             
             @"buyerBadges" :@"buyerBadges",
             };
}

+ (NSValueTransformer *)evluateBtnModelJSONTransformer
{
      return [MTLJSONAdapter dictionaryTransformerWithModelClass:[EvluateBtnModel class]];
}

@end








@implementation EvatipModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"name":@"n",
             @"value":@"v"
             };
}

@end

@implementation TradeBuyerModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"buyerId"         :@"buyerId",
             @"defaultScore"    :@"defaultScore",
             @"nickname"        :@"nickname",
             @"userIcon"        :@"userIcon"
             };
}

@end

@implementation MyEvaluateModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"buyer"           :@"buyer",
             @"score"           :@"ds",
             @"descrptiontext"  :@"dd",
             @"labels"          :@"ls",
             @"sm"              :@"sm",
             };
}

+ (NSValueTransformer *)labelsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[EvatipModel class]];
}

@end

@implementation ReleaseBusniessModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"productName" :@"productName",
             @"createTime"  :@"createTime",
             @"subjectId"   :@"subjectId",
             @"valid"       :@"valid"
             };
}

@end
