//
//  ShopBasicDataTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopBasicDataTableViewCell.h"

NSString *const ShopBasicDataTableViewCellID = @"ShopBasicDataTableViewCellID";

@interface ShopBasicDataTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation ShopBasicDataTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name value:(NSString *)value{
    self.nameLabel.text = name;
    self.valueLabel.text = value;
}

@end
