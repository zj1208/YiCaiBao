//
//  HSOrderManagementApi.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "OrderManagerModel.h"
#import "OrderManagementDetailModel.h"

//504201_采购商评价初始化
static NSString *Get_HSOM_mtop_deal_buyer_buyerInitOrderComment_URL = @"mtop.deal.buyer.buyerInitOrderComment";

//504202_买家提交评价
static NSString *Post_HSOM_mtop_deal_buyer_buyerAddOrderComment_URL = @"mtop.deal.buyer.buyerAddOrderComment";

//504106_卖家初始化评价
static NSString *Get_HSOM_mtop_deal_seller_sellerInitOrderComment_URL = @"mtop.deal.seller.sellerInitOrderComment";

//504107_卖家提交评价
static NSString *Post_HSOM_mtop_deal_seller_sellerAddOrderComment_URL = @"mtop.deal.seller.sellerAddOrderComment";

//504211_退款初始化（买家）
static NSString *Get_HSOM_mtop_deal_buyer_refundInit_URL = @"mtop.deal.buyer.refundInit";
//504212_退款（买家）
static NSString *Post_HSOM_mtop_deal_buyer_addRefund_URL = @"mtop.deal.buyer.addRefund";

//---
//504002_退款操作 
static NSString *Post_HSOM_mtop_deal_common_refundOperation_URL = @"mtop.deal.common.refundOperation";
//504003_退款详情
static NSString *Get_HSOM_mtop_deal_common_refundInfo_URL = @"mtop.deal.common.refundInfo";

//504004_订单详情
static NSString *Get_HSOM_mtop_deal_common_getMyOrderInfo_URL = @"mtop.deal.common.getMyOrderInfo";

//504101_更新订单备注 (商家)
static NSString *Post_HSOM_mtop_deal_seller_updateOrderRemark_URL = @"mtop.deal.seller.updateOrderRemark";


//504102_确认订单获取-商户端
static NSString *kOrder_Get_getConfirmOrder_URL = @"mtop.deal.seller.getConfirmOrder";
//504103_确认订单修改
static NSString *kOrder_Post_mdfConfirmOrder_URL = @"mtop.deal.seller.mdfConfirmOrder";

//504110_立即发货接口(供应商)
static NSString *kOrder_Post_orderDelivery_URL = @"mtop.deal.seller.orderDelivery";
//504109_获取立即发货页面接口(供应商)
static NSString *kOrder_Get_orderDelivery_URL=@"mtop.deal.seller.getOrderDelivery";
//504001_交易订单
static NSString *kOrder_Get_orderList_URL =@"mtop.deal.common.orderList";
//504009_订单统计
static NSString *kOrder_Get_orderStatusCount_URL =@"mtop.deal.common.orderStatusCount";
//504002_退款操作
static NSString *kOrder_Post_refundOperation_URL =@"mtop.deal.common.refundOperation";

//504210_确认收货
static NSString *kOrder_Post_buyer_confirmReceipt_URL =@"mtop.deal.buyer.confirmReceipt";

//504006_关闭订单
static NSString *kOrder_Post_closeOrder =@"mtop.deal.common.closeOrder";

//504104_卖家退款关单
static NSString *kOrder_Post_closeRefundOrder =@"mtop.deal.seller.refundAndClose";



typedef NS_ENUM(NSInteger, SellerOrderListStatus)
{
    ///全部
    SellerOrderListStatus_All = 0,
    ///待确认
    SellerOrderListStatus_ToBeConfirmed = 1,
    ///待支付
    SellerOrderListStatus_ToBePaid = 2,
    ///待发货
    SellerOrderListStatus_WaitForDelivery = 3,
    ///退款中
    SellerOrderListStatus_Refunding = 4,
    ///已发货
    SellerOrderListStatus_Deliveried = 5,
    ///待评价
    SellerOrderListStatus_ToBeCommit = 6,
    ///交易成功
    SellerOrderListStatus_TradeSuccessfully = 7,
    ///交易关闭
    SellerOrderListStatus_TradeClose = 8,

};

typedef NS_ENUM(NSInteger, PurchaserOrderListStatus)
{
    OrderListStatus_All = 0,
    OrderListStatus_ToBeConfirmed = 1,//待确认
    OrderListStatus_Obligation = 2,//待支付
    OrderListStatus_WaitForDelivery = 3,//待发货
    OrderListStatus_Refunding = 4,//退款中
    OrderListStatus_ToBeReceive = 5,//待收货
    OrderListStatus_ToBeCommit = 6,//待评价
    OrderListStatus_TradeSuccessfully = 7,//交易成功
    OrderListStatus_TradeClose = 8,//交易关闭

};


@interface HSOrderManagementApi : BaseHttpAPI


/**
 504101_更新订单备注 (只有商家才有)

 @param bizOrderId string	订单id
 @param remark string	备注
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostUppdateOrderRemarkWithBizOrderId:(NSString*)bizOrderId remark:(NSString*)remark  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 504004_订单详情
 
 @param roleType 角色 2-采购商 4-供应商
 @param bizOrderId 订单id
 @param success success description
 @param failure failure description
 */
- (void)getOrderManagementDetailWithRoleType:(WYTargetRoleType)roleType BizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504003_退款详情

 @param roleType 角色，2-采购商，4-供应商
 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getCommonRefundInfoWithRoleType:(WYTargetRoleType)roleType bizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 504002_退款操作

 @param bizOrderId 订单id
 @param operationType 操作类型A-同意，R-拒绝，C-取消
 @param reason 理由, 拒绝必填
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostCommonRefundOperationWithBizOrderId:(NSString*)bizOrderId operationType:(NSString*)operationType reason:(NSString*)reason  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 504212_退款

 @param bizOrderId 订单id
 @param reason 原因
 @param append 说明
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostBuyerAddRefundWithBizOrderId:(NSString*)bizOrderId reason:(NSString*)reason append:(NSString*)append  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504211_退款初始化

 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBuyerRefundInitWithBizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504202_买家提交评价

 @param dict 业务请求参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostPurCommitBuyerAddOrderCommentWithDict:(NSDictionary*)dict  success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504201_采购商评价初始化

 @param orderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostPurCommitInitWithOrderId:(NSString *)orderId  success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 504107_卖家提交评价

 @param orderId 订单id
 @param description 评价买家描述
 @param buyerStar 评价买家星级1-5颗星
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostSelCommitBuyerAddOrderCommentWithOrderId:(NSString *)orderId description:(NSString *)description buyerStar:(NSString *)buyerStar  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 504106_卖家初始化评价

 @param orderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)GetSelCommitInitWithOrderId:(NSString *)orderId  success:(CompleteBlock)success failure:(ErrorBlock)failure;











/**
 504001_交易订单

 @param roleType 角色
 @param status 订单不同状态
 @param search 订单搜索关键词
 @param pageNo pageNo description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */
- (void)getOrderListWithRoleType:(WYTargetRoleType)roleType orderStatus:(NSInteger)status  search:(NSString *)search pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;



/**
 504009_订单统计

 @param roleType 角色
 @param success success description
 @param failure failure description
 */
- (void)getOrderStatusCountWithRoleType :(WYTargetRoleType)roleType  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 504102_确认订单获取

 @param orderId 订单id
 @param success success description
 @param failure failure description
 */
- (void)getConfirmOrderWithOrderId:(NSString *)orderId success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 504103_确认订单修改

 @param model model数据
 @param success success description
 @param failure failure description
 */
- (void)postMdfConfirmOrderWithDictonary:(PostMdfConfirmOrderModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 504002_退款操作

 @param bizOrderId 订单id
 @param operationType 操作类型A-同意，R-拒绝，C-取消
 @param reason 理由, 拒绝必填
 @param success success description
 @param failure failure description
 */
- (void)postRefundOperationWithBizOrderId:(NSString *)bizOrderId operationType:(NSString *)operationType reason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504109_获取立即发货页面接口(供应商)

 @param bizOrderId 订单id
 @param success success description
 @param failure failure description
 */
- (void)getOrderDeliveryWithBizOrderId:(NSString *)bizOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504110_立即发货接口(供应商)

 @param model 参数model
 @param success success description
 @param failure failure description
 */
- (void)postOrderDeliveryWithDictonary:(PostOrderDeliveryModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 504210_确认收货

 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postOrderBuyerConfirmReceiptWithBizOrderId:(NSString *)bizOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
504006_关闭订单

 @param roleType roleType description
 @param bizOrderId bizOrderId description
 @param reason 关闭原因
 @param success success description
 @param failure failure description
 */
- (void)postCloseOrderWithRoleType:(WYTargetRoleType)roleType bizOrderId:(NSString *)bizOrderId closeReason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure;

//504104_卖家退款关单
- (void)postCloseRefundOrderWithBizOrderId:(NSString *)bizOrderId closeReason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
