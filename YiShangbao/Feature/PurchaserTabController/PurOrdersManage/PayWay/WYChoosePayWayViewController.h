//
//  WYChoosePayWayViewController.h
//  YiShangbao
//
//  Created by light on 2017/9/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYChoosePayWayViewController : UIViewController

@property (nonatomic ,copy) NSString *orderId;
@property (nonatomic ,copy) NSString *priceString;

@end


//WYChoosePayWayViewController *payWayVC = [[WYChoosePayWayViewController alloc]init];
//payWayVC.orderId = @"83479812355000020";//订单号
//payWayVC.priceString = @"¥11.1";//待支付金额
//self.hidesBottomBarWhenPushed = YES;
//[self.navigationController pushViewController:payWayVC animated:YES];
