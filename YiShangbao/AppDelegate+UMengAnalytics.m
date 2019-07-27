//
//  AppDelegate+UMengAnalytics.m
//  YiShangbao
//
//  Created by simon on 2017/11/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AppDelegate+UMengAnalytics.h"
#import <UMMobClick/MobClick.h>

@implementation AppDelegate (UMengAnalytics)



#pragma  mark - 友盟统计

- (void)addUMMobClick
{
    UMConfigInstance.appKey = @"585349d5f43e4861f40020f2";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];//配置以上参数后调用此方法初始化SDK！
    [MobClick setAppVersion:APP_Version];
    [MobClick setLogEnabled:YES];
    
    NSLog(@"%@",[[UIDevice currentDevice]getUMOpenUDIDString]);

//        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:@{@"oid" : deviceID}
//                                                           options:NSJSONWritingPrettyPrinted
//                                                             error:nil];
//
//        NSLog(@"%@", [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding]);
}

@end
