//
//  AppDelegate+ShareSDK.m
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "AppDelegate+ShareSDK.h"

//QQ、微信分享 这里只配置生产环境的分析ID和key，因为APP配置还需要做修改，故只用一个
#define QQAppId @"1105812101"
#define QQAppKey @"0MOeQFvmFU0Ds8W0"
#define WeChatAppid @"wxc8edd69b7a7950ee"
#define WeChatAppSecret @"5da19782393b0557978c106d8c1c2b73"


@implementation AppDelegate (ShareSDK)


#pragma mark - shareSDK初始化
-(void)initShareSDK
{
    /**
     *  设置ShareSDK的appKey，如果尚未在ShareSDK官网注册过App，请移步到http://mob.com/login 登录后台进行应用注册
     *  在将生成的AppKey传入到此方法中。
     *  方法中的第二个第三个参数为需要连接社交平台SDK时触发，
     *  在此事件中写入连接代码。第四个参数则为配置本地社交平台时触发，根据返回的平台类型来配置平台信息。
     *  如果您使用的时服务端托管平台信息时，第二、四项参数可以传入nil，第三项参数则根据服务端托管平台来决定要连接的社交SDK。
     */
    
    NSArray *arr = @[
                     @(SSDKPlatformTypeQQ),
                     @(SSDKPlatformSubTypeWechatSession),
                     @(SSDKPlatformTypeWechat),
                     ];
    [ShareSDK registerActivePlatforms:arr onImport:^(SSDKPlatformType platformType) {
        
        switch (platformType)
        {
            case SSDKPlatformTypeWechat:
                [ShareSDKConnector connectWeChat:[WXApi class]];
                break;
            case SSDKPlatformTypeQQ:
                [ShareSDKConnector connectQQ:[QQApiInterface class] tencentOAuthClass:[TencentOAuth class]];
                break;
            default:
                break;
        }
    } onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo) {
        
        switch (platformType)
        {
                
            case SSDKPlatformTypeWechat:
                [appInfo SSDKSetupWeChatByAppId:WeChatAppid
                                      appSecret:WeChatAppSecret];
                break;
            case SSDKPlatformTypeQQ:
                [appInfo SSDKSetupQQByAppId:QQAppId
                                     appKey:QQAppKey
                                   authType:SSDKAuthTypeBoth];
                break;
            default:
                break;
        }
    }];
}

@end
