//
//  WYChoosePayWayViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYChoosePayWayViewController.h"
#import "WYChoosePayWayTableViewCell.h"
#import "WYPayWayHeaderView.h"
#import "WYPublicModel.h"
#import "WYPaymentSuccessViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface WYChoosePayWayViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) NSArray *payWayList;

@property (nonatomic ,strong) WYPayWayHeaderView *headView;
@property (nonatomic ,strong) UIButton *payButton;
@property (nonatomic ,strong) CAGradientLayer *gradientLayer;
@property (nonatomic) NSInteger index;

@end

@implementation WYChoosePayWayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorF3F3F3];
    self.navigationItem.title = @"确认付款";
    self.tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    self.index = -1;
    self.automaticallyAdjustsScrollViewInsets = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResult:) name:Noti_PaymentResult_WYChoosePayWayViewController object:nil];
    [self requestPayWay];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.payWayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYChoosePayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYChoosePayWayTableViewCellID];
    if (!cell) {
        cell = [[WYChoosePayWayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYChoosePayWayTableViewCellID];
    }
    [cell updateData:self.payWayList[indexPath.row]];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 160.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 100.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return self.headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 375, 100)];
    self.payButton = [[UIButton alloc]initWithFrame:CGRectMake(16, 40, SCREEN_WIDTH - 32, 45)];
    self.payButton.titleLabel.font = [UIFont systemFontOfSize:20.0];
    [self.payButton setTitle:@"确定支付" forState:UIControlStateNormal];
    [self.payButton addTarget:self action:@selector(payAction) forControlEvents:UIControlEventTouchUpInside];
    self.payButton.layer.cornerRadius = 22.5;
    self.payButton.clipsToBounds = YES;
    [view addSubview:self.payButton];
    
    [self.payButton setBackgroundColor:[UIColor colorWithHex:0xDADADA]];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYChoosePayWayTableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    if (indexPath.row == self.index) {
        self.index = -1;
        [cell isSelect:NO];
    }else{
        if (self.index != -1) {
            NSIndexPath *oldIndexpath = [NSIndexPath indexPathForRow:self.index inSection:indexPath.section];
            WYChoosePayWayTableViewCell *oldCell = [self.tableView cellForRowAtIndexPath:oldIndexpath];
            [oldCell isSelect:NO];
        }
        [cell isSelect:YES];
        self.index = indexPath.row;
    }
}

#pragma mark -Payment
- (void)payAction{
    if (self.index > -1) {
        WS(weakSelf)
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
        WYPayWayModel *payWayModel = self.payWayList[self.index];
        [[[AppAPIHelper shareInstance] publicAPI] getPaymentOrderByOrderId:self.orderId payType:payWayModel.payWayId success:^(id data) {
            [MBProgressHUD zx_hideHUDForView:weakSelf.view];
            if ([data isKindOfClass:[NSString class]]) {
                [weakSelf paymentAlipayWithOrder:data];
            } else if ([data isKindOfClass:[WYWechatPaymentModel class]]){
                [weakSelf paymentWechatPayWith:data];
            }
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }
}


- (void)paymentAlipayWithOrder:(NSString *)orderString{
    NSString *appScheme = @"yicaibao";
    WS(weakSelf)
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [weakSelf paymentAlipayResult:[resultDic objectForKey:@"resultStatus"]];
    }];
}

- (void)paymentResult:(NSNotification *)notification {
    if ([notification.object isEqualToString:@"Alipay"]) {
        
        [self paymentAlipayResult:[notification.userInfo objectForKey:@"resultStatus"]];
    }else if([notification.object isEqualToString:@"Wechatpay"]){
        [self paymentWechatResult:[notification.userInfo objectForKey:@"code"]];
    }
}

- (void)paymentWechatPayWith:(WYWechatPaymentModel *)model{
    
    //调起微信支付
    PayReq *req = [[PayReq alloc] init];
    req.partnerId = model.partnerid;
    req.prepayId = model.prepayid;
    req.nonceStr = model.noncestr;
    req.timeStamp = model.timestamp.intValue;
    req.package = model.package;
    req.sign = model.sign;
    [WXApi sendReq:req];
}

//支付宝支付结果反馈
- (void) paymentAlipayResult:(NSString *)code{
    switch (code.integerValue) {
        case 9000:
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
            [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
            
            UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
            WYPaymentSuccessViewController *paymentSuccessVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_paySuccessViewController];
            paymentSuccessVC.orderId = self.orderId;
            paymentSuccessVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:paymentSuccessVC animated:YES];
        }
            
            break;
        case 8000:
            [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
        case 4000:
            [MBProgressHUD zx_showError:@"支付失败，请重新支付" toView:self.view];
            break;
        case 5000:
            [MBProgressHUD zx_showError:@"您已请求支付，无需重复操作" toView:self.view];
            break;
        case 6001:
            [MBProgressHUD zx_showError:@"您已取消支付" toView:self.view];
            break;
        case 6002:
            [MBProgressHUD zx_showError:@"网络好像有点问题噢，请检查您的网络设置" toView:self.view];
            break;
        case 6004:
            [MBProgressHUD zx_showError:@"正在处理支付结果，稍后注意查看结果" toView:self.view];
            break;
            
        default:
            [MBProgressHUD zx_showError:@"支付失败" toView:self.view];
            break;
    }
}

- (void)paymentWechatResult:(NSNumber *)code{
    if (code.integerValue == 0){
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
        
        [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
        WYPaymentSuccessViewController *paymentSuccessVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_paySuccessViewController];
        paymentSuccessVC.orderId = self.orderId;
        paymentSuccessVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:paymentSuccessVC animated:YES];
    }else{
        [MBProgressHUD zx_showError:@"支付失败" toView:self.view];
    }
}

#pragma mark -Request

- (void)requestPayWay{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] publicAPI] getAccountPayWaySuccess:^(id data) {
        weakSelf.payWayList = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark -GetterAndSetter
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
//        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.separatorColor = [UIColor colorWithHex:0xE1E2E3];
        [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
        [_tableView registerClass:[WYChoosePayWayTableViewCell class] forCellReuseIdentifier:WYChoosePayWayTableViewCellID];
        [self.view addSubview:_tableView];
        [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.equalTo(self.view);
            make.right.equalTo(self.view);
            make.bottom.equalTo(self.view);
        }];
    }
    return _tableView;
}

- (WYPayWayHeaderView *)headView{
    if (!_headView) {
        _headView = [[WYPayWayHeaderView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 160)];
        _headView.priceLabel.text = [NSString stringWithFormat:@"%@",self.priceString];
    }
    return _headView;
}

- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 32, 45);
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
    }
    return _gradientLayer;
}

- (void)setIndex:(NSInteger)newIndex{
    _index = newIndex;
    if (newIndex == -1) {
        [self.gradientLayer removeFromSuperlayer];
    }else{
        [self.payButton.layer insertSublayer:self.gradientLayer atIndex:0];
    }
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
