//
//  WYTabBarViewController.m
//  YiShangbao
//
//  Created by Lance on 16/12/7.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYTabBarViewController.h"

#import "AppDelegate.h"

#import "WYMainViewController.h"
#import "WYMessagePushView.h"
// iOS10 及以上需导入 UserNotifications.framework
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif
#import <WebKit/WebKit.h>



@interface WYTabBarViewController ()<UITabBarControllerDelegate>
@property(nonatomic, weak)WYMessagePushView *messagePushView; //weak

@end

@implementation WYTabBarViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setViewControllers];
}

+ (instancetype)sharedInstance
{
    AppDelegate *delegete = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *vc = delegete.window.rootViewController;
    if ([vc isKindOfClass:[WYTabBarViewController class]]) {
        return (WYTabBarViewController *)vc;
    }else{
        return nil;
    }
}

- (void)setViewControllers
{
    NSMutableArray *vcs=[NSMutableArray array];//创建一个数组来保存controller对象
    NSArray *sbNameArray = @[storyboard_ShopStore,@"Main",@"Main",@"Main"];
    NSArray *sbIdArray = @[SBID_StoryboardInital_Shop,SBID_StoryboardInital_Message,SBID_StoryboardInital_FuWu,SBID_StoryboardInital_Mine];
    for (int i =0; i<sbNameArray.count; i++)
    {
        UIStoryboard *sb=[UIStoryboard  storyboardWithName:sbNameArray[i] bundle:[NSBundle mainBundle]];
        UIViewController *vc=[sb instantiateViewControllerWithIdentifier:sbIdArray[i]];//根据storyboard和controller的storeId找到控制器
        vc.tabBarItem = [[self.viewControllers objectAtIndex:i]tabBarItem];
        [vcs addObject:vc];
    }
    
    [self setViewControllers:vcs animated:NO];//用当前的viewController(UINavigationController)数组替换原本的tabbarControlle的 viewControllers(UINavigationController)数组
    
    self.delegate = self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

//    UITabBarController *tb =[[self storyboard] instantiateInitialViewController];
    


    [self initTabBar];
    [self setApperanceForSigleNavController];
    [self setApperanceForAllController];
    
    [self addNoticationCenter];
    
    [self requestNewFansAndVisitor];
    [self updateMessageBadge:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


#pragma mark-
//设置基本数据
- (void)setApperanceForSigleNavController
{
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

         [obj xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
         [obj xm_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];

    }];
}


//设置基本数据
- (void)setApperanceForAllController
{
    [UIViewController xm_navigationBar_appearance_backgroundImageName:nil ShadowImageName:nil orBackgroundColor:[UIColor whiteColor] titleColor:UIColorFromRGB_HexValue(0x222222) titleFont:[UIFont boldSystemFontOfSize:17.f]];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateHighlighted];

    
    [UIViewController xm_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle];
    
    [[UIButton appearance]setExclusiveTouch:YES];
    
//    UIImage *backImage = [UIImage zh_imageWithColor:[UIColor orangeColor] andSize:CGSizeMake(10, 10)];
//    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}


- (void)initTabBar
{
    NSArray *imgSelectArray = @[@"toolbar_shangpu_sel",@"toolbar_message_sel",@"toolbar_fuwu-sel",@"toolbar_myCenter_sel"];
    NSArray *imgArray = @[@"toolbar_shangpu-nor",@"toolbar_message",@"toolbar_fuwu-nor",@"toolbar_myCenter_nor"];

    [self xm_tabBarController_tabBarItem_ImageArray:imgArray selectImages:imgSelectArray slectedItemTintColor:nil unselectedItemTintColor:nil];
    self.tabBar.translucent = NO;
    UIImage *tabImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xFAFAFA) andSize:self.tabBar.frame.size];
    self.tabBar.backgroundImage = tabImage;
    UIImage *shadowImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xD8D8D8) andSize:CGSizeMake(self.tabBar.frame.size.width, 0.5)];
    self.tabBar.shadowImage = shadowImage;
}

#pragma  mark - tabBarController

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
//    UINavigationController *shopNav = [tabBarController.viewControllers objectAtIndex:shopTabIndex];
    UINavigationController *messageNav = [tabBarController.viewControllers objectAtIndex:messageTabIndex];

//    if ([shopNav isEqual:viewController] && ![UserInfoUDManager isOpenShop])
//    {
//        if (!ISLOGIN)
//        {
//            UINavigationController *nav =tabBarController.selectedViewController;
//            [nav.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_OpenShopController withData:nil];
//            return NO;
//        }
//        else
//        {
//            WS(weakSelf);
//            __block BOOL openShop = NO;
//            [[[AppAPIHelper shareInstance] getShopAPI] getSynchronousShopIdWithSuccess:^(id data) {
//                [UserInfoUDManager setShopId:data];
//                openShop = data?YES:NO;
//            } failure:^(NSError *error) {
//
//                [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//            }];
//            if (openShop)
//            {
//                return YES;
//            }
//            UINavigationController *nav =tabBarController.selectedViewController;
//            [nav.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_OpenShopController withData:nil];
//            return NO;
//        }
//
//    }
    if ([messageNav isEqual:viewController] && ![self xm_performIsLoginActionWithPopAlertView:NO])
    {
        return NO;
    }
    return YES;
}



- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    [self updateMessageBadge:nil];
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.viewControllers.count>1)
    {
        [nav popToRootViewControllerAnimated:NO];
    }
    
    else if (tabBarController.selectedIndex ==shopTabIndex)
    {
        [MobClick event:kUM_Shops];
    }
    else if (tabBarController.selectedIndex ==messageTabIndex)
    {
        [MobClick event:kUM_b_toolbarmessage];
    }
    else if (tabBarController.selectedIndex ==fuWuTabIndex)
    {
        [MobClick event:kUM_Service];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_WYServiceViewController object:nil];
    }
    else if (tabBarController.selectedIndex ==mineTabIndex)
    {
        [MobClick event:kUM_b_mine];
    }
}

//添加通知中心
-(void)addNoticationCenter
{
    //设置商铺icon
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(setShopStoreTabBarItemWithRedDot:) name:Noti_TabBarItem_ShopIcon_Red object:nil];
    //重置商铺icon
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(resetShopStoreTabBarItem:) name:Noti_TabBarItem_ShopIcon_None object:nil];
    //消息未读数更新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateMessageBadge:) name:Noti_TabBarItem_Message_unreadCount object:nil];
    //收到消息内部弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessagePush:) name:Noti_Push_Message object:nil];
}


-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



#pragma mark - 检查新访客／粉丝
- (void)requestNewFansAndVisitor
{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    WS(weakSelf);
    [ProductMdoleAPI getCheckNewFansAndVisitorsWithSuccess:^(BOOL fansAdd, BOOL visitorsAdd, BOOL newOrderAdd, BOOL newBizAdd) {
        
        //如果有粉丝／访客
        if (fansAdd ||visitorsAdd || newOrderAdd|| newBizAdd)
        {
            [weakSelf setShopStoreTabBarItemWithRedDot:nil];
        }
        else
        {
            [weakSelf resetShopStoreTabBarItem:nil];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

//系统消息未读数量
- (void)updateMessageBadge:(id)notification
{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    if (self.viewControllers.count<=messageTabIndex)
    {
        return;
    }
    UITabBarItem *barItem = [[self.viewControllers objectAtIndex:messageTabIndex]tabBarItem];

    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
//        NSLog(@"%@",data);
        NSNumber *trade = [data objectForKey:@"trade"];
        NSNumber *todo = [data objectForKey:@"todo"];
        
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *market =  [data objectForKey:@"market"];
//        活动咨询-卖家/买家
        NSNumber *antsteam =  [data objectForKey:@"antsteam"];
//        大学-卖家
        NSNumber *ycbschool =  [data objectForKey:@"ycbschool"];
//        推广动态-卖家
        NSNumber *antsnews =  [data objectForKey:@"antsnews"];
        
        NSInteger total =[system integerValue]+[market integerValue]+[trade integerValue] +[todo integerValue] +antsteam.integerValue+ycbschool.integerValue+antsnews.integerValue;
        NSLog(@"system=%@,market=%@,total=%@",system,market,@(total));
        NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
        NSInteger badgeValue = nimValue +total;
        if (badgeValue>0)
        {
            barItem.badgeValue = [NSString stringWithFormat:@"%@",badgeValue>99?@"99+":@(badgeValue)];
        }
        else
        {
            barItem.badgeValue = nil;
        }
        
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            barItem.badgeValue = [NSString stringWithFormat:@"%@",nimValue>99?@"99+":@(nimValue)];
        }
        
    }];
}
#pragma mark - 登陆
//登陆的时候需要重新检查粉丝／访客，刷新数据；
- (void)loginIn:(id)notification
{
    [self requestNewFansAndVisitor];
    [self updateMessageBadge:nil];
}

- (void)loginOut:(id)notification
{
    [self resetShopStoreTabBarItem:nil];
    if (self.viewControllers.count<=messageTabIndex)
    {
        return;
    }
    UITabBarItem *barItem = [[self.viewControllers objectAtIndex:messageTabIndex]tabBarItem];
    barItem.badgeValue = nil;
}

#pragma mark - 商铺TabBarItem_Icon设置
//重置tabBarItem图片
- (void)resetShopStoreTabBarItem:(NSNotification*)noti
{
    if (self.viewControllers.count<=shopTabIndex)
    {
        return;
    }
    UITabBarItem *barItem = [[self.viewControllers objectAtIndex:shopTabIndex]tabBarItem];
    UIImage *selectImage = [[UIImage imageNamed:@"toolbar_shangpu_sel"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image = [[UIImage imageNamed:@"toolbar_shangpu-nor"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (![barItem.selectedImage isEqual:selectImage])
    {
        barItem.selectedImage = selectImage;
    }
    if (![barItem.image isEqual:image])
    {
        barItem.image =image;
    }
}
//设置tabBarItem图片小红点的图片
- (void)setShopStoreTabBarItemWithRedDot:(NSNotification *)noti
{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    if (self.viewControllers.count<=shopTabIndex)
    {
        return;
    }
    UITabBarItem *barItem = [[self.viewControllers objectAtIndex:shopTabIndex]tabBarItem];
    UIImage *selectImage = [[UIImage imageNamed:@"toolbar_shangpu_sel_i"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *image = [[UIImage imageNamed:@"toolbar_shangpu-nor_i"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (![barItem.selectedImage isEqual:selectImage])
    {
        barItem.selectedImage = selectImage;
    }
    if (![barItem.image isEqual:image])
    {
        barItem.image =image;
    }
}
-(void)pushMessagePush:(NSNotification*)noti
{
    WYMessagePushView* messageView = [[WYMessagePushView alloc] initWithData:noti.object];
    [messageView showToWindowAfterCompletion:^{
        if (self.messagePushView) {//上一个移除
            self.messagePushView.isIgnoreSetWindowLevelNormal = YES;
            [self.messagePushView dismissWithAnimated:NO completion:nil];
        }
        self.messagePushView = messageView;
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
