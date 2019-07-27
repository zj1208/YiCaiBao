//
//  MyCustomerAddHeadCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MyCustomerAddHeadCell.h"

@implementation MyCustomerAddHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 20.5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
