//
//  WYImmediateSubmitSussessViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYImmediateSubmitSussessViewController.h"
#import "WYWKWebViewController.h"
#import "ZXWebViewController.h"

@interface WYImmediateSubmitSussessViewController ()

@end

@implementation WYImmediateSubmitSussessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorBGgrey];
    self.title = @"提交成功";
    
    [self buildUI];
}
-(void)buildUI
{
    self.navigationItem.hidesBackButton = YES;
    
    self.estimateArrivalTimeDescLabel.text = _accountsubmitModel.estimateArrivalTimeDesc;
    self.bankNameLabel.text = _accountsubmitModel.bankName;
    self.bankCardNoLabel.text = _accountsubmitModel.bankCardNo;
    self.amountLabel.text = _accountsubmitModel.amount;
    self.feeLabel.text = _accountsubmitModel.fee;

    _sureBtn.layer.masksToBounds = YES;
    _sureBtn.layer.cornerRadius = _sureBtn.bounds.size.height/2;;
    UIImage* image = [WYUISTYLE imageWithStartColorHexString:@"FD7953" EndColorHexString:@"FE5147" WithSize:_sureBtn.bounds.size];
    [_sureBtn setBackgroundImage:image forState:UIControlStateNormal];
}

- (IBAction)clickSureBackbtn:(id)sender {
    
    //返回指定"我的收入"界面(返回最近的H5控制器),如果没找到，返回根
    UIViewController* popVC;
    int nums = (int)self.navigationController.viewControllers.count-1;
    for (int i = nums;i>=0; --i) {
        UIViewController* VC = self.navigationController.viewControllers[i];
        if ([VC isKindOfClass:[WYWKWebViewController class]]) {
            popVC = VC;
            break;
        }
        if ([VC isKindOfClass:[ZXWebViewController class]]) {
            popVC = VC;
            break;
        }
    }
    if (popVC) {
        [self.navigationController popToViewController:popVC animated:NO];
    }else{
        [self.navigationController popToRootViewControllerAnimated:NO];
    }
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
