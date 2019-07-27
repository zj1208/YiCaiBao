//
//  WYNIMAccoutManager.h
//  YiShangbao
//
//  Created by simon on 17/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString *const kNotificationAccountBlock;


@interface WYNIMAccoutManager : NSObject

+ (instancetype)shareInstance;

- (void)setupCurrentNIMAccoutLoginFailedErrorCode:(NIMRemoteErrorCode)code;
//重置账户正常
- (void)resetCurrentNIMAccoutNormal;

- (BOOL)cheackAccoutEnable:(UIViewController *)sourceController;
@end
