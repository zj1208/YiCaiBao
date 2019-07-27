//
//  WYTabBarViewController.h
//  YiShangbao
//
//  Created by Lance on 16/12/7.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
static NSInteger const shopTabIndex =0;
static NSInteger const messageTabIndex =1;
static NSInteger const fuWuTabIndex =2;
static NSInteger const mineTabIndex =3;

@interface WYTabBarViewController : UITabBarController

+ (instancetype)sharedInstance;

@end
