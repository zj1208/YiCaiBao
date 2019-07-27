//
//  ShopAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "ShopModel.h"

//301001_创建商铺
#define Post_createShopInfo_URL         @"mtop.shop.store.createShopInfo"
//301003_查询商铺ID（判断是否开店
#define Select_quryShopInfo_URL         @"mtop.shop.store.quryShopInfo"
//301004_修改商铺头像
#define modify_ShopIcon_URL             @"mtop.shop.store.modifyShopIcon"
//301006_获取商铺详情
#define Get_ShopDetail_URL              @"mtop.shop.store.getShopDetail"
//301007_获取地址信息。 //老接口不用
#define Get_ShopArrd_URL                @"mtop.shop.store.getShopArrd"
//301100_获取地址信息2
#define Get_ShopArrdNew_URL             @"mtop.shop.store.getShopArrdNew"
//301008_修改地址信息   //老接口不用了
#define Modify_ShopArrd_URL             @"mtop.shop.store.modifyShopArrd"
//301101_修改地址信息2
#define Modify_ShopArrdNew_URL          @"mtop.shop.store.modifyShopArrdNew"
//301009_获取简介
#define Get_ShopIntroduce_URL           @"mtop.shop.store.getShopIntroduce"
//301010_修改简介
#define Modify_ShopIntroduce_URL        @"mtop.shop.store.modifyShopIntroduce"
//301011_获取经营信息
#define Get_ShopManagerInfo_URL         @"mtop.shop.store.getShopManagerInfo"
//301012_更新经营信息
#define Modify_ShopManagerInfo_URL      @"mtop.shop.store.modifyShopManagerInfo"
//301013_获取联系信息
#define Get_ShopContact_URL             @"mtop.shop.store.getShopContact"
//301014_修改联系信息
#define Modify_ShopContact_URL          @"mtop.shop.store.modifyShopContact"

//100011_获取银行账户信息
#define Get_AcctInfo_URL                @"mtop.user.getAcctInfo"
//100012_增加银行账户信息
#define Add_AcctInfo_URL                @"mtop.user.addAcctInfo"
//100052_删除银行用户信息
#define Delete_AcctInfo_URL             @"mtop.user.deleteAcctInfo"
//100054_修改银行账户信息
#define Update_AcctInfo_URL             @"mtop.user.updateAcctInfo"
//100054_获取银行列表
#define Get_BankList_URL             @"mtop.app.getBankList"

//711005_获取市场
#define Get_Markets_URL             @"mtop.external.base.getMarkets"
//711030_获取市场New
#define Get_MarketsNew_URL             @"mtop.external.base.getMarketsNew"
//301028_获取公告
#define Get_ShopAnnouncement_URL           @"mtop.shop.store.quryShopAnnouncement"
//301029_增加公告
#define Add_ShopAnnouncement_URL        @"mtop.shop.store.addShopAnnouncement"
//010201_获取系统类目
#define Get_SysCates_URL        @"mtop.cat.sysCates"

//301055_接生意商铺设置
#define Post_Trade_shop_store_mfyShopMgr4order_URL   @"mtop.shop.store.mfyShopMgr4order"

//301059_修改是否支持在线交易
#define Post_mtop_shop_store_modifyShopCantrade_URL   @"mtop.shop.store.modifyShopCantrade"

//301060_清除商铺新订单
static NSString *const kShop_store_pruneNewOrderMark_URL= @"mtop.shop.store.pruneNewOrderMark";

//301070_校验新增商铺名
static NSString *const kShop_store_CheckShopname_URL = @"mtop.shop.store.checkShopName";

//301071_修改店铺名
static NSString *const kShop_store_modifyShopName_URL = @"mtop.shop.store.modifyShopName";

//301073_刷新点击
static NSString *const kShop_store_flushSubscribe_URL = @"mtop.shop.store.flushSubscribe";

//301080_商铺设置查看
static NSString *const kShop_store_getShopInfoNew_URL = @"mtop.shop.store.getShopInfoNew";

//301072_商铺首页
static NSString *const kShop_store_shopHome = @"mtop.shop.store.shopHome";

//301051_关注、取关店铺
static NSString *const kShop_store_attention = @"mtop.shop.store.changeFollow";

@interface ShopAPI : BaseHttpAPI

/**
 301055_接生意商铺设置
 @param sysCates 商铺主营类目
 @param mainSell 主营产品
 @param success success description
 @param failure failure description
 */
-(void)postShopStoreMfyShopMgr4orderWithSysCates:(NSString *)sysCates  mainSell:(NSString *)mainSell success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 创建商铺

 @param model 商铺信息
 @param success success block
 @param failure failure block
 */
-(void)postCreateShopInfoWithParameters:(ShopModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 查询商铺ID（判断是否开店

 @param success success block
 @param failure failure block
 */
-(void)getMyShopIdsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

-(void)getSynchronousShopIdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
 修改商铺头像

 @param icon 头像信息
 @param success success block
 @param failure failure block
 */
-(void)modifyShopIconWithIcon:(NSString *)icon success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取商铺详情

 @param success success block
 @param failure failure block
 */
-(void)getShopDetailWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取地址信息     老接口不用了

 @param success success block
 @param failure failure block
 */
-(void)getShopArrdWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301100_获取地址信息2

 @param success success description
 @param failure failure description
 */
- (void)getShopArrdNewWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 修改地址信息

 @param model 商铺地址信息model
 @param success success block
 @param failure failure block
 */
-(void)modifyShopArrdWithParameters:(ShopAddrModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301101_修改地址信息2

 @param model 商铺地址信息model
 @param success success description
 @param failure failure description
 */
- (void)postModifyShopArrdWithParameters:(ShopAddrModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取商铺简介
 
 @param success success block
 @param failure failure block
 */
-(void)getShopIntroduceWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 修改简介

 @param outline 内容
 @param success success block
 @param failure failure block
 */
-(void)modifyShopIntroduceWithoutline:(NSString *)outline success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取经营信息

 @param shopId 商铺id
 @param success success block
 @param failure failure block
 */
-(void)getShopManagerInfoWithshopId:(NSString *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 更新经营信息

 @param model 经营信息model
 @param success success block
 @param failure failure block
 */
-(void)modifyShopManagerInfoWithParameters:(ShopManagerInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取联系信息

 @param success success block
 @param failure failure block
 */
-(void)getShopContactWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 修改联系信息

 @param model 联系信息model
 @param success success block
 @param failure failure block
 */
-(void)modifyShopContactWithParameters:(ShopContactModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
  100011_获取账户信息(银行卡信息）
 @param type 信息类型，可为空，默认为0，0-全部银行卡信息 1-可提现银行卡信息
 @param success success block
 @param failure failure block
 */
-(void)getAcctInfoWithType:(NSNumber*)type Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 100012_增加银行账户信息
 
 @param channel 增加渠道，可为空，默认为0，0-商铺 1-提现 2-我的银行卡
 @param model 银行账号信息model
 @param success success block
 @param failure failure block
 */
-(void)addAcctInfoWithChannel:(NSNumber*)channel Parameters:(AcctInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 删除银行账户信息

 @param AccId 账户标识
 @param success success block
 @param failure failure block
 */
-(void)deleteAcctInfoWithAccId:(NSNumber *)AccId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
100014_修改账户信息 
 
 @param channel 增加渠道，可为空，默认为0，0-商铺 1-提现 2-我的银行卡
 @param model 账户信息model
 @param success success block
 @param failure failure block
 */
-(void)updateAcctInfoWithChannel:(NSNumber*)channel Parameters:(AcctInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取银行列表

 @param success success block
 @param failure failure block
 */
-(void)getBankListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取市场                   //已经不用了
 (隐藏参数：ext 是否展示其它市场，默认为空不展示；1：展示)
 @param success success block
 @param failure failure block
 */
-(void)getMarketsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 711030_获取市场New

 @param city 城市
 @param success success description
 @param failure failure description
 */
- (void)getMarketsByCity:(NSString *)city success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取公告

 @param success success block
 @param failure failure block
 */
-(void)getShopAnnouncementWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 增加公告

 @param shopId 商铺id
 @param content 商铺公告
 @param success success block
 @param failure failure block
 */
-(void)addShopAnnouncementWithshopId:(NSString *)shopId content:(NSString *)content success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取系统类目

 @param tagId 父类目id id和level不可同时为空
 @param level 类目等级 id和level不可同时为空
 @param success success block
 @param failure failure block
 */
-(void)getSysCatesWithId:(NSNumber *)tagId level:(NSNumber *)level success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 修改是否支持在线交易
 
 @param status 是否支持在线交易 0-不支持，1-支持
 @param success success description
 @param failure failure description
 */
- (void)postShopTradeSettingWithStatus:(NSNumber *)status success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301060_清除商铺新订单,get
 */
- (void)postShopStorePruneNewOrderMarkWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301070_校验新增商铺名

 @param name 商铺名
 @param success success description
 @param failure failure description
 */
- (void)getShopStoreCheckShopName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301071_修改商铺名

 @param name 商铺名
 @param success success description
 @param failure failure description
 */
- (void)postShopStoreModifyShopName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301073_刷新点击

 @param name 点击地方
 @param success success description
 @param failure failure description
 */
- (void)postShopStoreFlushClickWithName:(NSString *)name  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301080_商铺设置查看

 @param success success description
 @param failure failure description
 */
- (void)getShopStoreShopInfoNewSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 //301072_商铺首页
 0（默认）-全部【不包括4】，1-基础服务，2-增值服务，3-粉丝访客，4-优选服务

 */
- (void)getShopHomeInfoWithFactor:(NSNumber *)factor Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //301051_关注、取关店铺

 @param shopId 店铺ID
 @param status 请求关注状态
 @param success success description
 @param failure failure description
 */
- (void)postShopAttentionShopId:(NSString *)shopId status:(NSString *)status success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
