//
//  ServiceHeadView.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ServiceHeadView.h"

@implementation ServiceHeadView

-(id)init{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    _titleLabel = [[UILabel alloc]init];
    [self addSubview:_titleLabel];
    _titleLabel.font = [UIFont systemFontOfSize:16.0];
    _titleLabel.textColor = [UIColor colorWithHex:0x333333];
    
    _moreImageView = [[UIImageView alloc]init];
    [self addSubview:_moreImageView];
    
    _btnMore = [[UIButton alloc] init];
    [self addSubview:self.btnMore];

    
    _line = [[UIView alloc] init];
    [self addSubview:_line];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.centerY.equalTo(self);
    }];
    
    [self.moreImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(-15);
        make.centerY.equalTo(self);
    }];

    [self.btnMore mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-15);
        make.width.equalTo(@40);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [_moreImageView setImage:[UIImage imageNamed:@"searchmoreLight"]];
    
    [_btnMore setTitle:@"更多" forState:UIControlStateNormal];
//    [_btnMore setImage:[UIImage imageNamed:@"searchmoreLight"] forState:UIControlStateNormal];
    [_btnMore setTitleColor:[UIColor colorWithHex:0x999999] forState:UIControlStateNormal];
    [_btnMore.titleLabel setFont:WYUISTYLE.fontWith24];
    _line.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
    
    _btnMore.imageEdgeInsets = UIEdgeInsetsMake(0, _btnMore.titleLabel.frame.size.width, 0, -_btnMore.titleLabel.frame.size.width);
    _btnMore.titleEdgeInsets = UIEdgeInsetsMake(0, -_btnMore.imageView.frame.size.width, 0, _btnMore.imageView.frame.size.width);
    
    return  self;
}

-(void)headViewUITitle:(NSString *)title{
    _titleLabel.text = title;
}
@end
