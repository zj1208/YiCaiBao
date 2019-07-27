//
//  WYImmediateWithdrawalViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYImmediateWithdrawalViewController : UIViewController

//@property (weak, nonatomic) IBOutlet UIView *contentVieww;

@property (weak, nonatomic) IBOutlet UIView *containerView;


@property (weak, nonatomic) IBOutlet UIView *secondContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *BankCardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *xuanzebankLabel;
@property (weak, nonatomic) IBOutlet UIButton *selBankBtn;

//提现额度
@property (weak, nonatomic) IBOutlet UILabel *promptWithdrawalAmountLab;
@property (weak, nonatomic) IBOutlet UITextField *textfild;
//手续费
@property (weak, nonatomic) IBOutlet UILabel *shouxufeiLabel;
//超过可提现金额
@property (weak, nonatomic) IBOutlet UILabel *chaoguotixianLabel;


@property (weak, nonatomic) IBOutlet UILabel *inputPromptLab;

@property (weak, nonatomic) IBOutlet UIButton *tijiaoBtn;
@property (weak, nonatomic) IBOutlet UILabel *tijiaoDescLabel;

@end
