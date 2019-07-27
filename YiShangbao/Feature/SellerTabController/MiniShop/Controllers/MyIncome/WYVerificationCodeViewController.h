//
//  WYVerificationCodeViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountModel.h"

// 验证类型：忘记密码0，微信登录(绑定号码)1，手机号码注册2，短信登录3，采购端认证短信4，更换手机号码5，提现申请6，确认收货7
typedef NS_ENUM(NSInteger, VerificationCodeType) {
    VerificationCodeType_CashWithdrawal = 6 ,   //提现申请6
    VerificationCodeType_ConfirmReceiptOfGoods = 7 ,   //确认收货7

};

@class WYVerificationCodeViewController;
@protocol WYVerificationCodeViewControllerDelegate <NSObject>
@optional
//1.点击确定按钮代理,自身不校验验证码  (eg:提现，提交提现操作由WYImmediateWithdrawalViewController来请求校验)
-(void)jl_WYVerificationCodeViewControllerDidSureBtn:(WYVerificationCodeViewController*)wyverificationCodeViewController verificationCode:(NSString*)verificationCode;

//2.点击确定按钮代理,校验验证码成功 ,为了体验更好，需要手动掉用wy_remove移除  （eg:不传电话号码，自动获取，在当前控制器校验验证码正确后回调）
-(void)jl_WYVerificationCodeViewControllerVerificationCodeIsCorrect:(WYVerificationCodeViewController*)wyvCodeController;

@end
@interface WYVerificationCodeViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *VerificationCodeView;
@property (weak, nonatomic) IBOutlet UILabel *veriCodeTitleLabel;

@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;

@property (weak, nonatomic) IBOutlet UIView *textFiledContentView;
@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@property (weak, nonatomic) IBOutlet UIButton *againBtn;  //获取验证码

@property (weak, nonatomic) IBOutlet UILabel *writeSureLabel; //提示:请输入验证码
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;
@property (weak, nonatomic) IBOutlet UIButton *quedingBtn;

@property(nonatomic,weak)id<WYVerificationCodeViewControllerDelegate>delegate;

@property(nonatomic,strong)UIViewController* sourcecontroller; 


//必须传入参数
@property(nonatomic,assign)VerificationCodeType type	;//验证码类型

@property(nonatomic,copy)NSString *bizOrderId	;//订单号，用于传值给交易成功




//下面两个电话参数目前只用于提现用
@property(nonatomic,copy)NSString*countryCode	;//string	国家区号
@property(nonatomic,copy)NSString*phone	;//string	手机号(不传的话，回自动获取电话号码，自动校验，校验成功走完成代理2，目前只有提现这需要传这两个参数过来)

-(void)wy_remove;

@end
