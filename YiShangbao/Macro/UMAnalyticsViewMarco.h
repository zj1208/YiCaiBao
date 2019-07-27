//
//  UMAnalyticsViewMarco.h
//  YiShangbao
//
//  Created by simon on 17/3/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UMAnalyticsViewMarco : NSObject



@end




#pragma mark - 商户端＊＊＊＊＊＊＊＊＊----商户端----＊＊＊＊＊＊＊＊＊＊


#pragma  mark - tabBar

//toolbar“接生意”点击量
static NSString *const kUM_Builds  = @"Builds";
//toolbar“商铺”点击量
static NSString *const kUM_Shops  = @"Shops";
//toolbar“市场服务”点击量
static NSString *const kUM_Service = @"Service";

//toolbar“我的”点击量,
static NSString *const kUM_b_mine = @"b_mine";


#pragma  mark - 接生意

//接生意界面“我要接”点击量
static NSString *const kUM_gotoBuild = @"gotoBuild";
//生意详情界面“马上接单”点击量
static NSString *const kUM_gotoQuotes =@"gotoQuotes";
//接单界面“发送给采购商”点击量
static NSString *const kUM_sendPrice = @"sendPrice";
//“已接”点击量
static NSString *const kUM_yijie = @"yijie";

//5.5整理v_1.1

//接生意顶部“立即设置”点击量,0
static NSString *const kUM_b_gotoshopInformation = @"b_gotoshopInformation";
//生意详情“介绍给朋友”点击量,0
static NSString *const kUM_b_businessshare = @"b_businessshare";
//生意详情“联系采购商”点击量,0 ====== 同callphone   -->"联系对方"
static NSString *const kUM_b_contactbuyer = @"b_contactbuyer";
//生意详情“查看采购商”点击量,0
static NSString *const kUM_b_toviewbuyer = @"b_toviewbuyer";
//接单成功“打电话”点击量,0
static NSString *const kUM_b_businesscall = @"b_businesscall";
//接单成功“在线沟通”点击量,0
static NSString *const kUM_b_businessIM = @"b_businessIM";
//接单后生意详情“打电话”点击量,0
static NSString *const kUM_b_businesscall_2 = @"b_businesscall_2";
//接单后生意详情“在线沟通”点击量,0
static NSString *const kUM_b_businessIM_2 = @"b_businessIM_2";


//＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－6.8整理v_1.1(详见.m文件) －－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
//接生意顶部“与我相关”点击量,0
static NSString *const kUM_b_interrelatedme = @"b_interrelatedme";
//接生意“发布求购”点击量,0
static NSString *const kUM_b_inquiry = @"b_inquiry";
//推广“发布求购”点击量,0
static NSString *const kUM_b_pushinquiry = @"b_pushinquiry";

//＊＊＊＊＊＊＊＊＊＊＊＊＊＊－－－8.8整理－－－＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊＊
//接生意顶部“智能排序”,0
static NSString *const kUM_b_smartlist =@"b_smartlist";
//接生意顶部“与我相关”点击量,0  ==旧版本在使用，
//static NSString *const kUM_b_interrelatedme =@"b_interrelatedme"; //上6.8有
//接生意顶部“最新排序”,0
static NSString *const kUM_b_newlist =@"b_newlist";
//接生意顶部“设置”,0
static NSString *const kUM_b_indexset =@"b_indexset";
//接生意顶部“设置内-开启通知”,0 === 安卓不用
static NSString *const kUM_b_indexsetpush =@"b_indexsetpush";


//供应商端p1
//b_hometab1,供应商“接生意tab1”点击量,0---智能排序／最新发布
static NSString *const kUM_b_hometab1 =@"b_hometab1";
//b_hometab2,供应商“接生意tab2”点击量,0----库存专区／其他求购
static NSString *const kUM_b_hometab2 =@"b_hometab2";
//b_homestock,供应商“库存求购”点击量,0
static NSString *const kUM_b_homestock =@"b_homestock";
//b_homeother,供应商“其他求购”点击量,0
static NSString *const kUM_b_homeother =@"b_homeother";



#pragma mark - 商铺

//商铺“基本资料”点击量
static NSString *const kUM_gotoInformation = @"gotoInformation";
//商铺“粉丝”点击量
static NSString *const kUM_gotoFans = @"gotoFans";
//商铺“访客”点击量
static NSString *const kUM_gotoVisitors = @"gotoVisitors";

////商铺“轮播”点击量
//static NSString *const kUM_gotoShopsAd = @"gotoShopsAd";
//5.5 商铺产品
////商铺“轮播广告位”点击量,0
//static NSString *kUM_b_shopAD = @"b_shopAD";

//商铺“分享给朋友”点击量,0
static NSString *const kUM_b_shopshare = @"b_shopshare";
//供应商首页“二维码”点击量
static NSString *const kUM_b_home_code = @"b_home_code";
//供应商首页“必看通知”
static NSString *const kUM_b_home_notice = @"b_home_notice";
//供应商首页“底部banner”
static NSString *const kUM_b_home_banner = @"b_home_banner";

//b_shop_trade_level,采购商店铺首页“交易等级”点击量,0
static NSString *const kUM_b_shop_trade_level = @"kUM_b_shop_trade_level";

//b_home_score,供应商首页“交易得分”点击量，0
static NSString *const kUM_b_home_score = @"kUM_b_home_score";


//供应商首页“预览”点击量
static NSString *const kUM_b_home_preview = @"b_home_preview";
//二维码“换一张”
static NSString *const kUM_b_home_changecode = @"b_home_changecode";
//商户二维码“分享给朋友”点击量,0
static NSString *const kUM_b_qrcodeshare = @"b_qrcodeshare";
//商户二维码“保存相册”点击量,0
static NSString *const kUM_b_qrcodesave = @"b_qrcodesave";
//商户二维码“预览名片”点击量,0
static NSString *const kUM_b_viewcard = @"b_viewcard";
//商户二维码“编辑名片”点击量,0
static NSString *const kUM_b_editcard = @"b_editcard";

//b_home_adsuspension,供应商首页“底部悬浮广告”点击量，0
static NSString *const kUM_b_home_adsuspension = @"b_home_adsuspension";
//b_home_adclose,供应商首页“关闭底部悬浮广告”点击量，0
static NSString *const kUM_b_home_adclose = @"b_home_adclose";
#pragma - 粉丝/访客/我的客户 采购商信息

//访客列表“查看资料”点击量,0
static NSString *const kUM_b_b_visitorsview = @"b_visitorsview";
//粉丝列表“查看资料”点击量,0
static NSString *const kUM_b_fansview = @"b_fansview";
//采购商信息“查看经侦”点击量,0
static NSString *const kUM_b_warningview = @"b_warningview";

//采购商资料页“查看评价”点击量,0
static NSString *const kUM_b_purchaser_evaluation = @"b_purchaser_evaluation";

//采购商详情“添加到客户”点击量,0
static NSString *const kUM_b_buyerdetails_addclient = @"b_buyerdetails_addclient";

//我的客户“点击单个客户”点击量
static NSString *const kUM_b_myclientele_onclick = @"b_myclientele_onclick";

//采购商客户信息“添加为我的客户”点击量,0。（添加为我的客户时候需要填写客户信息的页面的“添加为我的客户”按钮）
static NSString *const kUM_b_customerinfo_creat =@"kUM_b_customerinfo_creat";
//采购商客户信息“采购商信息”点击量,0。   （已经添加为我的客户时客户信息的页面的“采购商信息”按钮）
static NSString *const kUM_b_customerinfo_Purchasersinfo =@"kUM_b_customerinfo_Purchasersinfo";


#pragma mark - 产品管理有关


//产品管理“搜索产品”
static NSString *const kUM_b_pd_search = @"b_pd_search";
//产品管理“本店分类设置”
static NSString *const kUM_b_pd_myclass = @"b_pd_myclass";
//产品管理“上货”点击量,0
static NSString *const kUM_b_PMaddproduct = @"b_PMaddproduct";

//新增产品“存为私密”点击量,0
static NSString *const kUM_b_PMaddprivate = @"b_PMaddprivate";
//新增产品“公开上架”点击量,0
static NSString *const kUM_b_PMaddpublicity = @"b_PMaddpublicity";

//新增产品“增加价格区间”点击量,0
static NSString *const kUM_b_product_pricerange = @"b_product_pricerange";

//新增产品 b_product_express,供应商“运费设置”点击量,0
static NSString *const kUM_b_product_express = @"b_product_express";

//b_product_moreinfo,供应商“完善更多信息”点击量,0
static NSString *const kUM_b_product_moreinfo = @"b_product_moreinfo";


//供应商“右上角全部类目”点击量
static NSString *const kUM_b_allcategory = @"b_allcategory";
//,供应商“搜索类目”点击量,0
static NSString *const kUM_b_searchcategory = @"b_searchcategory";

//本店分类设置“未分类产品”
static NSString *const kUM_b_pd_unclass = @"b_pd_unclass";
//本店分类设置“新建分类”
static NSString *const kUM_b_pd_newclass = @"b_pd_newclass";
//本店分类设置“上传产品”
static NSString *const kUM_b_pd_newproduct = @"b_pd_newproduct";
//本店分类设置“编辑分类”
static NSString *const kUM_b_pd_editclass = @"b_pd_editclass";
//本店分类设置“推广分类”
static NSString *const kUM_b_pd_extendclass = @"b_pd_extendclass";
//本店分类设置“排序上调”
static NSString *const kUM_b_pd_sortup = @"b_pd_sortup";
//本店分类设置“排序下调”
static NSString *const kUM_b_pd_sortdown = @"b_pd_sortdown";

//产品管理“电脑上传”点击量,0
static NSString *const kUM_b_productcontrol_upload =@"b_productcontrol_upload";
//产品管理“上传时间排序切换”点击量,0
static NSString *const kUM_b_productcontrol_switchover =@"b_productcontrol_switchover";
//产品管理“只看主营”点击量,0
static NSString *const kUM_b_productcontrol_major =@"b_productcontrol_major";
//产品管理“设置”点击量,0
static NSString *const kUM_b_productcontrol_set =@"b_productcontrol_set";
//产品管理“设置-下架”点击量,0
static NSString *const kUM_b_productcontrol_soldout =@"b_productcontrol_soldout";
//产品管理“设置-上架”点击量,0
static NSString *const kUM_b_productcontrol_putaway =@"b_productcontrol_putaway";
//产品管理“设置-删除”点击量,0
static NSString *const kUM_b_productcontrol_delete =@"b_productcontrol_delete";
//产品管理“推广-热销产品”点击量,0
static NSString *const kUM_b_productcontrol_generalize =@"b_productcontrol_generalize";
//产品管理“推广-库存收购”点击量,0
static NSString *const kUM_b_productcontrol_acquisition =@"b_productcontrol_acquisition";

 
#pragma mark - 消息

//供应商端p2
//b_toolbarmessage,供应商“toolbar消息”点击量,0
static NSString *const kUM_b_toolbarmessage =@"b_toolbarmessage";
//b_mestrade,供应商“消息交易相关”点击量,0
static NSString *const kUM_b_mestrade =@"b_mestrade";
//b_mesannouncement,供应商“消息市场公告”点击量,0
static NSString *const kUM_b_mesannouncement =@"b_mesannouncement";
//b_mesnotification,供应商“消息系统通知”点击量,0
static NSString *const kUM_b_mesnotification =@"b_mesnotification";
//b_mestodolist,供应商“消息待办事项”点击量,0
static NSString *const kUM_b_mestodolist =@"b_mestodolist";
//b_mesactivity,供应商“消息活动资讯”点击量,0
static NSString *const kUM_b_mesactivity =@"b_mesactivity";
//b_messchool,供应商“消息义采宝学堂”点击量,0
static NSString *const kUM_b_messchool =@"b_messchool";


//im聊天“进店”点击量,0
static NSString *const kUM_b_chat_intoshop =@"b_chat_intoshop";

//im聊天“选择本店产品”点击量,0
static NSString *const kUM_b_chat_ourproduct =@"b_chat_ourproduct";

#pragma mark - 市场服务



//经侦预警“诈骗案例”点击量
static NSString *const kUM_fraudcase = @"fraudcase";

//经侦预警“搜索”点击量,
static NSString *const kUM_b_search = @"b_search";

//市场服务“市场资讯”点击量,0  ====>new
static NSString *const kUM_b_ServiceInformation = @"b_ServiceInformation";

//市场服务“市场公告”点击量,0  ====>new
static NSString *const kUM_b_ServiceNotice = @"b_ServiceNotice";

//市场服务“市场资讯-更多”点击量,0  ====>new
static NSString *const kUM_b_ServiceInformationMore = @"b_ServiceInformationMore";

//b_service_rentinglist,市场服务“转租转让列表”点击量，0
static NSString *const kUM_b_service_rentinglist = @"b_service_rentinglist";
//b_service_rentingmore,市场服务“转租转让列表更多”点击量，0
static NSString *const kUM_b_service_rentingmore = @"b_service_rentingmore";
#pragma mark - 我的


//我的“推产品”点击量,0
static NSString *const kUM_b_Mypushproduct = @"b_Mypushproduct";
//我的“清库存”点击量,0
static NSString *const kUM_b_Mypushinventory = @"b_Mypushinventory";
//我的“接单生意”点击量,0
static NSString *const kUM_b_Myyijie = @"b_Myyijie";
//我的“求购”点击量,0
static NSString *const kUM_b_Mytobuy = @"b_Mytobuy";
//我的“客服电话”点击量,0
static NSString *const kUM_b_Servicetel = @"b_Servicetel";
//我的“客服qq”点击量,0
static NSString *const kUM_b_ServiceQQ = @"b_ServiceQQ";

//我的“设置”点击量,0
static NSString *const kUM_b_Set = @"b_Set";

//b_myintegral,供应商“我的积分”点击量,0
static NSString *const kUM_b_myintegral =@"b_myintegral";
//b_Integralmall,供应商“积分商城”点击量,0
static NSString *const kUM_b_Integralmall =@"b_Integralmall";
//b_servicemanager,供应商“服务经理”点击量,0
static NSString *const kUM_b_servicemanager =@"b_servicemanager";
//kUM_b_my_service,供应商“我订购服务”
static NSString *const kUM_b_my_service =@"b_my_service";



#pragma mark - 推广
//toolbar“推广”点击量,0
static NSString *const kUM_b_promotion = @"b_promotion";
//推广顶部的“热销产品”点击量,0
static NSString *const kUM_b_promotionproduct = @"b_promotionproduct";
//推广顶部的“库存处理”点击量,0
static NSString *const kUM_b_promotioninventory = @"b_promotioninventory";
//推广“发布推广”点击量,0
static NSString *const kUM_b_push = @"b_push";
//推广“推产品”点击量,0
static NSString *const kUM_b_pushproduct = @"b_pushproduct";
//推广“发名片”点击量,0  -->“推商铺”
static NSString *const kUM_b_pushshop = @"b_pushshop";
//推广“清库存”点击量,0
static NSString *const kUM_b_pushinventory = @"b_pushinventory";

//推产品“选择产品”点击量,0
static NSString *const kUM_b_push_selectproduct =@"b_push_selectproduct";
//推产品“拍照／相册”点击量,0
static NSString *const kUM_b_push_photograph =@"b_push_photograph";
//清库存“选择产品”点击量,0
static NSString *const kUM_b_promotion_selectproduct =@"b_promotion_selectproduct";
//清库存“拍照／相册”点击量,0
static NSString *const kUM_b_promotion_photograph =@"b_promotion_photograph";


//供应商“关闭求购”点击量
static NSString *const kUM_b_closepurchase = @"b_closepurchase";
//供应商“关闭求购成功”点击量
static NSString *const kUM_b_closedsuccessful = @"b_closedsuccessful";



#pragma mark - 供应商端订单


//供应商“订单列表搜索”点击量,0
static NSString *const kUM_b_ordersearch =@"b_ordersearch";
//供应商“订单搜索页点击搜索”点击量,0
static NSString *const kUM_b_ordersearchinput =@"b_ordersearchinput";
//供应商“订单上方点击”点击量,0
static NSString *const kUM_b_slideabove =@"b_slideabove";
//供应商“订单滑动下方”点击量,0
static NSString *const kUM_b_slidedown =@"b_slidedown";
//供应商“订单展开更多”点击量,0
static NSString *const kUM_b_listopen =@"b_listopen";
//供应商“订单详情联系买家”点击量,0
static NSString *const kUM_b_ordercontact =@"b_ordercontact";
//供应商“订单详情拨打电话”点击量,0
static NSString *const kUM_b_ordercall =@"b_ordercall";

//订单和收入“我的收入”
static NSString *const kUM_b_order_income = @"b_order_income";


#pragma mark- 供应商开单

//弹窗页面“关闭”点击量,0
static NSString *const kUM_kdb_firstpopup_close = @"kdb_firstpopup_close";
//弹窗页面“立即订购”点击量,0
static NSString *const kUM_kdb_firstpopup_order = @"kdb_firstpopup_order";
//弹窗页面“继续试用”点击量,0
static NSString *const kUM_kdb_firstpopup_continuetotry = @"kdb_firstpopup_continuetotry";
//弹窗页面“延长试用期”点击量,0
static NSString *const kUM_kdb_firstpopup_extend = @"kdb_firstpopup_extend";
//底部tabbar“开单”点击量,0
static NSString *const kUM_kdb_tabbar_openbill = @"kdb_tabbar_openbill";
//底部tabbar“数据”点击量,0
static NSString *const kUM_kdb_tabbar_data = @"kdb_tabbar_data";
//底部tabbar“客户”点击量,0
static NSString *const kUM_kdb_tabbar_customer = @"kdb_tabbar_customer";


//单据页“预览”点击量,0
static NSString *const kUM_kdb_openbill_new_preview = @"kdb_openbill_new_preview";
//单据页“客户”点击量,0
static NSString *const kUM_kdb_openbill_new_customer = @"kdb_openbill_new_customer";
//单据页“开单日期”点击量,0
static NSString *const kUM_kdb_openbill_new_opendate = @"kdb_openbill_new_opendate";
//单据页“收货日期”点击量,0
static NSString *const kUM_kdb_openbill_new_deaddate = @"kdb_openbill_new_deaddate";
//单据页产品“新增”点击量,0
static NSString *const kUM_kdb_openbill_new_product_create = @"kdb_openbill_new_product_create";
//单据页产品“删除”点击量,0
static NSString *const kUM_kdb_openbill_new_product_delete = @"kdb_openbill_new_product_delete";
//单据页产品“编辑”点击量,0
static NSString *const kUM_kdb_openbill_new_product_edit = @"kdb_openbill_new_product_edit";
//单据页“备注”点击量,0
static NSString *const kUM_kdb_openbill_new_remarks = @"kdb_openbill_new_remarks";
//单据页“附件”点击量,0
static NSString *const kUM_kdb_openbill_new_attachment = @"kdb_openbill_new_attachment";
//单据页“保存”点击量,0
static NSString *const kUM_kdb_openbill_new_save = @"kdb_openbill_new_save";
//单据产品编辑页“确认”点击量,0
static NSString *const kUM_kdb_openbill_new_product_confirm = @"kdb_openbill_new_product_confirm";
//单据产品编辑页“添加下一个”点击量,0
static NSString *const kUM_kdb_openbill_new_product_next = @"kdb_openbill_new_product_next";

/* old为编辑单据时候的埋点 */
//单据页“预览”点击量,0
static NSString *const kUM_kdb_openbill_old_preview = @"kdb_openbill_old_preview";
//单据页“客户”点击量,0
static NSString *const kUM_kdb_openbill_old_customername = @"kdb_openbill_old_customername";
//单据页“开单日期”点击量,0
static NSString *const kUM_kdb_openbill_old_opendate = @"kdb_openbill_old_opendate";
//单据页“收货日期”点击量,0
static NSString *const kUM_kdb_openbill_old_deaddate = @"kdb_openbill_old_deaddate";
//单据页产品“新增”点击量,0
static NSString *const kUM_kdb_openbill_old_product_create = @"kdb_openbill_old_product_create";
//单据页产品“删除”点击量,0
static NSString *const kUM_kdb_openbill_old_product_delete = @"kdb_openbill_old_product_delete";
//单据页产品“编辑”点击量,0
static NSString *const kUM_kdb_openbill_old_product_edit = @"kdb_openbill_old_product_edit";
//单据页“备注”点击量,0
static NSString *const kUM_kdb_openbill_old_remarks = @"kdb_openbill_old_remarks";
//单据页“附件”点击量,0
static NSString *const kUM_kdb_openbill_old_attachment = @"kdb_openbill_old_attachment";
//单据页“保存”点击量,0
static NSString *const kUM_kdb_openbill_old_save = @"kdb_openbill_old_save";
//单据产品编辑页“确认”点击量,0
static NSString *const kUM_kdb_openbill_old_product_confirm = @"kdb_openbill_old_product_confirm";
//单据产品编辑页“添加下一个”点击量,0
static NSString *const kUM_kdb_openbill_old_product_next = @"kdb_openbill_old_product_next";

//开单预览页“保存到相册”点击量,0
static NSString *const kUM_kdb_openbill_preview_save = @"kdb_openbill_preview_save";
//开单预览页“分享给客户”点击量,0
static NSString *const kUM_kdb_openbill_preview_share = @"kdb_openbill_preview_share";
//开单预览页分享“微信”点击量,0
//static NSString *const kUM_kdb_openbill_preview_share_wechat = @"kdb_openbill_preview_share_wechat";//暂时没用
//开单预览页“去修改”点击量,0
static NSString *const kUM_kdb_openbill_preview_fix = @"kdb_openbill_preview_fix";

//单据列表中间“新增”点击量,0
static NSString *const kUM_kdb_openbill_list_openbillcenter = @"kdb_openbill_list_openbillcenter";
//单据列表右上角“新增”点击量,0
static NSString *const kUM_kdb_openbill_list_openbilltop = @"kdb_openbill_list_openbilltop";
//单据列表“删除”点击量,0
static NSString *const kUM_kdb_openbill_list_delete = @"kdb_openbill_list_delete";
//单据列表“编辑按钮”点击量,0
static NSString *const kUM_kdb_openbill_list_editbutton = @"kdb_openbill_list_editbutton";
//单据列表“编辑”点击量,0
static NSString *const kUM_kdb_openbill_list_edit = @"kdb_openbill_list_edit";
//单据列表“预览”点击量,0
static NSString *const kUM_kdb_openbill_list_preview = @"kdb_openbill_list_preview";
//单据列表“搜索”点击量,0
static NSString *const kUM_kdb_openbill_list_search = @"kdb_openbill_list_search";
//单据列表横幅“关闭”点击量,0
static NSString *const kUM_kdb_openbill_list_close = @"kdb_openbill_list_close";
//单据列表横幅“去购买”点击量,0
static NSString *const kUM_kdb_openbill_list_pay = @"kdb_openbill_list_pay";

//数据“销售额统计”点击量,0
static NSString *const kUM_kdb_data_salemore = @"kdb_data_salemore";
//数据“商品销量排行榜”点击量,0
static NSString *const kUM_kdb_data_productmore = @"kdb_data_productmore";
//数据“客户成交额排行榜”点击量,0
static NSString *const kUM_kdb_data_customermore = @"kdb_data_customermore";

//客户管理“新增客户”点击量,0
static NSString *const kUM_kdb_customer_create_add = @"kdb_customer_create_add";
//客户管理“从通讯录导入”点击量,0
static NSString *const kUM_kdb_customer_create_contacts = @"kdb_customer_create_contacts";
//客户“搜索框”点击量,0
static NSString *const kUM_kdb_customer_search = @"kdb_customer_search";
//客户“编辑”点击量,0
static NSString *const kUM_kdb_customer_edit = @"kdb_customer_edit";
//客户“保存”点击量,0
static NSString *const kUM_kdb_customer_save = @"kdb_customer_save";

//到期弹窗页面“关闭”点击量,0
static NSString *const kUM_kdb_expirepopup_close = @"kdb_expirepopup_close";
//到期弹窗页面“立即购买”点击量,0
static NSString *const kUM_kdb_expirepopup_order = @"kdb_expirepopup_order";
//到期弹窗页面“延长试用期”点击量,0
static NSString *const kUM_kdb_expirepopup_extend = @"kdb_expirepopup_extend";



#pragma mark - 其他

//“消息”点击量-采购商有用到
static NSString *const kUM_message = @"message";

//商户闪屏点击量,0
static NSString *const kUM_b_flashscreen = @"b_flashscreen";
//商户弹窗点击量,0
static NSString *const kUM_b_popups = @"b_popups";

//,供应商“去支付认证”点击量,0
static NSString *const kUM_b_payforauthentication = @"b_payforauthentication";

//供应商首页“切换身份”
static NSString *const kUM_b_home_switch = @"b_home_switch";

///MARK:分享

//推广组件“复制链接”点击量
static NSString *const kUM_b_component_copylink = @"b_component_copylink";

//推广组件“义采宝联系人”点击量
static NSString *const kUM_b_component_linkman = @"b_component_linkman";

#pragma mark - ＊＊＊＊＊＊＊＊＊----采购端----＊＊＊＊＊＊＊＊＊＊

#pragma  mark - tabBar

//采购toolbar“首页”点击量,0
static NSString *const kUM_c_index = @"c_index";
//c_toobar_follow,底部菜单“关注”点击量，0
static NSString *const kUM_c_toobar_follow = @"c_toobar_follow";
//采购toolbar“求购”点击量,0
static NSString *const kUM_c_inquiry = @"c_inquiry";
//采购toolbar“我的求购”点击量,0
static NSString *const kUM_c_myInquiry = @"c_myInquiry";
//采购toolbar“我的”点击量,0
static NSString *const kUM_c_mine = @"c_mine";
//采购toolbar“我的消息”点击量,0
static NSString *const kUM_c_message = @"c_message";

//采购toolbar“进货单”点击量,0
static NSString *const kUM_c_toolbar_shoppinglist =@"c_toolbar_shoppinglist";
//采购toolbar“类目”点击量,0
static NSString *const kUM_c_toolbar_category =@"c_toolbar_category";


#pragma  mark - 采购首页

//采购首页“切换身份”
static NSString *const kUM_c_home_switch =@"c_home_switch";
//,采购首页“banner下方按钮区块,id=”
static NSString *const kUM_c_funcBar_id =@"c_funcBar_id";

//采购首页“搜索”点击量,0
static NSString *const kUM_c_indexsearch = @"c_indexsearch";
//采购分类查找“搜索”点击量,0
static NSString *const kUM_c_categorysearch = @"c_categorysearch";

//采购首页“发布求购”点击量,0
static NSString *const kUM_c_indexpushInquiry = @"c_indexpushInquiry";
//采购首页“产品类目”点击量,0
static NSString *const kUM_c_indexProductCategory = @"c_indexProductCategory";
//采购首页“专题”点击量,0
static NSString *const kUM_c_indexSeason = @"c_indexSeason";
//采购首页“热销产品-更多”点击量,0
static NSString *const kUM_c_indexProductmore = @"c_indexProductmore";
//采购首页“找库存-更多”点击量,0
static NSString *const kUM_c_indexInquirymore = @"c_indexInquirymore";
//采购首页“专题-更多”点击量,0
static NSString *const kUM_c_indexSeasonmore = @"c_indexSeasonmore";

//采购首页“banner”点击量,0  ===不用统计单个图。
static NSString *const kUM_c_indexbanner = @"c_indexbanner";

#pragma mark - 关注

//c_list_follow,关注列表推荐“关注”点击量,0
static NSString *const kUM_c_list_follow = @"c_list_follow";
//c_acrosslist_follow,关注横向推荐“关注”点击量,0
static NSString *const kUM_c_acrosslist_follow = @"c_acrosslist_follow";
//c_list_message,关注列表“在线沟通”点击量,0
static NSString *const kUM_c_list_message = @"c_list_message";
//c_list_supplier,关注右上角“我关注的供应商”点击量,0
static NSString *const kUM_c_list_supplier = @"c_list_supplier";
//c_list_tab1,关注tab“关注”点击量,0
static NSString *const kUM_c_list_tab1 = @"c_list_tab1";
//c_list_tab2,关注tab“上新”点击量,0
static NSString *const kUM_c_list_tab2 = @"c_list_tab2";
//c_list_tab3,关注tab“热销”点击量,0
static NSString *const kUM_c_list_tab3 = @"c_list_tab3";
//c_list_tab4,关注tab“库存”点击量,0
static NSString *const kUM_c_list_tab4 = @"c_list_tab4";
//c_list_pulldown,关注“下拉刷新”点击量,0
static NSString *const kUM_c_list_pulldown = @"c_list_pulldown";
//c_list_change,关注推荐“换一批”点击量,0
static NSString *const kUM_c_list_change = @"c_list_change";
//c_list_head,关注列表“商铺头像”点击量,0
static NSString *const kUM_c_list_head = @"c_list_head";
//c_acrosslist_head,关注横向推荐“商铺头像”点击量,0
static NSString *const kUM_c_acrosslist_head = @"c_acrosslist_head";
//c_list_pic,关注列表“图片”点击量,0
static NSString *const kUM_c_list_pic = @"c_list_pic";


#pragma mark - 进货单

//采购“进货单编辑按钮”点击量,0
static NSString *const kUM_c_sledit =@"c_sledit";
//采购“进货单商铺名称”点击量,0
static NSString *const kUM_c_slnickname =@"c_slnickname";
//采购“进货单加库存”点击量,0
static NSString *const kUM_c_sladd =@"c_sladd";
//采购“进货单减库存”点击量,0
static NSString *const kUM_c_slreduce =@"c_slreduce";
//采购“进货单库存输入”点击量,0
static NSString *const kUM_c_slinput =@"c_slinput";
//采购“进货单清空失效宝贝”点击量,0
static NSString *const kUM_c_slinvalid =@"c_slinvalid";
//采购“进货单结算”点击量,0
static NSString *const kUM_c_slsettleaccounts =@"c_slsettleaccounts";
//采购“确认订单提交订单”点击量,0
static NSString *const kUM_c_submit =@"c_submit";



#pragma mark - 采购商我的


//采购“我的我的求购”点击量,0
static NSString *const kUM_c_mypurchase =@"c_mypurchase";
//采购“我的关注的商铺”点击量,0
static NSString *const kUM_c_collectshop =@"c_collectshop";
//采购“我的收藏的商品”点击量,0
static NSString *const kUM_c_collectproduct =@"c_collectproduct";
//采购“我的查看更多订单”点击量,0
static NSString *const kUM_c_moreorder =@"c_moreorder";
//采购“我的待确认”点击量,0
static NSString *const kUM_c_tobeconfirmed =@"c_tobeconfirmed";
//采购“我的待支付”点击量,0
static NSString *const kUM_c_tobepay =@"c_tobepay";
//采购“我的待发货”点击量,0
static NSString *const kUM_c_tobedeliver =@"c_tobedeliver";
//采购“我的待收货”点击量,0
static NSString *const kUM_c_tobereceive =@"c_tobereceive";
//采购“我的待评价”点击量,0
static NSString *const kUM_c_tobeevaluate =@"c_tobeevaluate";
//c_mine_ranslate,采购商我的“语音翻译”点击量,0
static NSString *const kUM_c_mine_ranslate =@"c_mine_ranslate";

//c_myintegral,采购商“我的积分”点击量,0
static NSString *const kUM_c_myintegral =@"c_myintegral";
//c_Integralmall,采购商“积分商城”点击量,0
static NSString *const kUM_c_Integralmall =@"c_Integralmall";




#pragma mark - 采购商端订单

//采购“订单上方点击”点击量,0
static NSString *const kUM_c_slideabove =@"c_slideabove";
//采购“订单点击展开”点击量,0
static NSString *const kUM_c_listopen =@"c_listopen";
//采购“订单滑动下方”点击量,0
static NSString *const kUM_c_slidedown =@"c_slidedown";
//采购“订单详情联系卖家”点击量,0
static NSString *const kUM_c_ordercontact =@"c_ordercontact";
//采购“订单详情拨打电话”点击量,0
static NSString *const kUM_c_odercall =@"c_odercall";



#pragma mark - 其他

//采购商闪屏点击量,0
static NSString *const kUM_c_flashscreen = @"c_flashscreen";
//采购商弹窗点击量,0
static NSString *const kUM_c_popups = @"c_popups";

//c_im_productsend,im消息中点击“发送宝贝”点击量，0
static NSString *const kUM_c_im_productsend =@"c_im_productsend";

#pragma mark - 引导页
//引导页“我是采购商”
static NSString *const kUM_y_purchasers = @"y_purchasers";
//引导页“我是供应商”
static NSString *const kUM_y_supplier = @"y_supplier";
//引导页“滑动引导页kUM_y_slide_0、1、2”
static NSString *const kUM_y_slide = @"y_slide";






//添加技巧，打开下模版注释//，双击666选中粘贴
//static NSString *const kUM_.666 =@"666_666";



//v3.5.0
//
//c_im_productsend,im消息中点击“发送宝贝”点击量，0
//
//b_bussiness_contactinfo_email,供应商:外商直采联系信息中“email”点击量,0
//b_bussiness_contactinfo_mobile,供应商:外商直采联系信息中“mobile”点击量,0


//#08.16整理
//v3.7.1
//
//b_home_score,供应商首页“交易得分”点击量，0
//b_service_rentinglist,市场服务“转租转让列表”点击量，0
//b_service_rentingmore,市场服务“转租转让列表更多”点击量，0


