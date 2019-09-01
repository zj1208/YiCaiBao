//
//  UIViewController+ZXHelper.h
//  Baby
//
//  Created by simon on 16/2/24.
//  Copyright © 2016年 simon. All rights reserved.
//
// 2018.01.04 修改优化方法；
// 2019.06.11 增加连续present的最后页面dismiss到最初的页面；

#import <UIKit/UIKit.h>
@import StoreKit;
#import "UIViewController+ZXSystemBackButtonAction.h"

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (ZXHelper)<SKStoreProductViewControllerDelegate,UIActionSheetDelegate>
/**
 *  storyboard跳转-push
 *
 *  @param name  storyboardName
 *  @param storyboardId  storyboardID
 *  @param data  参数－dictionary格式
 */
- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data;


/**
 同上 storyboard跳转-push；

 @param name storyboardName
 @param storyboardId storyboardID
 @param data 参数－dictionary格式;kvc传值；
 @param toControllerBlock 返回目标controller
 */
- (void)zx_pushStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId withData:(nullable NSDictionary *)data toController:(void(^ __nullable)(UIViewController *vc))toControllerBlock;


/**
 同上storyboard跳转-present

 @param name name description
 @param storyboardId storyboardId description
 @param flag 是否有导航navigationController
 @param data 参数－dictionary格式;kvc传值；
 @param completion 跳转完成
 */
- (void)zx_presentStoryboardViewControllerWithStoryboardName:(NSString *)name identifier:(nullable NSString *)storyboardId isNavigationController:(BOOL)flag withData:(nullable NSDictionary *)data completion:(void(^ __nullable)(void))completion;


/**
 根据storyboardId获取controller

 @param name name description
 @param storyboardId storyboardId description
 @return return value description
 */
- (UIViewController *)zx_getControllerWithStoryboardName:(NSString *)name controllerWithIdentifier:(nullable NSString *)storyboardId;



/**
 *  过滤modalController的返回；如果是模态的，则dismiss；
 */
- (void)zx_goBackPreController;


/**
 去appStore
 */
- (void)zx_goAppStoreWithAppId:(NSString *)appId;


/**
 拨打电话，是否需要添加actionSheet提示

 @param phone 电话号码
 @param alertController 是否需要添加UIAlertController提示 
 // UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"提示", nil) message:NSLocalizedString(@"您还没有登录，是否需要登录", nil) preferredStyle:UIAlertControllerStyleAlert];

 */
- (void)zx_callIphone:(NSString *)phone withAlertController:(UIAlertController *)alertController;


/**
 回退到根控制器
 */
- (void)zx_dismissToRootViewController;
@end


NS_ASSUME_NONNULL_END

