//
//  MessageModel.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"





@interface shareModel : BaseModel

@property(nonatomic, copy)NSString *title;     //标题，可能含有占位符(商品名或商铺名)，由调用方填充
@property(nonatomic, copy)NSString *content;   //摘要
@property(nonatomic, copy)NSString *pic;       //当type=24或10时才有此值，此值为义商宝logo
@property(nonatomic, copy)NSString *link;      //商铺/商品详情的url，会有占位符(商铺/商品的id，ttid) ，需调用者填充

@end

@interface advArrModel : BaseModel
@property(nonatomic, copy)NSString *pic;
@property(nonatomic, copy)NSString *desc;
@property(nonatomic, copy)NSString *url;
@property(nonatomic, strong)NSNumber * iid;
@property(nonatomic, strong) NSNumber * areaId;


@end

@interface  AdvModel : BaseModel

@property(nonatomic, assign)int type;        //展示类型 0：不展示(后端会过滤，客户端不需要考虑)，1：轮播，2：闪屏 3：弹框
@property(nonatomic, assign)int num;    //每天展示次数 0：不限制，其它则展示相应次数。如：3
@property(nonatomic, copy)NSArray *advArr;           //展示类型


@end
//分类轮播adv
@interface FenLeiLunboAdvModel : BaseModel
@property(nonatomic, strong) NSNumber *catId;
@property(nonatomic, copy) NSString *desc;
@property(nonatomic, strong) NSNumber *iid;
@property(nonatomic, copy) NSString *pic;
@property(nonatomic, copy) NSString *url;
@end


//320002_卖家必读通知列表
@interface ShopMustReadAdvModel : BaseModel
//广告id
@property (nonatomic, strong) NSNumber *advId;
//广告区块id
@property (nonatomic, copy) NSNumber *areaId;
//展示类型图片
@property (nonatomic, copy) NSString *pic;
//点击跳转url
@property (nonatomic, copy) NSString *url;
//标题
@property (nonatomic, copy) NSString *title;
//描述
@property (nonatomic, copy) NSString *desc;
//点击次数
@property (nonatomic, strong) NSNumber *clickSum;
@end

@interface ShopMustReadAdvFatherModel : BaseModel

@property (nonatomic, strong) NSArray *list;

@property (nonatomic, assign) BOOL redDot;

@end


@interface  VersionModel : BaseModel

@property(nonatomic, copy)NSString *version;        //版本名字
@property(nonatomic, copy)NSNumber *versionCode;    //版本代码
@property(nonatomic, copy)NSString *desc;           //版本描述
@property(nonatomic, copy)NSString *url;            //版本下载链接
@property(nonatomic, strong)NSNumber *isForce;      //是否强制升级 0是 1否

@end



@interface SoundModel : BaseModel

@property (nonatomic, strong) NSNumber *enableSubject;  //生意
@property (nonatomic, strong) NSNumber *enableFan;      //粉丝
@property (nonatomic, strong) NSNumber *enableVisitor;  //访客

@end


//消息列表

@interface SubMsgModel : BaseModel

@property(nonatomic, copy) NSString *abbr;
@property(nonatomic, copy) NSString *date;

@end


@interface MessageModelSub : BaseModel

@property (nonatomic, assign) int num;
//market(1, "市场公告") -- 卖家
//antsteam(2, "活动资讯") -- 卖家&买家  //微蚁团队->活动资讯
//system(3, "系统通知")   -- 卖家&买家  //通知消息->系统通知
//fraud(4, "诈骗案例")
//buyernews(5, "采购资讯") -- 买家
//appnotify(6, "APP通知")
//// 2017.10.10
//trade(7, "交易相关")  -- 卖家&买家
//ycbschool(8, "义采宝学堂") -- 卖家
//todo(9, "待办事项") -- 卖家
//antsNews(10, "推广动态")
@property (nonatomic, assign) int type;
@property (nonatomic, copy) NSString *typeName;
@property (nonatomic, copy) NSString *typeIcon;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) SubMsgModel *subMsg;

@end


@interface MessageModel : BaseModel

@property(nonatomic, copy) NSArray *list;
@property(nonatomic, copy) NSArray *grid;


@end

//消息详情
@interface MessageDetailModel : BaseModel

@property (nonatomic, copy) NSString *date;
@property (nonatomic, copy) NSString *dateYmd;

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, copy) NSString *abbr;

@end


//消息详情

@interface IMChatInfoModelProSub : BaseModel

@property (nonatomic, copy) NSString *proId;
@property (nonatomic, copy) NSString *pic;

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *price;

@end


@interface IMChatInfoModel : BaseModel

@property (nonatomic, copy) NSString *uid;
@property (nonatomic, copy) NSString *accid;

@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *shopUrl;
@property(nonatomic, copy) IMChatInfoModelProSub *product;

@end
