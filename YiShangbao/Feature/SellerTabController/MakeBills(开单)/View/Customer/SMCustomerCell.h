//
//  SMCustomerCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SMCustomerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *iconBtn;

@property (weak, nonatomic) IBOutlet UILabel *companyNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyTop;

- (void)setData:(id)data;

@end
