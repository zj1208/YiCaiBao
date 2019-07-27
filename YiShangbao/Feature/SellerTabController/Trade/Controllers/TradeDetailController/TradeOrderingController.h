//
//  TradeOrderingController.h
//  YiShangbao
//
//  Created by simon on 17/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  接单页面

#import <UIKit/UIKit.h>

@interface TradeOrderingController : UIViewController
@property (nonatomic,strong)TradeDetailModel *dataModel;
//历史回复
@property (nonatomic, copy) NSString *reply;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;
@end
