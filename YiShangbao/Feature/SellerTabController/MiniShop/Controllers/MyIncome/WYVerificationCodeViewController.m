//
//  WYVerificationCodeViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
// ------验证码------

#import "WYVerificationCodeViewController.h"

@interface WYVerificationCodeViewController ()<UITextFieldDelegate>
@property(nonatomic,strong)NSString* userBaseInfo_Phone;
@property(nonatomic,strong)NSString* userBaseInfo_CountryCode;

@property(nonatomic,copy)NSString* VeriCodeViewTitle; // 设置title

@end

@implementation WYVerificationCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];

//    NSLog(@"%ld",_type);
    
    if (_type == VerificationCodeType_CashWithdrawal)
    {
        _veriCodeTitleLabel.text = @"为了您的资金安全\n请输入您收到的短信验证码";
        self.phoneLabel.text = [NSString stringWithFormat:@"验证码发送至手机号：%@",_userBaseInfo_Phone];

        [self getVerificationBtn:self.againBtn]; //自动帮用户获取
        
    }else if (_type == VerificationCodeType_ConfirmReceiptOfGoods)
    {
        _veriCodeTitleLabel.text = @"收到货物后再确认收货\n以防不必要的损失";
        //获取用户的电话号码(eg:确认收货)
        [self getUserPhoneInfo];
    }
    
    //
    [self buildUI];
    
}
-(void)setPhone:(NSString *)phone
{
    _phone = phone;
    _userBaseInfo_Phone = [NSString stringWithFormat:@"%@",_phone];
}
-(void)setCountryCode:(NSString *)countryCode
{
    _countryCode = countryCode;
    _userBaseInfo_CountryCode = [NSString stringWithFormat:@"%@",_countryCode];
}
-(void)wy_remove
{
    if (self.view.superview) {
        [self.view removeFromSuperview];
    }
    if (self.parentViewController) {
        [self removeFromParentViewController];
    }
}
#pragma mark - 获取电话号码
-(void)getUserPhoneInfo
{
    _VerificationCodeView.userInteractionEnabled = NO;
    [_againBtn setTitle:@"" forState:UIControlStateNormal];
    [[[AppAPIHelper shareInstance] getUserModelAPI] getUserBaseInfosuccess:^(id data) {
        NSLog(@"%@",data);
        _VerificationCodeView.userInteractionEnabled = YES;

        _userBaseInfo_Phone = [data objectForKey:@"mobile"];
        _userBaseInfo_CountryCode = [data objectForKey:@"countryCode"];

        self.phoneLabel.text = [NSString stringWithFormat:@"验证码发送至手机号：%@",_userBaseInfo_Phone];
        [self getVerificationBtn:self.againBtn]; //自动帮用户获取

        
    } failure:^(NSError *error) {
        _VerificationCodeView.userInteractionEnabled = YES;

        if (self.view.superview) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];
        }
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark - 校验验证码是否正确
-(void)checkVerifyCodephone
{
    [[[AppAPIHelper shareInstance] getUserModelAPI] checkVerifyCodephoneVTWO:_userBaseInfo_Phone verificationCode:[NSString stringWithFormat:@"%@",_textfiled.text] countryCode:_userBaseInfo_CountryCode type:_type success:^(id data) {
      
        if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYVerificationCodeViewControllerVerificationCodeIsCorrect:)]) {
            [self.delegate jl_WYVerificationCodeViewControllerVerificationCodeIsCorrect:self];
        }
       
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];

}
#pragma mark - 发送验证码
-(void)getSendVerifyCode
{
    _againBtn.enabled = NO;
    [[[AppAPIHelper shareInstance] getUserModelAPI] getSendVerifyCodeMobileVTWO:_userBaseInfo_Phone countryCode:_userBaseInfo_CountryCode type:_type success:^(id data){
        _againBtn.enabled = YES;

        if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
            [_againBtn startTime:59 title:@"重新发送" waitTittle:@"s" StopTitleColor:[WYUISTYLE colorWithHexString:@"FF5434"]];
        }else{
            [_againBtn startTime:59 title:@"重新发送" waitTittle:@"s" StopTitleColor:[WYUISTYLE colorWithHexString:@"F78136"]];
        }
    } failure:^(NSError *error) {
        _againBtn.enabled = YES;

        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
-(void)buildUI
{
    self.VerificationCodeView.layer.masksToBounds = YES;
    self.VerificationCodeView.layer.cornerRadius = 5;
    
    self.textFiledContentView.layer.masksToBounds = YES;
    self.textFiledContentView.layer.borderWidth = 0.5;
    self.textFiledContentView.layer.cornerRadius = 3;
    self.textFiledContentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"E1E2E3"].CGColor;
    
    
    [self.againBtn addTarget:self action:@selector(getVerificationBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.quxiaoBtn addTarget:self action:@selector(quxiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.quedingBtn addTarget:self action:@selector(quedingBtn:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.veriCodeTitleLabel jl_setAttributedText:nil withMinimumLineHeight:22.5 ];
    
    self.textfiled.delegate = self;
    
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家 4卖家
        [self.againBtn setTitleColor:[WYUISTYLE colorWithHexString:@"FF5434"] forState:UIControlStateNormal];
        [self.quedingBtn setTitleColor:[WYUISTYLE colorWithHexString:@"FF5434"] forState:UIControlStateNormal];
        self.writeSureLabel.textColor = [WYUISTYLE colorWithHexString:@"FF0000"];
    }else{
        [self.againBtn setTitleColor:[WYUISTYLE colorWithHexString:@"F78136"] forState:UIControlStateNormal];
        [self.quedingBtn setTitleColor:[WYUISTYLE colorWithHexString:@"F58F23"] forState:UIControlStateNormal];
        self.writeSureLabel.textColor = [WYUISTYLE colorWithHexString:@"FD764E"];
    }
    
    //适配
    CGFloat scale = LCDScale_5Equal6_To6plus(1);
    _VerificationCodeView.transform = CGAffineTransformMakeScale(scale, scale);

}
#pragma mark - 点击获取验证码
- (void)getVerificationBtn:(UIButton*)sender {

    [self getSendVerifyCode];

}


- (void)quxiaoBtn:(id)sender {
    if (self.view.superview ) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

- (void)quedingBtn:(id)sender {
    
    NSString* str = self.textfiled.text;
    if ([NSString zhIsBlankString:str]) {
        _writeSureLabel.hidden = NO;
//        [MBProgressHUD zx_showError:@"请输入验证码" toView:self.view];
        return;
    }
    
    if (!_phone) {
        [self checkVerifyCodephone];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYVerificationCodeViewControllerDidSureBtn:verificationCode:)]) {
            [self.delegate jl_WYVerificationCodeViewControllerDidSureBtn:self verificationCode:str];
        }
    }
    
    
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    _writeSureLabel.hidden = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
