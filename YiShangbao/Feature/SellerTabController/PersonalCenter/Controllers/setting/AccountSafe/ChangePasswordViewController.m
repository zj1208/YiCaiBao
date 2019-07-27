//
//  ChangePasswordViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ChangePasswordView.h"

@interface ChangePasswordViewController ()<UITextFieldDelegate>

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) createUI{
    self.title = @"修改密码";
    ChangePasswordView *view = [[ChangePasswordView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.txtField_oldPswd.delegate = self;
    view.txtField_newPswd.delegate = self;
    view.txtField_againPswd.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //按钮触发
    [view.btn_oldHide addTarget:self action:@selector(oldhideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_newHide addTarget:self action:@selector(newhideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_againHide addTarget:self action:@selector(againhideTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(confirmTap) forControlEvents:UIControlEventTouchUpInside];
    
}


//隐藏密码
-(void)oldhideTap{
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    view.btn_oldHide.selected = !view.btn_oldHide.selected;
    view.txtField_oldPswd.secureTextEntry = !view.txtField_oldPswd.secureTextEntry;
}
-(void)newhideTap{
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    view.btn_newHide.selected = !view.btn_newHide.selected;
    view.txtField_newPswd.secureTextEntry = !view.txtField_newPswd.secureTextEntry;
}
-(void)againhideTap{
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    view.btn_againHide.selected = !view.btn_againHide.selected;
    view.txtField_againPswd.secureTextEntry = !view.txtField_againPswd.secureTextEntry;
}
-(void)confirmTap{
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    NSString *oldPswd = view.txtField_oldPswd.text;
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
    [[[AppAPIHelper shareInstance] getUserModelAPI] changePasswordWithOldpswd:oldPswd newPwd:newPswd success:^(id data) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showSuccessWithStatus:@"密码修改成功" afterDelay:1];
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        [view.btn_confirm hideIndicator];
    }];
}

#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    if (textField == view.txtField_oldPswd) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
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
    ChangePasswordView *view = (ChangePasswordView *)self.view;
    if (view.txtField_newPswd.text.length > 0 && view.txtField_againPswd.text.length > 0) {
        [view.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
        view.btn_confirm.backgroundColor = WYUISTYLE.colorMred;
        view.btn_confirm.userInteractionEnabled = YES;
    }else{
        [view.btn_confirm setTitleColor:WYUISTYLE.colorLTgrey forState:UIControlStateNormal];
        view.btn_confirm.backgroundColor = WYUISTYLE.colorBGgrey;
        view.btn_confirm.userInteractionEnabled = NO;
    }
}

@end
