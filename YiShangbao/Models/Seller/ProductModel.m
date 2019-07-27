//
//  ProductModel.m
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductModel.h"
#import "WYPublicModel.h"

@implementation ProductModel

@end



@implementation ShopInfoWidgetsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"url" : @"url",
             @"iconURL" : @"icon",
             @"desc" :@"desc",
             @"type" :@"type",
             @"name":@"name",
             @"badgeIcon":@"badgeIcon",
             @"num":@"num"
             };

}


@end

@implementation ShopMainInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"shopIconURL" : @"shopIcon",
             @"shopName" : @"shopName",
             @"fans":@"fans",
             @"visitors":@"visitors",
             @"widgets":@"widgets",
             @"topWidgets":@"topWidgets",
             @"extIcons" :@"extIcons",
             @"sellerBadges" :@"sellerBadges",
             };
}



+ (NSValueTransformer *)widgetsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ShopInfoWidgetsModel class]];
}

+ (NSValueTransformer *)topWidgetsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ShopInfoWidgetsModel class]];
}

+ (NSValueTransformer *)sellerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end




@implementation ProductPutawayInitModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"picLimit" : @"picLimit",
             @"sysCateId" : @"sysCateId",
             @"sysCateName":@"sysCateName",
             @"ifRadioDisplay" :@"ifRadioDisplay",
             @"timesLeft" :@"timesLeft",
             @"totalTimes" :@"totalTimes",
             @"latestSysCates" : @"latestSysCates",
             
             @"hasFreightTemp" :@"hasFreightTemp",
            };
}

+ (NSValueTransformer *)latestSysCatesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYCategoryModel class]];
}



@end




@implementation ProSystemCatesModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"cateId" : @"v",
             @"level" : @"l",
             @"name" :@"n",
             };
}


@end



@implementation ShopBaseModel



+ (NSValueTransformer *)showAuthGuestJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)showAuthPersonJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)showAuthCompanyJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)buyerBadgesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[WYIconModlel class]];
}
@end


@implementation ShopFansModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
                @"userId" : @"unionid",
                @"userName" :@"nickname",
                @"iconURL" :@"iconUrl",
                @"companyName":@"companyName",
            
                @"showAuthCompany":@"showAuthCompany",
                @"showAuthPerson" :@"showAuthPerson",
                @"showAuthGuest"  :@"showAuthGuest",
                @"buyerBadges" :@"buyerBadges",

             };
}


@end


@implementation ShopVisitorsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"userId" : @"unionid",
             @"userName" :@"nickname",
             @"iconURL" :@"iconUrl",
             @"companyName":@"companyName",
             
             @"showAuthCompany":@"showAuthCompany",
             @"showAuthPerson" :@"showAuthPerson",
             @"showAuthGuest"  :@"showAuthGuest",

             @"modifyTime" : @"modifyTime",
             @"buyerBadges" :@"buyerBadges",

             };
}


@end

@implementation RecentlyBizsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"productName" : @"productName",
             @"createTime"  : @"createTime",
             @"subjectId"   : @"subjectId",
             @"valid" :@"valid"
             };
}


@end


@implementation ShopPurchaserInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"userName" :@"nickname",
             @"iconURL" :@"iconUrl",
             @"companyName":@"companyName",
             
             @"showAuthCompany":@"showAuthCompany",
             @"showAuthPerson" :@"showAuthPerson",
             @"showAuthGuest" :@"showAuthGuest",
             
             @"buyerBadges" :@"buyerBadges",

             
             @"locationName": @"locationName",
             @"buyProducts" : @"buyProducts",
             @"intro" : @"intro",
             @"source" :@"source",
             @"lastBizs": @"lastBizs",
             @"lastProducts":@"lastProducts",
             
             @"totalNiches" :@"totalNiches",
             
             
             @"countSubjectPurchaseRates" :@"countSubjectPurchaseRates",
             @"subjectPurchaseRate" :@"subjectPurchaseRate",
             
             @"showCustomer" : @"showCustomer",
             @"purchaserType" :@"type"
             };
    
}

+ (NSValueTransformer *)lastBizsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[RecentlyBizsModel class]];
}

+ (NSValueTransformer *)subjectPurchaseRateJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:EvaluateInfoModel.class];
}

+ (NSValueTransformer *)purchaserTypeJSONTransformer
{
    NSDictionary *dic = @{
                          @(1):@(WYPurchaserType_app),
                          @(2):@(WYPurchaserType_weiXin),
                          @(3):@(WYPurchaserType_tourist),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}
@end


@implementation ShopMyProductModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"isMain" :@"isMain",
             @"productId" :@"id",
             @"iconURL" :@"pic.p",
             @"pic":@"pic",

             @"name":@"name",
             
             @"price":@"price",
             @"link" :@"link",
             @"sourceType":@"sourceType"
            };
    
}

+ (NSValueTransformer *)isMainJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}
//+ (NSValueTransformer *)photosArrayJSONTransformer
//{
//    return [MTLJSONAdapter arrayTransformerWithModelClass:[AliOSSPicModel class]];
//}
+ (NSValueTransformer *)picJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[AliOSSPicUploadModel class]];
}

@end


@implementation ProductManagerCountModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"proCount" :@"count",
             @"status" :@"status",
             };
    
}


@end


@implementation MyProductSearchModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             
             @"isMain" :@"isMain",
             @"productId" :@"id",
             @"iconURL" :@"pic",
             @"picWidth":@"picWidth",
             @"picHeight":@"picHeight",

             @"name":@"name",

             @"type":@"type",
             @"typeName":@"typeName",
             
             @"price":@"price",
             @"link" :@"link",
             @"sourceType":@"sourceType",
             };
    
}

+ (NSValueTransformer *)isMainJSONTransformer
{
    return [NSValueTransformer valueTransformerForName:MTLBooleanValueTransformerName];
}

+ (NSValueTransformer *)typeJSONTransformer
{
    NSDictionary *dic = @{
                          @(0):@(MyProductType_soldoution),
                          @(1):@(MyProductType_public),
                          @(2):@(MyProductType_privacy),
                          };
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:dic];
}
@end


@implementation WYCategoryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"sysCateId"         :@"sysCateId",
             @"sysCateName"       :@"sysCateName",
             };
}

@end

@implementation WYShopCategoryInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"index"       :@"index",
             @"categoryId"  :@"id",
             @"name"        :@"name",
             @"prods"       :@"prods",
             };
}

@end

@implementation WYPictureModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"p"       :@"p",
             @"w"       :@"w",
             @"h"       :@"h",
             };
}

@end

@implementation WYShopCategoryGoodsModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"goodsId"         :@"id",
             @"name"            :@"name",
             @"pic"             :@"pic",
             @"price"           :@"price",
             @"specification"   :@"specification",
             @"sourceType"      :@"sourceType",
             @"isMain"          :@"isMain",
             @"status"          :@"status",
             @"statusName"      :@"statusName",
             @"prodUrl"         :@"prodUrl",
             };
}

@end

@implementation EvaluateInfoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"createTime"      :@"createTime",
             @"content"         :@"content",
             @"score"           :@"score",
             @"score_s"         :@"score_s",
             @"icon"            :@"icon",
             @"nickname"        :@"nickname"
             };
}

@end

//330001_运费模板列表
@implementation FreightTemplateModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"fid"         :@"fid",
             @"fname"       :@"fname",
             @"url"         :@"url",
             };
}

@end

@implementation FreightListModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey{
    return @{
             @"desc"            :@"desc",
             @"freightList"     :@"vos",
             };
}

+ (NSValueTransformer *)freightListJSONTransformer{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[FreightTemplateModel class]];
}

@end
