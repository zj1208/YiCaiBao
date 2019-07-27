//
//  WYPayWayHeaderView.m
//  YiShangbao
//
//  Created by light on 2017/9/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPayWayHeaderView.h"

@implementation WYPayWayHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        self.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.1];
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        
        
        UILabel *titleLabel = [[UILabel alloc]init];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.text = @"支付金额";
        titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        titleLabel.font = [UIFont systemFontOfSize:18.0];
        [backView addSubview:titleLabel];
        
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.textAlignment = NSTextAlignmentCenter;
        self.priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
        self.priceLabel.font = [UIFont systemFontOfSize:28.0];
        [backView addSubview:self.priceLabel];
        
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        [self addSubview:line];
        
        UILabel *wayLabel = [[UILabel alloc]init];
        wayLabel.textColor = [UIColor colorWithHex:0x868686];
        wayLabel.font = [UIFont systemFontOfSize:14.0];
        wayLabel.text = @"请选择支付方式";
        [self addSubview:wayLabel];
        
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@124);
        }];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).offset(21);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-36);
            make.height.equalTo(@0.5);
        }];
        
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(backView);
            make.top.equalTo(backView).offset(62);
        }];
        
        [wayLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.bottom.equalTo(self).offset(-8);
        }];
        
        
    }
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
