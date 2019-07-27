//
//  WYPurchaserReceiverInformationView.h
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPurchaserReceiverInformationView : UIView

@property (nonatomic ,strong) UILabel *addressLabel;
@property (nonatomic ,strong) UIButton *editButton;

- (void)updateData:(id)model;

@end
