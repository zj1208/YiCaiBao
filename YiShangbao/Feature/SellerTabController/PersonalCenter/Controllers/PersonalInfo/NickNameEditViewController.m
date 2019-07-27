//
//  NickNameEditViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NickNameEditViewController.h"
#import "NicknameEditView.h"

@interface NickNameEditViewController ()<UITextFieldDelegate>

@end

@implementation NickNameEditViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)creatUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WYUISTYLE.colorMTblack forState:UIControlStateNormal];
    rightBtn.titleLabel.font = WYUISTYLE.fontWith28;
    [rightBtn sizeToFit];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = BtnItem;
    
    self.title = @"修改昵称";
    NicknameEditView *view = [[NicknameEditView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.edit.text = self.nickName;
    view.edit.delegate = self;
    
    
}
-(void)rightBtnAction{
    NicknameEditView *view = (NicknameEditView *)self.view;
    NSString *nickname = view.edit.text;
    if (!nickname.length) {
        [self zhHUD_showErrorWithStatus:@"昵称不能为空"];
        return;
    }
    [[[AppAPIHelper shareInstance] getUserModelAPI] editNicknameWith:nickname success:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NicknameEditView *view = (NicknameEditView *)self.view;
    if (textField == view.edit) {
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
@end
