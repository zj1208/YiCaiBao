//
//  WYUtility.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/27.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYUtility.h"
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import "WYWKWebViewController.h"
#import "ZXWebViewController.h"
#import "ShopInfoViewController.h"
#import "WYMessageListViewController.h"

#import "MessageDetailListViewController.h"
#import "WYPerfectShopInfoViewController.h"
#import <sys/utsname.h>
#import "AddProductController.h"
#import "NTESSessionViewController.h"
#import "CircularListViewController.h"
#import "WYNIMAccoutManager.h"
//播放提示音
#import <AudioToolbox/AudioToolbox.h>
#import "WYTabBarViewController.h"
#import "WYPurchaserViewController.h"

#import "WYMainViewController.h"
#import "ExtendProductViewController.h"
#import "ChangePhoneStepOneViewController.h"
#import "FenLeiViewController.h"
#import "FraudCaseListViewController.h"
//搜索结果
#import "SearchDetailViewController.h"
//接生意设置
#import "WYTradeSetViewController.h"
//科大讯飞翻译
#import "MSCViewController.h"
//立即提现
#import "WYImmediateWithdrawalViewController.h"
//买家*卖家订单详情页
#import "SellerOrderDetailViewController.h"
//立即订购下单页面
#import "WYPurchaserConfirmOrderViewController.h"
//卖家订单列表
#import "SellerPageMenuController.h"
#import "BuyerPageMenuController.h"
//商铺资料-我的银行卡
#import "BankAccountViewController.h"
#import "WYPayDepositViewController.h"
#import "WYQRCodeViewController.h"
//开单
#import "MakeBillsTabController.h"
//接生意列表
#import "WYMainViewController.h"

//开单预览
#import "WYMakeBillPreviewViewController.h"
//开单
#import "WYMakeBillViewController.h"
//开单设置
#import "WYMakeBillPreviewSetController.h"

//新增我的客户
#import "MyCustomerAddEditController.h"

#import "AccountModel.h"
#import "WYAttentionViewController.h"
#import "TradeDetailController.h"
#import "VisitorViewController.h"
#import "FansViewController.h"
@implementation WYUtility

+ (WYUtility *)dataUtil{
    static dispatch_once_t once;
    static WYUtility *mInstance;
    dispatch_once(&once, ^ { mInstance = [[WYUtility alloc] init]; });
    return mInstance;
}


- (UIImage *)getCommonRedGradientImageWithSize:(CGSize)size
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(255.f, 67.f, 82.f, 1.f) endColor:UIColorFromRGBA(243.f, 19.f,37.f, 1.f)];
    return backgroundImage;
}

- (UIImage *)getCommonVersion2RedGradientImageWithSize:(CGSize)size
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(253.f, 121.f, 83.f, 1.f) endColor:UIColorFromRGBA(253.f, 82.f,71.f, 1.f)];
    return backgroundImage;
}

- (UIImage *)getCommonVersion2GreenGradientImageWithSize:(CGSize)size
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(79.f, 221.f, 208.f, 1.f) endColor:UIColorFromRGBA(33.f, 185.f,201.f, 1.f)];
    return backgroundImage;
}

- (UIImage*)getCommonNavigationBarMarketServiceImageWithSize:(CGSize)size{

    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(191.f, 53.f, 45.f, 1.f) endColor:UIColorFromRGBA(189.f, 43.f,35.f, 1.f)];
    return backgroundImage;
}

-(UIImage*)getCommonNavigationBarRedGradientImageWithSize:(CGSize)size
{
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(255.f, 163.f, 66.f, 1.f) endColor:UIColorFromRGBA(255.f, 113.f,85.f, 1.f)];
    return backgroundImage;
}
-(UIImage *)getTitleViewRedGradientImageWithSize:(CGSize)size
{ 
    UIImage *backgroundImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:size startColor:UIColorFromRGBA(253.f, 121.f, 83.f, 1.f) endColor:UIColorFromRGBA(254.f, 81.f,71.f, 1.f)];
    return backgroundImage;
}
- (UIImage *)getPurBarImageWithSize:(CGSize)size
{
    const CGFloat location[] ={0,1};
    const CGFloat components2[] ={
        1.0,0.73,0.29,1.0,
        1.0,0.55,0.19,1.0
    };
    UIImage *backgroundImage = [UIImage zh_getGradientImageWithSize:size locations:location components:components2 count:2];
    return backgroundImage;
}
//判断屏幕
- (NSString *)getMainScreen{
    UIScreen *MainScreen=[UIScreen mainScreen];
    CGSize size=[MainScreen bounds].size;
    if(size.height > 700)
    {
        return @"6p";
    }
    else if (size.height>650)
    {
        return @"6";
    }
    else if(size.height>500)
    {
        return @"5";
    }
    else
    {
        return @"4";
    }
    return @"5";
}


- (nullable UIViewController *)previewingNewControllerViewWithRouteUrl:(NSString *)url
{
    if ([url hasPrefix:@"http"] ||[url hasPrefix:@"https"])
    {
        if ([url rangeOfString:@"{shopId}"].location != NSNotFound &&[UserInfoUDManager isOpenShop])
        {
            url = [url stringByReplacingOccurrencesOfString:@"{shopId}" withString:[UserInfoUDManager getShopId]];
        }
        if ([url rangeOfString:@"{token}"].location != NSNotFound)
        {
            if(ISLOGIN)
            {
                url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
            }
            else
            {
                url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:@""];
            }
        }
        NSString *version  = [BaseHttpAPI getCurrentAppVersion];
        if ([url rangeOfString:@"{ttid}"].location != NSNotFound && version)
        {
            url =[url stringByReplacingOccurrencesOfString:@"{ttid}" withString:version];
        }
        if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11))
        {
            if ([url rangeOfString:@"duiba.com.cn"].location != NSNotFound || [url isEqualToString:@"https://wykj.microants.cn/ycbx/page/middlewarePage.html"])
            {
                ZXWebViewController *htmlVc = [[ZXWebViewController alloc] init];
                [htmlVc loadWebPageWithURLString:url];
                htmlVc.hidesBottomBarWhenPushed = YES;
                return htmlVc;
            }
            else
            {
                //H5跳转
                WYWKWebViewController *htmlVc = [[WYWKWebViewController alloc] init];
                [htmlVc loadWebPageWithURLString:url];
                htmlVc.hidesBottomBarWhenPushed = YES;
                return htmlVc;
            }
            
        }
        else
        {
            ZXWebViewController *htmlVc = [[ZXWebViewController alloc] init];
            [htmlVc loadWebPageWithURLString:url];
            htmlVc.hidesBottomBarWhenPushed = YES;
            return htmlVc;
        }
    }
    else if ([url rangeOfString:@"microants://businessDetail" options:NSAnchoredSearch].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tradeId = [components zhObjectForKey:@"id"];
        UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboard_Trade  bundle:[NSBundle mainBundle]];
       TradeDetailController *vc =  (TradeDetailController *)[sb instantiateViewControllerWithIdentifier:SBID_TradeDetailController];
        vc.postId = tradeId;
        return vc;
    }
    //3.访客列表
    else if ([url rangeOfString:@"microants://visitorList" options:NSAnchoredSearch].location!=NSNotFound) {
        
        UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboard_ShopStore  bundle:[NSBundle mainBundle]];
        VisitorViewController *vc = (VisitorViewController *) [sb instantiateViewControllerWithIdentifier:SBID_VisitorViewController];
        vc.shopId = [UserInfoUDManager getShopId];
        return vc;
    }
    
    //4.粉丝
    else if ([url rangeOfString:@"microants://latentVisitor" options:NSAnchoredSearch].location!=NSNotFound) {
        
        UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboard_ShopStore  bundle:[NSBundle mainBundle]];
        FansViewController *vc = (FansViewController *) [sb instantiateViewControllerWithIdentifier:SBID_FansViewController];
        vc.shopId = [UserInfoUDManager getShopId];
        return vc;
    }
    else if ([url rangeOfString:@"microants://messageList?type"].location !=NSNotFound)
    {
        if (![url canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
            url= [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *typeName = [components zhObjectForKey:@"title"];
        NSString *type = [components zhObjectForKey:@"type"];
        
        MessageDetailListViewController *vc = [[MessageDetailListViewController alloc] init];
        vc.typeName = typeName;
        vc.type = @([type integerValue]);
        vc.hidesBottomBarWhenPushed = YES;
        return vc;
    }
    return nil;
}

//个推过来的json数据：
//payloadMsg:{"body":"恭喜！有新客户关注了您的商铺，赶紧去查看！","extra":{"type":"2"},"title":"恭喜！新增一名潜在客户","url":"microants://latentVisitor”}

- (BOOL)routerWithName:(NSString *)name withSoureController:(UIViewController *)viewController
{
    [WYUserDefaultManager removeDidFinishLaunchRemoteNoti];
    if ([NSString zhIsBlankString:name])
    {
        NSLog(@"url跳转地址为空");
        return NO;
    }
    UIViewController * root = APP_MainWindow.rootViewController;
    if (![root isKindOfClass:[UITabBarController class]])
    {
        NSLog(@"还没有初始化TabBarController");
        return NO;
    }
    NSString *currentControllerName = NSStringFromClass([viewController class]);
    
    //判断是否有蒙层
    [self isSubviewsOnWYTabBarViewController_ViewWithCurrentControllerName:currentControllerName];
    
    //解决已经present了的界面问题；
    UIViewController *topViewController = viewController.navigationController.topViewController;
    if (topViewController.presentedViewController) {
        [topViewController.presentedViewController dismissViewControllerAnimated:NO completion:nil];
    }
    
    if ([root isKindOfClass:[WYTabBarViewController class]])
    {
        WYTabBarViewController *tab = (WYTabBarViewController *)root;
        return  [self pushBusinessRemoteControllerWithSoureController:viewController.navigationController advUrlString:name currentControllerName:currentControllerName tabBarController:tab];
    }
    else if ([root isKindOfClass:[WYPurchaserViewController class]])
    {
        WYPurchaserViewController *tab = (WYPurchaserViewController *)root;
        return  [self pushPurchaseRemoteControllerWithSoureController:viewController.navigationController advUrlString:name currentControllerName:currentControllerName tabBarController:tab];
    }
    return YES;

}

//收到通知跳转前移除功能引导页
-(void)isSubviewsOnWYTabBarViewController_ViewWithCurrentControllerName:(NSString*)currentControllerName
{
    if ([currentControllerName isEqualToString:@"MineMainViewController"] ||[currentControllerName isEqualToString:@"PurchaserMineViewController"])
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_RemoveView_GuideController  object:nil];
    }
}


//采购端跳转
- (BOOL)pushPurchaseRemoteControllerWithSoureController:(UINavigationController *)navigationController advUrlString:(NSString *)url currentControllerName:(NSString *)currentControllerName tabBarController:(UITabBarController *)tabBarController
{
    //我的
    if ([url isEqualToString:@"microants://userInfo"])
    {
        tabBarController.selectedIndex = 4;
        return YES;
    }
    // 分类查找
    else if ([url isEqualToString:@"microants://classifyFind"])
    {
        FenLeiViewController *vc = [[FenLeiViewController alloc] init];
        vc.pushstyle = FenLeiPushDefault;
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    // 分类查找指定分类：microants://classifyFind?categoryId=xxx
    else if ([url rangeOfString:@"microants://classifyFind?"].location !=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *categoryId = [components zhObjectForKey:@"categoryId"];
        FenLeiViewController *vc = [[FenLeiViewController alloc] init];
        vc.pushstyle = FenLeiPushDefault;
        vc.categroyId = [NSNumber numberWithInteger:[categoryId integerValue]] ;
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //搜索
    else if ([url isEqualToString:@"microants://search"])
    {
        if (tabBarController.selectedIndex ==0)
        {
            [navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            tabBarController.selectedIndex = 0;
        }
        return YES;
    }
//    采购端tabs页面
    else if ([url rangeOfString:@"microants://purchaser?tab" options:NSAnchoredSearch].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tab = [components zhObjectForKey:@"tab"];
        if ([tab isEqualToString:@"home"])
        {
            if (tabBarController.selectedIndex ==0)
            {
                 [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = 0;
            }
        }
        else if ([tab isEqualToString:@"focus"])
        {
            if (![UserInfoUDManager isLogin])
            {
                return [tabBarController.delegate tabBarController:tabBarController shouldSelectViewController:[tabBarController.viewControllers objectAtIndex:1]];
            }
            //    采购商关注页. (tab关注页子页面:0-关注 1-上新 2-热销 3-库存)
            NSString *subFocusTab = [components zhObjectForKey:@"subFocusTab"];
            if (tabBarController.selectedIndex ==1)
            {
                [navigationController popToRootViewControllerAnimated:YES];
                WYAttentionViewController *rootVC = (WYAttentionViewController *)navigationController.topViewController;
                [rootVC switchTabIndex:[subFocusTab integerValue]];
            }
            else
            {
                tabBarController.selectedIndex = 1;
                UINavigationController *nav = (UINavigationController *)tabBarController.selectedViewController;
                WYAttentionViewController *rootVC = (WYAttentionViewController *) nav.topViewController;
                [rootVC switchTabIndex:[subFocusTab integerValue]];
            }
        }
        else if ([tab isEqualToString:@"shoppingcart"])
        {
            if (![UserInfoUDManager isLogin])
            {
                return NO;
            }
            if (tabBarController.selectedIndex ==3)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = 3;
            }
        }
        else if ([tab isEqualToString:@"mine"])
        {
            if (tabBarController.selectedIndex ==4)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = 4;
            }
        }
        return YES;
    }
    //立即订购页面microants://order?productId=xxx&minQuantity=xxx
    else if ([url rangeOfString:@"microants://order" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *productId = [components zhObjectForKey:@"productId"];
        NSString *minQuantity = [components zhObjectForKey:@"minQuantity"];

        WYPurchaserConfirmOrderViewController*  viewC = [[WYPurchaserConfirmOrderViewController alloc] init ];
        viewC.itemId = productId.integerValue;
        viewC.quantity = minQuantity.integerValue;
        viewC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:viewC animated:YES];

    }
//    买家订单列表
    else if ([url rangeOfString:@"microants://buyerorderlist" options:NSAnchoredSearch].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *status = [components zhObjectForKey:@"status"];
        
        BuyerPageMenuController *vc = [[BuyerPageMenuController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setSelectedPageIndexWithOrderListStatus:[status integerValue]];
        [navigationController pushViewController:vc animated:YES];
    }
     //买家订单详情页面microants://buyerorderDetail?id=xxx
    else if ([url rangeOfString:@"microants://buyerorderDetail" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tradeId = [components zhObjectForKey:@"id"];
        
        SellerOrderDetailViewController*  viewC = [[SellerOrderDetailViewController alloc] init ];
        viewC.bizOrderId = tradeId; 
        viewC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:viewC animated:YES];
    }

    else
    {
       return  [self pushCommonControllerWithSoureController:navigationController advUrlString:url currentControllerName:currentControllerName];
    }
    return NO;

}

//商户端跳转
- (BOOL)pushBusinessRemoteControllerWithSoureController:(UINavigationController *)navigationController advUrlString:(NSString *)url currentControllerName:(NSString *)currentControllerName tabBarController:(WYTabBarViewController *)tabBarController
{
    
    //开店引导页; 没有开店的才会跳转
    if ([url isEqualToString:@"microants://makeShop"])
    {
        if ([UserInfoUDManager isLogin]||[UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"OpenShopController"])
        {
            [tabBarController.delegate tabBarController:tabBarController shouldSelectViewController:[tabBarController.viewControllers objectAtIndex:shopTabIndex]];
        }
    }
    else if ([url rangeOfString:@"microants://supplier?tab" options:NSAnchoredSearch].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tab = [components zhObjectForKey:@"tab"];
        if ([tab isEqualToString:@"store"])
        {
            if (tabBarController.selectedIndex ==shopTabIndex)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = shopTabIndex;
            }
        }
        else if ([tab isEqualToString:@"message"])
        {
            if (tabBarController.selectedIndex ==messageTabIndex)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = messageTabIndex;
            }
            [tabBarController.delegate tabBarController:tabBarController didSelectViewController:[tabBarController.viewControllers objectAtIndex:messageTabIndex]];
        }
        else if ([tab isEqualToString:@"service"])
        {
            if (tabBarController.selectedIndex ==fuWuTabIndex)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = fuWuTabIndex;
            }
        }
        else if ([tab isEqualToString:@"mine"])
        {
            if (tabBarController.selectedIndex ==mineTabIndex)
            {
                [navigationController popToRootViewControllerAnimated:YES];
            }
            else
            {
                tabBarController.selectedIndex = mineTabIndex;
            }
        }
        return YES;
    }

    //快速开店-
    else if ([url isEqualToString:@"microants://makeShopQuick"])
    {
        if (![UserInfoUDManager isLogin]||[UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"WYPerfectShopInfoViewController"])
        {
            WYPerfectShopInfoViewController *vc =  [[NSClassFromString(@"WYPerfectShopInfoViewController") alloc]init];

            vc.hidesBottomBarWhenPushed = YES;
            vc.soureControllerType = SourceControllerType_Any;
            [navigationController pushViewController:vc animated:YES];
        }
    }
    
    //1.接生意页
    else if ([url isEqualToString:@"microants://business"])
    {
        WYMainViewController *vc = (WYMainViewController *)[navigationController xm_getControllerWithStoryboardName:storyboard_Main controllerWithIdentifier:SBID_WYMainViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:NO];//NO
    }


    //推产品，清库存（1表示推产品，2表示清库存）microants://promote?type=1&id={id} //重新发布才有推广id
    else if ([url rangeOfString:@"microants://promote?type" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        else
        {
            NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
            NSString *tradeId = [components zhObjectForKey:@"type"];
            NSString *oldId = [components zhObjectForKey:@"id"];

            ExtendProductViewController* product = [[ExtendProductViewController alloc] init];
            product.hidesBottomBarWhenPushed = YES;
            product.numId = @([tradeId integerValue]);
            if (oldId) {
                product.oldId  = @(oldId.integerValue);
            }
            [navigationController pushViewController:product animated:NO];
        }
    }
    // 立即提现页面
    else if ([url isEqualToString:@"microants://drawcash"])
    {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"SellerOrder" bundle:[NSBundle mainBundle]];
        WYImmediateWithdrawalViewController* MSCVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_WYImmediateWithdrawalViewController];
        MSCVC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:MSCVC animated:YES];

    }
    //我的收入-我的银行卡(商铺我的银行卡列表)
    else if ([url isEqualToString:@"microants://bankcardlist"])
    {
        BankAccountViewController *vc = [[BankAccountViewController alloc] init];
        [navigationController pushViewController:vc animated:YES];
    }
    //卖家订单详情列表
    else if ([url rangeOfString:@"microants://sellerorderlist" options:NSAnchoredSearch].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *status = [components zhObjectForKey:@"status"];

        SellerPageMenuController *vc = [[SellerPageMenuController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [vc setSelectedPageIndexWithOrderListStatus:[status integerValue]];
        [navigationController pushViewController:vc animated:YES];
    }
    // 卖家订单详情页面microants://sellersorderDetail?id=xxx
    else if ([url rangeOfString:@"microants://sellersorderDetail" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tradeId = [components zhObjectForKey:@"id"];
        
        SellerOrderDetailViewController*  viewC = [[SellerOrderDetailViewController alloc] init ];
        viewC.bizOrderId = tradeId;
        viewC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:viewC animated:YES];
    }

    // 接生意-设置主营产品、主营类目、通知页面
    else if ([url isEqualToString:@"microants://businesssetting"])
    {
        WYTradeSetViewController *vc = (WYTradeSetViewController *)[navigationController xm_getControllerWithStoryboardName:storyboard_Main controllerWithIdentifier:SBID_WYTradeSetViewController];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    // 49.开单首页
    else if ([url rangeOfString:@"microants://openbill" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        MakeBillsTabController *vc = (MakeBillsTabController *)[navigationController xm_getControllerWithStoryboardName:@"MakeBills" controllerWithIdentifier:@"MakeBillsTabControllerID"];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //52.单据预览-v3.1
    else if ([url rangeOfString:@"microants://billPreview?" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *billId = [components zhObjectForKey:@"billId"];
        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
        WYMakeBillPreviewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYMakeBillPreviewViewController];
        VC.billId = billId;
        VC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:VC animated:YES];
    }
    //51.单据详情-v3.1
    else if ([url rangeOfString:@"microants://billDetail?" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *billId = [components zhObjectForKey:@"billId"];
        WYMakeBillViewController *vc = (WYMakeBillViewController *)[navigationController xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
        vc.billId = billId;
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //53.单据设置-v3.1
    else if ([url rangeOfString:@"microants://billSetting" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        WYMakeBillPreviewSetController *vc = (WYMakeBillPreviewSetController *)[navigationController xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillPreviewSetController];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //我的客户
    else if ([url isEqualToString:@"microants://myCustomer"])
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_MyCustomerViewController withData:nil];
    }
    //57.添加我的客户
    else if ([url rangeOfString:@"microants://addMyCustomer" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *buyerBizId = [components zhObjectForKey:@"buyerBizId"];
        NSString *source = [components zhObjectForKey:@"source"];
        
        MyCustomerAddEditController *VC = (MyCustomerAddEditController *)[navigationController xm_getControllerWithStoryboardName:sb_ShopCustomer controllerWithIdentifier:@"MyCustomerAddEditControllerID"];
        VC.buyerBizId = buyerBizId;
        VC.source = source.integerValue;
        VC.isEditCustomer = NO;
        VC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:VC animated:YES];
        
    }
    //商户钱包授权 信用贷
//    else if ([url rangeOfString:@"microants://creditLoan" options:NSAnchoredSearch].location!=NSNotFound){
//        if (![UserInfoUDManager isLogin]){
//            return NO;
//        }
//        [self verifyDouxin:navigationController];
//    }
    else
    {
       return  [self pushCommonControllerWithSoureController:navigationController advUrlString:url currentControllerName:currentControllerName];
    }
    return YES;

}


- (BOOL)pushCommonControllerWithSoureController:(UINavigationController *)navigationController advUrlString:(NSString *)url currentControllerName:(NSString *)currentControllerName
{
    if ([url hasPrefix:@"http"] ||[url hasPrefix:@"https"])
    {
        if ([url rangeOfString:@"{shopId}"].location != NSNotFound &&[UserInfoUDManager isOpenShop])
        {
            url = [url stringByReplacingOccurrencesOfString:@"{shopId}" withString:[UserInfoUDManager getShopId]];
        }
        if ([url rangeOfString:@"{token}"].location != NSNotFound)
        {
//            url = [url stringByReplacingOccurrencesOfString:@"&token={token}" withString:@""];
            if(ISLOGIN)
            {
                url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
            }
            else
            {
                url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:@""];
            }
        }
        NSString *version  = [BaseHttpAPI getCurrentAppVersion];
        if ([url rangeOfString:@"{ttid}"].location != NSNotFound && version)
        {
            url =[url stringByReplacingOccurrencesOfString:@"{ttid}" withString:version];
        }
        if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11))
        {
            if ([url rangeOfString:@"duiba.com.cn"].location != NSNotFound || [url isEqualToString:@"https://wykj.microants.cn/ycbx/page/middlewarePage.html"])
            {
                ZXWebViewController *web = [[ZXWebViewController alloc] init];
                [web loadWebPageWithURLString:url];
                web.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:web animated:YES];
            }
            else
            {
                //H5跳转
                WYWKWebViewController *htmlVc = [[WYWKWebViewController alloc] init];
                htmlVc.hidesBottomBarWhenPushed = YES;
                [htmlVc loadWebPageWithURLString:url];
                [navigationController pushViewController:htmlVc animated:YES];
             }
   
        }
        else
        {
            ZXWebViewController *htmlVc = [[ZXWebViewController alloc] init];
            htmlVc.hidesBottomBarWhenPushed = YES;
            [htmlVc loadWebPageWithURLString:url];
            [navigationController pushViewController:htmlVc animated:YES];
        }
  
    }

    //1.2.当匹配的生意推送过来／采购商查看了接单回复 microants://businessDetail?id=xxx
    else if ([url rangeOfString:@"microants://businessDetail" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *tradeId = [components zhObjectForKey:@"id"];
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":tradeId}];
    }
    //3.访客列表
    else if ([url rangeOfString:@"microants://visitorList" options:NSAnchoredSearch].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if ([currentControllerName isEqualToString:@"VisitorViewController"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_VisitorViewController object:nil];;
        }
        else
        {
            [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_VisitorViewController withData:@{@"shopId":[UserInfoUDManager getShopId]}];
        }
    }
    
    //4.粉丝
    else if ([url rangeOfString:@"microants://latentVisitor" options:NSAnchoredSearch].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if ([currentControllerName isEqualToString:@"FansViewController"])
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_FansController object:nil];;
        }
        else
        {
            [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_FansViewController withData:@{@"shopId":[UserInfoUDManager getShopId]}];
        }
    }
    //5.商铺二维码
    else if ([url rangeOfString:@"microants://shopqrcode" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"WYQRCodeViewController"])
        {
            WYQRCodeViewController *codeVC = (WYQRCodeViewController *)[navigationController.topViewController xm_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYQRCodeViewController];
            codeVC.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:codeVC animated:YES];
        }
    }
    //7.产品管理
    else if ([url rangeOfString:@"microants://productmanage" options:NSAnchoredSearch].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ProductManageController withData:@{@"selectIndex":@(0)}];
    }
    //8.上传产品
    else if ([url rangeOfString:@"microants://productupload" options:NSAnchoredSearch].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:nil];
    }
    //9.产品编辑
    else if ([url rangeOfString:@"microants://modifyProduct" options:NSAnchoredSearch].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *productId = [components zhObjectForKey:@"id"];
        
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_AddProductController withData:@{@"productId":productId,@"controllerDoingType":@(ControllerDoingType_EditProduct)}];
    }
    
    //10.商铺公告
    else if ([url rangeOfString:@"microants://shopnotice"].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"ShopNoticeViewController"])
        {
            UIViewController *noticeVc =[[NSClassFromString(@"ShopNoticeViewController") alloc]init];
            noticeVc.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:noticeVc animated:YES];
        }
    }
    //11.商铺实景 microants://shopimages
    else if ([url rangeOfString:@"microants://shopimages"].location!=NSNotFound)
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"ShopSceneryViewController"])
        {
            UIViewController *vc = [[NSClassFromString(@"ShopSceneryViewController") alloc] init];
            vc.hidesBottomBarWhenPushed = YES;
            [navigationController pushViewController:vc animated:YES];
        }
    }
    
    //12.商铺设置
    else if ([url rangeOfString:@"microants://shopinformation"].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        //商铺设置
        if (![currentControllerName isEqualToString:@"ShopInfoViewController"])
        {
            [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ShopInfoViewController withData:nil];
        }
    }
    //13.消息分类－im推送也是这里
    else if ([url isEqualToString:@"microants://messageCategory"])
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        if (![currentControllerName isEqualToString:@"WYMessageListViewController"])
        {
            WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
            messageList.hidesBottomBarWhenPushed= YES;
            [navigationController pushViewController:messageList animated:YES];
        }
    }
    //14.消息分类列表microants://messageList?type=2&title=@"活动资讯"
    else if ([url rangeOfString:@"microants://messageList?type"].location !=NSNotFound)
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        if (![url canBeConvertedToEncoding:NSASCIIStringEncoding])
        {
           url= [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        }
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *typeName = [components zhObjectForKey:@"title"];
        NSString *type = [components zhObjectForKey:@"type"];
        
        MessageDetailListViewController *vc = [[MessageDetailListViewController alloc] init];
        vc.typeName = typeName;
        vc.type = @([type integerValue]);
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //15.我的生意
    else if ([url isEqualToString:@"microants://myBusiness"])
    {
        if (![UserInfoUDManager isLogin]||![UserInfoUDManager isOpenShop])
        {
            return NO;
        }
        if ([currentControllerName isEqualToString:@"WYTradeFinishedController"])
        {
            
        }
        else
        {
            [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_MyTradesController withData:nil];
        }
    }
    //16.在线聊天
    else if ([url rangeOfString:@"microants://chat?"].location!=NSNotFound) {
        
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
 
        if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:navigationController.topViewController])
        {
            NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
            NSString *sessionId = [components zhObjectForKey:@"account"];
            NSString *hisUrl = [components zhObjectForKey:@"url"];
            NSString *shopUrl = [components zhObjectForKey:@"shopUrl"];
            NSString *prodId = [components zhObjectForKey:@"id"];
            if (prodId)
            {
                [MBProgressHUD zx_showLoadingWithStatus:nil toView:navigationController.topViewController.view];
                [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfo2WithIDType:NIMIDType_NIMAccout thisId:sessionId productId:prodId success:^(id data) {
                    
                    [MBProgressHUD zx_hideHUDForView:navigationController.topViewController.view];
                    IMChatInfoModel *model = data;
                    NIMSession *session = [NIMSession session:sessionId type:NIMSessionTypeP2P];
                    NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                    vc.hisUrl = hisUrl;
                    vc.shopUrl = shopUrl;
                    vc.proModel = model.product;
                    vc.hidesBottomBarWhenPushed = YES;
                    [navigationController pushViewController:vc animated:YES];
                    
                } failure:^(NSError *error) {
                    
                    [MBProgressHUD zx_showError:[error localizedDescription] toView:navigationController.topViewController.view];
                }];
            }
            else
            {
                NIMSession *session = [NIMSession session:sessionId type:NIMSessionTypeP2P];
                NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
                vc.hisUrl = hisUrl;
                vc.shopUrl = shopUrl;
                vc.hideUnreadCountView = YES;
                vc.hidesBottomBarWhenPushed = YES;
                [navigationController pushViewController:vc animated:YES];
            }
        }
    }
    //17.失信通报／经侦失信
    else if ([url isEqualToString:@"microants://badCompanyBoard"])
    {
        CircularListViewController *vc =[[CircularListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    //18.用户登陆
    else if ([url isEqualToString:@"microants://userLogin"])
    {
        [navigationController xm_presentLoginController];
    }
    //19.经营信息
    else if ([url isEqualToString:@"microants://shopmessage"])
    {
        if (![UserInfoUDManager isOpenShop] ||![UserInfoUDManager isLogin])
        {
            return NO;
        }
        [navigationController.topViewController xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ManagementInfoController withData:nil];
    }
    //变更手机号
    else if ([url isEqualToString:@"microants://changePhone"])
    {
        if (![UserInfoUDManager isLogin])
        {
            return NO;
        }
        ChangePhoneStepOneViewController *vc = [[ChangePhoneStepOneViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }

    // 市场资讯
    else if ([url isEqualToString:@"microants://case"])
    {
        FraudCaseListViewController *vc = [[FraudCaseListViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    // 采购商-搜索结果页-根据关键字
    else if ([url rangeOfString:@"microants://search?"].location!=NSNotFound)
    {
        url= [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *title = [components zhObjectForKey:@"words"];

        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
        SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
        searchDVC.searchKeyword = title;
        searchDVC.keywordType = 0;
        searchDVC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:searchDVC animated:YES];
    }
    //科大讯飞翻译
    else if ([url isEqualToString:@"microants://translate"])
    {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Extend bundle:[NSBundle mainBundle]];
        
        MSCViewController* MSCVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_MSCViewController];
        MSCVC.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:MSCVC animated:YES];
    }
//    48.支付页面 microants://authPay?comboId=xx（comboId为套餐id）、
    else if ([url rangeOfString:@"microants://authPay?"].location!=NSNotFound)
    {
        NSURLComponents *components = [[NSURLComponents alloc] initWithString:url];
        NSString *comboId = [components zhObjectForKey:@"comboId"];
        NSString *orderIds = [components zhObjectForKey:@"orderIds"];
        WYPayDepositViewController *vc = [[WYPayDepositViewController alloc] init];
        vc.comboId = comboId;
        vc.orderId = orderIds;
        vc.hidesBottomBarWhenPushed = YES;
        [navigationController pushViewController:vc animated:YES];
    }
    return YES;
}

+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize

{
    
    UIImage *newimage;
    
    if (nil == image)
        
    {
        
        newimage = nil;
        
    } else {
        
        CGSize oldsize = image.size;
        
        CGRect rect;
        
        if (asize.width/asize.height > oldsize.width/oldsize.height)
            
        {
            
            rect.size.width = asize.height*oldsize.width/oldsize.height;
            
            rect.size.height = asize.height;
            
            rect.origin.x = (asize.width - rect.size.width)/2;
            
            rect.origin.y = 0;
            
        } else {
            
            rect.size.width = asize.width;
            
            rect.size.height = asize.width*oldsize.height/oldsize.width;
            
            rect.origin.x = 0;
            
            rect.origin.y = (asize.height - rect.size.height)/2;
            
        }
        
        UIGraphicsBeginImageContext(asize);
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, [[UIColor clearColor] CGColor]);
        
        UIRectFill(CGRectMake(0, 0, asize.width, asize.height));//clear background
        
        [image drawInRect:rect];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

#pragma mark - 播放自定义提示音
+(void)AudioCustomSoundName:(NSString *)name{
    //播放test.wav文件
    static SystemSoundID soundIDTest = 0;//当soundIDTest == kSystemSoundID_Vibrate的时候为震动
    NSString * path = [[NSBundle mainBundle] pathForResource:name ofType:@"caf"];//自定义声音
    if (path) {
        AudioServicesCreateSystemSoundID( (__bridge CFURLRef)[NSURL fileURLWithPath:path], &soundIDTest);
    }
    AudioServicesPlaySystemSound(soundIDTest);
}

+(void)AudioSystemSound{
    //播放系统提示音
    SystemSoundID soundIDTest = 1007;
    AudioServicesPlaySystemSound(soundIDTest);
    //    NSString *path = [NSString stringWithFormat:@"/System/Library/Audio/UISounds/%@.%@",soundName,soundType];
    //[[NSBundle bundleWithIdentifier:@"com.apple.UIKit" ]pathForResource:soundName ofType:soundType];//得到苹果框架资源UIKit.framework ，从中取出所要播放的系统声音的路径
    
}


- (NSString *)iphoneType {
    
//    需要导入头文件：#import <sys/utsname.h>
    
    struct utsname systemInfo;
    
    uname(&systemInfo);
    
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSASCIIStringEncoding];
    
    if ([deviceString isEqualToString:@"iPhone1,1"]) return @"iPhone 2G";
    
    if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 3G";
    
    if ([deviceString isEqualToString:@"iPhone2,1"]) return @"iPhone 3GS";
    
    if ([deviceString isEqualToString:@"iPhone3,1"]) return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,2"]) return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone3,3"]) return @"iPhone 4";
    
    if ([deviceString isEqualToString:@"iPhone4,1"]) return @"iPhone 4S";
    
    if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,2"]) return @"iPhone 5";
    
    if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5c";
    
    if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5c";
    
    if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5s";
    
    if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5s";
    
    if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
    
    if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
    
    if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";
    
    if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";
    
    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 Plus";
    
    //2017年，海参新增
    if ([deviceString isEqualToString:@"iPhone10,1"])   return @"国行(A1863)、日行(A1906)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,2"])   return @"国行(A1864)、日行(A1898)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,3"])   return @"国行(A1865)、日行(A1902)iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,4"])   return @"美版(Global/A1905)iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,5"])   return @"美版(Global/A1897)iPhone 8 Plus";
    if ([deviceString isEqualToString:@"iPhone10,6"])   return @"美版(Global/A1901)iPhone X";
    
    if ([deviceString isEqualToString:@"iPod1,1"])   return @"iPod Touch 1G";
    
    if ([deviceString isEqualToString:@"iPod2,1"])   return @"iPod Touch 2G";
    
    if ([deviceString isEqualToString:@"iPod3,1"])   return @"iPod Touch 3G";
    
    if ([deviceString isEqualToString:@"iPod4,1"])   return @"iPod Touch 4G";
    
    if ([deviceString isEqualToString:@"iPod5,1"])   return @"iPod Touch 5G";
    
    if ([deviceString isEqualToString:@"iPad1,1"])   return @"iPad 1G";
    
    if ([deviceString isEqualToString:@"iPad2,1"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,2"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,3"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,4"])   return @"iPad 2";
    
    if ([deviceString isEqualToString:@"iPad2,5"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,6"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad2,7"])   return @"iPad Mini 1G";
    
    if ([deviceString isEqualToString:@"iPad3,1"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,2"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,3"])   return @"iPad 3";
    
    if ([deviceString isEqualToString:@"iPad3,4"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,5"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad3,6"])   return @"iPad 4";
    
    if ([deviceString isEqualToString:@"iPad4,1"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,2"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,3"])   return @"iPad Air";
    
    if ([deviceString isEqualToString:@"iPad4,4"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,5"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"iPad4,6"])   return @"iPad Mini 2G";
    
    if ([deviceString isEqualToString:@"i386"])      return @"iPhone Simulator";
    
    if ([deviceString isEqualToString:@"x86_64"])    return @"iPhone Simulator";
    
    return deviceString;
    
}




#pragma - 图片处理
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage{
    //进行图像尺寸的压缩
    CGSize imageSize = sourceImage.size;//取出要压缩的image尺寸
    CGFloat width = imageSize.width;    //图片宽度
    CGFloat height = imageSize.height;  //图片高度
    //1.宽高大于1280(宽高比不按照2来算，按照1来算)
    if (width>1280||height>1280) {
        if (width>height) {
            CGFloat scale = height/width;
            width = 1280;
            height = width*scale;
        }else{
            CGFloat scale = width/height;
            height = 1280;
            width = height*scale;
        }
    //2.宽大于1280高小于1280
    }else if(width>1280||height<1280){
        CGFloat scale = height/width;
        width = 1280;
        height = width*scale;
    //3.宽小于1280高大于1280
    }else if(width<1280||height>1280){
        CGFloat scale = width/height;
        height = 1280;
        width = height*scale;
    //4.宽高都小于1280
    }else{
    }
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    [sourceImage drawInRect:CGRectMake(0,0,width,height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //进行图像的画面质量压缩
    NSData *data=UIImageJPEGRepresentation(newImage, 1.0);
    if (data.length>100*1024) {
        if (data.length>1024*1024) {//1M以及以上
            data=UIImageJPEGRepresentation(newImage, 0.7);
        }else if (data.length>512*1024) {//0.5M-1M
            data=UIImageJPEGRepresentation(newImage, 0.8);
        }else if (data.length>200*1024) {
            //0.25M-0.5M
            data=UIImageJPEGRepresentation(newImage, 0.9);
        }
    }
    return data;
}



+(BOOL)is_Iphone_XX
{
    if (@available(iOS 11.0, *)) {
        CGFloat safeAreaInsets_bottom = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom;
        if (safeAreaInsets_bottom>0.0) {
            return YES;
        }
    }
    return NO;
}
+(CGFloat)safeAreaInsets_Bottom
{
    if (@available(iOS 11.0, *)) {
        CGFloat safeAreaInsets_bottom = [[[UIApplication sharedApplication] delegate] window].safeAreaInsets.bottom;
        return safeAreaInsets_bottom;
    }
    return 0.0;
}
@end
