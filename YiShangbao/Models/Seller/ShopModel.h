//
//  ShopModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

//内销外销
typedef NS_ENUM(NSInteger, ShopSaleType){
    ShopSaleType_domestic =0,      //内销
    ShopSaleType_export = 2,     //外销
    ShopSaleType_domesticAndExport =3, //内销和外销
    ShopSaleType_NO = 20, //没有选择
    
};

//经营模式（0-自有工厂；2-经销批发）
typedef NS_ENUM(NSInteger, ShopProSourceType){
    
    ShopProSourceType_ownFactory = 0,
    ShopProSourceType_wholesale = 2,
};


@interface ShopAddrModel : BaseModel

@property(nonatomic, copy) NSString *marketId;//### 大市场id（18.7.10新增参数）不影响老版本接口
@property(nonatomic, copy) NSString *kind;                          //是否为门楼街类型
@property(nonatomic, copy) NSString *submarket;                     //市场
@property(nonatomic, copy) NSString *submarketValue;                //市场


//老字段
@property(nonatomic, copy) NSString *gr1;                           //门 或者 省
@property(nonatomic, copy) NSString *gr1VO;                         //省
@property(nonatomic, copy) NSString *gr2;                           //楼 或者 市
@property(nonatomic, copy) NSString *gr2VO;                         //市
@property(nonatomic, copy) NSString *gr3;                           //街 或者 区
@property(nonatomic, copy) NSString *gr3VO;                         //县区
@property(nonatomic, copy) NSString *gr4;                           //商位号 或者 详细地址


//new
@property(nonatomic, copy) NSString *door;                      //门
@property(nonatomic, copy) NSString *floor;                     //楼
@property(nonatomic, copy) NSString *street;                    //街
@property(nonatomic, copy) NSString *booth;                     //商位号
@property(nonatomic, copy) NSString *pro;                       //省code
@property(nonatomic, copy) NSString *proVO;                     //省
@property(nonatomic, copy) NSString *city;                      //市code
@property(nonatomic, copy) NSString *cityVO;                    //市
@property(nonatomic, copy) NSString *area;                      //区code
@property(nonatomic, copy) NSString *areaVO;                    //区
@property(nonatomic, copy) NSString *addr;                      //详细地址

@end



@interface ShopManagerInfoModel : BaseModel

@property(nonatomic, strong) NSNumber *shopId;                        //商铺标识
@property(nonatomic, copy) NSArray *sysCates;                      //商铺主营类目
@property(nonatomic, copy) NSString *mainSell;                      //主营产品
@property(nonatomic, copy) NSString *mainBrand;                     //主营品牌
@property(nonatomic, strong) NSNumber *mgrPeriod;                     //经营年限
@property(nonatomic, strong) NSNumber *mgrType;                       //经营模式（0-自有工厂；2-经销批发）
@property(nonatomic, copy) NSString *factoryPics;                   //图片“，”分割
@property(nonatomic, strong) NSNumber *sellChannel;                   //销售渠道（0-内销，2-外销，3-既是外销也是内销）

@property (nonatomic, copy) NSString *sysCatesIds;
@end



@interface ShopContactModel : BaseModel

@property(nonatomic, copy) NSNumber *shopContactId;                 //商铺联系标识
@property(nonatomic, copy) NSNumber *shopId;                        //商铺标识
@property(nonatomic, copy) NSString *sellerName;                    //商铺经营者姓名
@property(nonatomic, copy) NSString *sellerPhone;                   //商铺经营者号码
@property(nonatomic, copy) NSString *tel;                           //经营者座机
@property(nonatomic, copy) NSString *fax;                           //经营者传真
@property(nonatomic, copy) NSString *qq;                            //经营者qq
@property(nonatomic, copy) NSString *wechat;                        //经营者微信
@property(nonatomic, copy) NSString *email;                         //经营者邮箱

@end

@interface AcctInfoModel : BaseModel
@property(nonatomic, strong) NSNumber *shopId;                      //id
@property(nonatomic, copy) NSNumber *bankId;                        //银行Id
@property(nonatomic, copy) NSString *bankIcon;                      //银行图标
@property(nonatomic, copy) NSString *bankCode;                      //银行code
@property(nonatomic, copy) NSString *bankValue;                     //银行
@property(nonatomic, copy) NSString *bankNo;                        //银行卡号
@property(nonatomic, copy) NSString *bankPlace;                     //支行信息
@property(nonatomic, copy) NSString *acctName;                      //户名

@property(nonatomic, copy) NSString *color;                         //颜色类型red，green，blue
@end

@interface BankModel : BaseModel

@property(nonatomic, copy) NSNumber *bankId;                        //银行Id
@property(nonatomic, copy) NSString *bankCode;                      //银行code
@property(nonatomic, copy) NSString *bankValue;                     //银行
@property(nonatomic, copy) NSString *bankValueS;                    //银行名称简写
@property(nonatomic, copy) NSString *icon;                          //图标

@end

@interface marketModel : BaseModel
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *code;         //子市场id
@property (nonatomic, copy) NSString *marketId; //大市场id
@property (nonatomic, copy) NSString *kind;     //1-普通市场，2-门楼街市场

@end


@interface ShopListModel : BaseModel
@property(nonatomic, copy) NSString *iconUrl;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *outline;
@property(nonatomic, copy) NSString *submarketValue;            //市场命名
@property(nonatomic, copy) NSString *door;                      //门
@property(nonatomic, copy) NSString *floor;                     //楼
@property(nonatomic, copy) NSString *street;                    //街
@property(nonatomic, copy) NSString *provinceVO;                  //省
@property(nonatomic, copy) NSString *cityVO;                      //市
@property(nonatomic, copy) NSString *areaVO;                      //区
@property(nonatomic, copy) NSString *address;                   //地址
@property(nonatomic, copy) NSString *boothNos;                   //商铺号，允许多个，中英逗号分
@property(nonatomic, copy) NSNumber *canTrade;                //支持在线交易 0-不支持（默认）1-支持
@end



@interface ShopModel : BaseModel

@property(nonatomic, copy) NSString *iconUrl;                   //商铺头像
@property(nonatomic, copy) NSString *name;                      //商铺名称
@property(nonatomic, copy) NSString *outline;                   //商铺描述
@property(nonatomic, copy) NSString *sysCates;                  //商铺主营类目
@property(nonatomic, copy) NSString *mainSell;                  //主营产品
@property(nonatomic, copy) NSString *marketId;                  //### 大市场id（18.7.10新增参数）不影响老版本接口
@property(nonatomic, copy) NSString *submarketCode;             //市场的code
@property(nonatomic, copy) NSString *submarketValue;            //市场命名
@property(nonatomic, copy) NSString *door;                      //门
@property(nonatomic, copy) NSString *floor;                     //楼
@property(nonatomic, copy) NSString *street;                    //街
@property(nonatomic, copy) NSString *province;                  //省
@property(nonatomic, copy) NSString *city;                      //市
@property(nonatomic, copy) NSString *area;                      //区
@property(nonatomic, copy) NSString *address;                   //地址
@property(nonatomic, copy) NSString *boothNos;                   //商铺号，允许多个，中英逗号分割，其他的只允许英文数字或者"-"，"/"，入库的时候是英文的逗号
@property(nonatomic, copy) NSString *sellerName;                //商铺经营者姓名
@property(nonatomic, copy) NSString *sellerPhone;               //商铺经营者号码
@property(nonatomic, copy) NSString *sellChannel;               //销售渠道（0-内销，2-外销）

@end



@interface SysCateModel : BaseModel

@property(nonatomic, copy) NSNumber *l;                   //等级
@property(nonatomic, copy) NSString *n;                   //类目名称
@property(nonatomic, copy) NSNumber *v;                   //类目id

@end


@interface ShopInfoModel : BaseModel

@property (nonatomic, copy) NSString *shopId;
@property (nonatomic, copy) NSString *shopName;//店铺名
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *iconUrl;//店铺头像
@property (nonatomic, copy) NSString *outline;//店铺简介
@property (nonatomic) BOOL shopRed;//商铺红点 1-设置 0-未设置或需要展示红点 ，下同
@property (nonatomic) BOOL quaRed;//认证设置
@property (nonatomic) BOOL tradeRed;//交易红点
@property (nonatomic) BOOL contactRed;//联系方式设置
@property (nonatomic) BOOL accountRed;
@property (nonatomic ,strong) NSNumber *canTrade;//是否可交易 1-支持
@property (nonatomic ,strong) NSNumber *canModify;//是否可以修改店铺名 0-可以修改 1-不可
@property (nonatomic, copy) NSString *shopQuaUrl;//商铺认证url
@property (nonatomic, copy) NSString *shopPreUrl;//商铺预览url
@property (nonatomic, copy) NSString *tradeScore;//交易的分
@property (nonatomic, copy) NSArray *identifys;//勋章图标，数组url
@property (nonatomic, copy) NSString *identifyDesc;//勋章文案
@property (nonatomic, copy) NSString *identifyUrl;//勋章Url
@property (nonatomic, copy) NSString *tradeScoreUrl;//交易得分Url
@end




// 301072_商铺首页
@class ShopHomeInfoModelFansVisiSub,ShopHomeExposeModel;

@interface ShopHomeInfoModel : BaseModel

@property (nonatomic, strong) NSURL *shopIconURL;
@property (nonatomic, copy) NSString *shopName;

//图标WYIconModlel
@property (nonatomic, copy) NSArray *identifierIcons;
//店铺二维码
@property (nonatomic, copy) NSString *ercode;
//店铺二维码红点标识 T-存在 F-不存在
@property (nonatomic, assign) BOOL ercodeReddot;
//粉丝访客
@property (nonatomic, strong) ShopHomeInfoModelFansVisiSub *fansAndVisitors;

@property (nonatomic, strong) ShopHomeExposeModel *exposeModel;

//必看通知红点标识； 目前没用，后端无法实现
@property (nonatomic, assign) BOOL noticeReddot;
//菜单
@property (nonatomic, copy) NSArray *baseService;
@property (nonatomic, copy) NSArray *appendService;
@property (nonatomic, copy) NSArray *perfectService;

// 商铺预览
@property (nonatomic, copy) NSString *viewUrl;

//店铺交易等级【2018/4/28】
@property (nonatomic, copy) NSString *tradeLevelIcon;
//店铺交易得分【2018/7/12】
@property (nonatomic, copy) NSString *tradeScore;

//店铺交易H5链接
@property (nonatomic, copy) NSString *tradeLevelUrl;


@end


@interface ShopHomeInfoModelFansVisiSub : BaseModel

@property (nonatomic, strong) NSNumber *fans;
@property (nonatomic, strong) NSNumber *visitors;
//粉丝红点标识 T-存在 F-不存在
@property (nonatomic, assign) BOOL fansReddot;
//访客红点标识 T-存在 F-不存在
@property (nonatomic, assign) BOOL visitorsReddot;

@end


@interface BadgeItemCommonModel : BaseModel

// 跳转url
@property (nonatomic, copy) NSString *url;

// 图片地址
@property (nonatomic, copy) NSString *icon;

// 模块名称，标题展示
@property (nonatomic, copy) NSString *desc;

// 模块类型，1：native 2：h5
@property (nonatomic, strong) NSNumber *type;

// 模块名称标志- 标记用的；
@property (nonatomic, copy) NSString *name;


// 是否需要登录
@property (nonatomic, assign) BOOL needLogin;

// 是否需要开通商铺
@property (nonatomic, assign) BOOL needOpenShop;

// 是否需要认证
@property (nonatomic, assign) BOOL needAuth;

// 角标类型0-无，1-红点，2-数字，3-图片
@property (nonatomic, assign) NSInteger sideMarkType;

// 当sideMarkType为数字或者图片的时候读取
@property (nonatomic, copy) NSString *sideMarkValue;

// 是否展示“V”，标识该服务用户已订购
@property (nonatomic, assign) BOOL vbrands;

@end

// 8.28- 3.7.2
@interface ShopHomeExposeModel : BaseModel
//曝光数
@property (nonatomic, copy) NSString *exposeNum;
//跳转URL
@property (nonatomic, copy) NSString *exposeUrl;
@end
