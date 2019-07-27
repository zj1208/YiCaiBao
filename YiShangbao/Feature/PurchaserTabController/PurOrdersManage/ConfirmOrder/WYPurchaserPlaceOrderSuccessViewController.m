//
//  WYPurchaserPlaceOrderSuccessViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserPlaceOrderSuccessViewController.h"
#import "WYPlaceOrderModel.h"
#import "BuyerPageMenuController.h"

@interface WYPurchaserPlaceOrderSuccessViewController ()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//副标题

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UILabel *priceNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@end

@implementation WYPurchaserPlaceOrderSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateView];
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
    BuyerPageMenuController *vc = [[BuyerPageMenuController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//返回首页
- (IBAction)backHomeAction:(id)sender {
    self.tabBarController.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)updateView{
    self.titleLabel.text = self.model.title;
    self.contentLabel.text = self.model.subTitle;
    self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@",self.model.address.fullName];
    self.phoneLabel.text = self.model.address.mobile;
    self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@",self.model.address.addressDetail];
    
    self.priceNameLabel.text = self.model.orderSumInfo.sumTotalPriceLabel;
    self.priceLabel.text = self.model.orderSumInfo.sumTotalPrice;
    self.tipLabel.text = self.model.orderSumInfo.tipInfo;
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
