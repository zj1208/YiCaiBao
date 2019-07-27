//
//  ShopModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopModel.h"
@implementation ShopAddrModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"marketId"                    :   @"marketId",
             @"kind"                        :   @"kind",
             @"submarket"                   :   @"submarket",
             @"submarketValue"              :   @"submarketValue",
             @"gr1"                         :   @"gr1",
             @"gr1VO"                       :   @"gr1VO",
             @"gr2"                         :   @"gr2",
             @"gr2VO"                       :   @"gr2VO",
             @"gr3"                         :   @"gr3",
             @"gr3VO"                       :   @"gr3VO",
             @"gr4"                         :   @"gr4",
             
             @"door"                        :   @"door",
             @"floor"                       :   @"floor",
             @"street"                      :   @"street",
             @"booth"                       :   @"booth",
             @"pro"                         :   @"pro",
             @"proVO"                       :   @"proVO",
             @"city"                        :   @"city",
             @"cityVO"                      :   @"cityVO",
             @"area"                        :   @"area",
             @"areaVO"                      :   @"areaVO",
             @"addr"                        :   @"addr",
             };
}

@end


@implementation ShopManagerInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"shopId"                      :   @"id",
             @"sysCates"                    :   @"sysCates",
             @"mainSell"                    :   @"mainSell",
             @"mainBrand"                   :   @"mainBrand",
             @"mgrPeriod"                   :   @"mgrPeriod",
             @"mgrType"                     :   @"mgrType",
             @"factoryPics"                 :   @"factoryPics",
             @"sellChannel"                 :   @"sellChannel",
             @"sysCatesIds" :@"sysCatesIds"
             };
}


+ (NSValueTransformer *)sysCatesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[SysCateModel class]];
}

@end


@implementation ShopContactModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"shopContactId"               :   @"id",
             @"shopId"                      :   @"shopId",
             @"sellerName"                  :   @"sellerName",
             @"sellerPhone"                 :   @"sellerPhone",
             @"tel"                         :   @"tel",
             @"fax"                         :   @"fax",
             @"qq"                          :   @"qq",
             @"wechat"                      :   @"wechat",
             @"email"                       :   @"email"
             };
}

@end

@implementation AcctInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"bankId"                  :   @"bankId",
             @"shopId"                  :   @"id",
             @"bankIcon"                :   @"bankIcon",
             @"bankCode"                :   @"bankCode",
             @"bankValue"               :   @"bankValue",
             @"bankNo"                  :   @"bankNo",
             @"bankPlace"               :   @"bankPlace",
             @"acctName"                :   @"acctName",
             @"color"                   :   @"color"
             };
}

@end

@implementation BankModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"bankId"                  :   @"id",
             @"bankCode"                :   @"bankCode",
             @"bankValue"               :   @"bankValue",
             @"bankValueS"              :   @"bankValueS ",
             @"icon"                    :   @"icon"
             };
}

@end

@implementation marketModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"name"                :   @"name",
             @"code"                :   @"id",
             @"marketId"            :   @"marketId",
             @"kind"                :   @"kind",
             };
}
@end

@implementation ShopListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"iconUrl"                 :   @"iconUrl",
             @"name"                    :   @"name",
             @"outline"                 :   @"outline",
             @"submarketValue"          :   @"submarketValue",
             @"door"                    :   @"door",
             @"floor"                   :   @"floor",
             @"street"                  :   @"street",
             @"provinceVO"                :   @"provinceVO",
             @"cityVO"                    :   @"cityVO",
             @"areaVO"                    :   @"areaVO",
             @"address"                 :   @"address",
             @"boothNos"                 :   @"boothNos",
             @"canTrade"                :@"canTrade",
             };
}

@end


@implementation ShopModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"iconUrl"                 :   @"iconUrl",
             @"name"                    :   @"name",
             @"sysCates"                :   @"sysCates",
             @"mainSell"                :   @"mainSell",
             @"marketId"                :   @"marketId",
             @"submarketCode"           :   @"submarketCode",
             @"submarketValue"          :   @"submarketValue",
             @"door"                    :   @"door",
             @"floor"                   :   @"floor",
             @"street"                  :   @"street",
             @"province"                :   @"province",
             @"city"                    :   @"city",
             @"area"                    :   @"area",
             @"address"                 :   @"address",
             @"boothNos"                :   @"boothNos",
             @"sellerName"              :   @"sellerName",
             @"sellerPhone"             :   @"sellerPhone",
             @"sellChannel"             :   @"sellChannel"
             };
}
@end


@implementation SysCateModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"n"               :   @"n",
             @"v"               :   @"v",
             @"l"               :   @"l"
             };
}
@end

@implementation ShopInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"shopId"          :@"shopId",
             @"shopName"        :@"shopName",
             @"address"         :@"address",
             @"iconUrl"         :@"iconUrl",
             @"outline"         :@"outline",
             @"shopRed"         :@"shopRed",
             @"quaRed"          :@"quaRed",
             @"tradeRed"        :@"tradeRed",
             @"contactRed"      :@"contactRed",
             @"accountRed"      :@"accountRed",
             @"canTrade"        :@"canTrade",
             @"canModify"       :@"canModify",
             @"shopQuaUrl"      :@"shopQuaUrl",
             @"shopPreUrl"      :@"shopPreUrl",
             @"tradeScore"      :@"tradeScore",
             @"identifys"       :@"identifys",
             @"identifyDesc"    :@"identifyDesc",
             @"identifyUrl"     :@"identifyUrl",
             @"tradeScoreUrl"   :@"tradeScoreUrl",
             };
}

+ (NSValueTransformer *)identifyssJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NSString class]];
}


@end








@implementation ShopHomeInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shopIconURL" : @"shopIcon",
             @"shopName" : @"shopName",
             @"identifierIcons" :@"identifierIcons",

             @"ercode" :@"ercode",
             @"ercodeReddot" :@"ercodeReddot",
             @"fansAndVisitors" :@"fansAndVisitors",
             
             @"noticeReddot" : @"noticeReddot",
             @"baseService" :@"baseService",
             @"appendService" :@"appendService",
             @"perfectService" :@"perfectService",
             
             @"viewUrl" :@"viewUrl",
             @"tradeLevelIcon" :@"tradeLevelIcon",
             @"tradeLevelUrl" :@"tradeLevelUrl",
             @"tradeScore" :@"tradeScore",
             
             @"exposeModel" :@"expose",
             };
}


+ (NSValueTransformer *)identifierIconsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}



+ (NSValueTransformer *)fansAndVisitorsJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ShopHomeInfoModelFansVisiSub class]];
}

+ (NSValueTransformer *)exposeModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[ShopHomeExposeModel class]];
}

+ (NSValueTransformer *)baseServiceJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BadgeItemCommonModel class]];
}

+ (NSValueTransformer *)appendServiceJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BadgeItemCommonModel class]];
}

+ (NSValueTransformer *)perfectServiceJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[BadgeItemCommonModel class]];
}
@end



@implementation ShopHomeInfoModelFansVisiSub

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"fans" : @"fans",
             @"visitors" : @"visitors",
             @"fansReddot" :@"fansReddot",
             
             @"visitorsReddot" :@"visitorsReddot",
             };
}

@end


@implementation BadgeItemCommonModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"url" : @"url",
             @"icon" : @"icon",
             @"desc" :@"desc",
             @"type" :@"type",
             @"name":@"name",
             
             @"needLogin" :@"needLogin",
             @"needOpenShop":@"needOpenShop",
             @"needAuth" :@"needAuth",
             @"sideMarkType" :@"sideMarkType",
             @"sideMarkValue" :@"sideMarkValue",
             @"vbrands" :@"vbrands"
             };
}


@end

@implementation ShopHomeExposeModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"exposeNum" : @"exposeNum",
             @"exposeUrl" : @"exposeUrl",
             };
}

@end
