//
//  PurOrederSuccessfulDealViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurOrederSuccessfulDealViewController.h"

#import "WYPurOrderCommitViewController.h"
#import "SellerOrderDetailViewController.h"
@interface PurOrederSuccessfulDealViewController ()

@property (weak, nonatomic) IBOutlet UIButton *orderDetailButton;
@property (weak, nonatomic) IBOutlet UIButton *orederCommitButton;
@end

@implementation PurOrederSuccessfulDealViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"交易成功";

    CGFloat Btn_W = (LCDW-15.f*2-20.f)/2;
    CGFloat Btn_H = Btn_W*5.f/18.f;

    self.orderDetailButton.layer.masksToBounds = YES;
    self.orderDetailButton.layer.cornerRadius = Btn_H/2;
    self.orderDetailButton.layer.borderWidth = 0.5;
    self.orderDetailButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
    
    self.orederCommitButton.layer.masksToBounds = YES;
    self.orederCommitButton.layer.cornerRadius = Btn_H/2;
    UIImage* image = [WYUISTYLE imageWithStartColorHexString:@"FFBA49" EndColorHexString:@"FF8D32" WithSize:CGSizeMake(Btn_W, Btn_H)];
    [self.orederCommitButton setBackgroundImage:image forState:UIControlStateNormal];

}
//订单详情
- (IBAction)orderDetail:(id)sender {
    SellerOrderDetailViewController* viewC = [[SellerOrderDetailViewController alloc] init ];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.bizOrderId = _bizOrderId;
    [self.navigationController pushViewController:viewC animated:YES];
}
//买家评论
- (IBAction)orederCommit:(id)sender {
    WYPurOrderCommitViewController *viewC = [[WYPurOrderCommitViewController alloc] init ];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.bizOrderId = _bizOrderId;
    [self.navigationController pushViewController:viewC animated:YES];
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
