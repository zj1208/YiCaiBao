//
//  MessageAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

#pragma mark - Message URL

//400008_获取消息摘要列表
#define Main_MessageList_URL              @"mtop.mc.getAbbrMsgList"
//400002_获取分类消息列表
#define Detail_MessageList_URL            @"mtop.mc.getMsgList"
//400003_标记消息已查看
#define MarkMsgRead_URL                   @"mtop.mc.markMsgRead"
//400004_未读消息数目
#define ShowMsgCount_URL                  @"mtop.mc.showMsgCount"
//400005_市场公告（无需登陆）
#define Get_PublicMsgList_URL                  @"mtop.mc.getPublicMsgList"

//400006_获取分享配置
#define Get_Share_URL                  @"mtop.share.conf"

//800004_获取最新版本接口
#define Get_LastVersion_URL                  @"mtop.app.getLastVersion"

//010301_获取区块内容
#define Get_Adv_URL             @"mtop.cc.getAdv"

//800001_设备更新接口
#define Post_DeviceInfo_URL             @"mtop.app.addOrUpdateDeviceInfo"


//800002_推送声音设置
#define Update_SoundSetting_URL             @"mtop.app.updateSoundSetting"

//800003_查询推送声音设置
#define Query_SoundSetting_URL             @"mtop.app.querySoundSetting"

//010401_增加业务埋点（广告点击量埋点）
static NSString *Trade_postMonitor_addTrackInfo_URL = @"mtop.monitor.addTrackInfo";

//320002_卖家必读通知列表
static NSString *kAdv_Get_gquerySellerMustReads = @"mtop.shop.querySellerMustReads";

// 卖家必读通知列表获取类型
typedef NS_ENUM(NSInteger, SellerMustReadsType){
    // 全部
    SellerMustReadsType_All = 0,
    // 最近三条
    SellerMustReadsType_LastThree = 1,
};

@interface MessageAPI : BaseHttpAPI



/**
 后台广告点击量埋头统计(广告)
 trackId
 义采宝：100（搜索）, 101（我的收藏）, 102（店铺首页）, 103（店铺名片），104（产品页面）, 105（市场分类商铺），106（采购端首页），107（进货单）, 108(订单列表)，109（订单详情）, 110（产品搜索结果列表页面）, 111（商铺分类）
 action
 viewItem（浏览商品）, viewShop（浏览店铺）, addFav（加入收藏）, viewCard（浏览名片）, clickAdv（点击广告）, viewAdv（展示广告）
 
 卖家版APP区块id
 1001：店铺首页轮播广告位
 10011：店铺首页必看通知 added.2017-12-11
 1002：APP开屏
 1003：店铺二维码
 1004：我的页面右下区块
 1005：APP弹窗
 1006：生意列表顶部广告位（仅文字和链接）
 1007：生意列表信息流植入广告（最新排序tab）
 10071：生意列表信息流植入广告（智能排序tab）
 10072：生意列表信息流植入广告（与我相关tab）
 1008：APP发布求购成功页（采购商、供应商公用） h5
 1009：APP店铺首页右侧广告
 10110：待办事项列表顶部 h5
 1011：我的积分  h5
 1012:停车缴费支付成功页banner h5
 买家版APP区块id
 2001：首页顶部广告
 2002：首页功能bar
 2003：待定
 2004：我的页面右下区块
 2005：APP开屏
 2006：APP弹窗
 2007：分类查找
 20071:分类查找-热门推荐-顶栏;
 20072:分类查找-热门推荐-专场推荐
 2008：市场导航下面的广告1
 2009：市场导航下面的广告2
 2010：库存出售广告位（左）
 2011：产品热销广告位（右）
 2012：超级网商榜-采购商
 2013：超级爆款榜
 买家版H5区块id
 @param areaId 广告埋点，区块id
 @param advId 广告埋点，广告id
 @param success success description
 @param failure failure description
 */
- (void)postAddTrackInfoWithAreaId:(NSNumber *)areaId advId:(NSString *)advId  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 400008_获取消息摘要列表

 @param success 成功block
 @param failure 失败block
 */
- (void)getAbbrMsgListWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取分类消息列表

 @param type 消息类别，1：市场公告，2：微蚁团队 3：通知消息
 @param pageNo 默认第1页
 @param pageSize 默认每页10条
 @param success 成功block
 @param failure 失败block
 */
- (void)getDetailMsgListWithType:(NSNumber *)type pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;



/**
 标记消息已查看

 @param type 消息类别，1：市场公告，2：微蚁团队 3：通知消息
 @param success 成功block
 @param failure 失败block
 */
-(void)markMsgReadWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 400004_未读消息数目
 all(0, "所有"),
 market(1, "市场公告") -- 卖家
 antsteam(2, "活动资讯") -- 卖家&买家  //微蚁团队->活动资讯
 system(3, "系统通知")   -- 卖家&买家  //通知消息->系统通知
 buyernews(5, "采购资讯") -- 买家
 
 // 2017.10.10
 trade(7, "交易相关")  -- 卖家&买家
 ycbschool(8, "义采宝学堂") -- 卖家
 todo(9, "待办事项") -- 卖家
 
 antsNews(10, "推广动态")   -- 卖家   
 */
-(void)getshowMsgCountWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取分类消息列表（无需登陆）
 
 @param type 消息类别，1：市场公告，2：微蚁团队 3：通知消息
 @param pageNo 默认第1页
 @param pageSize 默认每页10条
 @param success 成功block
 @param failure 失败block
 */
- (void)getPublicMsgListWithType:(int)type pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure;





/**
 获取分享配置

 @param type 配置类型       11-采购端分享商铺配置
                           12-采购端分享电子名片配置 
                           13-采购端分享商品配置 
                           10-采购端分享其他配置 
                           21-商户端分享商铺配置 
                           22-商户端分享电子名片配置 
                           23-商户端分享商品配置 
                           24-商户端分享app配置
                           25-商户端分享求购配置
 @param success 成功block
 @param failure 失败block
 */
- (void)getShareWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 400006_分享链接配置

 @param type 配置类型
 @param shopId 分享推广产品，分享库存，分享店铺内分类 必传
 @param shopCateName 店铺内产品分类名
 @param shopCateId 店铺内产品分类ID
 @param success success description
 @param failure failure description
 */
- (void)getShareWithType:(NSNumber *)type shopId:(NSString *)shopId shopCateName:(NSString *)shopCateName shopCateId:(NSString *)shopCateId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 获取最新版本 角色类型（6-全部，4-商家，2-买家）

 @param success 成功block
 @param failure 失败block
 */
- (void)checkAppVersionWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取区块内容

 @param type 区块id，
 1001：商铺首页，
 1002：APP欢迎页，
 1003：商铺二维码，
 1004：分类搜索，
 1005：APP弹窗
 1006：生意列表顶部广告位（仅文字和链接）
 1007：生意列表信息流植入广告（最新排序tab）
 10071：生意列表信息流植入广告（智能排序tab）
 10072：生意列表信息流植入广告（与我相关tab）
 1008：APP发布求购成功页（采购商、供应商公用）
 1009：APP商铺首页右侧广告
 1015：粉丝广告
 1016：访客广告

 
 买家版区块id
 2001：首页顶部广告
 2002：首页功能bar
 2003：产品类目选择
 2004：我的页面右下区块
 2005：APP开屏
 2006：APP弹窗
 2007：分类查找
 @param success 成功block
 @param failure 失败block
 */
- (void)GetAdvWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

//默认0，0：排序， 1：随机
- (void)GetAdvWithType:(NSNumber *)type rnd:(NSNumber *)rnd success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 //010301_获取区块内容
 获取分类查找广告图

 @param type 区块id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)GetFenLeiAdvWithType:(NSNumber *)type sysCatesId:(NSString*)sysCatesId success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 320002_卖家必读通知列表
 @param type  默认0:全部，1:最近三条；

 @param success success description
 @param failure failure description
 */
- (void)getShopQuerySellerMustReadsWithListType:(SellerMustReadsType)type  success:(CompleteBlock)success failure:(ErrorBlock)failure;




/**
 800001 设备更新接口

 手机通知设置0－开启，1－关闭
 @param params 请求参数
 @param success 成功block
 @param failure 失败block
 */
- (void)




PostDeviceInfoWithParameters:(NSDictionary *)params success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 推送声音设置

 @param subject 生意 0:开启，1：关闭
 @param fan 粉丝
 @param visitor 游客
 @param success 成功block
 @param failure 失败block
 */
- (void)updateSoundSettingWithSubject:(NSString*)subject fan:(NSString*)fan visitor:(NSString*)visitor success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 查询推送声音设置

 @param success 成功block
 @param failure 失败block
 */
- (void)querySoundSettingWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


@end
