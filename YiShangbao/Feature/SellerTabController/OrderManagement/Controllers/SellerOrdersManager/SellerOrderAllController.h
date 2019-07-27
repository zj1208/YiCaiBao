//
//  SellerOrderAllController.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerOrderAllController : UIViewController

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//订单列表类型
@property (nonatomic, assign) SellerOrderListStatus orderListStatus;


@property (nonatomic, copy) NSString *nTitle;
@end
