//
//  SWInfoTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SWInfoTableViewCell.h"

NSString *const SWInfoTableViewCellID = @"SWInfoTableViewCellID";

@implementation SWInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.titleLabel.text = NSLocalizedString(@"最高可借20万，随借随还！\n极速放贷，资金短缺不求人！", @"");
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
