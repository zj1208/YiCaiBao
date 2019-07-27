//
//  SMAddCustomerCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMAddCustomerCell.h"

@implementation SMAddCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    
    self.iconBtn.selected = selected;
}

@end
