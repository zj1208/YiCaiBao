//
//  PurchaserModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"
@class WYOrderNumberModel;
@class WYLikeNumberModel;
//-------------------------------------------------------------------------------
@interface BuyerUserModel : BaseModel

@property (nonatomic, strong) WYOrderNumberModel *order;         //不同状态订单数量
@property (nonatomic, strong) WYLikeNumberModel *like;             //收藏商铺等数量
@property (nonatomic, copy) NSString *headIcon;                  //头像存放路径
@property (nonatomic, copy) NSString *describe;                  //描述
@property (nonatomic, copy) NSString *nickname;                  //昵称，微信昵称
@property (nonatomic, strong) NSNumber *percent;                 //资料完整度
@property (nonatomic, strong) NSNumber *showAuthPerson;          //个人认证 true展示，false不展示
@property (nonatomic, strong) NSNumber *showAuthCompany;         //企业认证 true展示，false不展示
@property (nonatomic, strong) NSNumber *showAuthGuest;           //特邀采购员 true展示，false不展示
@property (nonatomic, copy) NSString *countryCode;               //国家区号
@property (nonatomic, copy) NSString *phone;                     //手机认证号码
@property (nonatomic, copy) NSString *authName;                  //个人名字或者公司名字，隐藏中间两个字
@property (nonatomic, copy) NSString *authStatus;                //0未审核，101个人待审核，102个人认证通过，企业待审核，103个人未认证，企业待审核，2个人认证成功，3企业认证成功
@property (nonatomic, copy) NSString *qq;                        //客服qq
@property (nonatomic, strong) NSNumber *bindWechat;                        //false-未绑定 true-绑定
@property (nonatomic, strong) NSNumber *needSetPwd;                        //false,不需要，true需要
@property (nonatomic, strong) NSNumber *score;//积分
@property (nonatomic, copy) NSString *scoreUrl;//积分

//图标WYIconModlel
@property (nonatomic, copy) NSArray *buyerBadges;

@property (nonatomic, copy) NSString *link;//

@end

@interface WYOrderNumberModel : BaseModel

@property (nonatomic, strong) NSNumber *waitConfirmCount;
@property (nonatomic, strong) NSNumber *waitPayCount;
@property (nonatomic, strong) NSNumber *waitTranCount;
@property (nonatomic, strong) NSNumber *waitReceiveCount;
@property (nonatomic, strong) NSNumber *waitEvalCount;

@end

@interface WYLikeNumberModel : BaseModel

@property (nonatomic, strong) NSNumber *subjectCount;
@property (nonatomic, strong) NSNumber *favorShopCount;
@property (nonatomic, strong) NSNumber *favorProdCount;

@end

//---------------------------------------------------------------------------------
@interface PurchaserCommonAdvModel : BaseModel
@property(nonatomic, strong) NSNumber *iid;            //广告id
@property(nonatomic, strong) NSNumber *areaId;        //区块id
@property(nonatomic, copy) NSString *pic;           //图片
@property(nonatomic, copy) NSString *title;        //标题，中文内容
@property(nonatomic, copy) NSString *desc;        //标题描述，中文内容
@property(nonatomic, copy) NSString *url;        //点击跳转url
@end


@interface YcbRegInfoModel : BaseModel
@property(nonatomic, copy) NSString *name;                   //数据名称
@property(nonatomic, strong) NSNumber *value;                  //数据值

@end

@interface NewsModel : BaseModel
@property(nonatomic, copy) NSString *label;        //标签文案，如：热门
@property(nonatomic, copy) NSString *title;        //咨询标题
@property(nonatomic, copy) NSString *newsUrl;      //咨询跳转h5

@end

@interface YcbBuyNewsModel : BaseModel
@property(nonatomic, copy) NSString *iconUrl;        //采购咨询icon
@property(nonatomic, copy) NSArray *news;            //采购咨询列表
@end
@interface TopCategoryModel : BaseModel
@property(nonatomic, copy) NSString *icon;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *route;
@end

#pragma mark - MainModel
@interface PurchaserModel : BaseModel

@property(nonatomic, strong)NSArray *advInfo;               //顶部轮播图
@property(nonatomic, strong)NSArray *ycbRegInfo;            //平台注册数据等，注意顺序
@property(nonatomic, strong)NSArray *funcBarInfo;           //功能条,
@property(nonatomic, copy)YcbBuyNewsModel *ycbBuyNews;      //采购咨询

@property(nonatomic, copy)NSArray *goldAdvInfo;    //单张广告图 - 取第一个展示
@property(nonatomic, copy)NSArray *specialAdvInfo; //单张广告图下正方形横向滚动列表
@property(nonatomic, copy)NSArray *tbzgAdv;        //淘宝直供广告位 - 取第一个展示
@property(nonatomic, copy)NSArray *lowPriceStockAdv ; //底价库存广告位 - 取第一个展示
@property(nonatomic, copy)NSArray *hotShopAdv;        //热销店铺广告位 - 取第一个展示

@property(nonatomic, copy)NSArray *bestProductsAdv;   //精品推荐广告位，横向滚动列表
@property(nonatomic, copy)NSArray *lunboAdv;          //轮播广告位 -热搜类目上方轮播

@property(nonatomic, strong)NSArray *topCategory;              //人气分类，1：表示展示，0：不展示
@property(nonatomic, strong)NSString *shopRecmd;               //单个商铺推荐，1：表示展示，0：不展示
@property(nonatomic, strong)NSString *shopSpecial;             //商铺专题，1：表示展示，0：不展示
@property(nonatomic, strong)NSString *productSpecial;          //产品专题，1：表示展示，0：不展示
@property(nonatomic, strong)NSString *guessYouLike;            //为你推荐产品，1：表示展示，0：不展示
@end


@interface RecommendPicsModel : BaseModel

@property(nonatomic, copy)NSString *p;                          //原图url
@property(nonatomic, strong)NSNumber *h;                          //原图高度
@property(nonatomic, strong)NSNumber *w;                          //原图宽度

@end

//--------------------------------------------------------------------------------

@interface PurchaserListModel : BaseModel
@property(nonatomic, strong)NSString *iid;                         //产品id
@property(nonatomic, copy)NSString *picUrl;                        //产品图片url
@property(nonatomic, copy)NSString *name;                          //产品名称
@property(nonatomic, copy)NSString *price;                        //产品批发价
@property(nonatomic, strong)NSNumber *sourceType;                  //产品货源类型 1-现货 2-订做
@property(nonatomic, copy)NSString *sourceTypeName;                //产品货源类型名称
@property (nonatomic, copy) NSString *link;                         //产品详情页面链接url
@end


@interface RecommendModel : BaseModel

@property(nonatomic, copy)NSString *intro;                      //简介
@property(nonatomic, copy)NSString *shopId;                     //商铺id
@property(nonatomic, copy)NSString *shopName;                   //商铺名称
@property(nonatomic, copy)NSString *shopIcon;                   //商铺头像
@property(nonatomic, strong)NSNumber *isKeySeller;              //是否为重点供应商
@property(nonatomic, strong)NSNumber *authStatus;               //卖家认证状态 0-未认证 1-市场认证
@property(nonatomic, copy)NSString *publishTime;                //发布时间
@property(nonatomic, strong)NSArray *pics;                       //图片

@end



@interface SpreadModel : BaseModel

@property(nonatomic, strong)NSArray *recommendProduct;          //推广产品列表
@property(nonatomic, strong)NSArray *recommendinventory;        //推荐库存列表

@end

//------------------------------------------------------------------------------
@interface bgpModel : BaseModel
@property(nonatomic, strong)NSNumber *h;
@property(nonatomic, copy)NSString *p;
@property(nonatomic, strong)NSNumber *w;
@end

@interface RecmdShopsModel : BaseModel
@property(nonatomic, copy)NSString *iid;                             //商铺标识
@property(nonatomic, copy)NSString *name;                          //
@property(nonatomic, copy)bgpModel *pic;                          //

@property(nonatomic, copy)NSString *url;                          //
@end



@interface ShopRecmdListModel : BaseModel

@property(nonatomic, strong)NSNumber *index;                      //序列标识
@property(nonatomic, copy)NSString *link;                        //link
@property(nonatomic, copy)NSString *title;                        //标题
@property(nonatomic, copy)bgpModel *bgp;                          //背景图
@property(nonatomic, copy)NSString *outline;                      //描述
@property(nonatomic, strong)NSArray *shops;                       //外层商铺预览

@end


//----
@interface prodsModel : BaseModel

@property(nonatomic, strong)NSString *iid;                      //产品标识
@property(nonatomic, copy)NSString *prodName;                   //产品名称
@property(nonatomic, copy)NSString *price;                      //价格
@property(nonatomic, copy)bgpModel *pic;                        //图片 见备注
@property(nonatomic, strong)NSString *alias;                    //友盟统计，无业务含义recmdsalone1prod1

@property (nonatomic, copy) NSString *link;
@property(nonatomic, copy)NSString *url;                          //
@end


@interface ShopStandAloneRecmdModel : BaseModel
@property(nonatomic, copy)NSString* shopId	;	//N	string	商铺标识
@property(nonatomic, copy)NSString* shopName;	//N	string	商铺名称
@property(nonatomic, copy)NSString* iconUrl	;	//N	string	商铺头像
@property(nonatomic, copy)NSString* descriptionN;		//N	string	描述
@property(nonatomic, strong)NSNumber* supplierSig;      //N	number	重点供应商标识 1-是，0-不是
@property(nonatomic, strong)NSNumber* authMarket	;   //	N	number	市场认证标识 1-是，0-不是
@property(nonatomic, strong)NSNumber* hasFactory	;   //	N	number	自有工厂 1-是，0-不是
@property(nonatomic, copy)NSArray*identifierIcons ;     //商铺图标V2.4.0后统一使用这套图标逻辑方案
@property(nonatomic, copy)NSArray*prods ;           //产品数
@property(nonatomic, copy)NSString*alias	;       //	N	string	友盟统计，无业务含义,如recmdsalone1
@property (nonatomic, copy) NSString *url;//商铺地址

@end

@interface prodRecmdModel : BaseModel
@property(nonatomic, strong)NSString *iid;                      //产品标识
@property(nonatomic, copy)NSString *link;                   //
@property(nonatomic, copy)NSString *title;                   //产品名称
@property(nonatomic, copy)NSString *descriptionN;                      //价格
@property(nonatomic, copy)bgpModel *bgp;                        //图片 见备注
@property(nonatomic, copy)NSArray*prods ;
@property(nonatomic, strong)NSString *alias;                    //友盟统计，无业务含义recmdsalone1prod1
@end







