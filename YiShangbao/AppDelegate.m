//
//  AppDelegate.m
//  YiShangbao
//
//  Created by Lance on 16/12/1.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "AppDelegate.h"
#import "WYIntroduceViewController.h"
#import "EventViewController.h"
#import "MessageModel.h"
#import "WYNIMAccoutManager.h"
#import "AliOSSUploadManager.h"
#import "WYTimeManager.h"
#import "AppDelegate+UMengAnalytics.h"
#import "AppDelegate+ShareSDK.h"
//科大讯飞
#import "iflyMSC/IFlyMSC.h"
#define APPID_VALUE        @"599fc839"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import <AvoidCrash.h>
//个推
#import <GTSDK/GeTuiSdk.h>
//阿里支付回调
#import <AlipaySDK/AlipaySDK.h>
//云信
#import <NIMSDK/NIMSDK.h>
#import "NTESSDKConfigDelegate.h"
#import "WYPurchaserViewController.h"
#import "WYTabBarViewController.h"

#import "NTESCellLayoutConfig.h"
#import "LocalHtmlStringManager.h"

// app从什么激活的
typedef NS_ENUM(NSInteger, AppActiveFromType)
{
    AppActiveFromType_finishLaunch = 1,//app启动激活
    AppActiveFromType_background = 0//从后台激活
};

@interface AppDelegate ()<GeTuiSdkDelegate,UNUserNotificationCenterDelegate,NIMLoginManagerDelegate,NIMChatManagerDelegate>

@property (nonatomic,strong) NTESSDKConfigDelegate *sdkConfigDelegate;

@property (nonatomic, assign) NSInteger nimRequestTimes;

@property (nonatomic, assign) AppActiveFromType appActiveFromType;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(nullable NSDictionary *)launchOptions
{
    //初始化本地数据设置
    //不知道是否开启
    [WYUserDefaultManager setMyAppUserNotificationOpenType:UDAuthorizationStatusNotDetermined];
    [[NSUserDefaults standardUserDefaults]removeObjectForKey:ud_GTClientId];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
    return YES;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    if ([launchOptions objectForKey:UIApplicationLaunchOptionsUserActivityDictionaryKey])
    {
        self.appActiveFromType =AppActiveFromType_finishLaunch;
    }
    [self setUI];
  
    //设置域名环境
    [self setDomainManager];
    
    //监听事件
    [self commonInitListenEvents];

    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];

    //处理刚启动时候收到的通知
    [self takeLaunchRemoteNoti:launchOptions];
    
    //添加个推及注册通知
    [self registerGetuiAndRemoteNotification];
    
    //判断用户通知关闭及请求
    [self isOpenUserNotification];
  
    //向微信注册应用
    [WXApi registerApp:[WYUserDefaultManager getkURL_WXAPPID]];
    
    //添加addAvoidCrash
    [self addAvoidCrash];

    //首次app下载开机
    [self startFirst];

    //应用推送红点
    [GeTuiSdk setBadge:0];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
//    云信
    [self initNIMSDK];

    //shareSDK
    [self initShareSDK];
    //友盟统计
    [self addUMMobClick];

//    科大讯飞
    [self initIFlyMSC];
    [self set3DTouch];
    [self requestLocalHtmlStringManagers];
    return YES;
}



- (void)setUI
{
    [[UIButton appearance]setExclusiveTouch:YES];
    self.window.backgroundColor = [UIColor whiteColor];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeVisibleNotification:) name:UIWindowDidBecomeVisibleNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeKeyNotification:) name:UIWindowDidBecomeKeyNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(windowDidBecomeHiddenNotification:) name:UIWindowDidBecomeHiddenNotification object:nil];
}

- (void)windowDidBecomeVisibleNotification:(id)noti
{
    
}

- (void)windowDidBecomeKeyNotification:(id)noti
{
    
}

- (void)windowDidBecomeHiddenNotification:(id)noti
{
    
}
#pragma mark - 监听事件
- (void)commonInitListenEvents
{
    //token错误
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tokenError:) name:kNotificationUserTokenError object:nil];
    
    //先去获取一下im信息
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginInRepeatRequest:) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:Noti_tryAgainGetNimAccout object:nil];
    //监听自动登录
    [[[NIMSDK sharedSDK]loginManager]addDelegate:self];;

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(changeDomain:) name:kNotificationUserChangeDomain object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(postDataToHost:) name:Noti_PostDataToHost object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 设置域名环境
- (void)setDomainManager
{
    [WYUserDefaultManager setOpenChangeDomain:NO];
    
    if (![WYUserDefaultManager getOpenChangeDomain] ||[WYUserDefaultManager getkAPP_BaseURL].length==0)
    {
        [WYUserDefaultManager setkAPP_BaseURL:@"https://api.m.microants.cn"];
        [WYUserDefaultManager setkAPP_H5URL:@"https://wykj.microants.cn"];
        [WYUserDefaultManager setkURL_WXAPPID:@"wxc8edd69b7a7950ee"];
    }
    if (![WYUserDefaultManager getOpenChangeDomain] ||[WYUserDefaultManager getkCookieDomain].length==0)
    {
        [WYUserDefaultManager setkCookieDomain:@".microants.cn"];
    }
}

#pragma mark- token错误
- (void)tokenError:(NSNotification *)notification
{
    if ([[notification.userInfo objectForKey:@"api"] isEqualToString:kNIM_getUserIMInfo])
    {
        return;
    }
    [self.window.rootViewController zx_presentLoginController];
}

- (void)changeDomain:(NSNotification *)notification
{
    [self registerGetuiAndRemoteNotification];
    [self initNIMSDK];
    [WXApi registerApp:[WYUserDefaultManager getkURL_WXAPPID]];
    [WYTIMEMANAGER removeLastAppStartEventTime];
}



#pragma mark -云信初始化 及自动登陆／不要忘了切换推送证书

- (void)initNIMSDK
{
    NSString *cerName =[WYUserDefaultManager getOpenChangeDomain]?[WYUserDefaultManager getTestNiMCerName]:[WYUserDefaultManager getOnlineNiMCerName];
    //  也可以使用registerWithOption:同时注册VOIP
    [[NIMSDK sharedSDK] registerWithAppID:@"84754c46dc41ff1fa0f099705c5e9e79" cerName:cerName];
    [[NIMSDK sharedSDK]enableConsoleLog];
    
    //可以设置SDK根目录，消息本地数据目录
    NIMSDKConfig *nimSDKConfig = [NIMSDKConfig sharedConfig];
    //是否在收到消息后自动下载附件 (群和个人)
    nimSDKConfig.fetchAttachmentAutomaticallyAfterReceiving = YES;
    //是否需要将被撤回的消息计入未读计算考虑
    nimSDKConfig.shouldConsiderRevokedMessageUnreadCount = NO;
    nimSDKConfig.shouldSyncUnreadCount = YES;
    //是否开启 Https 支持
//    nimSDKConfig.enabledHttps = YES;
    //我们认为消息，包括图片，视频，音频信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 HTTPS 支持，将原本 HTTP URL 转化成可用的 HTTPS URL 。
    //如果开发者需要将这些信息都托管在自己的服务器上，需要设置这个接口为 NO;转变NO；
    nimSDKConfig.enabledHttpsForInfo = NO;
    //在默认情况下，我们认为消息，包括图片，视频，音频信息都是默认托管在云信上，所以 SDK 会针对他们自动开启 https 支持。
    nimSDKConfig.enabledHttpsForMessage = YES;
    //是否支持动图缩略;默认NO；
//    nimSDKConfig.animatedImageThumbnailEnabled = YES;
    //配置项委托；自定义配置项
    self.sdkConfigDelegate = [[NTESSDKConfigDelegate alloc] init];
    nimSDKConfig.delegate = self.sdkConfigDelegate;
    [[NIMSDK sharedSDK].chatManager addDelegate:self];
//    [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
//    [[NIMSDK sharedSDK].apnsManager addDelegate:self];
    [self niMLogin];
    //需要自定义消息时使用
    [NIMCustomObject registerCustomDecoder:[[NTESAttachmentDecoder alloc]init]];
    //注入 NIMKit 布局管理器
    NIMKit *nimKit = [NIMKit sharedKit];
    [nimKit registerLayoutConfig:[NTESCellLayoutConfig new]];
 
}


//先自动登录
- (void)niMLogin
{
    if (ISLOGIN)
    {
        NSString *account =[WYUserDefaultManager getNimAccid];
        NSString *token   = [WYUserDefaultManager getNimPWD];
        
        // 启动APP如果已经保存了用户帐号和令牌,建议使用这个登录方式,使用这种方式可以在无网络时直接打开会话窗口
        if ([account length] && [token length])
        {
            //也可以使用autoLogin:(NIMAutoLoginData *)loginData强制登录模式，挤掉之前的登录；
            [[[NIMSDK sharedSDK]loginManager]autoLogin:account token:token];
        }
        else
        {
            [self loginInRepeatRequest:nil];
        }
    }
}

#pragma mark - app登陆后，云信登陆处理，手动登陆；

- (void)loginIn:(id)notification
{
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getNimAccountAPI]getNIMUserIMInfoWithSuccess:^(id data) {
        [WYUserDefaultManager setNimAccid:[data objectForKey:@"accid"]];
        [WYUserDefaultManager setNimPWD:[data objectForKey:@"pwd"]];
        [WYUserDefaultManager setNiMMyInfoUrl:[data objectForKey:@"url"]];
        [weakSelf loginNIM];
        [[WYNIMAccoutManager shareInstance] resetCurrentNIMAccoutNormal];

        
    } failure:^(NSError *error) {
        
        NSString *codeString = [error.userInfo objectForKey:@"code"];
//        您的聊天功能无法使用，请联系客服。
        if ([codeString isEqualToString:@"im_netease_get_iminfo_failed_disp4from"])
        {
            [[WYNIMAccoutManager shareInstance]setupCurrentNIMAccoutLoginFailedErrorCode:NIMRemoteErrorCodeUserNotExist];
        }
//        您已被禁言，如有疑问请联系客服。
        if ([codeString isEqualToString:@"im_netease_get_iminfo_block_disp4from"])
        {
              [[WYNIMAccoutManager shareInstance]setupCurrentNIMAccoutLoginFailedErrorCode:NIMRemoteErrorAccountBlock];
        }
        _nimRequestTimes--;
        if (_nimRequestTimes>0)
        {
            [weakSelf performSelector:@selector(loginIn:) withObject:nil afterDelay:5.f];
        }

    }];
        
}

- (void)loginInRepeatRequest:(id)notification
{
    _nimRequestTimes = 3;
    [self loginIn:nil];

    
}

- (void)loginNIM
{
//    dev_im_1016122511028649984
    NSString *loginAccount =[WYUserDefaultManager getNimAccid];
    NSString *loginToken   = [WYUserDefaultManager getNimPWD];

    [[[NIMSDK sharedSDK]loginManager]login:loginAccount token:loginToken completion:^(NSError * _Nullable error) {
        if (error ==nil)
        {
            NSLog(@"登陆云信成功:");
            NSString *account =  [[[NIMSDK sharedSDK]loginManager]currentAccount];
            NSLog(@"%@",account);
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
        }
        else
        {
            NSLog(@"登陆云信失败:");
        }
    }];
}

#pragma mark - app退出后，注销NIM登陆；


- (void)loginOut:(id)notification
{
    /**
     *  登出
     *
     *  @param completion 完成回调
     *  @discussion 用户在登出是需要调用这个接口进行 SDK 相关数据的清理,回调 Block 中的 error 只是指明和服务器的交互流程中可能出现的错误,但不影响后续的流程。
     *              如用户登出时发生网络错误导致服务器没有收到登出请求，客户端仍可以登出(切换界面，清理数据等)，但会出现推送信息仍旧会发到当前手机的问题。
     */
    [[WYNIMAccoutManager shareInstance]resetCurrentNIMAccoutNormal];
    [[[NIMSDK sharedSDK]loginManager]logout:^(NSError * _Nullable error) {
       
        [UserDefault removeObjectForKey:@"accid"];
        [UserDefault removeObjectForKey:@"nimPwd"];
        [UserDefault removeObjectForKey:@"nimMyInfo"];
    }];
}

# pragma  mark - NIMLoginManagerDelegate

-(void)onKick:(NIMKickReason)code clientType:(NIMLoginClientType)clientType
{
//    NSString *reason = @"你被踢下线";
    switch (code) {
        case NIMKickReasonByClient:
        case NIMKickReasonByClientManually:{
//            NSString *clientName = [NTESClientUtil clientName:clientType];
//            reason = clientName.length ? [NSString stringWithFormat:@"你的帐号被%@端踢出下线，请注意帐号信息安全",clientName] : @"你的帐号被踢出下线，请注意帐号信息安全";
            break;
        }
        case NIMKickReasonByServer:
//            reason = @"你被服务器踢下线";
            [[WYNIMAccoutManager shareInstance]setupCurrentNIMAccoutLoginFailedErrorCode:NIMRemoteErrorAccountBlock];
            //帐号被踢禁言了
            [[NSNotificationCenter defaultCenter]postNotificationName:kNotificationAccountBlock object:nil];
            break;
        default:
            break;
    }
    
//    [[[NIMSDK sharedSDK] loginManager] logout:^(NSError *error) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:NTESNotificationLogout object:nil];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"下线通知" message:reason delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//    }];
    NSLog(@"你被踢下线");
}

/**
 *  登录退出回调
 *
 *  @param step 登录步骤
 *  @discussion 这个回调主要用于客户端UI的刷新
 */

- (void)onLogin:(NIMLoginStep)step
{
    if (step == NIMLoginStepLoginOK)
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
    }
}

/**
 *  自动登录失败回调
 *
 *  @param error 失败原因
 *  @discussion 自动重连不需要上层开发关心，但是如果发生一些需要上层开发处理的错误，SDK 会通过这个方法回调
 *              用户需要处理的情况包括：AppKey 未被设置，参数错误，密码错误，多端登录冲突，账号被封禁，操作过于频繁等
 */

- (void)onAutoLoginFailed:(NSError *)error
{
    NSLog(@"自动登录失败回调，查看是否有密码错误：%@，errorCode:%ld",[error localizedDescription],error.code);
    if (error.code == NIMRemoteErrorCodeExist)
    {
        [self loginNIM];
    }
    else if (error.code ==NIMRemoteErrorAccountBlock)
    {
        [[WYNIMAccoutManager shareInstance]setupCurrentNIMAccoutLoginFailedErrorCode:NIMRemoteErrorAccountBlock];
    }
    else if (error.code ==NIMRemoteErrorCodeUserNotExist)
    {
        [[WYNIMAccoutManager shareInstance]setupCurrentNIMAccoutLoginFailedErrorCode:NIMRemoteErrorCodeUserNotExist];
    }
}


- (void)onRecvMessages:(NSArray<NIMMessage *> *)messages
{
    NIMMessage *message =[messages lastObject];
    NSLog(@"%@,%@",message.senderName,message.text);
    NSString *loginAccount =[WYUserDefaultManager getNimAccid];
    if (![message.from isEqualToString:loginAccount])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Push_Message object:message];
    }
}
//#pragma mark - NIMSystemNotificationManagerDelegate
//
//- (void)onReceiveSystemNotification:(NIMSystemNotification *)notification
//{
//
//}
//
//- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
//{
//
//}

#pragma mark - 个推，个推能重新注册

- (void)registerGetuiAndRemoteNotification
{
    //通过个推平台分配的appId、 appKey 、appSecret 启动SDK，注：该方法需要在主线程中调用
    NSString *geAppId = [WYUserDefaultManager getOpenChangeDomain]?kTestGtAppId:kOnlineGtAppId;
    NSString *geAppSecret = [WYUserDefaultManager getOpenChangeDomain]?kTestGtAppSecret:kOnlineGtAppSecret;
    NSString *geAppKey = [WYUserDefaultManager getOpenChangeDomain]?kTestGtAppKey:kOnlineGtAppKey;

    [GeTuiSdk startSdkWithAppId:geAppId appKey:geAppKey appSecret:geAppSecret delegate:self];
    //注册 APNs
    [self registerRemoteNotification];
}



/** 注册 APNs */
- (void)registerRemoteNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        // Xcode 8编译会调用
        #if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = self;
        [center requestAuthorizationWithOptions:(UNAuthorizationOptionBadge | UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionCarPlay) completionHandler:^(BOOL granted, NSError *_Nullable error) {
            if (!error)
            {
                NSLog(@"request authorization succeeded!");
            }
        }];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        // Xcode 7编译会调用
        #else
        
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
        #endif
    }
    else if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        UIUserNotificationType types = (UIUserNotificationTypeAlert | UIUserNotificationTypeSound | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }
}


#pragma mark - addAvoidCrash

- (void)addAvoidCrash
{
    if (![WYUserDefaultManager getOpenChangeDomain])
    {
        [AvoidCrash becomeEffective];
        //监听通知:AvoidCrashNotification, 获取AvoidCrash捕获的崩溃日志的详细信息
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dealwithCrashMessage:) name:AvoidCrashNotification object:nil];
//        [NSArray avoidCrashExchangeMethod];
//        [NSMutableArray avoidCrashExchangeMethod];
    }
}

- (void)dealwithCrashMessage:(NSNotification *)note {
    //注意:所有的信息都在userInfo中
    //你可以在这里收集相应的崩溃信息进行相应的处理(比如传到自己服务器)
    NSLog(@"%@",note.userInfo);
}

#pragma mark - 3D-Touch
- (void)set3DTouch
{
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        if (self.window.traitCollection.forceTouchCapability ==UIForceTouchCapabilityAvailable)
        {
            NSString *htmlUrl = [[LocalHtmlStringManager shareInstance]getYcbPurchaseFormURL];
            if ([NSString zhIsBlankString:htmlUrl])
            {
                return;
            }
            UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"type_qiuGou" localizedTitle:NSLocalizedString(@"发布求购", nil) localizedSubtitle:nil icon:icon userInfo:nil];
            [UIApplication sharedApplication].shortcutItems = @[item];

        }
        else if (self.window.traitCollection.forceTouchCapability ==UIForceTouchCapabilityUnknown)
        {
            
        }
        else if (self.window.traitCollection.forceTouchCapability ==UIForceTouchCapabilityUnavailable)
        {
            
        }
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler
{
    if ([shortcutItem.type isEqualToString:@"type_qiuGou"])
    {
        [MobClick event:kUM_b_inquiry];
        NSString *htmlUrl = [[LocalHtmlStringManager shareInstance]getYcbPurchaseFormURL];
        if ([NSString zhIsBlankString:htmlUrl])
        {
            return;
        }
        if (![self.window.rootViewController isKindOfClass:[UITabBarController class]])
        {
            [WYUserDefaultManager setDidFinishLaunchRemoteNoti:htmlUrl];
        }
        else
        {
            UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
            UINavigationController *firstNav = tabBarController.selectedViewController;
            [[WYUtility dataUtil]routerWithName:htmlUrl withSoureController:firstNav.topViewController];
        }
    }
}

#pragma mark - appDelegate

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

//
- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.    
    BOOL interval = [[WYTimeManager shareTimeManager]isLastAppStartEventEqualMore_30min];
    if(interval)
    {
        if ([APP_MainWindow.rootViewController isKindOfClass:[UITabBarController class]])
        {
            UITabBarController *tab = (UITabBarController *)APP_MainWindow.rootViewController;
            EventViewController *vc = [[EventViewController alloc] init];
            [tab addChildViewController:vc];
            [tab.view addSubview:vc.view];
        }
    }
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    NSLog(@"===============DidBecomeActive================");
    //下载开屏广告图
    [self downEventImage];
    //设置推送红点取消
    //1.设置本地推送
    UILocalNotification *localNote = [[UILocalNotification alloc] init];
    localNote.applicationIconBadgeNumber = -1;
    [[UIApplication sharedApplication] scheduleLocalNotification:localNote];
    [[UIApplication sharedApplication] cancelLocalNotification:localNote];
    
    //更新未读消息数量；如果有新消息；
    if ([WYTabBarViewController sharedInstance])
    {
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
    }
}


- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings
{
    NSLog(@"注册用户通知成功回调");
}


- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSString *token = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    token = [token stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSLog(@"\n>>>[DeviceToken Success]:%@\n\n", token);
    [UserInfoUDManager setRemoteNotiDeviceToken:token];
    // 向个推服务器注册deviceToken
    [GeTuiSdk registerDeviceToken:token];
    //更新云信APNS的设备token
    [[NIMSDK sharedSDK]updateApnsToken:deviceToken];
}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"注册远程推送通知的设备token失败");
}


- (void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // Background Fetch 恢复SDK 运行
    [GeTuiSdk resume];
    completionHandler(UIBackgroundFetchResultNewData);
}


//iOS10以前接收推送通知的回调
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    // 将收到的APNs信息传给个推统计
    [GeTuiSdk handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    //程序当前正处于前台不做处理-因为会从透传处理
    if (application.applicationState == UIApplicationStateActive)
    {
        NSLog(@"active");
    }
    //程序处于非激活状态，推送后台跳转
    else if(application.applicationState == UIApplicationStateInactive)
    {
        [GeTuiSdk setBadge:0];
        [self jumpPage:userInfo];
    }
}


//对于iOS 10 及以后版本，处理 APNs 通知点击
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

//  iOS 10: App在前台获取到通知；
- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_Message_unreadCount object:nil];
    completionHandler(UNNotificationPresentationOptionBadge | UNNotificationPresentationOptionSound | UNNotificationPresentationOptionAlert);
}

//  iOS 10: 点击通知进入App时触发，在该方法内统计有效用户点击数
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler
{
    NSLog(@"didReceiveNotification：%@", response.notification.request.content.userInfo);
    [GeTuiSdk handleRemoteNotification:response.notification.request.content.userInfo];
    completionHandler();
    [GeTuiSdk setBadge:0];
    NSDictionary *dic = response.notification.request.content.userInfo;
    [self jumpPage:dic];
}


#endif


#pragma mark - 个推回调

//个推高级功能 接收个推通道下发的透传消息/处理内容
// SDK收到透传消息回调
- (void)GeTuiSdkDidReceivePayloadData:(NSData *)payloadData andTaskId:(NSString *)taskId andMsgId:(NSString *)msgId andOffLine:(BOOL)offLine fromGtAppId:(NSString *)appId {
    //收到个推消息
    NSString *payloadMsg = nil;
    if (payloadData) {
        payloadMsg = [[NSString alloc] initWithBytes:payloadData.bytes length:payloadData.length encoding:NSUTF8StringEncoding];
    }
    
    NSString *msg = [NSString stringWithFormat:@"taskId=%@,messageId:%@,payloadMsg:%@%@",taskId,msgId, payloadMsg,offLine ? @"<离线消息>" : @""];
    NSLog(@"\n>>>[GexinSdk ReceivePayload]:%@\n\n", msg);
    
    
    NSData *jsonData = [payloadMsg dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:nil];
    
    //做判断
    if ([WYTabBarViewController sharedInstance])
    {
        NSString *type = [[dic objectForKey:@"extra"] objectForKey:@"type"];
        if ([type isEqualToString:@"1"])
        {
            if (!offLine && [[[NSUserDefaults standardUserDefaults] objectForKey:EnableSubject] boolValue])
            {
                [WYUtility AudioCustomSoundName:@"haikui"];
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Trade_Push_NewTrades object:nil];//通知请求系统推荐数
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_ShopIcon_Red object:nil];
        }
        //粉丝2访客3订单4
        if ([type isEqualToString:@"2"]||[type isEqualToString:@"3"]||[type isEqualToString:@"4"])
        {
            if (!offLine)
            {
                NSLog(@"%@-----------------------",[[NSUserDefaults standardUserDefaults] objectForKey:EnableFan]);
                if ([type isEqualToString:@"2"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:EnableFan] boolValue])
                {
                    [WYUtility AudioCustomSoundName:@"favor"];
                }
                if ([type isEqualToString:@"3"]&&[[[NSUserDefaults standardUserDefaults] objectForKey:EnableVisitor] boolValue])
                {
                    [WYUtility AudioCustomSoundName:@"visitor"];
                }
            }
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_ShopIcon_Red object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Shop_ReceiveNewFansOrVisitors object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Shop_ReceiveNewOrder object:nil];

        }
    }
    [GeTuiSdk setBadge:0];
    
}


/** SDK启动成功返回cid */
- (void)GeTuiSdkDidRegisterClient:(NSString *)clientId {
    //个推SDK已注册，返回clientId
    NSLog(@"%@",clientId);
    [[NSUserDefaults standardUserDefaults] setObject:clientId forKey:ud_GTClientId];
    [self postDataToHost:nil];
}



- (void)postDataToHost:(id)notification
{
    NSInteger userNotificationOpenType = [WYUserDefaultManager getMyAppUserNotificationOpenType];

    NSString *clientId = [UserInfoUDManager getClientId];
    NSString *deviceToken = [UserInfoUDManager getRemoteNotiDeviceToken];
    if (clientId && deviceToken && userNotificationOpenType !=UDAuthorizationStatusNotDetermined)
    {
        NSDictionary *dic = @{
                              @"roleType":@([WYUserDefaultManager getUserTargetRoleType]),
                              @"type":@"0",
                              @"token":deviceToken,
                              @"systemVersion": CurrentSystemVersion,
                              @"clientId":clientId,
                              @"appSourceType":@"1",
                              @"appVersion":kAppVersion,
                              @"did":[[UIDevice currentDevice]zx_getIDFAUUIDString],
                              @"mobileBrand":WYUTILITY.iphoneType,
                              @"mobileSetting":@(userNotificationOpenType)
                              };
        [[[AppAPIHelper shareInstance] getMessageAPI] PostDeviceInfoWithParameters:dic success:^(id data) {
            
        } failure:^(NSError *error) {
            
        }];
        
        WYTargetRoleSource source = [WYUserDefaultManager getChangeUserTargetRoleSource];
   
        [[[AppAPIHelper shareInstance]getUserModelAPI]postChangeUserRoleWithClientId:clientId source:source targetRole:[WYUserDefaultManager getUserTargetRoleType] success:^(id data) {
            
        } failure:^(NSError *error) {
            
        }];
    }

}


#pragma mark - 处理开机启动的推送

- (void)takeLaunchRemoteNoti:(NSDictionary *)launchOptions
{
    //获取 APNs（通知） 推送内容（app未启动时接受推送消息）
    //apn 内容获取
    NSDictionary *remoteDic = [launchOptions objectForKey: UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteDic)
    {
        NSString *url = nil;
        
        if ([remoteDic objectForKey:@"nim"])
        {
            url = @"microants://messageCategory";
        }
        else
        {
            if ([remoteDic objectForKey:@"payload"])
            {
                NSString *payloadStr = [remoteDic objectForKey:@"payload"];
                NSDictionary *payload = [NSString zhGetJSONSerializationObjectFormString:payloadStr];
                url = [payload objectForKey:@"url"];
            }
            else
            {
                url = [remoteDic objectForKey:@"url"];
            }
        }
        [WYUserDefaultManager setDidFinishLaunchRemoteNoti:url];
    }
}

#pragma mark - 推送跳转
-(void)jumpPage:(NSDictionary *)dic{
  
    NSString *url = nil;
    //表示是云信；给我们badge，sound，alert内容，对方用户名；
    if ([dic objectForKey:@"nim"])
    {
        url = @"microants://messageCategory";
    }
    else
    {
        NSDictionary *tempDic = nil;
        if ([dic objectForKey:@"payload"])
        {
            NSString *payloadStr = [dic objectForKey:@"payload"];
            NSDictionary *payload = [NSString zhGetJSONSerializationObjectFormString:payloadStr];
            tempDic = [NSDictionary dictionaryWithDictionary:payload];
        }
        else
        {
            tempDic = [NSDictionary dictionaryWithDictionary:dic];
        }
        url = [tempDic objectForKey:@"url"];
    }
    if (![self.window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        NSLog(@"还没有初始化TabBarController");
        return;
    }
    else
    {
        UINavigationController *firstNav = nil;
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        firstNav = tabBarController.selectedViewController;
        [[WYUtility dataUtil]routerWithName:url withSoureController:firstNav.topViewController];
    }
    
}

#pragma mark - UserNotification

- (void)isOpenUserNotification
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                [WYUserDefaultManager setMyAppUserNotificationOpenType:UDAuthorizationStatusDenied];
            }
            else
            {
                [WYUserDefaultManager setMyAppUserNotificationOpenType:UDAuthorizationStatusAuthorized];
            }
            [self postDataToHost:nil];
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [WYUserDefaultManager setMyAppUserNotificationOpenType:UDAuthorizationStatusDenied];
        }
        else
        {
            [WYUserDefaultManager setMyAppUserNotificationOpenType:UDAuthorizationStatusAuthorized];
        }
        [self postDataToHost:nil];
    }

}

/** SDK遇到错误回调 */
- (void)GeTuiSdkDidOccurError:(NSError *)error {
    //个推错误报告，集成步骤发生的任何错误都在这里通知，如果集成后，无法正常收到消息，查看这里的通知。
    NSLog(@"\n>>>[GexinSdk error]:%@\n\n", [error localizedDescription]);
}


#pragma mark - openURL:


- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options NS_AVAILABLE_IOS(9_0)
{
    return [self customAppByCallbackHandleOpenURL:url];
}



//第三方app回调本app
- (BOOL)customAppByCallbackHandleOpenURL:(NSURL *)url
{
    NSLog(@"%@",url);
    if ([url.host isEqualToString:@"safepay"])
    {
        // app支付：处理支付宝客户端返回的url（在app被杀模式下，通过这个方法获取支付结果）。
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic)
         {
              [[NSNotificationCenter defaultCenter] postNotificationName:Noti_PaymentResult_WYChoosePayWayViewController object:@"Alipay" userInfo:resultDic];
             NSLog(@"result = %@",resultDic);
         }];
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic)
         {
             NSLog(@"result = %@",resultDic);
             // 解析 auth code
             NSString *result = resultDic[@"result"];
             NSString *authCode = nil;
             if (result.length>0) {
                 NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                 for (NSString *subResult in resultArr) {
                     if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                         authCode = [subResult substringFromIndex:10];
                         break;
                     }
                 }
             }
             NSLog(@"授权结果 authCode = %@", authCode?:@"");
         }];
        return YES;
    }
    else if ([url.scheme isEqualToString:@"yicaibao"])
    {
        if ([url.host isEqualToString:@"businessDetail"])
        {
            [self activityRouterWithOpenURL:url];
        }
        self.appActiveFromType =AppActiveFromType_background;
        return YES;
    }
    return [WXApi handleOpenURL:url delegate:self];
}
#pragma mark - UserActivity

- (BOOL)application:(UIApplication *)application willContinueUserActivityWithType:(NSString *)userActivityType
{
    NSLog(@"willContinueUserActivity");
    return YES;
}

- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
{
    if ([userActivity.activityType isEqualToString:NSUserActivityTypeBrowsingWeb])
    {
//      @"https://wykj.microants.cn/ycb/page/purchaseDetailShareYsb.html?id=1837254085483823401"
        NSURL *webpageURL = userActivity.webpageURL;
        NSURL *myURL = [NSURL URLWithString:[WYUserDefaultManager getkAPP_H5URL]];
//       处理自己公司域名的H5页面跳转
        if ([webpageURL.host isEqualToString:myURL.host])
        {
            if ([webpageURL.path isEqualToString:@"/ycb/page/purchaseDetailShareYsb.html"])
            {
                [self activityRouterWithOpenURL:webpageURL];
            }
        }
        else
        {
            if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication]openURL:webpageURL options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(YES)} completionHandler:^(BOOL success) {
                    if (success)
                    {
                        NSLog(@"success");
                    }
                }];
            }
        }
    }
    self.appActiveFromType =AppActiveFromType_background;
    return YES;
}

- (void)activityRouterWithOpenURL:(NSURL *)openUrl
{
    NSURLComponents *components = [[NSURLComponents alloc] initWithString:openUrl.absoluteString];
    NSString *tradeId = [components zhObjectForKey:@"id"];
    NSString *tradeUrl = [NSString stringWithFormat:@"microants://businessDetail?id=%@",tradeId];
    if (self.appActiveFromType ==AppActiveFromType_finishLaunch)
    {
        [WYUserDefaultManager setDidFinishLaunchRemoteNoti:tradeUrl];
    }
    else
    {
        UITabBarController *tabBarController = (UITabBarController *)self.window.rootViewController;
        UINavigationController *firstNav = tabBarController.selectedViewController;
        [[WYUtility dataUtil]routerWithName:tradeUrl withSoureController:firstNav.topViewController];
    }
}

- (void)application:(UIApplication *)application didFailToContinueUserActivityWithType:(NSString *)userActivityType error:(NSError *)error
{
    NSLog(@"didFailToContinueUserActivity");
}

- (void)application:(UIApplication *)application didUpdateUserActivity:(NSUserActivity *)userActivity
{
    NSLog(@"didUpdateUserActivity:");
}

#pragma mark - 微信回调

/*! 微信回调，不管是登录还是分享成功与否，都是走这个方法 @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * resp具体的回应内容，是自动释放的
 */


-(void) onResp:(BaseResp*)resp{
    NSLog(@"resp %d",resp.errCode);
    
    /*
     enum  WXErrCode {
     WXSuccess           = 0,    成功
     WXErrCodeCommon     = -1,  普通错误类型
     WXErrCodeUserCancel = -2,    用户点击取消并返回
     WXErrCodeSentFail   = -3,   发送失败
     WXErrCodeAuthDeny   = -4,    授权失败
     WXErrCodeUnsupport  = -5,   微信不支持
     };
     */
    if ([resp isKindOfClass:[SendAuthResp class]]) {   //授权登录的类。
        if (resp.errCode == 0) {  //成功。
            //这里处理回调的方法 。 通过代理吧对应的登录消息传送过去。
            if ([_wxDelegate respondsToSelector:@selector(loginSuccessByCode:)]) {
                SendAuthResp *resp2 = (SendAuthResp *)resp;
                [_wxDelegate loginSuccessByCode:resp2.code];
            }
        }else{ //失败
            NSLog(@"error %@",resp.errStr);
            [self.window.rootViewController zhHUD_showErrorWithStatus:@"微信授权失败"];
            //            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"登录失败" message:[NSString stringWithFormat:@"reason : %@",resp.errStr] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            //            [alert show];
        }
    }else if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_PaymentResult_WYChoosePayWayViewController object:@"Wechatpay" userInfo:@{@"code":@(response.errCode)}];
    }
}

#pragma mark - 第一次安装app开屏引导页
-(void)startFirst{
    
    EventViewController *vc = [[EventViewController alloc] init];
    
    NSArray* aimage = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",nil];
    [WYIntroduceViewController guideFigureWithImages:aimage NowGotoImage:nil SelectIdentityImage:nil finishWithRootController:vc];
}


#pragma mark - 下载loading图片
-(void)downEventImage{
    //上次下载时间
    NSDate *lastDownloadImageDate = [[WYTimeManager shareTimeManager]getLastTimeAppStartEvent];
    BOOL interval = [[WYTimeManager shareTimeManager]isLastAppStartEventEqualMore_30min];
    
    if(interval || !lastDownloadImageDate)
    {
        //移除图片
        NSFileManager *manager = [NSFileManager defaultManager];
        [manager removeItemAtPath:kImageBusinessPath error:nil];
        [manager removeItemAtPath:kImageBuyerPath error:nil];
        [self requestStartAppSellerAdvImage];
        [self requestStartAppPurchaserAdvImage];
    }
}

- (void)requestStartAppSellerAdvImage
{
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    //商家
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1002 success:^(id data) {
        AdvModel *model = data;
        advArrModel *arrModel = model.advArr[0];
        if (arrModel.pic.length>0)
        {
            NSLog(@"advPic =%@",arrModel.pic);
            NSURL *url =  [NSURL URLWithString:arrModel.pic];
            [sdManager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                [WYUserDefaultManager setOpenAPPSellerAdvURL:arrModel.pic];
                [[NSUserDefaults standardUserDefaults] setObject:arrModel.url forKey:kImageBusinessUrl];
                [[NSUserDefaults standardUserDefaults] setObject:arrModel.iid forKey:kImageBusinessUrl_ID];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[WYTimeManager shareTimeManager]setCurryTimeToLastAppStartEvent];
            }];
        }
        else
        {
            [WYUserDefaultManager removeOpenAPPSellerAdvURL];
            [[SDImageCache sharedImageCache]removeImageForKey:[WYUserDefaultManager getOpenAPPSellerAdvURL] withCompletion:nil];
            [[WYTimeManager shareTimeManager]setCurryTimeToLastAppStartEvent];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kImageBusinessUrl];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kImageBusinessUrl_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    } failure:^(NSError *error) {
    }];
}
- (void)requestStartAppPurchaserAdvImage
{
    //采购
    SDWebImageManager *sdManager = [SDWebImageManager sharedManager];
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@2005 success:^(id data) {
        AdvModel *model = data;
        advArrModel *arrModel = model.advArr[0];
        if (arrModel.pic.length>0) {
            
            NSURL *url =  [NSURL URLWithString:arrModel.pic];
            [sdManager loadImageWithURL:url options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
                
                
            } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                
                [[NSUserDefaults standardUserDefaults] setObject:arrModel.url forKey:kImageBuyerUrl];
                [[NSUserDefaults standardUserDefaults] setObject:arrModel.iid forKey:kImageBuyerUrl_ID];
                [WYUserDefaultManager setOpenAPPPurchaserAdvURL:arrModel.pic];
                [[NSUserDefaults standardUserDefaults] synchronize];
            }];
        }else{
            //移除图片
            [[SDImageCache sharedImageCache]removeImageForKey:[WYUserDefaultManager getOpenAPPPurchaserAdvURL] withCompletion:nil];
            [WYUserDefaultManager removeOpenAPPPurchaserAdvURL];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kImageBuyerUrl];
            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:kImageBuyerUrl_ID];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }
    } failure:^(NSError *error) {
    }];
}

#pragma mark - 科大讯飞语音-
-(void)initIFlyMSC
{
    //设置sdk的log等级，log保存在下面设置的工作路径中
    [IFlySetting setLogFile:LVL_ALL];
    
    //打开输出在console的log开关
    [IFlySetting showLogcat:NO];
    
    //设置sdk的工作路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *cachePath = [paths objectAtIndex:0];
    [IFlySetting setLogFilePath:cachePath];
    
    //创建语音配置,appid必须要传入，仅执行一次则可
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",APPID_VALUE];
    
    //所有服务启动前，需要确保执行createUtility
    [IFlySpeechUtility createUtility:initString];

}


- (void)requestLocalHtmlStringManagers
{
    [[LocalHtmlStringManager shareInstance]registerLocalHtmlStringManagers];
}
@end
