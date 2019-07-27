//
//  BuyerPageMenuController.h
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuyerPageMenuController : UIViewController


@property (nonatomic, assign) PurchaserOrderListStatus orderListStatus;


@property (nonatomic, assign) NSInteger selectIndex;

- (void)setSelectedPageIndexWithOrderListStatus:(PurchaserOrderListStatus)status;
@end
