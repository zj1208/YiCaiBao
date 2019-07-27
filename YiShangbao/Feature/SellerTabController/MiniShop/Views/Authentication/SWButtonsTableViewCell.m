//
//  SWButtonsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SWButtonsTableViewCell.h"

NSString *const SWButtonsTableViewCellID = @"SWButtonsTableViewCellID";

@implementation SWButtonsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 45);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [self.confirmButton.layer insertSublayer:gradientLayer atIndex:0];
    
    self.confirmButton.layer.cornerRadius = 22.5;
    self.confirmButton.layer.masksToBounds = YES;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)agreeButtonAction:(id)sender {
    
}

- (IBAction)confirmButtonAction:(id)sender {
    
}

- (IBAction)cancelButtonAction:(id)sender {
    
}


@end
