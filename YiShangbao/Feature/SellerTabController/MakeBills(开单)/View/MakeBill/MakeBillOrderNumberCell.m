//
//  MakeBillOrderNumberCell.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillOrderNumberCell.h"

NSString *const MakeBillOrderNumberCellID = @"MakeBillOrderNumberCellID";

@interface MakeBillOrderNumberCell ()

@property (weak, nonatomic) IBOutlet UILabel *orderNumberLabel;

@end

@implementation MakeBillOrderNumberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(NSString *)orderNumber{
    self.orderNumberLabel.text = orderNumber;
}

@end
