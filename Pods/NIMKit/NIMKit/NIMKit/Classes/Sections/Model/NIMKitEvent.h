//
//  NIMKitEvent.h
//  NIMKit
//
//  Created by chris.
//  Copyright (c) 2015年 NetEase. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NIMSDK/NIMSDK.h>
#import "NIMMessageModel.h"

@interface NIMKitEvent : NSObject

@property (nonatomic,copy) NSString *eventName;

@property (nonatomic,strong) NIMMessageModel *messageModel;

@property (nonatomic,strong) id data;

@end




extern NSString *const NIMKitEventNameTapContent;
extern NSString *const NIMKitEventNameTapLabelLink;
extern NSString *const NIMKitEventNameTapAudio;
extern NSString *const NIMKitEventNameTapRobotLink;
extern NSString *const NIMKitEventNameTapRobotBlock;
extern NSString *const NIMKitEventNameTapRobotContinueSession;
// 新增发送产品图文链接-推荐产品-布局不同，类名不同
extern NSString *const NIMKitEventNameTapProductPicTextLink;
// 发送产品详情中调起的聊天产品；-布局不同，类名不同
extern NSString *const NIMKitEventNameTapSendProduct;
