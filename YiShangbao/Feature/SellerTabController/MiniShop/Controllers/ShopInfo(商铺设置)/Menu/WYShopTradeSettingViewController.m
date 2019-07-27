//
//  WYShopTradeSettingViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopTradeSettingViewController.h"

@interface WYShopTradeSettingViewController ()
@property (weak, nonatomic) IBOutlet UISwitch *tradeSwitch;

@end

@implementation WYShopTradeSettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self clickTradesettingRequest];
    
    if (self.canTrade.integerValue > 0) {
        self.tradeSwitch.on = YES;
    }else {
        self.tradeSwitch.on = NO;
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Request
//商铺设置中交易设置点击后
- (void)clickTradesettingRequest{
    [[[AppAPIHelper shareInstance] getShopAPI] postShopStoreFlushClickWithName:@"shop_trade_setting" success:^(id data) {
        
    } failure:^(NSError *error) {
    }];
}

- (IBAction)shopTradeSettingAction:(id)sender {
    
    UISwitch *switchBtn = sender;
    int status = switchBtn.on;
    [[[AppAPIHelper shareInstance] shopAPI] postShopTradeSettingWithStatus:@(status) success:^(id data) {
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
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
