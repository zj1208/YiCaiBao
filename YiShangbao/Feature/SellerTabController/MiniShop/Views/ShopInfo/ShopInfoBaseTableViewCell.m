//
//  ShopInfoBaseTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopInfoBaseTableViewCell.h"

NSString *const ShopInfoBaseTableViewCellID = @"ShopInfoBaseTableViewCellID";

@interface ShopInfoBaseTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redPointImageView;

@end

@implementation ShopInfoBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setName:(NSString *)name value:(NSString *)value isHiddenRed:(BOOL)isShow{
    self.nameLabel.text = name;
    self.valueLabel.text = value;
    self.redPointImageView.hidden = isShow;
}

@end
