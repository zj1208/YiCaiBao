//
//  WYResetPasswordViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/9.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYResetPasswordViewController.h"
#import "WYResetPasswordView.h"
@interface WYResetPasswordViewController ()<UITextFieldDelegate>

@end

@implementation WYResetPasswordViewController

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
    self.title = @"重置密码";
    WYResetPasswordView *view = [[WYResetPasswordView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.txtField_newPswd.delegate = self;
    view.txtField_againPswd.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //按钮触发
    [view.btn_newHide addTarget:self action:@selector(newhideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_againHide addTarget:self action:@selector(againhideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(confirmTap) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma mark - button aciton
//隐藏密码
-(void)newhideTap{
    WYResetPasswordView *view = (WYResetPasswordView *)self.view;
    view.btn_newHide.selected = !view.btn_newHide.selected;
    view.txtField_newPswd.secureTextEntry = !view.txtField_newPswd.secureTextEntry;
}
-(void)againhideTap{
    WYResetPasswordView *view = (WYResetPasswordView *)self.view;
    view.btn_againHide.selected = !view.btn_againHide.selected;
    view.txtField_againPswd.secureTextEntry = !view.txtField_againPswd.secureTextEntry;
}
-(void)confirmTap{
    WYResetPasswordView *view = (WYResetPasswordView *)self.view;
    NSString *newPswd = view.txtField_newPswd.text;
    NSString *reNewPswd = view.txtField_againPswd.text;
    if (newPswd.length < 6) {
        [self zhHUD_showErrorWithStatus:@"请输入6-20位密码"];
        return;
    }
    if(![newPswd isEqualToString: reNewPswd]){
        [self zhHUD_showErrorWithStatus:@"密码与确认密码不一致"];
        return;
    }
    [view.btn_confirm showIndicator];
    [self zhHUD_showHUDAddedTo:self.view labelText:nil];
    [[[AppAPIHelper shareInstance] getUserModelAPI] resetPasswordWithMobile:self.phone code:self.code newPwd:newPswd countryCode:self.countryCode success:^(id data) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showSuccessWithStatus:@"密码修改成功"];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        [view.btn_confirm hideIndicator];
    }];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    WYResetPasswordView *view = (WYResetPasswordView *)self.view;
    if (textField == view.txtField_newPswd) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    if (textField == view.txtField_againPswd) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    return YES;
}

-(void)signInButChangeAlpha:(NSNotification*)notification{
    WYResetPasswordView *view = (WYResetPasswordView *)self.view;
    if (view.txtField_newPswd.text.length > 0 && view.txtField_againPswd.text.length > 0) {
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
