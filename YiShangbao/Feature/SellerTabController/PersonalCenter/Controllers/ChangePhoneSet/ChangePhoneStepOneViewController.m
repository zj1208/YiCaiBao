//
//  ChangePhoneStepOneViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/6/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChangePhoneStepOneViewController.h"
#import "ChangePhoneStepOneView.h"
#import "CountryCodeViewController.h"
#import "ChangePhoneStepTwoViewController.h"

#import "PurchaserModel.h"
#import "UserModel.h"

@interface ChangePhoneStepOneViewController ()<UITextFieldDelegate>

//data
@property(nonatomic, strong) BuyerUserModel *buyeruserModel;
@property(nonatomic, strong) UserModel *businessUserModel;


@end

@implementation ChangePhoneStepOneViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
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
    ChangePhoneStepOneView *view = [[ChangePhoneStepOneView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
//    view.txtField_phoneNumber.delegate = self;
    view.txtField_phoneNumber.enabled = NO;
    view.codeCell.btn.enabled = NO;
    
//    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
//        NSArray *strArr = [self.phoneStr componentsSeparatedByString:@" "];
//        if (strArr.count == 2) {
//            view.codeCell.label.text = strArr[0];
//            view.txtField_phoneNumber.text = strArr[1];
//        }
//    }else{
//        view.codeCell.label.text = self.codeStr;
//        view.txtField_phoneNumber.text = self.phoneStr;
//    }
    
    view.txtField_smsNumber.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //按钮触发
    [view.codeCell.btn addTarget:self action:@selector(chooseCode) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_send addTarget:self action:@selector(sendAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(nextBtnAction) forControlEvents:UIControlEventTouchUpInside];
}

-(void)initData{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        [[[AppAPIHelper shareInstance] getPurchaserAPI] getBuyerInfoWithsuccess:^(id data) {
            self.buyeruserModel = data;
            self.phoneStr = self.buyeruserModel.phone;
            [self updateUI];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }else{
        [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
            self.businessUserModel = data;
            self.codeStr = self.businessUserModel.countryCode;
            self.phoneStr = self.businessUserModel.nickPhone;
            [self updateUI];
        } failure:^(NSError *error) {
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }
}

-(void)updateUI{
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        NSArray *strArr = [self.phoneStr componentsSeparatedByString:@" "];
        if (strArr.count == 2) {
            view.codeCell.label.text = strArr[0];
            view.txtField_phoneNumber.text = strArr[1];
        }
    }else{
        view.codeCell.label.text = self.codeStr;
        view.txtField_phoneNumber.text = self.phoneStr;
    }
}
#pragma mark - button aciton
//选择国家区号
-(void)chooseCode{
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
    CountryCodeViewController *vc = [[CountryCodeViewController alloc] init];
    vc.selectCity = ^(NSString *cityName){
        view.codeCell.label.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


-(void)sendAction{
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    
    [[[AppAPIHelper shareInstance] getUserModelAPI] getVeriCodeByUpdateOldPhone:phone countryCode:countryCode success:^(id data) {
        [self zhHUD_showSuccessWithStatus:@"发送验证码成功"];
        [view.btn_send startTime:59 title:@"重新发送" waitTittle:@"s后重发"];
    } failure:^(NSError *error) {
                [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


-(void)nextBtnAction{
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *code = view.txtField_smsNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    
    [view.btn_confirm showIndicator];
    [self zhHUD_showHUDAddedTo:self.view labelText:nil];
    
    [[[AppAPIHelper shareInstance] getUserModelAPI] checkVeriCodeByUpdateOldPhone:phone countryCode:countryCode verificationCode:code success:^(id data) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_hideHUDForView:self.view];
        ChangePhoneStepTwoViewController *vc = [[ChangePhoneStepTwoViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [view.btn_confirm hideIndicator];
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
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
    ChangePhoneStepOneView *view = (ChangePhoneStepOneView *)self.view;
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
