//
//  SetBankAccountView.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SetBankAccountView.h"

@implementation SetBankAccountView

- (id)init {
    self = [super init];
    if (!self) return nil;
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.scorll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scorll_bg];
    self.scorll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.cell_bank = [[CommonListCell alloc] init];
    [self.scorll_bg addSubview:self.cell_bank];
    self.cell_bank.title.text = @"*银行";
    self.cell_bank.subTitle.text = @"请选择银行";
    
    self.cell_openbank = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_openbank];
    self.cell_openbank.title.text = @"支行名称";
    self.cell_openbank.input.placeholder = @"请输入支行名称";
    
    self.cell_openName = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_openName];
    self.cell_openName.title.text = @"*户名";
    self.cell_openName.input.placeholder = @"请输入姓名";
    
    self.cell_bankID = [[CommonListNoArrowCell alloc] init];
    [self.scorll_bg addSubview:self.cell_bankID];
    self.cell_bankID.title.text = @"*卡号";
    self.cell_bankID.input.placeholder = @"请输入卡号";
    self.cell_bankID.input.keyboardType = UIKeyboardTypeNumberPad;
    
    self.btn_confirm = [[UIButton alloc]init];
    [self addSubview:self.btn_confirm];
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    [self.btn_confirm setBackgroundImage:[UIImage imageNamed:@"按钮"] forState:UIControlStateNormal];
    [self.btn_confirm setTitle:@"确 认" forState:UIControlStateNormal];
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btn_confirm.titleEdgeInsets = UIEdgeInsetsMake(-6, 0, 0, 0);
    

    //位置
    self.scorll_bg.contentSize = CGSizeMake(SCREEN_WIDTH, 520);
    [self.scorll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.cell_bank mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_openbank mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_bank.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_openName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_openbank.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.cell_bankID mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(self.cell_openName.mas_bottom);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@44);
    }];
    
    [self.btn_confirm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.cell_bankID.mas_bottom).offset(43);
    }];
    return self;
}

-(void)setData:(AcctInfoModel *)data{
    self.cell_openName.input.text = data.acctName;
    self.cell_bank.subTitle.text = data.bankValue;
    self.cell_bank.subTitle.textColor = WYUISTYLE.colorMTblack;
    self.cell_openbank.input.text = data.bankPlace;
    self.cell_bankID.input.text = data.bankNo;
}
@end
