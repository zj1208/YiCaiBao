//
//  ChangePasswordView.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangePasswordView.h"

@implementation ChangePasswordView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    
    self.txtField_oldPswd = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_oldPswd];
    self.btn_oldHide = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_oldHide];
    self.lineoldpswd = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.lineoldpswd];
    
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
    self.lineoldpswd.backgroundColor = self.linepswd.backgroundColor = self.lineagainpswd.backgroundColor = WYUISTYLE.colorLinegrey;
    
    self.txtField_oldPswd.secureTextEntry = YES;
    [WYUIStyle setTextFieldWithNoImagePl:@"请输入旧密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_oldPswd];
    [self.btn_oldHide setImage:[UIImage imageNamed:@"明文密码"] forState:UIControlStateNormal];
    [self.btn_oldHide setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
    [self.btn_oldHide setSelected:YES];
    
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
    
    [self.btn_confirm setTitle:@"完 成" forState:UIControlStateNormal];
    self.btn_confirm.backgroundColor = WYUISTYLE.colorBGgrey;
    [self.btn_confirm setTitleColor:WYUISTYLE.colorLTgrey forState:UIControlStateNormal];
    [self.btn_confirm.titleLabel setFont:WYUISTYLE.fontWith36];
    self.btn_confirm.layer.cornerRadius = 18.f;
    [self.btn_confirm.titleLabel setTextAlignment:NSTextAlignmentCenter];
    self.btn_confirm.userInteractionEnabled = NO;
    
    //位置
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@(0));
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    //密码
    [self.txtField_oldPswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@20);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_oldHide.mas_left).offset(-12);
        make.height.equalTo(@(30));
    }];
    [self.btn_oldHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_oldPswd.mas_top).offset(-6);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.lineoldpswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_oldPswd.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    [self.txtField_newPswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineoldpswd.mas_bottom).offset(6);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_newHide.mas_left).offset(-12);
        make.height.equalTo(@(30));
    }];
    [self.btn_newHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineoldpswd.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.linepswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_newPswd.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    [self.txtField_againPswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linepswd.mas_bottom).offset(6);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_againHide.mas_left).offset(-12);
        make.height.equalTo(@(30));
    }];
    [self.btn_againHide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linepswd.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.lineagainpswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_againPswd.mas_bottom).offset(6);
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
    
    //注册
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lbl_notice.mas_bottom).offset(50);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@260);
        make.height.equalTo(@36);
    }];
    
    return self;
}

@end
