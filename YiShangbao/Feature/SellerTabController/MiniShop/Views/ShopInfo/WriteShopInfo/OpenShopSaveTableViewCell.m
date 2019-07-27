//
//  OpenShopSaveTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OpenShopSaveTableViewCell.h"

NSString *const OpenShopSaveTableViewCellID = @"OpenShopSaveTableViewCellID";

@implementation OpenShopSaveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.saveButton.layer.cornerRadius = 18.0f;
    self.saveButton.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
