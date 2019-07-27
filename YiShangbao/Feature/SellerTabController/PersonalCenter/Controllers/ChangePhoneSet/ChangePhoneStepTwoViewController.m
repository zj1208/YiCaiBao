//
//  ChangePhoneStepTwoViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/6/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangePhoneStepTwoViewController.h"
#import "ChangePhoneStepTwoView.h"
#import "CountryCodeViewController.h"

@interface ChangePhoneStepTwoViewController ()<UITextFieldDelegate>

@end

@implementation ChangePhoneStepTwoViewController

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
    self.title = @"更换手机号";
    ChangePhoneStepTwoView *view = [[ChangePhoneStepTwoView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    view.txtField_phoneNumber.delegate = self;
    view.txtField_smsNumber.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //按钮触发
    [view.codeCell.btn addTarget:self action:@selector(chooseCode) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
}



#pragma mark - button aciton
//选择国家区号
-(void)chooseCode{
    ChangePhoneStepTwoView *view = (ChangePhoneStepTwoView *)self.view;
    CountryCodeViewController *vc = [[CountryCodeViewController alloc] init];
    vc.selectCity = ^(NSString *cityName){
        view.codeCell.label.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)sendAction{
    ChangePhoneStepTwoView *view = (ChangePhoneStepTwoView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    
    [[[AppAPIHelper shareInstance] getUserModelAPI] getSendVerifyCodeMobile:phone countryCode:countryCode type:@"5" success:^(id data){
        [self zhHUD_showSuccessWithStatus:@"发送验证码成功"];
        [view.btn_send startTime:59 title:@"重新发送" waitTittle:@"s后重发"];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)nextBtnAction{
    ChangePhoneStepTwoView *view = (ChangePhoneStepTwoView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *code = view.txtField_smsNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    
    [view.btn_confirm showIndicator];
    [self zhHUD_showHUDAddedTo:self.view labelText:nil];
    [[[AppAPIHelper shareInstance] getUserModelAPI] postupdateUserPhone:phone countryCode:countryCode verificationCode:code success:^(id data) {
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:2] animated:YES];
    } failure:^(NSError *error) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ChangePhoneStepTwoView *view = (ChangePhoneStepTwoView *)self.view;
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
    return YES;
}


-(void)signInButChangeAlpha:(NSNotification*)notification{
    ChangePhoneStepTwoView *view = (ChangePhoneStepTwoView *)self.view;
    if (view.txtField_phoneNumber.text.length > 0 && view.txtField_smsNumber.text.length > 0) {
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
