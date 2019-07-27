//
//  WYImmediateSubmitSussessViewController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AccountModel.h"

@interface WYImmediateSubmitSussessViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *estimateArrivalTimeDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *bankCardNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *feeLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

//estimateArrivalTimeDesc	string	预计到账时间说明
//bankName	string	银行名称
//bankCardNo	string	银行卡号
//amount	string	到账金额（格式：￥0.00）
//fee	string	手续费（格式：￥0.00）


@property(nonatomic,strong)AccountSubmitModel* accountsubmitModel;

@end
