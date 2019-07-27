//
//  MakeBillServiceExpireViewController.h
//  YiShangbao
//
//  Created by light on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MakeBillServiceViewController.h"

@protocol MakeBillServiceExpireViewControllerDelegate <NSObject>
@optional

- (void)serviceExpireSelectType:(WYServiceSelectedType)type;

@end

@interface MakeBillServiceExpireViewController : UIViewController

@property (nonatomic, weak) id<MakeBillServiceExpireViewControllerDelegate> delegate;

- (void)addServiceInfo:(WYServicePlaceOrderModel *)model;

@end
