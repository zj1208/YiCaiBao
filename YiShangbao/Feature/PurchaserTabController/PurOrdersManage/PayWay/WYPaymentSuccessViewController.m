//
//  WYPaymentSuccessViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPaymentSuccessViewController.h"
#import "SellerOrderDetailViewController.h"

@interface WYPaymentSuccessViewController ()

@property (weak, nonatomic) IBOutlet UIButton *lookOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *backHomeButton;

@end

@implementation WYPaymentSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.lookOrderButton.layer.cornerRadius = 22.5;
    self.lookOrderButton.layer.borderWidth = 0.5;
    self.lookOrderButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
    
    self.backHomeButton.layer.cornerRadius = 22.5;
    self.backHomeButton.layer.borderWidth = 0.5;
    self.backHomeButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)navigationShouldPopOnBackButton{
    [self.navigationController popToViewController:self.navigationController.viewControllers[self.navigationController.viewControllers.count - 3] animated:YES];
    return NO;
}

//查看订单
- (IBAction)lookOrderAction:(id)sender {
    SellerOrderDetailViewController *orderDetailVC = [[SellerOrderDetailViewController alloc] init];
    orderDetailVC.bizOrderId = self.orderId;
    orderDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:orderDetailVC animated:YES];
}

//返回首页
- (IBAction)backHomeAction:(id)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
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
