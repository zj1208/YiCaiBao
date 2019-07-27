//
//  WYTradeSetAlertController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYTradeSetAlertController.h"

@interface WYTradeSetAlertController ()

@end

@implementation WYTradeSetAlertController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.descLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(16.f)];
    self.alertView.layer.cornerRadius = 4.f;
    self.alertView.layer.masksToBounds = YES;
    self.descLabel.text = @"您还没有完商铺资料,\n系统无法为您推荐匹配的生意哦～";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)sureClcik:(UIButton *)sender {
    if (self.btnClcikBlock) {
        self.btnClcikBlock(sender);
    }
    [self dismissViewControllerAnimated:NO completion:nil];

}
- (IBAction)closeClick:(UIButton *)sender {
//    if (self.btnClcikBlock) {
//        self.btnClcikBlock(sender);
//    }
    [self dismissViewControllerAnimated:NO completion:nil];
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
