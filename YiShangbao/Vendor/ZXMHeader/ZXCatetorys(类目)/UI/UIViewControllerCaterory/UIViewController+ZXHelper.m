//
//  UIViewController+ZXHelper.m
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//

#import "UIViewController+ZXHelper.h"
#import "MBProgressHUD+ZXCategory.h"


//iTunesLink 链接－－iTunesLink＋appID，ios6以后有直接跳转appStore的item应用Controller页面
#ifndef ITUNESLINK
#define ITUNESLINK @"http://itunes.apple.com/cn/app/id"
#endif

@implementation UIViewController (ZXHelper)

- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (controller)
    {
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        controller.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(NSDictionary *)data toController:(void(^ __nullable)(UIViewController *vc))toControllerBlock
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (toControllerBlock)
    {
        toControllerBlock(controller);
    }
    [self zx_pushStoryboardViewControllerWithStoryboardName:name identifier:storyboardId withData:data];
}


- (void)zx_presentStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId isNavigationController:(BOOL)flag withData:(nullable NSDictionary *)data completion:(void(^ __nullable)(void))completion
{
    UIViewController *controller = [self zx_getControllerWithStoryboardName:name controllerWithIdentifier:storyboardId];
    if (controller)
    {
        if (data)
        {
            [data enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                
                [controller setValue:obj forKey:key];
            }];
        }
        if (flag)
        {
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nav animated:YES completion:completion];
        }
        else
        {
            [self presentViewController:controller animated:YES completion:completion];
        }
    }
}

-(UIViewController *)zx_getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(nullable NSString *)storyboardId
{
    if (!name)
    {
        assert(name);
        return nil;
    }
    NSURL *resoureUrl = [[NSBundle mainBundle] URLForResource:name withExtension:@"storyboardc"];
    NSError  *error = nil;
    if ([resoureUrl checkResourceIsReachableAndReturnError:&error]==NO)
    {
        NSDictionary *userInfo = @{NSLocalizedFailureReasonErrorKey: NSLocalizedStringFromTable(@"File URL not reachable.", @"", nil)};
        error = [[NSError alloc] initWithDomain:NSCocoaErrorDomain code:NSURLErrorBadURL userInfo:userInfo];
        NSLog(@"%@",error);
        return nil;
    }
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:name  bundle:[NSBundle mainBundle]];
    if (storyboardId)
    {
        return  [sb instantiateViewControllerWithIdentifier:storyboardId];
    }
    return [sb instantiateInitialViewController];
}
//


- (void)pushSameStoryboardPerformSegueWithIdentifier:(NSString *)segue withData:(NSDictionary *)data
{
    
}


- (void)zx_goBackPreController
{
    if (self.presentingViewController)
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}


#pragma mark - SKStoreProductViewController
- (void)zx_goAppStoreWithAppId:(NSString *)appId
{
    Class skStore = NSClassFromString(@"SKStoreProductViewController");
    UIDevice *device = [UIDevice currentDevice];
    device.proximityMonitoringEnabled = YES;
    //用近距离传感器来判断是否是真机
    if (device.isProximityMonitoringEnabled && skStore)
    {
        [MBProgressHUD zx_showLoadingWithStatus:@"正在载入" toView:self.view];
        __weak __typeof(self)weakSelf = self;
        
        SKStoreProductViewController *skStoreProductVC = [[SKStoreProductViewController alloc] init];
        skStoreProductVC.delegate = self;
        [skStoreProductVC loadProductWithParameters:@{SKStoreProductParameterITunesItemIdentifier:appId} completionBlock:^(BOOL result, NSError *error) {
            
            [MBProgressHUD hideHUDForView:weakSelf.view animated:YES];
            if (result)
            {
                [weakSelf presentViewController:skStoreProductVC animated:YES completion:nil];
            }
            if (error)
            {
                [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
            }
        }];
        
    }
    else
    {
        NSURL *url =[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",ITUNESLINK,appId]];
        
        if ([[UIApplication sharedApplication] canOpenURL:url])
        {
            if ([[[UIDevice currentDevice] systemVersion]floatValue]>=10.f)
            {
                [[UIApplication sharedApplication]openURL:url options:@{UIApplicationOpenURLOptionUniversalLinksOnly:@(YES)} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:url];
            }
        }
    }
    device.proximityMonitoringEnabled = NO;
    
}



//取消按钮
- (void)productViewControllerDidFinish:(SKStoreProductViewController *)viewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
}





- (void)zx_callIphone:(NSString *)phone withAlertController:(UIAlertController *)alertController
{
    if (phone && phone.length>0)
    {
        if (!alertController)
        {
            NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
        }
        else
        {            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            }];
            UIAlertAction *otherAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                NSString *allString = [NSString stringWithFormat:@"tel:%@",phone];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:allString]];
                
            }];
            [alertController addAction:cancelAction];
            [alertController addAction:otherAction];
            [self presentViewController:alertController animated:YES completion:nil];

        }

    }
}



/**
 回退到根控制器;
 1）原理上是presentingViewController对象负责dismiss，即使你用presentedViewController对象调用dismiss方法；
 2）如果您连续prensent呈现几个视图控制器，从而构建一个呈现的视图控制器堆栈，那么在堆栈中较低的视图控制器上调用此方法将会丢弃它的当前子视图控制器以及堆栈中该子视图控制器之上的所有视图控制器。
 例如：A页面prenset到页面B-B又prenset到C-C又prensent到D;只要A调用dismissViewController方法就会移除堆栈中该子视图控制器之上的所有控制器B，C，D；
 */
- (void)zx_dismissToRootViewController
{
    UIViewController *vc = self;
    while (vc.presentingViewController) {
        vc = vc.presentingViewController;
    }
    [vc dismissViewControllerAnimated:YES completion:nil];
}
@end
