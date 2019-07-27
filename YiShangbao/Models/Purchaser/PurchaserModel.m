//
//  PurchaserModel.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserModel.h"

@implementation BuyerUserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"like"                :@"like",
             @"order"               :@"order",
             @"headIcon"            :   @"headIcon",
             @"describe"            :   @"describe",
             @"nickname"            :   @"nickname",
             @"percent"             :   @"percent",
             @"showAuthPerson"      :   @"showAuthPerson",
             @"showAuthCompany"     :   @"showAuthCompany",
             @"showAuthGuest"       :   @"showAuthGuest",
             @"countryCode"         :   @"countryCode",
             @"phone"               :   @"phone",
             @"authName"            :   @"authName",
             @"authStatus"          :   @"authStatus",
             @"qq"                  :   @"qq",
             @"bindWechat"          :   @"bindWechat",
             @"needSetPwd"          :   @"needSetPwd",
             @"score"               :@"score",
             @"scoreUrl"            :@"scoreUrl",
             @"buyerBadges"         :@"buyerBadges",
             @"link"                :@"link",
             };
}

+ (NSValueTransformer *)buyerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}

@end

@implementation WYOrderNumberModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"waitConfirmCount"    :@"waitConfirmCount",
             @"waitPayCount"        :@"waitPayCount",
             @"waitTranCount"       :@"waitTranCount",
             @"waitReceiveCount"    :@"waitReceiveCount",
             @"waitEvalCount"       :@"waitEvalCount",
             };
}

@end

@implementation WYLikeNumberModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    
    return @{
             @"subjectCount"        :@"subjectCount",
             @"favorShopCount"      :@"favorShopCount",
             @"favorProdCount"      :@"favorProdCount",
             };
}

@end

//------------------------------------------------------------------------
@implementation PurchaserCommonAdvModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"     :         @"id",
             @"areaId"    :       @"areaId",
             @"pic"    :          @"pic",
             @"title"    :       @"title",
             @"desc"    :       @"desc",
             @"url"    :         @"url",
             
             };
}
@end

@implementation NewsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"label"     :       @"label",
             @"title"    :       @"title",
             @"newsUrl"     :       @"newsUrl",
             };
}

@end

@implementation YcbBuyNewsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iconUrl"     :       @"iconUrl",
             @"news"    :       @"news",
             
             };
}
+ (NSValueTransformer *)newsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[NewsModel class]];
}

@end

@implementation YcbRegInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"name"     :       @"name",
             @"value"    :       @"value",
             };
    }

@end
@implementation TopCategoryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{


             @"icon"    :       @"icon",
             @"name"    :       @"name",
             @"route"    :       @"route",

             };
}

@end


@implementation PurchaserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{

    return @{
             @"advInfo"            :   @"advInfo",
             @"ycbRegInfo"            :   @"ycbRegInfo",
             @"funcBarInfo"        :   @"funcBarInfo",
             @"ycbBuyNews"        :   @"ycbBuyNews",

             @"goldAdvInfo"         :   @"goldAdvInfo",
             @"tbzgAdv"         :   @"tbzgAdv",
             @"specialAdvInfo"         :   @"specialAdvInfo",
             @"lowPriceStockAdv"    :   @"lowPriceStockAdv",
             @"hotShopAdv"    :   @"hotShopAdv",

             @"bestProductsAdv"    :   @"bestProductsAdv",
             @"lunboAdv"    :   @"lunboAdv",
             
             @"topCategory"    :   @"topCategory",
             @"shopRecmd"    :   @"shopRecmd",
             @"shopSpecial"    :   @"shopSpecial",
             @"productSpecial"    :   @"productSpecial",
             @"guessYouLike"    :   @"guessYouLike"

             };
}

+ (NSValueTransformer *)advInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
//
+ (NSValueTransformer *)ycbRegInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[YcbRegInfoModel class]];
}
+ (NSValueTransformer *)funcBarInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)goldAdvInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)specialAdvInfoJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)tbzgAdvJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)lowPriceStockAdvJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)hotShopAdvJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}

+ (NSValueTransformer *)bestProductsAdvJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)lunboAdvJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PurchaserCommonAdvModel class]];
}
+ (NSValueTransformer *)topCategoryJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[TopCategoryModel class]];
}

//

+ (NSValueTransformer *)YcbBuyNewsModelJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[YcbBuyNewsModel class]];
}
@end

//------------------------------------------------------------------------

@implementation PurchaserListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"     :       @"id",
             @"picUrl"     :       @"picUrl",
             @"name"     :       @"name",
             @"price"     :       @"price",
             @"sourceType"     :       @"sourceType",
             @"sourceTypeName"     :       @"sourceTypeName",
             @"link"                :@"link",
             };
}

@end
@implementation RecommendPicsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"p"     :       @"p",
             @"h"     :       @"h",
             @"w"     :       @"w"
             };
}

@end

@implementation RecommendModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"intro"               :       @"intro",
             @"shopId"              :       @"shopId",
             @"shopName"            :       @"shopName",
             @"shopIcon"            :       @"shopIcon",
             @"isKeySeller"         :       @"isKeySeller",
             @"authStatus"          :       @"authStatus",
             @"publishTime"         :       @"publishTime",
             @"pics"                 :       @"pics"
             };
}

+ (NSValueTransformer *)picsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RecommendPicsModel class]];
}

@end


@implementation SpreadModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"recommendProduct"          :   @"product",
             @"recommendinventory"        :   @"inventory"
             };
}

+ (NSValueTransformer *)recommendProductJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RecommendModel class]];
}

+ (NSValueTransformer *)recommendinventoryJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RecommendModel class]];
}
@end
//------------------------------------------------------------------------------

@implementation bgpModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"h"          :       @"h",
             @"p"        :       @"p",
             @"w"     :       @"w"
             };
}

@end

@implementation RecmdShopsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"iid"          :       @"id",
             @"name"        :       @"name",
             @"pic"          :       @"pic",
             @"url"          :       @"url",

             };
}
+ (NSValueTransformer *)picJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[bgpModel class]];
}
@end

@implementation ShopRecmdListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"index"               :       @"index",
             @"title"               :       @"title",
             @"link"               :        @"link",
             @"bgp"                 :       @"bgp",
             @"outline"             :       @"outline",
             @"shops"               :       @"shops"
             };
}

+ (NSValueTransformer *)shopsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RecmdShopsModel class]];
}
+ (NSValueTransformer *)bgpJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[bgpModel class]];
}
@end

@implementation prodsModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    
    return @{
             @"iid"          :       @"id",
             @"prodName"        :       @"prodName",
             @"price"          :       @"price",
             @"pic"          :       @"pic",
             @"alias"          :       @"alias",
             @"link"            :   @"link",
             @"url"          :       @"url",

             };
}
+ (NSValueTransformer *)picJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[bgpModel class]];
}
@end

@implementation ShopStandAloneRecmdModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shopId"          :       @"shopId",
             @"shopName"        :       @"shopName",
             @"iconUrl"          :       @"iconUrl",
             @"descriptionN"          :       @"description",
             @"supplierSig"          :       @"supplierSig",
             @"authMarket"          :       @"authMarket",
             @"hasFactory"          :       @"hasFactory",
             @"prods"          :       @"prods",
             @"alias"          :       @"alias",
            
             @"identifierIcons"          :       @"identifierIcons",
             @"url"                      :@"url",
             };
}
+ (NSValueTransformer *)prodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[prodsModel class]];
}
+ (NSValueTransformer *)identifierIconsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end

@implementation prodRecmdModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"iid"          :       @"id",
             @"link"        :       @"link",
             @"title"        :       @"title",
             @"descriptionN"          :       @"description",
             @"bgp"          :       @"bgp",
             @"prods"          :       @"prods",
             @"alias"          :       @"alias",
             };
}
+ (NSValueTransformer *)prodsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[prodsModel class]];
}
@end
