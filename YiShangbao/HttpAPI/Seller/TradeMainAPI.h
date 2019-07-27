//
//  TradeMainAPI.h
//  YiShangbao
//
//  Created by Lance on 17/1/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "WYTradeModel.h"

#pragma mark - USER URL
//生意主页
static NSString *kTrade_BusinessList_URL = @"mtop.order.business.pbid";
//201017_我的生意(2.0)
static NSString *kTrade_myBusinessList_URL  =@"mtop.order.business.myBid";
//2010103_搜索生意列表
static NSString *kTrade_businessSearchList_URL  =@"mtop.order.business.query";


//204002_评价
static NSString *kTrade_evaluate_URL  = @"mtop.order.business.sfb";
//204001_评价页面初始化+
static NSString *kTrade_evalueteInitInfo_URL = @"mtop.order.business.fbinit";
//204004_求购中采购商收到的评价
static NSString *kTrade_buyerEvalueteList_URL = @"mtop.order.brd";

// 201014－我要接－生意详情
static NSString *kTrade_detail_URL = @"mtop.order.business.sds";
//201015_马上接单-生意详情－判断是否可以接单
static NSString *kTrade_detailTakeOrdering_URL = @"mtop.order.business.bbs";
//201016_提交报价
static NSString *kTrade_postOrder_URL = @"mtop.order.business.bid";

//201033_剩余报价次数
static NSString *kTrade_remainOrderingTimes_URL  =@"mtop.order.bid.times.left";


//010301_获取区块内容
//1006：生意列表顶部广告位（仅文字和链接）
static NSString *Trade_getAdv_URL = @"mtop.cc.getAdv";
static NSString *kTrade_ClickPic_URL = @"mtop.view.subject.by.pic";

//201037_与我相关求购数
static NSString *kTrade_get_order_subject_increment_URL = @"mtop.order.subject.increment";

//201038_接收其他求购初始化
static NSString *kTrade_get_mtop_order_romQuery_URL = @"mtop.order.romQuery";

//201039_设置是否接收其他求购
static NSString *kTrade_post_mtop_order_romSet_URL = @"mtop.order.romSet";

//201040_给定采购商发布的所有有效求购
static NSString *kTrade_get_releaseBusinessList_URL  =@"mtop.order.validNiches";

//201042_供应商忽略求购
static NSString *kTrade_post_ignoreSubject_URL= @"mtop.order.ignoreSubject";

//011401_简单翻译器
static NSString *kTrade_get_translatorSimple_URL  =@"mtop.translator.simple";


/**
 我的生意：类型
 */
typedef NS_ENUM(NSInteger, WYBuyType){
    WYBuyType_underway = 1,     //进行中
    WYBuyType_finished =2,      //已结束
};


/**
 生意列表 类型
 */
typedef NS_ENUM(NSInteger, TradeRelatedToMeListType){
    TradeRelatedToMeListType_all = 0,     //全部，最新发布
    TradeRelatedToMeListType_systemRecommend =1,      //与我相关，系统推荐
    TradeRelatedToMeListType_sorting =2, //智能排序
    
    TradeRelatedToMeListType_inventory =3, //库存专区

};

typedef NS_ENUM(NSInteger, WYTranslatorType){
    WYTranslatorType_EN_to_CN = 0,      //英文转中文
    WYTranslatorType_CN_to_EN = 1,      //中文转英文
};


@interface TradeMainAPI : BaseHttpAPI


/**
 201040_给定采购商发布的所有有效求购

 @param buyerId 采购商uid
 @param pageNum 页数
 @param pageSize 单页数量
 @param success success description
 @param failure failure description
 */
- (void)getkTradeReleaseBusinessListURLBuyerId:(NSString *)buyerId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
 201039_设置是否接收其他求购

 @param rom 是否开启接收库存及其他求购信息推送 true-开启 false-关闭 1/0
 @param success success description
 @param failure failure description
 */
-(void)postMtopOrderRomSetURLWithRom:(BOOL)rom  success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 201038_接收其他求购初始化

 @param success success description
 @param failure failure description
 */
- (void)getkTradeMtopOrderRomQueryURLsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 201037_与我相关求购数

 @param success success description
 @param failure failure description
 */
- (void)getkTradeGetOrderSubjectIncrementsuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取走马灯广告

 @param iid 区块id
 @param success success description
 @param failure failure description
 */
- (void)getTradeAdvWithQuKuaiID:(NSInteger)iid success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 接生意首页
 翻页的时候只获取发布时间 ≤ 第一页请求时的时间的生意,降低重复几率；
 @param bidedArray 已接生意
 @param ignoredArray 忽略的生意； 忽略目前有问题；
 @param pageNo 第几页
 @param pageSize pageSize description
 @param relatedtoMeType 0-全部(最新发布，默认) 1-与我相关(2017.5.23) 2-智能排序(2017.8.7) 3-低价库存(2017.10.11) 9-其他求购(2017.10.11)

 */
- (void)getTradeBussinessListWithBided:(NSMutableArray *)bidedArray ignored:(NSMutableArray *)ignoredArray  pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize  relatedToMe:(TradeRelatedToMeListType)relatedtoMeType  requestId:(NSString *)requestId success:(void(^)(id data,PageModel *pageModel,NSString * responseId))success failure:(ErrorBlock)failure;


/**
 2010103_搜索生意列表

 @param pageNo page no，默认1(第一页)
 @param pageSize page size，默认10
 @param keywords 搜索生意关键词
 @param requestId 请求id，pageNo为1的情况可以为空，pageNo大于1的情况必须设置为前一次请求返回来的responseId
 @param success success description
 @param failure failure description
 */
- (void)getSearchTradeBussinessListPageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize keywords:(NSString *)keywords  requestId:(NSString *)requestId success:(void(^)(id data,PageModel *pageModel,NSString * responseId))success failure:(ErrorBlock)failure;

/**
 生意帖子详情

 @param postId 帖子id
 
 */
- (void)getTradeBussinessDetailWithPostId:(NSString *)postId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 201017_我的生意(2.0)

 @param buyType buyType 我的生意类型
 @param pageNo pageNo description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */
- (void)getMyTradeBusinessListWithType:(WYBuyType)buyType pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;



//201015_马上接单(报价页面初始化)  编辑

- (void)getTradeDetailTakeOrderingWithPostId:(NSString *)postId success:(CompleteBlock)success failure:(ErrorBlock)failure;

//201016_提交报价
- (void)postOrderWithPostId:(NSString *)postId replyContent:(NSString *)content promptGoodsType:(WYPromptGoodsType)goodsType price:(NSString *)price minCount:(NSString *)countString photos:(NSArray *)photosArray success:(CompleteBlock)success failure:(ErrorBlock)failure;

//201033_剩余报价次数
- (void)getRemainOrderingTimesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 评价页面初始化

 @param identityType 用户身份 2-买家 4-卖家
 @param sid 求购id
 @param success 成功block
 @param failure 失败block
 */
- (void)getTradeInitEvaluateInfoWithIdentityType:(NSNumber *)identityType tradeId:(NSString *)sid success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 提交评价

 @param postId 产品id
 @param content 反馈内容
 @param starNum 0-无星 1-半星 2-一星 3-一星半 4-两星 5-两星半 6-三星 7-三星半 8-四星 9-四星半 10-五星
 @param tags 评价标签(id),逗号分隔
 @param identityType 用户身份 2-买家 4-卖家
 @param success 成功block
 @param failure 失败block
 */
- (void)postTradeCommentWithPostId:(NSString *)postId content:(NSString *)content starNum:(NSNumber *)starNum tag:(NSString *)tags  identityType:(NSNumber *)identityType evaluate:(NSString *)ratings success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 204004_求购中采购商收到的评价

 @param uid 买家Id
 @param pageNum pageNum description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */
- (void)getTradeEvaluateListByBuyerId:(NSString *)uid pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;

//点击图片看大图
- (void)getTradePicClickWithTradeId:(NSString *)tradeId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 //201042_供应商忽略求购

 @param tradeId 生意id
 @param reason 关闭原因
 */
- (void)postIgnoreSubjectWithTradeId:(NSString *)tradeId reason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 011401_简单翻译器

 @param type 翻译类型-中文<->英文
 @param sources 要翻译的字符串组成的数组
 @param success 翻译成功的字符串数组，对应sources顺序
 @param failure failure description
 */
- (void)getTranslatorSimpleWithType:(WYTranslatorType )type sources:(NSArray *)sources  success:(CompleteBlock)success failure:(ErrorBlock)failure;


@end
