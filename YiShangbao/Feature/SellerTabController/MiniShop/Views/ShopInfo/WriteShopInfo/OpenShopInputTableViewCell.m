//
//  OpenShopInputTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OpenShopInputTableViewCell.h"

NSString *const OpenShopInputTableViewCellID = @"OpenShopInputTableViewCellID";

@interface OpenShopInputTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation OpenShopInputTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateTitle:(NSString *)title content:(NSString *)content placeholder:(NSString *)placeholder{
    self.titleLabel.text = title;
    self.textField.text = content;
    self.textField.placeholder = placeholder;
}

@end
