//
//  WYSearchCategoryHeaderView.m
//  YiShangbao
//
//  Created by light on 2017/10/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSearchCategoryHeaderView.h"
NSString * const WYSearchCategoryHeaderViewID = @"WYSearchCategoryHeaderViewID";

@interface WYSearchCategoryHeaderView()

@property (nonatomic, strong) UIView *icon;

@end

@implementation WYSearchCategoryHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.icon = [[UIView alloc]init];
    [self.contentView addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.centerY.equalTo(self.contentView);
        make.width.equalTo(@5);
        make.height.equalTo(@15);
    }];
    
    
    self.titleLabel = [[UILabel alloc]init];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(26);
        make.centerY.equalTo(self.contentView);
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, 5, 15);
    [self.icon.layer addSublayer:gradientLayer];
    
    self.icon.layer.masksToBounds= YES;
    self.icon.layer.cornerRadius = 2.5f;
    self.icon.backgroundColor = [UIColor colorWithHex:0xFE5147];
    
    self.titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.titleLabel.font = [UIFont systemFontOfSize:15.0];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
