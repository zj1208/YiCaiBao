//
//  WYLoginView.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYLoginView.h"

@interface WYLoginView()

@end


@implementation WYLoginView
- (id)init {
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBWhite;
    
    self.scroll_bg = [[UIScrollView alloc] init];
    [self addSubview:self.scroll_bg];
    
    self.btn_colse = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_colse];
    
    self.btn_register = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_register];
    
    self.image_logo = [[UIImageView alloc] init];
    [self.scroll_bg addSubview:self.image_logo];
    
    self.codeCell = [[CountryCell alloc] init];
    [self.scroll_bg addSubview:self.codeCell];
    
    self.txtField_phoneNumber = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_phoneNumber];
    self.linephone = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linephone];
    
    self.historyPhoneBtn = [[UIButton alloc] init];
    [self.historyPhoneBtn setImage:[UIImage imageNamed:@"pic_kuaijieanniuBottom"] forState:UIControlStateNormal];
    [self.historyPhoneBtn setImage:[UIImage imageNamed:@"pic_kuaijieanniuTop"] forState:UIControlStateSelected];
    [self.scroll_bg addSubview:self.historyPhoneBtn];
//    _historyPhoneBtn.backgroundColor = [UIColor purpleColor];
    
    self.txtField_password = [[UITextField alloc] init];
    [self.scroll_bg addSubview:self.txtField_password];
    self.linepswd = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.linepswd];
    
    self.btn_forgetPswd = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_forgetPswd];
    self.btn_fastPhoneLogin = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_fastPhoneLogin];
    
//    self.btn_confirm = [[UIButton alloc] init];
//    [self.scroll_bg addSubview:self.btn_confirm];
    
    self.lineleft = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.lineleft];
    self.lineright = [[UIView alloc] init];
    [self.scroll_bg addSubview:self.lineright];
    self.lbl_wx = [[UILabel alloc] init];
    [self.scroll_bg addSubview:self.lbl_wx];
    self.btn_wx = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_wx];
    
    //切换环境入口
    self.btn_changeEnv = [[UIButton alloc] init];
    [self.scroll_bg addSubview:self.btn_changeEnv];
    
    //样式
    [self.btn_colse setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];

    self.image_logo.image = [UIImage imageNamed:@"登录页"];
    
    self.txtField_phoneNumber.keyboardType = UIKeyboardTypeNumberPad;
    self.txtField_phoneNumber.clearButtonMode=UITextFieldViewModeWhileEditing;
    [WYUIStyle setTextFieldWithNoImagePl:@"输入手机号" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_phoneNumber];
    
    self.linephone.backgroundColor = self.linepswd.backgroundColor = self.lineleft.backgroundColor = self.lineright.backgroundColor = WYUISTYLE.colorLinegrey;
    
    self.txtField_password.secureTextEntry = YES;
    [WYUIStyle setTextFieldWithNoImagePl:@"请输入正确的密码" LblColor:WYUISTYLE.colorMTblack withField:self.txtField_password];
    
    [self.btn_forgetPswd setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.btn_forgetPswd setTitleColor:WYUISTYLE.colorSblue forState:UIControlStateNormal];
    [self.btn_forgetPswd.titleLabel setFont:WYUISTYLE.fontWith28];
    [self.btn_fastPhoneLogin setTitle:@"手机快捷登录" forState:UIControlStateNormal];
    [self.btn_fastPhoneLogin setTitleColor:WYUISTYLE.colorSblue forState:UIControlStateNormal];
    [self.btn_fastPhoneLogin.titleLabel setFont:WYUISTYLE.fontWith28];
    
    self.btn_confirm =[[UIButton alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-30, 40)];
    [self.btn_confirm setTitle:@"登录" forState:UIControlStateNormal];
    self.btn_confirm.layer.masksToBounds= YES;
    self.btn_confirm.layer.cornerRadius =20.f;
    self.btn_confirm.layer.borderColor =[UIColor clearColor].CGColor;
    [self.scroll_bg addSubview:self.btn_confirm];
    [self.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
    [self.btn_confirm setBackgroundColor:[UIColor colorWithHex:0xD9D9D9]];
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xE23728].CGColor,(id)[UIColor colorWithHex:0xCF2218].CGColor, nil];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1.0, 0);
//    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 40);
//    [self.btn_confirm.layer addSublayer:gradientLayer];
    
//    [self.btn_confirm setBackgroundImage:[WYUIStyle imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]] forState:UIControlStateNormal];
    self.btn_confirm.userInteractionEnabled = NO;
    
//    [self.btn_register setTitle:@"注 册" forState:UIControlStateNormal];
//    [self.btn_register setTitleColor:WYUISTYLE.colorMred forState:UIControlStateNormal];
//    [self.btn_register setTitleColor:[UIColor colorWithRed:0.97 green:0.51 blue:0.21 alpha:1.0] forState:UIControlStateNormal];
//    self.btn_register.titleLabel.font = WYUISTYLE.fontWith36;
    self.btn_register.layer.cornerRadius = 11.f;
    self.btn_register.layer.borderColor = [UIColor colorWithHexString:@"#FF5434"].CGColor;
    self.btn_register.layer.borderWidth = 0.5f;
    self.btn_register.backgroundColor = [UIColor colorWithHexString:@"#FFF5F1"];

    [self.btn_register setTitle:@"注册" forState:UIControlStateNormal];
    [self.btn_register setTitleColor:[UIColor colorWithHexString:@"#FF5434"] forState:UIControlStateNormal];
    self.btn_register.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    self.lbl_wx.text = @"使用微信登录";
    self.lbl_wx.textColor = WYUISTYLE.colorSTgrey;
    self.lbl_wx.font = WYUISTYLE.fontWith28;
    [self.btn_wx setImage:[UIImage imageNamed:@"ic_loginwechat"] forState:UIControlStateNormal];
    
    //切换环境入口样式
    [self.btn_changeEnv setTitle:@"点击此处切换环境" forState:UIControlStateNormal];
    [self.btn_changeEnv setTitleColor:WYUISTYLE.colorSblue forState:UIControlStateNormal];

    //位置
    [self.scroll_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(0));
        make.top.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@(SCREEN_HEIGHT));
    }];
    
    [self.btn_colse mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.top.equalTo(@0);
    }];
    
    [self.image_logo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.btn_colse.mas_bottom).offset(11);
//        make.width.equalTo(@138);
//        make.height.equalTo(@50);
    }];
    
    [self.codeCell mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image_logo.mas_bottom).offset(34);
        make.left.equalTo(@12);
        make.width.equalTo(@76);
        make.height.equalTo(@30);
    }];
    
    //手机号码
    [self.txtField_phoneNumber mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image_logo.mas_bottom).offset(34);
        make.left.equalTo(self.codeCell.mas_right);
        make.right.equalTo(self).offset(-24-25.f);
        make.height.equalTo(@(30));
    }];
    [self.linephone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_phoneNumber.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    //历史账号按钮
    [self.historyPhoneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.image_logo.mas_bottom).offset(34);
        make.left.equalTo(self.txtField_phoneNumber.mas_right);
        make.right.equalTo(self).offset(-14.f);
        make.height.equalTo(@(30));
    }];
    NSArray *history = [UserInfoUDManager getLoginInputPhones];
    if (history&&history.count>0) {
        self.historyPhoneBtn.hidden = NO;
    }else{
        self.historyPhoneBtn.hidden = YES;
    }
    
    //密码
    [self.txtField_password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linephone.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@(30));
    }];
    [self.linepswd mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.txtField_password.mas_bottom).offset(6);
        make.left.equalTo(@12);
        make.width.equalTo(@(SCREEN_WIDTH-24));
        make.height.equalTo(@0.5);
    }];
    
    //忘记密码快捷登录
    [self.btn_forgetPswd mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn_confirm.mas_bottom).offset(30);
        make.left.equalTo(@12);
        make.width.equalTo(self.btn_forgetPswd);
        make.height.equalTo(@(20));
    }];
    [self.btn_fastPhoneLogin mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.btn_forgetPswd.mas_top);
        make.right.equalTo(self.mas_right).offset(-12);
        make.width.equalTo(self.btn_fastPhoneLogin);
        make.height.equalTo(@(20));
    }];
    
    //登录
    [self.btn_confirm mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.linepswd.mas_bottom).offset(45);
        make.centerX.equalTo(self.mas_centerX);
        make.width.equalTo(@(SCREEN_WIDTH-30));
        make.height.equalTo(@40);
    }];
    
    [self.btn_register mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self).offset(22);
        make.centerY.equalTo(self.btn_colse);
        make.right.equalTo(self).offset(-10);
        make.width.equalTo(@52);
        make.height.equalTo(@22);
    }];
    
    //微信登录
    [self.btn_wx mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.mas_bottom).offset(-12.5-HEIGHT_TABBAR_SAFE);
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.lbl_wx mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.btn_wx.mas_top).offset(-14);
        make.centerX.equalTo(self.mas_centerX);
//        make.width.equalTo(@86);
        make.height.equalTo(@16);
    }];
    [self.lineleft mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbl_wx.mas_centerY);
        make.left.equalTo(@12);
        make.right.equalTo(self.lbl_wx.mas_left).offset(-10);
        make.height.equalTo(@0.5);
    }];
    [self.lineright mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.lbl_wx.mas_centerY);
        make.left.equalTo(self.lbl_wx.mas_right).offset(10);
        make.right.equalTo(self.mas_right).offset(-12);
        make.height.equalTo(@0.5);
    }];
    
    //切换环境
    [self.btn_changeEnv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.btn_confirm.mas_bottom).offset(50);
        make.width.equalTo(@200);
    }];
    return self;
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self endEditing:YES];
}
@end
