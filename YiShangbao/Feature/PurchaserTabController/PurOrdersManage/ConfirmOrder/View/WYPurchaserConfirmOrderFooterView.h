//
//  WYPurchaserConfirmOrderFooterView.h
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString * const WYPurchaserConfirmOrderFooterViewID;

@protocol WYPurchaserConfirmOrderFooterViewDelegate <NSObject>
@optional

- (void)updateQuantity:(NSInteger)quantity;

@end

@interface WYPurchaserConfirmOrderFooterView : UITableViewHeaderFooterView

@property (nonatomic ,strong) UIView *countView;

@property (nonatomic ,weak) id<WYPurchaserConfirmOrderFooterViewDelegate> delegate;

- (void)updateData:(id)model;

@end
