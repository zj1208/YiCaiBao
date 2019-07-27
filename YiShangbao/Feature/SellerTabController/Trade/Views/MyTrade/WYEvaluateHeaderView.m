//
//  WYEvaluateHeaderView.m
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYEvaluateHeaderView.h"
NSString *const WYEvaluateHeaderViewID = @"WYEvaluateHeaderViewID";

@interface WYEvaluateHeaderView ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UIImageView *hideImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *hideLabel;

@end

@implementation WYEvaluateHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(25.0);
            make.centerY.equalTo(self.contentView);
        }];
        self.nameLabel.textColor = [UIColor colorWithHex:0x535353];
        self.nameLabel.font = [UIFont systemFontOfSize:14.0];
        self.nameLabel.text = @"评价采购商";
        
        self.hideLabel = [[UILabel alloc]init];
        [self.contentView addSubview:self.hideLabel];
        [self.hideLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).offset(-15.0);
            make.centerY.equalTo(self.contentView);
        }];
        self.hideLabel.textColor = [UIColor colorWithHex:0x8E8E8E];
        self.hideLabel.font = [UIFont systemFontOfSize:14.0];
        self.hideLabel.text = @"匿名评价";
        
        self.iconImageView = [[UIImageView alloc]init];
        [self.contentView addSubview:self.iconImageView];
        [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).offset(15.0);
            make.centerY.equalTo(self.contentView);
            make.width.equalTo(@3.5);
            make.height.equalTo(@15.0);
        }];
        [self.iconImageView setImage:[UIImage imageNamed:@"ic_line"]];
        
//        self.hideImageView = [[UIImageView alloc]init];
//        [self.contentView addSubview:self.hideImageView];
//        [self.hideImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.right.equalTo(self.hideLabel.mas_left).offset(-7.0);
//            make.centerY.equalTo(self.contentView);
//            make.width.equalTo(@11.5);
//            make.height.equalTo(@10.0);
//        }];
//        [self.hideImageView setImage:[UIImage imageNamed:@"ic_yincang"]];
        
        UIView *line = [[UIView alloc]init];
        [self.contentView addSubview:line];
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
            make.bottom.equalTo(self.contentView);
            make.height.equalTo(@0.5);
        }];
        line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        
        self.contentView.backgroundColor = [UIColor whiteColor];
//        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
