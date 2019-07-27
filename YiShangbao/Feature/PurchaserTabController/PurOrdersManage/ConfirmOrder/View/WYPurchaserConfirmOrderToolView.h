//
//  WYPurchaserConfirmOrderToolView.h
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPurchaserConfirmOrderToolView : UIView

@property (nonatomic ,strong) UIButton *settleAccountsButton;

- (void)settleAccountsButtonIsTouch:(BOOL)isTouch;

- (void)updateData:(id)model;

@end
