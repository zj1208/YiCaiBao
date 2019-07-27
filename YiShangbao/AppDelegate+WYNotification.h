//
//  AppDelegate+WYNotification.h
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "AppDelegate.h"
#import "GeTuiSdk.h"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

@interface AppDelegate (WYNotification)<UIApplicationDelegate,GeTuiSdkDelegate,UNUserNotificationCenterDelegate>

@end
