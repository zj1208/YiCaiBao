//
//  PurchaserAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

#pragma mark - Purchaser URL
////010701_采购端首页配置（废弃）
//#define Get_PurchaserIndexConfig_URL             @"mtop.index.getConfig"

//010703_客户端首页配置
#define Get_mtop_index_getConfig_URL                    @"mtop.index.getConfig"
//010502_APP扫码
#define Get_appScanQR_URL                        @"mtop.qr.appScanQr"


//101002_获取采购端用户详情
#define Get_BuyerInfo_URL                        @"mtop.user.getBuyerInfo"


//304010_推广推荐
#define Get_spread_URL                           @"mtop.spread.rec"

//301032_获取商铺推荐列表（搜索）V2.0
#define Get_ShopRecmdList_URL                    @"mtop.shop.store.getShopRecmdList"

//810012_获取为你推荐产品列表接口
#define Get_search_getRecommendProductList_URL   @"mtop.search.getRecommendProductList"

//301056_单个商铺推荐
#define Get_mtop_shop_store_shopStandAloneRecmd_URL   @"mtop.shop.store.shopStandAloneRecmd"
//301057_产品推荐 
#define Get_mtop_shop_store_prodRecmd_URL   @"mtop.shop.store.prodRecmd"




@interface PurchaserAPI : BaseHttpAPI

/**
301056_单个商铺推荐

 @param success success description
 @param failure failure description
 */
- (void)getShopStandAloneRecmdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
- (id)getShopStandAloneRecmdWithSuccess_DataCache; //数据缓存,和上面👆接口success返回一致

/**
301057_产品推荐
 
 @param success success description
 @param failure failure description
 */
- (void)getProdRecmdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
- (id)getProdRecmdWithSuccess_DataCache;


/**
 810012_获取为你推荐产品列表接口

 @param timestamp 时间戳，每次访问第一页数据的时候生成，之后的页面数据仍旧使用访问第一页数据时的时间戳
 @param preTimestamp 前一次访问时间戳，只有在访问第一页的时候才需要，如果没有前一次访问时间戳则设置为0
 @param pageNo 第几页，未设置的情况默认第一页
 @param pageSize 每页几条，未设置的情况默认每页十条
 @param success success description
 @param failure failure description
 */
- (void)getPurchaserListWithTimestamp:(NSString *)timestamp preTimestamp:(NSString*)preTimestamp  PageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize  success:(CompleteBlock)success failure:(ErrorBlock)failure;
-(void)getPurchaserListWithTimestamp_DataCache:(void(^)(NSInteger maxPage, NSArray*array))success ;

/**
 采购端首页配置

 @param marketId 默认是A161101, 如：义乌市场是A161101 可为空
 @param success success block
 @param failure failure block
 */
- (void)getPurchaserIndexConfigWithMarketId:(NSString *)marketId success:(CompleteBlock)success failure:(ErrorBlock)failure;
- (id)getPurchaserIndexConfigWithMarketId_DataCache; //数据缓存,和上面👆接口success返回一致



/**
 APP扫码

 @param roleType 默认值2，2：采购商；4：供应商
 @param qrOriginStr 扫码后的原始内容
 @param success success block
 @param failure failure block
 */
-(void)getAppScanQRWithRoleType:(int)roleType qrOriginStr:(NSString *)qrOriginStr success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301031推广推荐

 @param success success block
 @param failure failure block
 */
- (void)getSpreadWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 301032_获取商铺推荐列表（搜索）V2.0

 @param success success block
 @param failure failure block
 */
- (void)getShopRecmdListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
- (id)getShopRecmdListWithSuccess_DataCache;




/**
 获取采购端用户详情

 @param success success block
 @param failure failure block
 */
- (void)getBuyerInfoWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
