//
//  ShopFunctionTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopFunctionTableViewCell.h"

NSString *const ShopFunctionTableViewCellID = @"ShopFunctionTableViewCellID";

@interface ShopFunctionTableViewCell ()

@end

@implementation ShopFunctionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self changeLayoutWithButton:self.businessInformationButton];
    [self changeLayoutWithButton:self.shopNoticesButton];
    [self changeLayoutWithButton:self.shopRealPhotoButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)changeLayoutWithButton:(UIButton *)btn{
//    CGSize titleSize = btn.titleLabel.frame.size;
    CGSize imageSize = btn.imageView.frame.size;
    
    [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -imageSize.width, -(imageSize.height + 10), 0)];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(0, 53.5/2, 16 + 10, -53.5/2)];
    
}

@end
