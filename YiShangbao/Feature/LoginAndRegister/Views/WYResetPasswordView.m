//
//  WYResetPasswordView.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYResetPasswordView.h"

@interface WYResetPasswordView()


@end

@implementation WYResetPasswordView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    self.scroll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.viewbg = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.viewbg];
    self.viewbg.backgroundColor = [UIColor whiteColor];
    
    self.txtField_newPswd = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_newPswd];
    self.btn_newHide = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_newHide];
    self.linepswd = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linepswd];
    
    self.txtField_againPswd = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_againPswd];
    self.btn_againHide = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_againHide];
    self.lineagainpswd = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.lineagainpswd];
    
    self.lbl_notice = [[UILabel alloc] init];
    [self.scroll_bg addSubview:self.lbl_notice];
    
    self.btn_confirm = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_confirm];
    
    
    //样式
    self.linepswd.backgroundColor = self.lineagainpswd.backgroundColor = WYUISTYLE.colorLinegrey;
    
    self.txtField_newPswd.secureTextEntry = YES;
    [WYUIStyle setTextFieldWithNoImagePl:@"请设置新密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_newPswd];
    [self.btn_newHide setImage:[UIImage imageNamed:@"明文密码"] forState:UIControlStateNormal];
    [self.btn_newHide setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
    [self.btn_newHide setSelected:YES];

    self.txtField_againPswd.secureTextEntry = YES;
    [WYUIStyle setTextFieldWithNoImagePl:@"请再次输入密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_againPswd];
    [self.btn_againHide setImage:[UIImage imageNamed:@"明文密码"] forState:UIControlStateNormal];
    [self.btn_againHide setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
    [self.btn_againHide setSelected:YES];

    
    self.lbl_notice.text = @"6~20位的密码，建议数字、字母组合";
    self.lbl_notice.textColor = WYUISTYLE.colorMred;
    self.lbl_notice.font = WYUISTYLE.fontWith24;
    
    
    self.btn_confirm = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_confirm];
    self.btn_confirm =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
    [self.btn_confirm setTitle:@"完 成" forState:UIControlStateNormal];
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btn_confirm.layer.masksToBounds= YES;
    self.btn_confirm.layer.cornerRadius =20.f;
    self.btn_confirm.layer.borderColor =[UIColor clearColor].CGColor;
    [self.scroll_bg addSubview:self.btn_confirm];
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    [self.btn_confirm setBackgroundImage:[WYUIStyle imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]] forState:UIControlStateNormal];
    self.btn_confirm.userInteractionEnabled = NO;
    
    //位置
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.viewbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll_bg.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(90));
    }];
    
    //密码
    [self.txtField_newPswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_newHide.mas_left).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.btn_newHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txtField_newPswd.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.linepswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_newPswd.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    [self.txtField_againPswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linepswd.mas_bottom);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_againHide.mas_left).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.btn_againHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.txtField_againPswd.mas_centerY);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.lineagainpswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_againPswd.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    [self.lbl_notice mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineagainpswd.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@30);
    }];
    
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbl_notice.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@40);
    }];
    
    return self;
}


@end
