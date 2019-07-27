//
//  StoryboardHeader.h
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StoryboardHeader : NSObject

@end

/*
 @brief  Main Storyboard Name
 */
static NSString *const storyboard_Main  = @"Main";
static NSString *const storyboard_Trade = @"Trade";
static NSString *const storyboard_ShopStore =@"ShopStore";
//static NSString *const storyboard_ThirdStroyboard = @"ThirdTab";
//static NSString *const storyboard_FourthStoryboard = @"FourthTab";
//static NSString *const storyboard_FiveStoryboard =@"FiveTab";
// 商户端order订单
static NSString *const sb_SellerOrder = @"SellerOrder";
// 开单
static NSString *const sb_MakeBills = @"MakeBills";
//推产品+科大语音
static NSString *const sb_Extend = @"Extend";
//商户的-我的客户
static NSString *const sb_ShopCustomer = @"ShopCustomer";

//采购端
static NSString *const sb_Purchaser = @"Purchaser";

/**
 * brief Storyboard ID
 **/

FOUNDATION_EXTERN NSString *const SBID_StoryboardInital_Shop;
FOUNDATION_EXTERN NSString *const SBID_StoryboardInital_Message;
FOUNDATION_EXTERN NSString *const SBID_StoryboardInital_FuWu;
FOUNDATION_EXTERN NSString *const SBID_StoryboardInital_Mine;

//#pragma mark - Login

#pragma mark - 订单

//订单管理页面
static NSString *const SBID_SellerOrderAllController = @"SellerOrderAllControllerID";
static NSString *const SBID_BuyerOrderAllController = @"BuyerOrderAllControllerID";
//订单搜索
static NSString *const SBID_SellerOrderSearchController = @"SellerOrderSearchControllerID";
//立即发货
static NSString *const SBID_SendGoodsController = @"SendGoodsControllerID";
//确认订单修改价格
static NSString *const SBID_ModifyOrderPriceController = @"ModifyOrderPriceControllerID";
// 退款详情
static NSString *const SBID_RefundingDetailController = @"RefundingDetailControllerID";

#pragma mark - Seller———————商户端


// 商铺首页引导图
static NSString *const SBID_GuideShopHomeController  =@"GuideShopHomeControllerID";


#pragma mark -Shop商铺

//商铺信息
static NSString *const SBID_ShopInfoViewController = @"ShopInfoViewControllerID";
//商铺二维码
static NSString *const SBID_WYQRCodeViewController = @"WYQRCodeViewControllerID";
//经营信息
static NSString *const SBID_ManagementInfoController = @"ManagementInfoController";
//交易设置
static NSString *const SBID_WYShopTradeSettingViewController = @"WYShopTradeSettingViewController";

//粉丝
static NSString *const SBID_FansViewController = @"FansViewController";
static NSString *const segue_FansViewController = @"FansViewController";
//访客
static NSString *const SBID_VisitorViewController = @"VisitorViewController";
static NSString *const segue_VisitorViewController = @"VisitorViewController";
//我的客户
static NSString *const SBID_MyCustomerViewController = @"MyCustomerViewController";
static NSString *const segue_MyCustomerViewController = @"MyCustomerViewController";

//采购商详情
static NSString *const segue_BuyerInfoController =@"BuyerInfoController";
static NSString *const SBID_BuyerInfoController = @"BuyerInfoControllerID";
//推产品、清库存-选择产品
static NSString *const SBID_SEProductSelectController = @"SEProductSelectControllerID";
//推产品、清库存-发布成功
static NSString *const SBID_ExtendSuccessViewController = @"ExtendSuccessViewControllerID";
static NSString *const SBID_ExtendProductAlertController = @"ExtendProductAlertControllerID";


#pragma mark -接生意
//接生意列表
static NSString *const SBID_WYMainViewController = @"WYMainViewController";
//我的商机
static NSString *const SBID_MyTradesController = @"MyTradesControllerID";

//生意详情
static NSString *const SBID_TradeDetailController = @"TradeDetailController";
//接单页面
static NSString *const segue_TradeOrderingController =@"TradeOrderingControllerID";
//接单成功
static NSString *const segue_TradeOrderSuccessViewController =@"TradeOrderSuccessViewControllerID";
//接生意评价页面
static NSString *const SBID_WYTradeEvaluateViewController = @"WYTradeEvaluateViewControllerID";

//接生意设置
static NSString *const SBID_WYTradeSetViewController = @"WYTradeSetViewControllerID";
static NSString *const segue_WYTradeSetViewController = @"WYTradeSetViewControllersegue";
//接生意设置提示弹框
static NSString *const SBID_WYTradeSetAlertController = @"WYTradeSetAlertControllerID";
//生意搜索
static NSString *const SBID_TradeSearchController = @"TradeSearchControllerID";

//接生意功能引导
static NSString *const SBID_GuideTradeMainController = @"GuideTradeMainControllerID";


#pragma mark -开单宝

//开单添加编辑页
static NSString *const SBID_WYMakeBillViewController = @"WYMakeBillViewControllerID";
//添加编辑产品页
static NSString *const SBID_WYMakeBillGoodsViewController = @"WYMakeBillGoodsViewControllerID";

//开单预览
static NSString *const SBID_WYMakeBillPreviewViewController = @"WYMakeBillPreviewViewControllerID";
//开单设置
static NSString *const SBID_WYMakeBillPreviewSetController = @"WYMakeBillPreviewSetControllerID";

//成交额排行榜
static NSString *const segue_SaleClientsViewController = @"SaleClientsViewController";
//销量排行榜
static NSString *const segue_SaleGoodsChartController = @"SaleGoodsChartController";
static NSString *const SBID_SaleGoodsChartController = @"SaleGoodsChartController";
// 销售额统计
static NSString *const segue_SaleAmountChartController = @"SaleAmountChartController";
static NSString *const SBID_SaleClientsViewController = @"SaleClientsViewController";

// MakeBill弹窗
static NSString *const SBID_MakeBillServiceViewController = @"MakeBillServiceViewControllerID";
static NSString *const SBID_MakeBillServiceExpireViewController = @"MakeBillServiceExpireViewControllerID";
//搜索页
static NSString *const SBID_WYSearchViewViewController = @"WYSearchViewViewControllerID";
//开单搜索结果页
static NSString *const SBID_WYBillSearchResultViewController = @"WYBillSearchResultViewControllerID";


#pragma mark -产品管理————店内分类

//产品管理
static NSString *const SBID_ProductManageController = @"ProductManageController";
//公开产品页面
static NSString *const SBID_SellingProductController = @"SellingProductControllerID";
//下架产品页面
static NSString *const SBID_SoldOutProductController =@"SoldOutProductControllerID";
//私密产品页面
static NSString *const SBID_PrivacyProductsController = @"PrivacyProductsControllerID";
//产品搜索页面
static NSString *const SBID_ProductSearchController = @"ProductSearchController";


//商铺店内分类
static NSString *const SBID_WYShopCategoryViewController = @"WYShopCategoryViewControllerID";
//商铺店内分类内页
static NSString *const SBID_WYShopCateDetailViewController = @"WYShopCateDetailViewControllerID";
//商铺店内分类管理
static NSString *const SBID_WYShopCateManageViewController = @"WYShopCateManageViewControllerID";
//商铺选择店内分类
static NSString *const SBID_WYChooseShopCateViewController = @"WYChooseShopCateViewControllerID";

#pragma mark -添加产品

//添加产品
static NSString *const SBID_AddProductController = @"AddProductController";

//上传照片－添加商品
static NSString *const segue_AddProductPicController = @"AddProductPicController";
//箱规
static NSString *const segue_ProductSizeController =@"ProductSizeController";
//添加产品名称
static NSString *const segue_AddProNameController = @"AddProNameController";
//添加产品标签
static NSString *const segue_AddProLabelsController = @"AddProLabelsController";
//产品介绍
static NSString *const segue_AddProBriefController = @"AddProBriefController";
static NSString *const segue_AddProBriefsController = @"AddProBriefsController";

//规格尺寸
static NSString *const segue_AddProSpecController = @"AddProSpecController";

//产品运费设置
static NSString *const SBID_AddProFreightViewController = @"AddProFreightViewController";
static NSString *const segue_AddProFreightViewController =@"AddProFreightViewController";
//产品运费模版列表
static NSString *const SBID_AddProFreightListViewController = @"AddProFreightListViewController";

// 添加产品引导
static NSString *const SBID_GuideAddProController = @"GuideAddProController";


#pragma mark -我的收入

//立即提现
static NSString *const SBID_WYImmediateWithdrawalViewController = @"WYImmediateWithdrawalViewControllerID";
//验证码
static NSString *const SBID_WYVerificationCodeViewController = @"WYVerificationCodeViewControllerID";
//提现成功
static NSString *const SBID_WYImmediateSubmitSussessViewController = @"WYImmediateSubmitSussessViewControllerID";
//交易成功
static NSString *const SBID_PurOrederSuccessfulDealViewController = @"PurOrederSuccessfulDealViewControllerID";


//-------------------------------------------------------------------
#pragma mark - Buyer 采购端


//搜索
static NSString *const SBID_SearchViewController = @"SearchViewControllerID";
//搜索详情容器
static NSString *const SBID_SearchDetailViewController = @"SearchDetailViewControllerID";
//产品搜索详情
static NSString *const SBID_SearchProductDetailController = @"SearchProductDetailControllerID";
//商铺搜索详情
static NSString *const SBID_SearchShopDetailController = @"SearchShopDetailControllerID";

#pragma mark -采购端下订单
//确认订单修改地址
static NSString *const SBID_EditAddressViewController = @"WYPurchaserConfirmOrderEditAddressViewController";
//提交订单成功
static NSString *const SBID_PlaceOrderSuccessViewController = @"WYPurchaserPlaceOrderSuccessViewControllerID";
//支付成功
static NSString *const SBID_paySuccessViewController = @"SBID_paySuccessViewController";



#pragma mark - 其他

//科大讯飞语音
static NSString *const SBID_MSCViewController = @"MSCViewControllerID";






