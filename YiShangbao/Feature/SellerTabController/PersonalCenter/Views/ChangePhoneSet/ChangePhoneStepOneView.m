//
//  ChangePhoneStepOneView.m
//  YiShangbao
//
//  Created by 何可 on 2017/6/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangePhoneStepOneView.h"

@implementation ChangePhoneStepOneView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    self.scroll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    //更改密码上部
    self.viewbg = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.viewbg];
    self.viewbg.backgroundColor = [UIColor whiteColor];
    
    //电话
    self.codeCell = [[CountryCell alloc] init];
    [self.scroll_bg addSubview:self.codeCell];
    
    self.txtField_phoneNumber = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_phoneNumber];
    self.txtField_phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    [WYUIStyle setTextFieldWithNoImagePl:@"输入手机号" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_phoneNumber];
    
    self.linephone = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linephone];
    
    //发送验证码
    self.txtField_smsNumber = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_smsNumber];
    self.txtField_smsNumber.keyboardType = UIKeyboardTypeNumberPad;
    [WYUIStyle setTextFieldWithNoImagePl:@"输入短信验证码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_smsNumber];
    
    self.linesend = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linesend];
    self.linesend.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1.0];
    
    self.btn_send = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_send];
    [self.btn_send setTitleColor:[UIColor colorWithRed:0.97 green:0.51 blue:0.21 alpha:1.0] forState:UIControlStateNormal];
    [self.btn_send.titleLabel setFont:WYUISTYLE.fontWith28];
    [self.btn_send setTitle:@"获取验证码" forState:UIControlStateNormal];
    
    self.linesms = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linesms];
    
    self.btn_confirm = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_confirm];
    self.btn_confirm =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
    [self.btn_confirm setTitle:@"下一步" forState:UIControlStateNormal];
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btn_confirm.layer.masksToBounds= YES;
    self.btn_confirm.layer.cornerRadius =20.f;
    self.btn_confirm.layer.borderColor =[UIColor clearColor].CGColor;
    [self.scroll_bg addSubview:self.btn_confirm];
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    [self.btn_confirm setBackgroundImage:[WYUIStyle imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]] forState:UIControlStateNormal];
    self.btn_confirm.userInteractionEnabled = NO;
    
    
    //样式
    self.linephone.backgroundColor = self.linesms.backgroundColor = WYUISTYLE.colorLinegrey;

    //位置
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    [self.viewbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll_bg.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(90));
    }];
    
    //手机号码
    [self.codeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewbg.mas_top);
        make.left.equalTo(@12);
        make.width.equalTo(@76);
        make.height.equalTo(@45);
    }];
    [self.txtField_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewbg.mas_top);
        make.left.equalTo(self.codeCell.mas_right);
        make.right.equalTo(self.btn_send.mas_left).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.linephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_phoneNumber.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    //短信验证码
    [self.txtField_smsNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linephone.mas_bottom);
        make.left.equalTo(@12);
        make.right.equalTo(self.linesend).offset(-15);
        make.height.equalTo(@(45));
    }];
    
    [self.linesend mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txtField_smsNumber.mas_centerY);
        make.right.equalTo(self.btn_send.mas_left).offset(-15);
        make.width.equalTo(@0.5);
        make.height.equalTo(@20);
    }];
    
    [self.btn_send mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txtField_smsNumber.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@80);
    }];
    
    //确认
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_smsNumber.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@40);
    }];
    
    return self;
}

@end
