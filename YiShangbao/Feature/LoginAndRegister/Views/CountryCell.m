//
//  CountryCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CountryCell.h"

@implementation CountryCell

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    self.btn = [[UIButton alloc] init];
    [self addSubview:self.btn];
    
    self.label = [[UILabel alloc] init];
    [self addSubview:self.label];
    self.label.text = @"+86";
    self.label.font = [UIFont systemFontOfSize:15];
    self.label.textColor = [UIColor colorWithHex:0xE23728];
    
    self.image = [[UIImageView alloc] init];
    [self addSubview:self.image];
    self.image.image = [UIImage imageNamed:@"pic_kuaijieanniu"];
    
    self.line = [[UIView alloc] init];
    [self addSubview:self.line];
    self.line.backgroundColor = [UIColor colorWithRed:0.90 green:0.90 blue:0.90 alpha:1.0];
    
    //位置
    [self.btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.top.equalTo(self.mas_top);
        make.width.equalTo(self.mas_width);
        make.height.equalTo(self.mas_height);
    }];
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right).offset(-10);
        make.centerY.equalTo(self.mas_centerY);
    }];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image.mas_right).offset(5);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@0.5);
        make.height.equalTo(@20);
    }];
    return self;
}

@end
