//
//  MakeBillRemarkCell.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillRemarkCell.h"

NSString *const MakeBillRemarkCellID = @"MakeBillRemarkCellID";

@interface MakeBillRemarkCell()

@end

@implementation MakeBillRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.remarkTextView.placeholder = @"请输入备注信息";
    self.remarkTextView.placeholderColor = [UIColor colorWithHex:0xC2C2C2];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
