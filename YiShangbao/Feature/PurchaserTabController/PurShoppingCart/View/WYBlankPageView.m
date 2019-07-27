//
//  WYblankPageView.m
//  YiShangbao
//
//  Created by light on 2017/9/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYBlankPageView.h"

@implementation WYBlankPageView

- (id)init{
    self = [super init];
    if (self) {
        [self setUI];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUI];
    }
    return self;
}

- (void)setUI{
    self.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView =[[UIImageView alloc]init];
    [imageView setImage:[UIImage imageNamed:@"searchproductempty"]];
    [self addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(39);
    }];
    
    UILabel *label = [[UILabel alloc]init];
    label.textColor = [UIColor colorWithHex:0x999999];
    label.font = [UIFont systemFontOfSize:14];
    label.font = [UIFont fontWithName:@"PingFangSC-Light" size:14.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.text = @"进货单是空的，这里物美价廉\n快去逛逛市场吧～";
    [self addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(imageView.mas_bottom).offset(30);
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
