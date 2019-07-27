//
//  NTESSessionViewController.h
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//
//  入口：消息列表，生意详情页面，接单成功页面，采购商信息；退款详情页面，订单详情；h5页面路由

#import "NIMKit.h"


#import "NIMSessionViewController.h"

@interface NTESSessionViewController : NIMSessionViewController

@property (nonatomic,assign) BOOL disableCommandTyping;  //需要在导航条上显示“正在输入”

@property (nonatomic,assign) BOOL disableOnlineState;  //需要在导航条上显示在线状态

// 个人资料地址
@property (nonatomic, copy) NSString *hisUrl;

// 商铺地址
@property (nonatomic, copy) NSString *shopUrl;

@property (nonatomic, strong) IMChatInfoModelProSub *proModel;


@property (nonatomic, assign) BOOL hideUnreadCountView;
@end
