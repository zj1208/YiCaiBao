//
//  ZXPopoverPresentaionBackgroundView.h
//  YiShangbao
//
//  Created by simon on 2018/9/29.
//  Copyright © 2018年 com.Microants. All rights reserved.
//
//  注意：利用遍历superView的方法修改圆角，蒙层透明度，有可能会有bug，一旦系统控件内部结构修改；每次iOS的SDK更新都要留意变化；


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZXPopoverPresentaionBackgroundView : UIPopoverBackgroundView

// 绘制完箭头显示；
@property (nonatomic, strong) UIImageView *arrowImageView;

@end

NS_ASSUME_NONNULL_END

// 例如：弹出一个自定义popoverBackgroundView的popoverView；
/*
// #import "ZXPopoverPresentaionBackgroundView.h"
// <UIPopoverPresentationControllerDelegate>

// [self displayOptionsForSelectedItem:sender];


- (void)displayOptionsForSelectedItem:(UIButton *)sender
{
    UIStoryboard *sb=[UIStoryboard  storyboardWithName:storyboard_ShopStore  bundle:[NSBundle mainBundle]];
    FansViewController *vc = (FansViewController *) [sb instantiateViewControllerWithIdentifier:SBID_FansViewController];
    vc.shopId = [UserInfoUDManager getShopId];
    vc.modalPresentationStyle = UIModalPresentationPopover;
    vc.preferredContentSize = CGSizeMake(LCDScale_5Equal6_To6plus(160), 250);
    vc.popoverPresentationController.sourceView = sender;
    vc.popoverPresentationController.sourceRect =sender.bounds;
    //    vc.popoverPresentationController.barButtonItem = sender;
    //    vc.popoverPresentationController.backgroundColor = [UIColor blackColor];//一般不设置
    vc.popoverPresentationController.permittedArrowDirections = UIPopoverArrowDirectionUp;
    //    vc.popoverPresentationController.passthroughViews = @[self.tableView];
    vc.popoverPresentationController.delegate = self;
    vc.popoverPresentationController.popoverBackgroundViewClass = [ZXPopoverPresentaionBackgroundView class];
    [self presentViewController:vc animated:YES completion:nil];
}
-(UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller
{
    return UIModalPresentationNone;
}
- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller traitCollection:(UITraitCollection *)traitCollection
{
    return UIModalPresentationNone;
}
*/
