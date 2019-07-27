//
//  MakeBillButtonTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillButtonTableViewCell.h"

NSString *const MakeBillButtonTableViewCellID = @"MakeBillButtonTableViewCellID";

@implementation MakeBillButtonTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self != nil){
        self.backgroundColor = [UIColor clearColor];
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.saveButton = [[UIButton alloc]init];
        [self.contentView addSubview:self.saveButton];
        [self.saveButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(50);
            make.left.equalTo(self.contentView).offset(15);
            make.right.equalTo(self.contentView).offset(-15);
            make.height.equalTo(@45.0);
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30 , 45);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
        [self.saveButton.layer insertSublayer:gradientLayer atIndex:0];
        self.saveButton.layer.cornerRadius = 22.5;
        self.saveButton.layer.masksToBounds = YES;
        
        [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
