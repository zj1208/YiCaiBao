//
//  SellerPageMenuController.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellerPageMenuController : UIViewController


@property (nonatomic, assign) SellerOrderListStatus orderListStatus;


- (void)setSelectedPageIndexWithOrderListStatus:(SellerOrderListStatus)status;

@end
