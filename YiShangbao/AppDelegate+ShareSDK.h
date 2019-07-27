//
//  AppDelegate+ShareSDK.h
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKConnector/ShareSDKConnector.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@interface AppDelegate (ShareSDK)

-(void)initShareSDK;

@end
