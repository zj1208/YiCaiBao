//
//  BankAccountAddTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BankAccountAddTableViewCell.h"


@implementation BankAccountAddTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
        self.backgroundColor = WYUISTYLE.colorBGgrey;
            self.btn_all = [[UIButton alloc]init];
            [self addSubview:self.btn_all];
            [self.btn_all setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
            [self.btn_all setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
            [self.btn_all setTitle:@"添加银行卡" forState:UIControlStateNormal];
            [self.btn_all.titleLabel setFont:WYUISTYLE.fontWith36];
            [self.btn_all.titleLabel setTextAlignment:NSTextAlignmentCenter];
            self.btn_all.titleEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, 0);
        
        [self.btn_all mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.centerY.equalTo(self.mas_centerY);
        }];
    return self;
}

@end

