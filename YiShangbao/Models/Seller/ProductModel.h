//
//  ProductModel.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"
#import "AddProductModel.h"

/**
 产品管理：类型
 */
typedef NS_ENUM(NSInteger, MyProductType){
    
    MyProductType_soldoution =0,   //已下架
    MyProductType_public = 1,     //公开出售的产品列表
    MyProductType_privacy =2,      //私密产品列表
    MyProductType_None = NSIntegerMax,//无
};

// 采购商信息类型
typedef NS_ENUM(NSInteger, WYPurchaserType){
    
    WYPurchaserType_app =1,   //app
    WYPurchaserType_weiXin = 2,  //微信访客
    WYPurchaserType_tourist =3,  //游客
};



@interface ProductModel : BaseModel

@end

//商铺首页概要 的工具
@interface ShopInfoWidgetsModel : BaseModel
//跳转url
@property (nonatomic, copy) NSString *url;
//图片
@property (nonatomic, strong) NSURL *iconURL;

//模块名称
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSNumber *type;
//模块名称标志
@property (nonatomic, copy) NSString *name;

//角标图片
@property (nonatomic, copy) NSString *badgeIcon;
//角标数量
@property (nonatomic, strong) NSNumber *num;


@end

//商铺首页概要
@interface ShopMainInfoModel : BaseModel

@property (nonatomic, strong) NSURL *shopIconURL;
@property (nonatomic, copy) NSString *shopName;


@property (nonatomic, strong) NSNumber *fans;
@property (nonatomic, strong) NSNumber *visitors;
//菜单
@property (nonatomic, copy) NSArray *widgets;
@property (nonatomic, copy) NSArray *topWidgets;

//图标WYIconModlel
@property (nonatomic, copy) NSArray *sellerBadges;
@end


//上架初始化
@interface ProductPutawayInitModel : BaseModel

@property (nonatomic, strong) NSNumber *picLimit;
// 上次所选的三级类目id
@property (nonatomic, strong) NSNumber *sysCateId;

// 上次所选的三级类目名称
@property (nonatomic, copy) NSString *sysCateName;

// 是否展示"是否设为主营产品"radio
@property (nonatomic, assign) BOOL ifRadioDisplay;

// 剩余可设置的主营产品数
@property (nonatomic, strong) NSNumber *timesLeft;

// 最近显示的5个类目
@property (nonatomic, copy) NSArray *latestSysCates;

// 总主营产品数限制
@property (nonatomic, strong) NSNumber *totalTimes;

// 是否有运费模板 2018.4.26
@property (nonatomic, assign) BOOL hasFreightTemp;
@end


//获取上架系统类目
@interface ProSystemCatesModel : BaseModel
//类目id
@property (nonatomic, strong) NSNumber *cateId;
//等级
@property (nonatomic, strong) NSNumber *level;
//类目名称
@property (nonatomic, copy) NSString *name;
@end






@interface ShopBaseModel : BaseModel

/**
 用户id －uid
 */
@property (nonatomic,copy) NSString *userId;

/**
 求购者名称-nn
 */
@property (nonatomic,copy) NSString *userName;

/**
 头像-tx
 */
@property (nonatomic,strong) NSURL *iconURL;

/**
 公司名字－cn
 */
@property (nonatomic,copy) NSString *companyName;
//是否企业认证
@property (nonatomic,assign) BOOL showAuthCompany;
//是否个人认证
@property (nonatomic,assign) BOOL showAuthPerson;
//特邀
@property (nonatomic,assign) BOOL showAuthGuest;

//采购商图标
@property (nonatomic, copy) NSArray *buyerBadges;
@end

//粉丝列表model
@interface ShopFansModel : ShopBaseModel


@end


@interface ShopVisitorsModel : ShopBaseModel

@property (nonatomic ,copy) NSString *modifyTime;

@end

//最近发布的生意
@interface RecentlyBizsModel : BaseModel

@property (nonatomic, copy) NSString *productName;

@property (nonatomic, copy) NSString *createTime;

//求购生意id
@property (nonatomic, copy) NSString *subjectId;

//是否完成
@property (nonatomic, assign) BOOL valid;
@end


//采购商信息
@class EvaluateInfoModel;
@interface ShopPurchaserInfoModel : ShopBaseModel

//城市展示省-市-区
@property (nonatomic ,copy) NSString *locationName;
//采购列表"
@property (nonatomic, copy) NSArray *buyProducts;
//简介
@property (nonatomic, copy) NSString *intro;
//来源，返回没有字段啊
@property (nonatomic, copy) NSString *source;
//最近发布的生意
@property (nonatomic, copy) NSArray *lastBizs;
//最近在找的产品
@property (nonatomic ,copy) NSArray *lastProducts;
//发布求购总数
@property (nonatomic, strong) NSNumber *totalNiches;

// 评价
@property (nonatomic, strong) EvaluateInfoModel *subjectPurchaseRate;
// 评价数量
@property (nonatomic, strong) NSNumber *countSubjectPurchaseRates;

// 是否展示添加客户
@property (nonatomic, assign) BOOL showCustomer;

// 采购商信息类型
@property (nonatomic, assign) WYPurchaserType purchaserType;

@end

//我的商铺的商品列表

@interface ShopMyProductModel : BaseModel

@property (nonatomic, assign) BOOL isMain;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, strong)NSURL *iconURL; //对应的pic.p
@property (nonatomic, strong)AliOSSPicUploadModel *pic; 

@property (nonatomic, copy) NSString *link;

@property (nonatomic ,copy) NSString *sourceType;


@end


@interface ProductManagerCountModel : BaseModel

//状态 2-私密 1-出售中 0-已下架

@property (nonatomic, strong) NSNumber *status;

@property (nonatomic, strong) NSNumber *proCount;

@end

//810009_获取商户产品列表接口
@interface MyProductSearchModel : BaseModel

@property (nonatomic, assign) BOOL isMain;

@property (nonatomic, copy) NSString *productId;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *price;

@property (nonatomic, strong)NSURL *iconURL;

@property (nonatomic, strong)NSNumber *picWidth ;//   int    产品主图宽
@property (nonatomic, strong)NSNumber *picHeight  ;//   int    产品主图高

@property (nonatomic, copy) NSString *link;


//获取货物定做还是什么的类型名字
@property (nonatomic ,copy) NSString *sourceType;

//产品类型,产品类型 0-下架 1-公开 2-私密
@property (nonatomic ,assign)MyProductType type;

//产品类型名词
@property (nonatomic ,copy) NSString *typeName;

@end



//类目model
@interface WYCategoryModel : BaseModel

@property (nonatomic ,strong) NSNumber *sysCateId;
@property (nonatomic ,strong) NSString *sysCateName;

@end

#pragma mark- ShopCategory
@interface WYShopCategoryInfoModel : BaseModel

@property (nonatomic ,strong) NSNumber *index;
@property (nonatomic ,copy) NSString *categoryId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,strong) NSNumber *prods;
//自定义是否选中
@property (nonatomic) BOOL isSelected;

@end

@interface WYPictureModel : BaseModel

@property (nonatomic ,copy) NSString *p;
@property (nonatomic ,assign) NSInteger w;
@property (nonatomic ,assign) NSInteger h;

@end

@interface WYShopCategoryGoodsModel : BaseModel

@property (nonatomic ,assign)NSInteger goodsId;
@property (nonatomic ,copy) NSString *name;
@property (nonatomic ,strong) WYPictureModel *pic;
@property (nonatomic ,copy) NSString *price;
@property (nonatomic ,copy) NSString *specification;
@property (nonatomic ,copy) NSString *sourceType;
@property (nonatomic ,assign) BOOL isMain;
@property (nonatomic ,assign) NSInteger status;
@property (nonatomic ,copy) NSString *statusName;
@property (nonatomic ,copy) NSString *prodUrl;
//自定义是否选中
@property (nonatomic) BOOL isSelected;

@end

//对买家评价
@interface EvaluateInfoModel : BaseModel

@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *score_s;
@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *nickname;

@end

//330001_运费模板列表
@interface FreightTemplateModel : BaseModel

@property (nonatomic, copy) NSString *fid;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, copy) NSString *fname;

@end

@interface FreightListModel : BaseModel

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSArray *freightList;

@end




