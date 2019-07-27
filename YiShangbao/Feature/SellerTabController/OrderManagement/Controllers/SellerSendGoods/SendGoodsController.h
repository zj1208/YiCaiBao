//
//  SendGoodsController.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendGoodsController : UIViewController


@property (nonatomic, copy) NSString *bizOrderId;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@end
