//
//  RefundingDetailController.h
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  退款详情

#import <UIKit/UIKit.h>

@interface RefundingDetailController : UIViewController


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, copy) NSString *bizOrderId;


@end
