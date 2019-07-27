//
//  PhoneSetPasswordViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PhoneSetPasswordViewController.h"
#import "WYResetPasswordView.h"
@interface PhoneSetPasswordViewController ()<UITextFieldDelegate>

@end

@implementation PhoneSetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createUI{
    self.title = @"设置密码";
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

-(void)setData{
    
}


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
    [[[AppAPIHelper shareInstance] getUserModelAPI] phoneSetPasswordWithMobile:self.phone pwd:newPswd success:^(id data) {
        [self zhHUD_showSuccessWithStatus:@"密码设置成功" afterDelay:1];
        [self.navigationController popViewControllerAnimated:YES];
//        [self.navigationController dismissViewControllerAnimated:NO completion:^{
//        }];
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
