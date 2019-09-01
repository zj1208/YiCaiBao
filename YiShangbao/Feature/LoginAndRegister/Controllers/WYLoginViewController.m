//
//  WYLoginViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYLoginViewController.h"
#import "WYLoginView.h"
#import "WYPhoneLoginViewController.h"
#import "WYForgetPasswordViewController.h"
#import "WYRegisterViewController.h"
#import "WYBindViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"
#import "ChangeDomainController.h"

#import "CountryCodeViewController.h"

#import "WYLoginHistoryPhonesView.h"

@interface WYLoginViewController ()<WXDelegate,UITextFieldDelegate>
{
    AppDelegate *appdelegate;
}
@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) WYLoginHistoryPhonesView *loginHistoryView;

@end

@implementation WYLoginViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController zx_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [self zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];

    [self createUI];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [super viewWillDisappear:animated];
    

}

-(void)dealloc{
//    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(WYLoginHistoryPhonesView *)loginHistoryView
{
    if (!_loginHistoryView) {
        WYLoginHistoryPhonesView* viewH = [[[NSBundle mainBundle] loadNibNamed:@"WYLoginHistoryPhonesView" owner:self options:nil] firstObject];
        viewH.frame = self.view.frame;
       
        WS(weakSelf);
        WYLoginView *weakView = (WYLoginView *)weakSelf.view;

        [viewH setTopFollowingWithView:weakView.txtField_phoneNumber];
        viewH.phoneBlock = ^(NSString *countryCode, NSString *phone) {
            weakView.codeCell.label.text = countryCode;
            weakView.txtField_phoneNumber.text = phone;
        };
        viewH.hvWillRemove = ^{
            weakView.historyPhoneBtn.selected = NO;
        };
        _loginHistoryView = viewH;
    }
    NSArray *history = [UserInfoUDManager getLoginInputPhones];
    _loginHistoryView.arrayTitles = [NSArray arrayWithArray:history];
    return _loginHistoryView;
}

#pragma mark - private function
-(void) createUI{
    WYLoginView *view = [[WYLoginView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    
    [self UIWXAppInstalled];
    view.txtField_phoneNumber.delegate = self;
    view.txtField_password.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    
    [view.codeCell.btn addTarget:self action:@selector(chooseCode) forControlEvents:UIControlEventTouchUpInside];
    [view.historyPhoneBtn addTarget:self action:@selector(clickHistoryBtn:) forControlEvents:UIControlEventTouchUpInside];

    [view.btn_colse addTarget:self action:@selector(colseBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_forgetPswd addTarget:self action:@selector(forgetPswdBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_fastPhoneLogin addTarget:self action:@selector(fastLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_register addTarget:self action:@selector(registerBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_wx addTarget:self action:@selector(wxLoginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //切换环境
    if ([WYUserDefaultManager getOpenChangeDomain]) {
        view.btn_changeEnv.hidden = NO;
        view.btn_changeEnv.enabled = YES;
    }else{
        view.btn_changeEnv.hidden = YES;
        view.btn_changeEnv.enabled = NO;
    }
    
    [view.btn_changeEnv addTarget:self action:@selector(changeEnvBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    //自动填充上次账号
    NSArray *history = [UserInfoUDManager getLoginInputPhones];
    NSDictionary *dict = history.firstObject;
    if (dict && dict.allKeys.count==2) {
        view.codeCell.label.text = [dict objectForKey:@"countryCode"];
        view.txtField_phoneNumber.text = [dict objectForKey:@"phone"] ;
    }
   
}

//获取商铺id
-(void)getShopInfo{
    
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {
        [UserInfoUDManager setShopId:data];

        [weakSelf dismissController];

    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)dismissController
{
    [MBProgressHUD zx_hideHUDForView:self.view];

    [self.navigationController dismissViewControllerAnimated:NO completion:^{
        
        [UserInfoUDManager loginIn];
    }];
}

//提交个推信息
-(void)postGTInfo{
    if ([[NSUserDefaults standardUserDefaults] objectForKey:ud_GTClientId]) {
        NSDictionary *dic = @{
                              @"roleType":@([WYUserDefaultManager getUserTargetRoleType]),
                              @"type":@"0",
#if !TARGET_IPHONE_SIMULATOR //真机
//                              @"token":[[NSUserDefaults standardUserDefaults] objectForKey:ud_deviceToken],
                              @"did":[[UIDevice currentDevice]zx_getIDFAUUIDString],
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
}

#pragma mark - button aciton

//选择国家区号
-(void)chooseCode{
    WYLoginView *view = (WYLoginView *)self.view;
    CountryCodeViewController *vc = [[CountryCodeViewController alloc] init];
    vc.selectCity = ^(NSString *cityName){
        view.codeCell.label.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}
//弹出历史账号
-(void)clickHistoryBtn:(UIButton *)sender
{
    WYLoginView *view = (WYLoginView *)self.view;
    if (self.loginHistoryView.arrayTitles&&self.loginHistoryView.arrayTitles.count>0) {
        [self.view endEditing:YES];
        sender.selected = YES;
        [view addSubview:self.loginHistoryView];
    }
}

//关闭按钮
-(void)colseBtnAction{
    [self.view endEditing:YES];
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

//注册
-(void)registerBtnAction{
    WYRegisterViewController *vc = [[WYRegisterViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//忘记密码
-(void)forgetPswdBtnAction{
    WYForgetPasswordViewController *vc = [[WYForgetPasswordViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//手机快捷登录
-(void)fastLoginBtnAction{
    WYPhoneLoginViewController *vc = [[WYPhoneLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

//登录
-(void)loginBtnAction{
    [self.view endEditing:YES];
    WYLoginView *view = (WYLoginView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *password = view.txtField_password.text;
    NSString *countrycode = view.codeCell.label.text;
    [MBProgressHUD zx_showLoadingWithStatus:@"正在登录" toView:self.view];
    
    [[[AppAPIHelper shareInstance] getUserModelAPI]getLoginWithUserName:phone password:password countryCode:countrycode  success:^(id data) {
        
        [self getShopInfo];
        [self postGTInfo];
       
        [self saveHistoryPhones];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
    
}
//本地存储历史账号
-(void)saveHistoryPhones
{
    WYLoginView *view = (WYLoginView *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *countrycode = view.codeCell.label.text;
    
    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
    if (![NSString zhIsBlankString:countrycode]) {
        [dictM setObject:countrycode forKey:@"countryCode"];
    }
    if (![NSString zhIsBlankString:phone]) {
        [dictM setObject:phone forKey:@"phone"];
    }
    if (dictM.allKeys.count == 2) {
        [UserInfoUDManager saveLoginInputPhone:dictM];
    }
}
//微信登录
-(void)wxLoginBtnAction{
    SendAuthReq *req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    
    req.openID = [WYUserDefaultManager getkURL_WXAPPID];
    req.state = @"123456";
    //微信要求这样写
    appdelegate = [UIApplication sharedApplication].delegate;
    appdelegate.wxDelegate = self;
    [WXApi sendReq:req];
}


//切换环境
-(void)changeEnvBtnAction{
    NSLog(@"切换环境入口");
    [self zx_pushStoryboardViewControllerWithStoryboardName:@"Main" identifier:@"ChangeDomainID" withData:nil];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    WYLoginView *view = (WYLoginView *)self.view;
//    if (textField == view.txtField_phoneNumber) {
//        if (string.length == 0) return YES;
//        NSInteger existedLength = textField.text.length;
//        NSInteger selectedLength = range.length;
//        NSInteger replaceLength = string.length;
//        if (existedLength - selectedLength + replaceLength > 11) {
//            return NO;
//        }
//    }
    if (textField == view.txtField_password) {
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
    WYLoginView *view = (WYLoginView *)self.view;
    [self.gradientLayer removeFromSuperlayer];
    //-----------------手机号取消限制
    if (view.txtField_phoneNumber.text.length >0 && view.txtField_password.text.length > 0) {
        [view.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xE23728].CGColor,(id)[UIColor colorWithHex:0xCF2218].CGColor, nil];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1.0, 0);
        gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 40);
        [view.btn_confirm.layer insertSublayer:gradientLayer atIndex:0];
        self.gradientLayer = gradientLayer;
        view.btn_confirm.userInteractionEnabled = YES;
    }else{
        [view.btn_confirm setTitleColor:WYUISTYLE.colorBWhite forState:UIControlStateNormal];
        [view.btn_confirm setBackgroundColor:[UIColor colorWithHex:0xD9D9D9]];
        view.btn_confirm.userInteractionEnabled = NO;
    }
}


#pragma mark - 微信登录代理
-(void)UIWXAppInstalled{
    if ([WXApi isWXAppInstalled]) {
        WYLoginView *view = (WYLoginView *)self.view;
        view.lineleft.hidden = NO;
        view.lineright.hidden = NO;
        view.lbl_wx.hidden = NO;
        view.btn_wx.hidden = NO;
    }else{
        //未安装微信
        WYLoginView *view = (WYLoginView *)self.view;
        view.lineleft.hidden = YES;
        view.lineright.hidden = YES;
        view.lbl_wx.hidden = YES;
        view.btn_wx.hidden = YES;
    }
}


-(void)loginSuccessByCode:(NSString *)code{
    NSLog(@"code %@",code);
    [[[AppAPIHelper shareInstance] getUserModelAPI] geWXLoginWithCODE:code success:^(id data) {
        
        NSNumber *isNeedBindPhone = [data objectForKey:@"isNeedBindPhone"];
        
        if (isNeedBindPhone.intValue) {
            WYBindViewController *vc = [[WYBindViewController alloc] init];
            vc.unionidUUID = [data objectForKey:@"unionidUUID"];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self getShopInfo];
            [self postGTInfo];
        }
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

@end
