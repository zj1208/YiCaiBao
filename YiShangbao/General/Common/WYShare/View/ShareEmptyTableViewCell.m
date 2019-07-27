//
//  shareEmptyTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShareEmptyTableViewCell.h"

NSString *const ShareEmptyTableViewCellID = @"ShareEmptyTableViewCellID";

@implementation ShareEmptyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
