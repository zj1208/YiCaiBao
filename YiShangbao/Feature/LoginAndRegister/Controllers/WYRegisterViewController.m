//
//  WYRegisterViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/9.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYRegisterViewController.h"
#import "WYRegisterView.h"
#import "CountryCodeViewController.h"
#import "YYText.h"

@interface WYRegisterViewController ()<UITextFieldDelegate>

@end

@implementation WYRegisterViewController


#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}



#pragma mark - private function
-(void) createUI{
    self.title = @"注册";
    WYRegisterView *view = [[WYRegisterView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    view.txtField_phoneNumber.delegate = self;
    view.txtField_smsNumber.delegate = self;
    view.txtField_pswd.delegate = self;
    view.txtField_name.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    [view.codeCell.btn addTarget:self action:@selector(chooseCode) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_send addTarget:self action:@selector(sendCodeTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_hide addTarget:self action:@selector(hideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_agree addTarget:self action:@selector(agreeTap) forControlEvents:UIControlEventTouchUpInside];
//    [view.btn_read addTarget:self action:@selector(readTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(confirmTap) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeLabelText:view.label_agreement];
}

//协议内容
- (void)changeLabelText:(YYLabel *)label{
    NSString *string = @"《义采宝用户服务协议》 《义采宝交易争议处理规则》";
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:string];
    one.yy_font = [UIFont boldSystemFontOfSize:14];
    one.yy_lineSpacing = 5;
    
    NSRange range = [string rangeOfString:@"《义采宝用户服务协议》"];
    if (range.location != NSNotFound){
        [one yy_setTextHighlightRange:range
                                color:[UIColor colorWithHex:0x56ABE9]
                      backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                [self readTapRegisterProtocolUrl];
                            }];
    }
    range = [string rangeOfString:@"《义采宝交易争议处理规则》"];
    if (range.location != NSNotFound){
        [one yy_setTextHighlightRange:range
                                color:[UIColor colorWithHex:0x56ABE9]
                      backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                [self readTapDisputeHandleRulesUrl];
                            }];
    }
    
    label.attributedText = one;
}


//注册成功登录跳转
-(void)registerToLogin:(NSString *)phone password:(NSString *)password countryCode:(NSString *)countryCode{
    [[[AppAPIHelper shareInstance] getUserModelAPI]getLoginWithUserName:phone password:password countryCode:countryCode success:^(id data) {
        
        [self getShopInfo];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ud_GTClientId]) {
            NSDictionary *dic = @{
                                  @"roleType":@([WYUserDefaultManager getUserTargetRoleType]),
                                  @"type":@"0",
#if !TARGET_IPHONE_SIMULATOR //真机
//                                  @"token":[[NSUserDefaults standardUserDefaults] objectForKey:ud_deviceToken],
                                  @"did":[[UIDevice currentDevice]getIDFAUUIDString],
#endif
                                  @"systemVersion": CurrentSystemVersion,
                                  @"clientId":[[NSUserDefaults standardUserDefaults] objectForKey:ud_GTClientId],
                                  @"appSourceType":@"1",
                                  @"appVersion":kAppVersion,
                                  @"mobileBrand":WYUTILITY.iphoneType
                                  };
            NSMutableDictionary *dics = [NSMutableDictionary dictionaryWithDictionary:dic];
            if ([[NSUserDefaults standardUserDefaults] objectForKey:ud_deviceToken]) {
                [dics setObject:[[NSUserDefaults standardUserDefaults] objectForKey:ud_deviceToken] forKey:@"token"];
            }
            [[[AppAPIHelper shareInstance] getMessageAPI] PostDeviceInfoWithParameters:dics success:^(id data) {
            } failure:^(NSError *error) {
            }];
        }
        
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)getShopInfo{
    
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {
        if (![data isEqual:[NSNull null]]) {
            [UserInfoUDManager setShopId:data];
            
            [weakSelf zhHUD_showSuccessWithStatus:@"登录成功"];
            [weakSelf.navigationController dismissViewControllerAnimated:NO completion:^{
                
                [UserInfoUDManager loginIn];
            }];
        }
    } failure:^(NSError *error) {
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}



#pragma mark - button aciton
//选择国家区号
-(void)chooseCode{
    WYRegisterView *view = (WYRegisterView *)self.view;
    CountryCodeViewController *vc = [[CountryCodeViewController alloc] init];
    vc.selectCity = ^(NSString *cityName){
        view.codeCell.label.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

//发送验证码
-(void)sendCodeTap{
    WYRegisterView *view = (WYRegisterView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *countryCode = view.codeCell.label.text;

    [[[AppAPIHelper shareInstance] getUserModelAPI] getSendVerifyCodeMobile:phone countryCode:countryCode type:@"2" success:^(id data){
        [self zhHUD_showSuccessWithStatus:@"发送验证码成功"];
        [view.btn_send startTime:59 title:@"重新发送" waitTittle:@"s后重发"];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

//隐藏密码
-(void)hideTap{
    WYRegisterView *view = (WYRegisterView *)self.view;
     view.btn_hide.selected = !view.btn_hide.selected;
    view.txtField_pswd.secureTextEntry = !view.txtField_pswd.secureTextEntry;
}

//同意协议
- (void)agreeTap{
    WYRegisterView *view = (WYRegisterView *)self.view;
    view.btn_agree.selected = !view.btn_agree.selected;
}

//阅读协议

-(void)readTapRegisterProtocolUrl{
    
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.registerProtocol;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_registerProtocol withSoureController:self];
}

-(void)readTapDisputeHandleRulesUrl{
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.disputeHandleRules;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_disputeHandleRules withSoureController:self];
}

//注册
-(void)confirmTap{
    WYRegisterView *view = (WYRegisterView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *codeNum = view.txtField_smsNumber.text;
    NSString *password = view.txtField_pswd.text;
    NSString *invitationCode = view.txtField_inviteNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    NSString *name = view.txtField_name.text;
    if (!view.btn_agree.selected) {
        [self zhHUD_showErrorWithStatus:@"请先同意注册协议"];
        return;
    }
    if (!name.length) {
        [self zhHUD_showErrorWithStatus:@"请输入姓名"];
        return;
    }
    if (password.length < 6) {
        [self zhHUD_showErrorWithStatus:@"请输入6-20位密码"];
        return;
    }
    [view.btn_confirm showIndicator];
    [[[AppAPIHelper shareInstance] getUserModelAPI]getRegisterWithUserName:phone password:password countryCode:countryCode name:name verifyCode:codeNum invitationCode:invitationCode success:^(id data) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showHUDAddedTo:self.view labelText:@"注册成功，正在跳转登录"];
        [self registerToLogin:phone password:password countryCode:countryCode];
    } failure:^(NSError *error) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    WYRegisterView *view = (WYRegisterView *)self.view;
//    if (textField == view.txtField_phoneNumber) {
//        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
    if (textField == view.txtField_smsNumber) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    if (textField == view.txtField_pswd) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    if (textField == view.txtField_name) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 12) {
            return NO;
        }
    }
    return YES;
}


-(void)signInButChangeAlpha:(NSNotification*)notification{
    WYRegisterView *view = (WYRegisterView *)self.view;
    if (view.txtField_phoneNumber.text.length >0 && view.txtField_smsNumber.text.length > 0 && view.txtField_pswd.text.length > 0) {
        [view.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
        [view.btn_confirm setBackgroundImage:[WYUIStyle ButtonBackgroundWithSize:view.btn_confirm.frame.size] forState:UIControlStateNormal];
        view.btn_confirm.userInteractionEnabled = YES;
    }else{
        [view.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
        [view.btn_confirm setBackgroundImage:[WYUIStyle imageWithColor:[UIColor colorWithRed:0.85 green:0.85 blue:0.85 alpha:1.0]] forState:UIControlStateNormal];
        view.btn_confirm.userInteractionEnabled = NO;
    }
}


@end
