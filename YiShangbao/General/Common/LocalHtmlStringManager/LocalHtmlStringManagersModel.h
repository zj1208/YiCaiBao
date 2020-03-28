//
//  LocalHtmlStringManagersModel.h
//  YiShangbao
//
//  Created by 朱新明 on 2020/2/5.
//  Copyright © 2020 com.Microants. All rights reserved.
//

#import "BaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LocalHtmlStringManagersModel : BaseModel

//发布求购 "http://wykj-internal.s-ant.cn/ycb/page/ycbPurchaseForm.html?ttid={ttid}"
@property (nonatomic, copy) NSString *ycbPurchaseForm;
//我的求购 "http://wykj-internal.s-ant.cn/ycb/page/ycbPurchaseOrder.html?ttid={ttid}"
@property (nonatomic, copy) NSString *ycbPurchaseOrder;
//我关注的商铺；我的店铺 "http://wykj-internal.s-ant.cn/ycbx/page/ycbPersonalConcernedShop.html?ttid={ttid}"
@property (nonatomic, copy) NSString *ycbPersonalConcernedShop;
//收藏的产品
@property (nonatomic, copy) NSString *ycbPersonalConcernedGoods;
//认证状态(个人认证)
@property (nonatomic, copy) NSString *ycbPersonalRealAuthenticationSuccess;
//认证状态（企业认证）
@property (nonatomic, copy) NSString *ycbCompanyAuthenticationSuccess;
//认证状态
@property (nonatomic, copy) NSString *ycbIdentityVerify;
//义乌国际商贸城市场认证
@property (nonatomic, copy) NSString *unverify;
//我的收入
@property (nonatomic, copy) NSString *wallet;
//我订购的服务
@property (nonatomic, copy) NSString *myOrderedService;
//《义采宝用户服务协议》
@property (nonatomic, copy) NSString *registerProtocol;
//《义采宝交易争议处理规则》
@property (nonatomic, copy) NSString *disputeHandleRules;
//电脑上传
@property (nonatomic, copy) NSString *pcUploadIntro;

//P1

//意见反馈-卖家
@property (nonatomic, copy) NSString *suggestFeedBack;
//意见反馈-买家
@property (nonatomic, copy) NSString *ycbSuggestFeedBack;
//设置/帮助中心-买家
@property (nonatomic, copy) NSString *ycbHelpCenter;
//设置/帮助中心-卖家
@property (nonatomic, copy) NSString *helpCenter;
//关于我们
@property (nonatomic, copy) NSString *aboutUs;

@end

NS_ASSUME_NONNULL_END
