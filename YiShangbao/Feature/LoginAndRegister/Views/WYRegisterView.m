//
//  WYRegisterView.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/6.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYRegisterView.h"

@interface WYRegisterView()


@end


@implementation WYRegisterView

- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    self.scroll_bg.backgroundColor = WYUISTYLE.colorBGgrey;
    
    //注册上部
    self.viewPhonebg = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.viewPhonebg];
    self.viewPhonebg.backgroundColor = [UIColor whiteColor];
    
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

    //注册下部
    self.viewpwdbg = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.viewpwdbg];
    self.viewpwdbg.backgroundColor = [UIColor whiteColor];
    
    //姓名
    self.txtField_name = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_name];
    [WYUIStyle setTextFieldWithNoImagePl:@"请输入商铺名称或昵称" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_name];
    
    self.linesms = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linesms];
    //设置密码
    self.txtField_pswd = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_pswd];
    self.txtField_pswd.secureTextEntry = YES;
    [WYUIStyle setTextFieldWithNoImagePl:@"请输入6-20位的密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_pswd];
    
    self.btn_hide = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_hide];
    [self.btn_hide setImage:[UIImage imageNamed:@"明文密码"] forState:UIControlStateNormal];
    [self.btn_hide setImage:[UIImage imageNamed:@"隐藏密码"] forState:UIControlStateSelected];
    [self.btn_hide setSelected:YES];
    
    self.linepswd = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linepswd];
    //邀请码
    self.txtField_inviteNumber = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_inviteNumber];
    self.txtField_inviteNumber.keyboardType = UIKeyboardTypeNumberPad;
    [WYUIStyle setTextFieldWithNoImagePl:@"请输入邀请码（可不填）" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_inviteNumber];
    
    self.lineinvite = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.lineinvite];
    
    //同意协议
    self.btn_agree = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_agree];
    [self.btn_agree setImage:[UIImage imageNamed:@"ic_xuanzhong"]
                    forState:UIControlStateSelected];
    [self.btn_agree setImage:[UIImage imageNamed:@"ic_weixuanzhong"]
                    forState:UIControlStateNormal];
    [self.btn_agree setSelected:YES];
    
    self.label_agree = [[UILabel alloc] init];
    [self.scroll_bg addSubview:self.label_agree];
    self.label_agree.text = @"已阅读并同意以下协议";
    self.label_agree.textColor = WYUISTYLE.colorSTgrey;
    self.label_agree.font = WYUISTYLE.fontWith28;

    self.label_agreement = [[YYLabel alloc]init];
    self.label_agreement.numberOfLines = 0;
    self.label_agreement.preferredMaxLayoutWidth = SCREEN_WIDTH - 48;
    [self.scroll_bg addSubview:self.label_agreement];

    self.btn_read = [[UIButton alloc] init];
    self.btn_read.hidden = YES;
    [self.scroll_bg addSubview:self.btn_read];
    [self.btn_read setTitle:@"《义采宝用户服务协议》"
                   forState:UIControlStateNormal];
    [self.btn_read setTitleColor:WYUISTYLE.colorMTblack
                        forState:UIControlStateNormal];
    [self.btn_read.titleLabel setFont:WYUISTYLE.fontWith28];
    
    //注册
    self.btn_confirm = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_confirm];
    self.btn_confirm =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
    [self.btn_confirm setTitle:@"注 册" forState:UIControlStateNormal];
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
    self.linephone.backgroundColor = self.linesms.backgroundColor = self.linepswd.backgroundColor = self.lineinvite.backgroundColor = WYUISTYLE.colorLinegrey;
    
    //old样式
//    [WYUIStyle setTextFieldWithPl:@"输入手机号" imageName:@"手机号" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_phoneNumber];
//    self.btn_send.layer.borderColor = WYUISTYLE.colorMred.CGColor;
//    self.btn_send.layer.cornerRadius = 15;
//    self.btn_send.layer.borderWidth = 0.5;
//    [WYUIStyle setTextFieldWithPl:@"输入短信验证码" imageName:@"短信验证码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_smsNumber];
//    [WYUIStyle setTextFieldWithPl:@"请输入6-20位的密码" imageName:@"密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_pswd];
//    [WYUIStyle setTextFieldWithPl:@"请输入邀请码（选填）" imageName:@"邀请码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_inviteNumber];

    
    //位置
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    //注册上部
    [_viewPhonebg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.scroll_bg.mas_top);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(90));
    }];
    //手机号码
    [self.codeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewPhonebg.mas_top);
        make.left.equalTo(@12);
        make.width.equalTo(@76);
        make.height.equalTo(@45);
    }];
    [self.txtField_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewPhonebg.mas_top);
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

    //注册下部
    [self.viewpwdbg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewPhonebg.mas_bottom).offset(10);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@135);
    }];
    //姓名
    [self.txtField_name mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.viewpwdbg.mas_top);
        make.left.equalTo(@12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.linesms mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_name.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    //密码
    [self.txtField_pswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linesms.mas_bottom);
        make.left.equalTo(@(12));
        make.right.equalTo(self.btn_hide.mas_left).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.btn_hide mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linesms.mas_bottom);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(@(44));
        make.height.equalTo(@(44));
    }];
    [self.linepswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_pswd.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    //邀请码
    [self.txtField_inviteNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linepswd.mas_bottom);
        make.left.equalTo(@(12));
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@(45));
    }];
    [self.lineinvite mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_inviteNumber.mas_bottom);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    //同意
    [self.btn_agree mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.label_agree.mas_centerY);
        make.left.equalTo(@(12));
    }];
    
    [self.label_agree mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.lineinvite.mas_bottom).offset(10);
        make.left.equalTo(self.btn_agree.mas_right).offset(12);
        make.width.equalTo(self.label_agree);
        make.height.equalTo(@(20));
    }];
    
    [self.label_agreement mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_agree.mas_bottom).offset(5);
        make.left.equalTo(self.btn_agree.mas_right).offset(12);
//        make.right.equalTo(self).offset(-12);
    }];
    
    [self.btn_read mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_agree.mas_top);
        make.left.equalTo(self.label_agree.mas_right).offset(-4);
        make.width.equalTo(self.btn_read);
        make.height.equalTo(@(20));
    }];
    
    //注册
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label_agreement.mas_bottom).offset(30);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@40);
    }];
    
    return self;
}

@end
