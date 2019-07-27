//
//  SearchModel.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

//产品货源类型 0-全部 1-现货 2-订做
typedef NS_ENUM(NSInteger, WYSearchProductType){
    WYSearchProductTypeQuanBu  = 0,      //0-全部
    WYSearchProductTypeXianHuo = 1,      //1-现货
    WYSearchProductTypeDingZuo = 2,      //2-订做
    
};

/**
 810006_获取筛选条件接口 模型
 */
@interface SearchCatesModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //所在地id
@property(nonatomic, copy) NSString *name;                    //所在地名称
@end
@interface SearchLocationsModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //类目id
@property(nonatomic, copy) NSString *name;                    //类目名称
@end
@interface SearchProductSourcesModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //货源类型id
@property(nonatomic, copy) NSString *name;                    //货源类型名称
@end
@interface SearchScreenModel : BaseModel
@property(nonatomic, strong) NSArray *locations;                     //所在地
@property(nonatomic, strong) NSArray *cates;                 //类目
@property(nonatomic, strong) NSArray *productSources;                   //货源类型
@end
/**
 搜索轮播图
 */
@interface SearchLunBoModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //商铺id
@property(nonatomic, copy) NSString *headPicUrl;              //商铺头像图片url
@property(nonatomic, copy) NSString *name;                    //商铺名称
@property(nonatomic, strong) NSNumber *badges;                  //徽章 和值形式 0-无 1-实体认证 2-重点商家
@property(nonatomic, copy) NSArray *icons;                  //商铺图标V2.4.0后统一使用这套图标逻辑方案

@property(nonatomic, copy) NSString *businessAgeAndMode;      //经营年限和模式
@property(nonatomic, copy) NSString *address;                 //商铺地址
@property(nonatomic, copy) NSString *payMark;                 //付费标识

@property(nonatomic, copy) NSString *mainSell;                 //主营产品
@property (nonatomic, copy) NSString *link;                     //商铺详情页面链接url
@end

@interface SearchLunBoMainModel : BaseModel
@property(nonatomic, strong) NSArray *shops;
@property(nonatomic, strong) NSString *shopCnt;
@end

/**
 产品搜索
 */

@interface SearchProMainModel : BaseModel
@property(nonatomic, copy) NSString *responseId ; //    string    应答id
@property(nonatomic, strong) NSNumber *flag;        //      int    结果标识 0-产品 1-推荐关键词
@property(nonatomic, copy) NSArray *products ;   //        json数组字符串
//@property(nonatomic, copy)NSArray *tryKeywords; //
@end

@interface SearchModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //产品id
@property(nonatomic, copy) NSString *picUrl;                  //产品图片url
@property(nonatomic, copy) NSString *name;                    //产品名称
@property(nonatomic, copy) NSString *specs;                   //产品规格
@property(nonatomic, copy) NSString *address;                 //商铺地址
@property(nonatomic, copy) NSString *price;                   //产品批发价
@property (nonatomic) WYSearchProductType sourceType;         //产品货源类型 1-现货 2-订做
@property(nonatomic, copy) NSString *sourceTypeName;          //产品货源类型名称
@property(nonatomic, copy) NSString *payMark;                 //付费标识
@property (nonatomic, copy) NSString *link;                     //产品详情页面链接url

@end



/**
 合并相同卖家/搜索商铺－－－－
 */
@interface SearchShopProductsModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //产品id
@property(nonatomic, copy) NSString *picUrl;                  //产品图片url
@property (nonatomic, copy) NSString *link;                     //产品详情页面链接url
@end

@interface SearchShopModel : BaseModel
@property(nonatomic, copy) NSString *iid;                     //商铺id
@property(nonatomic, copy) NSString *headPicUrl;              //商铺头像图片url
@property(nonatomic, copy) NSString *name;                    //商铺名称
@property(nonatomic, strong) NSNumber *badges;                  //徽章 和值形式 0-无 1-实体认证 2-重点商家3- 实体认证＋重点商家
@property(nonatomic, copy) NSArray *icons;                  //商铺图标V2.4.0后统一使用这套图标逻辑方案
@property(nonatomic, copy) NSString *businessAgeAndMode;      //经营年限和模式
@property(nonatomic, copy) NSString *address;                 //商铺地址
@property(nonatomic, copy) NSArray *products;                 //产品模型数组
@property(nonatomic, copy) NSString *resultDesc;              //结果描述-> 合并相同卖家特有字段
@property(nonatomic, copy) NSString *mainSell;                //主营产品-> 搜索商铺特有字段
@property(nonatomic, copy) NSString *payMark;                 //付费标识
@property (nonatomic, copy) NSString *link;                 //商铺详情页面链接url
@end
//--------

