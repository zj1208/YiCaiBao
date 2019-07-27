//
//  WYPurchaserViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/4/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserViewController.h"

#import "WYMessagePushView.h"

@interface WYPurchaserViewController ()<UITabBarControllerDelegate>
@property(nonatomic, weak)WYMessagePushView *messagePushView; //weak
@end

@implementation WYPurchaserViewController
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [UIViewController xm_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle];
    
    UIImage *tabImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xFAFAFA) andSize:self.tabBar.frame.size];
    self.tabBar.backgroundImage = tabImage;
    UIImage *shadowImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xD8D8D8) andSize:CGSizeMake(self.tabBar.frame.size.width, 0.5)];
    self.tabBar.shadowImage = shadowImage;
    
    self.delegate = self;
    
    //加载controllers
    [self addViewcontrollers];
    
    [self addNoticationCenter];
    
}
-(void)addViewcontrollers
{
    //首页
    [self addViewControllerWithStoryBoardName:@"Purchaser" Identifier:@"WYPurchaserMainViewControllerID"  NorImageName:@"toolbar_home_normal" SelImageName:@"toolbar_home_selected"];
    
    //分类查找
//    [self addViewControllerWithName:@"FenLeiViewController" NorImageName:@"toolbar_classify_normal" SelImageName:@"toolbar_classify_selected"];
    
    [self addViewControllerWithStoryBoardName:@"Attention" Identifier:@"WYAttentionViewControllerID"  NorImageName:@"toolbar_interest_no" SelImageName:@"toolbar_interest"];
   
    //发布求购
    [self addViewControllerWithName:@"PurPublishViewController" NorImageName:@"toolbar_+" SelImageName:@"toolbar_+"];
   
    //进货单
    [self addViewControllerWithName:@"WYPurchaserShoppingCartViewController" NorImageName:@"toolbar_jinhuodan_nor" SelImageName:@"toolbar_jinhuodan_selected"];

    //我的
    [self addViewControllerWithStoryBoardName:@"Purchaser" Identifier:@"WYPurchaserMineViewControllerID" NorImageName:@"toolbar_me_normal" SelImageName:@"toolbar_me_selected"];
}

-(void)addViewControllerWithName:(NSString*)VCname  NorImageName:(NSString*)Norname SelImageName:(NSString*)SelName
{
    Class clas = NSClassFromString(VCname);
    UIViewController*  viewC = [[clas alloc] init ];
    
    UINavigationController* naVC = [[UINavigationController alloc] initWithRootViewController:viewC];
    
    [naVC xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];

    naVC.navigationBar.tintColor = WYUISTYLE.colorMTblack;
    naVC.tabBarItem.image = [[UIImage imageNamed:Norname] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    naVC.tabBarItem.selectedImage = [[UIImage imageNamed:SelName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    if (! [VCname isEqualToString:@"PurPublishViewController"]) {
        naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    NSMutableArray* arrayM = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [arrayM addObject:naVC];
    self.viewControllers = arrayM;
}
-(void)addViewControllerWithStoryBoardName:(NSString*)storyboardName Identifier:(NSString*)identifier NorImageName:(NSString*)Norname SelImageName:(NSString*)SelName
{
    //根据storyboard和controller的storeId找到控制器
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboardName bundle:[NSBundle mainBundle]];
    UIViewController *viewC=[sb instantiateViewControllerWithIdentifier:identifier];
    
    UINavigationController* naVC = [[UINavigationController alloc] initWithRootViewController:viewC];
    [naVC xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];

    naVC.navigationBar.tintColor = WYUISTYLE.colorMTblack;
    naVC.tabBarItem.image = [[UIImage imageNamed:Norname] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] ;
    naVC.tabBarItem.selectedImage = [[UIImage imageNamed:SelName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    naVC.tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    
    NSMutableArray* arrayM = [[NSMutableArray alloc] initWithArray:self.viewControllers];
    [arrayM addObject:naVC];
    self.viewControllers = arrayM;
    
}



- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    if (viewController == self.viewControllers[0]) {
        [MobClick event:kUM_c_index];
        NSInteger selectedIndex = tabBarController.selectedIndex;
        if (selectedIndex == 0) { //再次点击通知刷新
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_WYPurchaserMainViewController object:nil];
        }
    }
    if (viewController == self.viewControllers[1]) {
        [MobClick event:kUM_c_toobar_follow];
        if ([self xm_performIsLoginActionWithPopAlertView:NO]){
            return YES;
        }else{
            return NO;
        }
    }
    if (viewController == self.viewControllers[2]) {
        [MobClick event:kUM_c_inquiry];
        //点击中间tabbarItem，不切换，让当前页面跳转
//        NSString *webUrl = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseForm.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [WYUTILITY routerWithName:webUrl withSoureController:navi.topViewController];
        UINavigationController *navi = tabBarController.selectedViewController;
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPurchaseForm;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPurchaseForm withSoureController:navi.topViewController];
        return NO;
    }
    if (viewController == self.viewControllers[3]) {
        [MobClick event:kUM_c_toolbar_shoppinglist];
        if ([self xm_performIsLoginActionWithPopAlertView:NO])
        {
            return YES;
        }else{
            return NO;
        }
    }
    if (viewController == self.viewControllers[4]) {
        [MobClick event:kUM_c_mine];
    }
    return YES;
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    UINavigationController *nav = (UINavigationController *)viewController;
    if (nav.viewControllers.count>1)
    {
        [nav popToRootViewControllerAnimated:NO];
    }
}

#pragma mark - 添加通知中心
-(void)addNoticationCenter
{
    //收到消息内部弹出
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushMessagePush:) name:Noti_Push_Message object:nil];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)pushMessagePush:(NSNotification*)noti
{
    WYMessagePushView* messageView = [[WYMessagePushView alloc] initWithData:noti.object];
    [messageView showToWindowAfterCompletion:^{
        if (self.messagePushView) { //上一个移除
            self.messagePushView.isIgnoreSetWindowLevelNormal = YES;
            [self.messagePushView dismissWithAnimated:NO completion:nil];
        }
        self.messagePushView = messageView;
    }];
}


@end
