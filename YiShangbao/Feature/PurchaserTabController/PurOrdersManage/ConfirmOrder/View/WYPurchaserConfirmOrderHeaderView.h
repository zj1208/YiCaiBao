//
//  WYPurchaserConfirmOrderHeaderView.h
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WYPurchaserConfirmOrderHeaderViewID;

@protocol WYPurchaserConfirmOrderHeaderViewDelegate <NSObject>

@optional

- (void)goShopId:(NSString *)shopId;

@end

@interface WYPurchaserConfirmOrderHeaderView : UITableViewHeaderFooterView
@property (nonatomic ,weak) id<WYPurchaserConfirmOrderHeaderViewDelegate> delegate;

- (void)updateData:(id)model;

@end
