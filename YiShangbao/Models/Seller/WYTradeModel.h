//
//  WYTradeModel.h
//  YiShangbao
//
//  Created by simon on 17/1/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"
#import "CommonModel.h"

typedef NS_ENUM(NSInteger, WYCertificationType){
    WYCertificationType_no = 0,     //未认证
    WYCertificationType_personage =1,      //个人认证
    WYCertificationType_enterprise =2,      //企业认证
    WYCertificationType_buyer =3,      //特邀采购员
};

//是否现货
typedef NS_ENUM(NSInteger, WYPromptGoodsType){
    WYPromptGoodsType_NO =2,      //可定制
    WYPromptGoodsType_YES = 1,     //有现货
    WYPromptGoodsType_NOSelect = 3,//没有选择

 };


//cell不同展示
typedef NS_ENUM(NSInteger, WXCellType){
    WXCellType_Trade =1,      //生意cell
    WXCellType_Adv = 2,     //广告cell
    
};

//生意求购类型
typedef NS_ENUM(NSInteger, WYTradeType){
    WYTradeType_foreignTrade = 1,     //外贸
    WYTradeType_domesticTrade =2,      //内贸
    WYTradeType_inventory =3,      //库存
    WYTradeType_foreignDirect =4,      //外商直采
    WYTradeType_other =9,      //其它
};

#pragma mark - 接生意走马灯广告ItemsModel
@interface TradeMoveTitleItemsModel : BaseModel
@property(nonatomic, strong)NSNumber* iid;    //每天展示次数
@property(nonatomic, copy)NSString *pic;    //展示类型json数组
@property(nonatomic, copy)NSString *url;
@property(nonatomic, copy)NSString *desc;
@end

#pragma mark - 接生意走马灯广告model
@interface TradeMoveTitleModel : BaseModel
@property(nonatomic, strong)NSNumber* num;    //每天展示次数
@property(nonatomic, copy)NSArray *items;    //展示类型json数组(模型)
@property(nonatomic, strong)NSNumber *type;
@end



#pragma mark -基础生意model
@interface BaseTradeModel : BaseModel

/**
 生意id-id
 */
@property (nonatomic,copy) NSString *postId;

/**
 微信用户id －uid
 */
@property (nonatomic,copy) NSString *unId;

/**
 求购者名称-nn
 */
@property (nonatomic,copy) NSString *userName;

/**
 头像-tx
 */
@property (nonatomic,strong) NSURL *URL;


/**
 认证类型－at
 */
@property (nonatomic) WYCertificationType certificationType;

/**
 公司名字－cn,可以空
 */
@property (nonatomic,copy) NSString *companyName;


/**
 帖子内容-ds
 */
@property (nonatomic,copy) NSString *content;


/**
 手机号－mb
 */
@property (nonatomic,copy) NSString *phoneNum;


/**
 发布求购时的名称 -pn－商品名称
 */
@property (nonatomic,copy) NSString *title;

/**
 过期时间-et
 */
@property (nonatomic) NSInteger expirationTime;

//发布时间
@property (nonatomic, copy) NSString *publishTime;

//是广告还是生意
@property (nonatomic, assign) WXCellType cellType;


@property (nonatomic, copy) NSString *h5Url;

//生意求购类型:4种求购类型，外贸大货，其它求购等
@property (nonatomic, assign) WYTradeType tradeType;
//生意求购类型: sten
@property (nonatomic, copy) NSString *tradeTypeTitle;

//所有已发布的有效求购
@property (nonatomic, strong) NSNumber *totalNiches;

//采购商图标
@property (nonatomic, copy) NSArray *buyerBadges;
@end







#pragma mark - 生意帖子model

@interface WYTradeModel : BaseTradeModel

/**
 我要接／来晚了 按钮－
 "bt" : {
 "n" : "我要接",
 "v" : 1
 },
 {"n":"来晚了","v":0}

 */
@property (nonatomic, strong) WYButtonModel *orderingBtnModel;

@property (nonatomic, strong) NSArray *photosArray;

@property (nonatomic, copy) NSString *mark;

@end















#pragma mark - 生意帖子详情
//生意帖子详情
@class TradeMyCommintModel;
@class TradeOtherReplyModel;

@interface TradeDetailModel :BaseTradeModel

@property (nonatomic,strong) NSArray *photosArray;


/**
 采购数量－no --详情页需要
 */
@property (nonatomic,copy) NSString *needCount;

/**
 交货时间 -ed --详情页需要
 */
@property (nonatomic,copy) NSString *deliveryTime;

//我回复的内容model－bv
@property (nonatomic,strong) TradeMyCommintModel *myCommitModel;
//其它人的回复model列表,bidList
@property (nonatomic, copy) NSArray *otherReplyModel;
//报价人数
@property (nonatomic, strong) NSNumber* qouterAmout;
//完成比例
@property (nonatomic, assign) CGFloat ratio;
//报价人头像
@property (nonatomic, strong) NSArray *sellerIcons;


//外商联系方式 2018.5.16 ste为4(外商直采)时可能有值
@property (nonatomic,copy) NSString *mobile ;
//外商email 2018.5.16 ste为4(外商直采)时可能有值
@property (nonatomic,copy) NSString *email  ;

//翻译数组
@property (nonatomic,copy) NSArray *translation;

@end



#pragma mark- 帖子详情中其它人的回复model列表

@interface TradeOtherReplyModel : BaseModel

@property (nonatomic, copy) NSString *shopName;

@property (nonatomic, strong) NSNumber *bidTimes;
//认证标识 0-未认证 1-认证通过;弃用
@property (nonatomic) BOOL authFlag;
//是否为重点供应商 0-否 1-是 弃用
@property (nonatomic) BOOL keyFlag;

@property (nonatomic, copy) NSString *shopIcon;
//小图标数组
@property (nonatomic, copy) NSArray *sellerBadges;
@end




#pragma mark- 帖子详情中我的回复model

@interface TradeMyCommintModel : BaseModel

/**
 回复时间 － ts
 */
@property (nonatomic,copy) NSString *replyTime;

/**
 是否现货，卖货的类型－st
 */
@property (nonatomic,copy) NSString *sellGoodsType;

/**
 商品单价-pr
 */
@property (nonatomic,copy) NSString *goodsPrice;

/**
 回复的图片－ps
 */
@property (nonatomic,strong) NSArray *photosArray;

/**
 回复内容－sr
 */
@property (nonatomic,copy) NSString *replyContent;


/**
 最小起订量-mq
 */
@property (nonatomic,copy) NSString *orderBeginCount;
@end











//我的生意－进行中／已结束
@interface MYTradeUnderwayModel : BaseTradeModel


/**
 回复时间-ts
 */
@property (nonatomic,copy) NSString *replyTime;

/**
 是否已查看动态按钮字典
 */

@property (nonatomic,copy) NSString *btnTitle;

@property (nonatomic,strong) NSNumber *btnType;

/**
 评价按钮－星级评分；
 */

@property (nonatomic,strong)EvluateBtnModel *evluateBtnModel;
@end
















/*
{
ds:1,                             ds-default score 默认评分 0-无星 1-半星 2-一星 ... 10-五星
dd:"xxxxxx",                      dd-default descrption 默认评价
ls:                               ls-labels 评价标签(json数组)
    [
    {"n":"xxx","v":1},
    {"n":"xxx","v":2},
    {"n":"xxx","v":3},
    {"n":"xxx","v":4},
     ...
     ]
}
 */
@interface EvatipModel : BaseModel
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *value;

@end

@interface TradeBuyerModel : BaseModel

@property (nonatomic, copy) NSString *buyerId;
@property (nonatomic, strong) NSNumber *defaultScore;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *userIcon;

@end

@interface MyEvaluateModel : BaseModel

@property (nonatomic, strong) TradeBuyerModel *buyer;
@property (nonatomic, strong) NSNumber *score;
//没有描述了
@property (nonatomic, strong) NSString *descrptiontext;
@property (nonatomic, strong) NSArray *labels;
@property (nonatomic, strong) NSArray *sm;

@end

@interface ReleaseBusniessModel : BaseModel

@property (nonatomic, strong) NSString *productName;
@property (nonatomic, strong) NSString *createTime;
@property (nonatomic, strong) NSString *subjectId;
@property (nonatomic) BOOL valid;

@end
