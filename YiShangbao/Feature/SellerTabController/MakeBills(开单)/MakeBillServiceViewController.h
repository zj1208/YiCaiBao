//
//  MakeBillServiceViewController.h
//  YiShangbao
//
//  Created by light on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class WYPublicModel;
#import "WYPublicModel.h"

typedef NS_ENUM(NSInteger, WYServiceSelectedType){
    WYServiceSelectedTypeCancel = 0,           //
    WYServiceSelectedTypeBuy = 1,      //
    WYServiceSelectedTypeUrl = 2,        //
};

@protocol MakeBillServiceViewControllerDelegate <NSObject>
@optional

- (void)serviceSelectType:(WYServiceSelectedType)type;

@end

@interface MakeBillServiceViewController : UIViewController

@property (nonatomic, strong) id<MakeBillServiceViewControllerDelegate> delegate;
- (void)addServiceInfo:(WYServicePlaceOrderModel *)model;

@end
