//
//  PurRefundReasonViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PurRefundReasonViewController;
@protocol PurRefundReasonViewControllerDelegate <NSObject>

-(void)jl_PurRefundReasonViewController:(PurRefundReasonViewController*)purRefundReasonViewController viewWillRemoveWithSelString:(NSString*)str didSelectedInteger:(NSInteger)integer;

@end
@interface PurRefundReasonViewController : UIViewController
@property(nonatomic,weak)id<PurRefundReasonViewControllerDelegate>delegate;

-(void)showToViewController:(UIViewController *)viewController WithAnimated:(BOOL)animated;

@end
