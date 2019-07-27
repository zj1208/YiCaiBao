//
//  ZXModalPresentaionController.h
//  YiShangbao
//
//  Created by simon on 2018/8/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  优点：封装转场通过管理类可以通用于一种场景：遮罩+可以设置frame的业务控制器的整个view；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXModalPresentaionController : UIPresentationController

// 设置弹出的presentedView的frame大小位置；
@property (nonatomic, assign) CGRect frameOfPresentedView;
@end

NS_ASSUME_NONNULL_END

/*
 #import "ZXModalPresentaionController.h"
<UIViewControllerTransitioningDelegate>
// 预览
- (void)previewBtnAction:(UIButton *)sender
{
    ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
    alertView.modalPresentationStyle = UIModalPresentationCustom;
    alertView.transitioningDelegate = self;
    __block ZXNotiAlertViewController *SELF = alertView;
    alertView.cancleActionHandleBlock = ^{
        
        [SELF dismissViewControllerAnimated:YES completion:nil];
    };
    [self presentViewController:alertView animated:YES completion:nil];
 }
//转场管理器
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZXModalPresentaionController *presentation =  [[ZXModalPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    presentation.frameOfPresentedView = CGRectMake(0, LCDH-300, LCDW, 300);
    return presentation;
}
 */
