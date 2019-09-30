//
//  WYPhoneLoginViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/8.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYPhoneLoginViewController.h"
#import "WYPhoneLoginVIew.h"
#import "CountryCodeViewController.h"
#import "PhoneSetPasswordViewController.h"


NSInteger CounterGlobal = 1;

@interface WYPhoneLoginViewController ()<UITextFieldDelegate>


@end

@implementation WYPhoneLoginViewController



#pragma mark - life cycle


- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    
    //    NSMutableArray *arrayM = [NSMutableArray arrayWithObjects:@"1", @"2", nil];
    //    // copy深拷贝容器对象，创建的是不可变副本容器对象
    //    self.newArrayI=arrayM;
    //
    //    NSLog(@"arr_p:%p,class:%@",arrayM,[arrayM class]);
    //    NSLog(@"copyArr_p:%p,class:%@",self.newArrayI,[self.newArrayI class]);
    
    //    [arrayM removeObjectAtIndex:0];
    //    NSLog(@"arr_p:%p,class:%@,count= %@",arrayM,[arrayM class],@(arrayM.count));
    //    NSLog(@"copyArr_p:%p,class:%@,count= %@",self.aCopyArrayI,[self.aCopyArrayI class],@(_aCopyArrayI.count));
    
    [self blockTest];

    
    //    NSString *path =[[NSBundle mainBundle]pathForResource:@"11" ofType:@"jpg"];
    //    NSMutableData *data1 = [NSMutableData dataWithContentsOfFile:path];
    //    NSData *data2 = [data1 copy];
    //    NSData *data3 = [data1 mutableCopy];
    //    NSLog(@"p : %p, class: %@", data1, [data1 class]);
    //    NSLog(@"p : %p, class: %@", data2, [data2 class]);
    //    NSLog(@"p : %p, class: %@", data3, [data3 class]);
    /*
    WS(weakSelf);
    __block NSInteger num = 0;
    NSArray *arr_yiDon = @[@"134",@"135",@"136",@"137",@"138",@"139",@"147",@"150",@"151",@"152",@"157",@"158",@"159",@"172",@"178",@"182",@"183",@"184",@"187",@"188",@"198"];
    NSArray *arr_lianTong = @[@"130",@"131",@"132",@"145",@"155",@"156",@"166",@"171",@"175",@"176",@"185",@"186",@"166"];
    NSMutableArray *mArray = [arr_yiDon mutableCopy];
    [mArray addObjectsFromArray:arr_lianTong];
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3 repeats:YES block:^(NSTimer * _Nonnull timer) {
        if (num == 200) {
            [timer setFireDate:[NSDate distantFuture]];

        }
        NSString *begainNum = [mArray objectAtIndex:arc4random()%mArray.count];
        double afterNum = [self zhGetRandomNumberWithFrom:10000000 to:99999999];
        
        NSString *phone = [NSString stringWithFormat:@"%@%.f",begainNum,afterNum];
        [[[AppAPIHelper shareInstance] getUserModelAPI] getSendVerifyCodeMobile:phone countryCode:@"+86" type:@"3" success:^(id data) {
            num ++;
            [weakSelf zhHUD_showSuccessWithStatus:[NSString stringWithFormat:@"发送验证码成功-%@",@(num)]];

            
        } failure:^(NSError *error) {
            [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }];
    [timer fire];
    */
}

- (void)blockTest
{
    __block BOOL found = NO;
    NSSet *aSet = [NSSet setWithObjects: @"Alpha", @"Beta", @"Gamma", @"X", nil];
    NSString *string = @"gamma";
     
    [aSet enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        if ([obj localizedCaseInsensitiveCompare:string] == NSOrderedSame) {
            *stop = YES;
            found = YES;
        }
    }];
    // At this point, found == YES
}
/*
 0
 1
 2
 3
 4
 6
 7
 5
 9
 8
  */

- (int)zhGetRandomNumberWithFrom:(int)from to:(int)to
{
    return (int)(from + (arc4random() % (to-from + 1)));
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

#pragma mark - private function

-(void) createUI{
    self.title = @"手机快捷登录";
    WYPhoneLoginVIew *view = [[WYPhoneLoginVIew alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.txtField_phoneNumber.delegate = self;
    view.txtField_smsNumber.delegate = self;
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signInButChangeAlpha:) name:UITextFieldTextDidChangeNotification object:nil];
    
    //按钮触发
    [view.codeCell.btn addTarget:self action:@selector(chooseCode) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_send addTarget:self action:@selector(sendCodeTap) forControlEvents:UIControlEventTouchUpInside];
    [view.btn_confirm addTarget:self action:@selector(confirmTap) forControlEvents:UIControlEventTouchUpInside];
    //    [view.btn_read addTarget:self action:@selector(readTap) forControlEvents:UIControlEventTouchUpInside];
    [self changeLabelText:view.label_agree];
}

//协议内容
- (void)changeLabelText:(YYLabel *)label{
    
    NSString *string = @"温馨提示：未注册义采宝的手机号，登录时将自动注册，且代表您已阅读并同意以下协议 \n《义采宝用户服务协议》 《义采宝交易争议处理规则》";
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:string];
    one.yy_font = [UIFont boldSystemFontOfSize:14];
    one.yy_color = WYUISTYLE.colorSTgrey;
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


-(void)getShopInfo{
    
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {
        if (![data isEqual:[NSNull null]]) {
            [UserInfoUDManager setShopId:data];
            
            [weakSelf zhHUD_hideHUDForView:weakSelf.view];
            
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
    WYPhoneLoginVIew *view = (WYPhoneLoginVIew *)self.view;
    CountryCodeViewController *vc = [[CountryCodeViewController alloc] init];
    vc.selectCity = ^(NSString *cityName){
        view.codeCell.label.text = cityName;
    };
    [self.navigationController pushViewController:vc animated:YES];
}


//发送验证码
-(void)sendCodeTap{
    WYPhoneLoginVIew *view = (WYPhoneLoginVIew *)self.view;
    NSString *phone = view.txtField_phoneNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    
    [self zhHUD_showHUDAddedTo:self.view labelText:nil];
    [[[AppAPIHelper shareInstance] getUserModelAPI] getSendVerifyCodeMobile:phone countryCode:countryCode type:@"3" success:^(id data) {
        [self zhHUD_showSuccessWithStatus:@"发送验证码成功"];
        [view.btn_send startTime:59 title:@"重新发送" waitTittle:@"s后重发"];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

-(void)confirmTap{
    WYPhoneLoginVIew *view = (WYPhoneLoginVIew *)self.view;
    NSString *mobile = view.txtField_phoneNumber.text;
    NSString *verifyCode = view.txtField_smsNumber.text;
    NSString *countryCode = view.codeCell.label.text;
    [view.btn_send showIndicator];
    [self zhHUD_showHUDAddedTo:self.view labelText:@"正在登录"];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getUserModelAPI] getFastLoginWithMobile:mobile verificationCode:verifyCode countryCode:countryCode success:^(id data) {
        [view.btn_send hideIndicator];
        [self zhHUD_hideHUD];
        [weakSelf getShopInfo];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:ud_GTClientId]) {
            NSDictionary *dic = @{
                                  @"roleType":@([WYUserDefaultManager getUserTargetRoleType]),
                                  @"type":@"0",
#if !TARGET_IPHONE_SIMULATOR //真机
                                  //                                  @"token":[[NSUserDefaults standardUserDefaults] objectForKey:ud_deviceToken],
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
        //            PhoneSetPasswordViewController *vc = [[PhoneSetPasswordViewController alloc] init];
        //            vc.phone = mobile;
        //            [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [view.btn_send hideIndicator];
        [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
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

#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    WYPhoneLoginVIew *view = (WYPhoneLoginVIew *)self.view;
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
    WYPhoneLoginVIew *view = (WYPhoneLoginVIew *)self.view;
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



