//
//  WYPurchaserMainViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZXBadgeIconButton.h"

@interface WYPurchaserMainViewController : UIViewController
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CustomBarTopLay;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *searchBotton_ruzhuTopLay;

@property (weak, nonatomic) IBOutlet UIView *customBarContentView; //H=121
@property (weak, nonatomic) IBOutlet UIImageView *naviBackgroundImageView;

@property (weak, nonatomic) IBOutlet UIView *stateView; //状态栏
@property (weak, nonatomic) IBOutlet UIView *CustomNavigationBar;
@property (weak, nonatomic) IBOutlet UIView *funContentView;

@property (weak, nonatomic) IBOutlet ZXBadgeIconButton *messageBadgeView;//消息
@property (weak, nonatomic) IBOutlet UIButton *scanQRBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *switchIdentitiesBtn;

@property (weak, nonatomic) IBOutlet UILabel *ruzhuLabel;


@end
