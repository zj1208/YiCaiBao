//
//  SetBankAccountViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SetBankAccountViewController.h"
#import "SetBankAccountView.h"
#import "ChooseBankViewController.h"

@interface SetBankAccountViewController ()<UITextFieldDelegate>

@end

@implementation SetBankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.type.integerValue == 1) {
        self.title = @"添加银行卡";
    }else{
        self.title = @"编辑";
    }
    [self creatUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)creatUI{
    SetBankAccountView *view = [[SetBankAccountView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.cell_bankID.input.delegate = self;
    view.cell_openName.input.delegate = self;
    view.cell_openName.input.returnKeyType = UIReturnKeyDone;
    [view.cell_bank.btn_cell addTarget:self action:@selector(chooseBankTip) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(confirmTap) forControlEvents:UIControlEventTouchUpInside];
    if (self.type.integerValue == 1) {
        self.accInfoModel = [[AcctInfoModel alloc] init];
    }else{
        UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [rightBtn setTitle:@"删 除" forState:UIControlStateNormal];
        [rightBtn setTitleColor:WYUISTYLE.colorMTblack forState:UIControlStateNormal];
        rightBtn.titleLabel.font = WYUISTYLE.fontWith28;
        [rightBtn sizeToFit];
        rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
        UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
        self.navigationItem.rightBarButtonItem  = BtnItem;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.type.integerValue == 1) {
        if (self.bankModel.bankValue.length) {
            SetBankAccountView *view = (SetBankAccountView *)self.view;
            view.cell_bank.subTitle.text = self.bankModel.bankValue;
            view.cell_bank.subTitle.textColor = WYUISTYLE.colorMTblack;
        }
    }else{
        SetBankAccountView *view = (SetBankAccountView *)self.view;
        [view setData:self.accInfoModel];
    }
}
-(void)rightBtnAction{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"确定要删除银行卡吗？", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"确定", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[[AppAPIHelper shareInstance] shopAPI] deleteAcctInfoWithAccId:self.accInfoModel.shopId success:^(id data) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];

}

-(void)chooseBankTip{
    ChooseBankViewController *vc = [[ChooseBankViewController alloc] init];
    vc.fatherVc = self;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)confirmTap{
    SetBankAccountView *view = (SetBankAccountView *)self.view;
    self.accInfoModel.acctName = view.cell_openName.input.text;
    self.accInfoModel.bankPlace = view.cell_openbank.input.text;
    self.accInfoModel.bankNo = view.cell_bankID.input.text;
    if (!self.accInfoModel.acctName.length) {
        [self zhHUD_showErrorWithStatus:@"开户名不能为空"];
        return;
    }
    if (!self.accInfoModel.bankNo.length) {
        [self zhHUD_showErrorWithStatus:@"银行卡号不能为空"];
        return;
    }
    if (self.type.integerValue == 1) {
        self.accInfoModel.bankId = self.bankModel.bankId;
        self.accInfoModel.bankCode = self.bankModel.bankCode;
        self.accInfoModel.bankValue = self.bankModel.bankValue;
        if (!self.accInfoModel.bankCode.length) {
            [self zhHUD_showErrorWithStatus:@"请选择银行"];
            return;
        }
        //新增
        [[[AppAPIHelper shareInstance] shopAPI] addAcctInfoWithChannel:_channel Parameters:self.accInfoModel success:^(id data) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }else{
        //修改
        [[[AppAPIHelper shareInstance] shopAPI] updateAcctInfoWithChannel:_channel Parameters:self.accInfoModel success:^(id data) {
            [self.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    SetBankAccountView *view = (SetBankAccountView *)self.view;
    if (textField == view.cell_bankID.input) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 20) {
            return NO;
        }
    }
    if (textField == view.cell_openName.input) {
      return [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:12 remainTextNum:^(NSInteger remainLength) {
            
        }];
        
//        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 12) {
//            return NO;
//        }
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

@end
