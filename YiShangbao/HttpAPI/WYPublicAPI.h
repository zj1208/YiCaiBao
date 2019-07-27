//
//  WYPublicAPI.h
//  YiShangbao
//
//  Created by light on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "WYPublicModel.h"

//504204_获取默认收货地址
static NSString *Get_buyer_getDefaultDeliveryAddress_URL = @"mtop.deal.buyer.getDefaultDeliveryAddress";

//504205_新增收货地址
static NSString *Post_buyer_addDeliveryAddress_URL = @"mtop.deal.buyer.addDeliveryAddress";

//504206_更新收货地址
static NSString *Post_buyer_updateDeliveryAddress_URL = @"mtop.deal.buyer.updateDeliveryAddress";

//011101_支付方式查询
static NSString *Get_account_payWays_URL = @"mtop.account.payWays";
//500301_订单支付签名
static NSString *Get_account_paymentOrderSign_URL = @"mtop.payment.orderSign";

//100030_获取兑吧登录接口
static NSString *Get_account_DuibaLogin_URL = @"mtop.user.getDuibaAutoLoginUrl";
//100031_获取义采宝服务经理接口
static NSString *Get_account_ServiceManager_URL = @"mtop.user.getServiceMgrUrl";

//500211_服务下单页
static NSString *kService_buy_ssConfirmOrder_URL = @"mtop.buy.ssConfirmOrder";
//500212_创建服务订单
static NSString *kService_buy_ssCreateOrder_URL = @"mtop.buy.ssCreateOrder";
//500213_查询认证信息
static NSString *Get_buy_querySsInfo_URL = @"mtop.buy.querySsInfo";
// 800032_初始化获取seo url，本地链接地址
static NSString *kPublic_getSeoUrls_URL=@"mtop.app.getSeoUrls";


//认证服务Type
typedef NS_ENUM(NSInteger, WYServiceAuthenticationType){
    WYServiceAuthenticationTypeFirst = 0,           //首次
    WYServiceAuthenticationTypeRenewalFee = 1,      //续费
    WYServiceAuthenticationTypeUpgrUade = 2,        //升级
};
//功能服务type
typedef NS_ENUM(NSInteger, WYServiceFunctionType){
    WYServiceFunctionTypeOutMarket = 0,         //市场外
    WYServiceFunctionTypePushProduct = 1,       //推产品
    WYServiceFunctionTypePushStock = 2,         //推库存
    WYServiceFunctionTypeMakeBill = 3,          //开单
};


@interface WYPublicAPI : BaseHttpAPI


/**
 获取默认收货地址

 @param success success description
 @param failure failure description
 */
- (void)getBuyerDefaultDeliveryAddressSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 新增收货地址

 @param deliveryName 收货人
 @param deliveryPhone 收货人联系方式
 @param prov 省
 @param city 市
 @param town 区
 @param address 详细地址（不少于5个字）
 @param success success description
 @param failure failure description
 */
- (void)postBuyerAddDeliveryName:(NSString *)deliveryName deliveryPhone:(NSString *)deliveryPhone provCode:(NSString *)prov cityCode:(NSString *)city townCode:(NSString *)town addressName:(NSString *)address success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 更新收货地址

 @param addressId 收货地址id
 @param deliveryName 收货人
 @param deliveryPhone 收货人联系方式
 @param prov 省
 @param city 市
 @param town 区
 @param address 详细地址（不少于5个字）
 @param success success description
 @param failure failure description
 */
- (void)postBuyerUpdateAddressId:(NSNumber *)addressId deliveryName:(NSString *)deliveryName deliveryPhone:(NSString *)deliveryPhone provCode:(NSString *)prov cityCode:(NSString *)city townCode:(NSString *)town addressName:(NSString *)address success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 支付方式
 
 @param success success description
 @param failure failure description
 */
- (void)getAccountPayWaySuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 订单支付签名

 @param orderId 待支付订单号
 @param payType 支付类型
 @param success success description
 @param failure failure description
 */
- (void)getPaymentOrderByOrderId:(NSString *)orderId payType:(NSInteger)payType success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100030_获取兑吧登录接口

 @param success success description
 @param failure failure description
 */
- (void)getDuibaLoginUrlSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100031_获取义采宝服务经理接口

 @param success success description
 @param failure failure description
 */
- (void)getServiceManagerUrlSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 500211_服务下单页

 @param funcType 功能服务type
 @param success success description
 @param failure failure description
 */
- (void)getServiceConfirmOrderByFuncType:(WYServiceFunctionType)funcType success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 500212_创建服务订单

 @param comboId 套餐Id
 @param type 认证服务type
 @param funcType 功能服务type
 @param outOrderId 预生成订单号
 @param success success description
 @param failure failure description
 */
- (void)postCreatServiceOrderBycomboId:(NSInteger)comboId type:(WYServiceAuthenticationType)type funcType:(WYServiceFunctionType)funcType outOrderId:(NSString *)outOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 500213_查询认证信息

 @param comboId 套餐id
 @param success success description
 @param failure failure description
 */
- (void)getBuyQueryAuthenticationInfoComboId:(NSString *)comboId success:(CompleteBlock)success failure:(ErrorBlock)failure;


- (void)getHtmlStringsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
