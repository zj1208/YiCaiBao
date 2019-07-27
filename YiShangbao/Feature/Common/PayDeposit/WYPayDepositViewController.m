//
//  WYPayDepositViewController.m
//  YiShangbao
//
//  Created by light on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPayDepositViewController.h"
#import "WYPayDepositTableViewCell.h"
#import "WYChoosePayWayTableViewCell.h"
#import "WYWKWebViewController.h"
#import "ZXWebViewController.h"

#import "WYPublicModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface WYPayDepositViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic ,strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) UIButton *payButton;

@property (nonatomic ,strong) WYAuthenticationInfoModel *model;
@property (nonatomic ,strong) NSArray *payWayList;
@property (nonatomic) NSInteger index;

@end

@implementation WYPayDepositViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"在线支付";
    self.view.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(paymentResult:) name:Noti_PaymentResult_WYChoosePayWayViewController object:nil];
    
    [self creatUI];
    [self loadData];
    self.index = 0;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action
- (void)payButtonAction{
    if (self.index > -1) {
        [MobClick event:kUM_b_payforauthentication];
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

#pragma mark -Request
- (void)loadData{
    [self requestPayInfo];
    [self requestPayWay];
}

- (void)requestPayInfo{
    WS(weakSelf)
//    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] publicAPI] getBuyQueryAuthenticationInfoComboId:self.comboId success:^(id data) {
//        [MBProgressHUD zx_showSuccess:@"" toView:weakSelf.view];
        if (data) {
            weakSelf.model = data;
            [weakSelf.tableView reloadData];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestPayWay{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] publicAPI] getAccountPayWaySuccess:^(id data) {
        weakSelf.payWayList = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)paymentAlipayWithOrder:(NSString *)orderString{
    NSString *appScheme = @"yicaibao";
    WS(weakSelf)
    [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
        [weakSelf paymentAlipayResult:[resultDic objectForKey:@"resultStatus"]];
    }];
}

#pragma mark -PayResult

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
- (void)paymentAlipayResult:(NSString *)code{
    switch (code.integerValue) {
        case 9000:
        {
            [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
            [self goPaySuccessVC];
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
        [MBProgressHUD zx_showError:@"恭喜您支付成功" toView:self.view];
        [self goPaySuccessVC];
    }else{
        [MBProgressHUD zx_showError:@"支付失败" toView:self.view];
    }
}

- (void)goPaySuccessVC{
    if (self.paySuccessBlock) {
        self.paySuccessBlock();
    }
    
    WYWKWebViewController *htmlVC;
    ZXWebViewController *oldHtmlVC;
    NSArray *array = self.navigationController.viewControllers;
    NSArray* reversedArray = [[array reverseObjectEnumerator] allObjects];
    for (UIViewController *vc in reversedArray) {
        if ([vc isKindOfClass:[WYWKWebViewController class]]) {
            htmlVC = (WYWKWebViewController *)vc;
            [htmlVC.webView goBack];
            [htmlVC.webView goBack];
            [self.navigationController popViewControllerAnimated:YES];
            WYWKWebViewController *webVC = [[WYWKWebViewController alloc] init];
            webVC.webUrl = self.model.payJumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
            htmlVC = webVC;
            break;
        }
        if ([vc isKindOfClass:[ZXWebViewController class]]) {
            oldHtmlVC = (ZXWebViewController *)vc;
            [oldHtmlVC.webView goBack];
            [oldHtmlVC.webView goBack];
            [self.navigationController popViewControllerAnimated:YES];
            ZXWebViewController *webVC = [[ZXWebViewController alloc] init];
            webVC.webUrl = self.model.payJumpUrl;
            [self.navigationController pushViewController:webVC animated:YES];
            oldHtmlVC = webVC;
            break;
        }
    }
    if (htmlVC){
        [self.navigationController popToViewController:htmlVC animated:YES];
    }else if (oldHtmlVC){
        [self.navigationController popToViewController:oldHtmlVC animated:YES];
    }else{//逻辑与开单服务支付弹窗 viewWillAppear调两次
        [self.navigationController popViewControllerAnimated:YES];
        [[WYUtility dataUtil]routerWithName:self.model.payJumpUrl withSoureController:self];
    }
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0){
        return 1;
    }else if (section == 1){
        return self.payWayList.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        WYPayDepositTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYPayDepositTableViewCellID forIndexPath:indexPath];
        if (!cell){
            cell = [[WYPayDepositTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYPayDepositTableViewCellID];
        }
        [cell updateData:self.model.ssView];
        return cell;
    }else{
        WYChoosePayWayTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYChoosePayWayTableViewCellID];
        if (!cell) {
            cell = [[WYChoosePayWayTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYChoosePayWayTableViewCellID];
        }
        cell.isRedHook = YES;
        [cell updateData:self.payWayList[indexPath.row]];
        if (self.index == indexPath.row) {
            [cell isSelect:YES];
        }else{
            [cell isSelect:NO];
        }
        return cell;
    }
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1){
        return 43;
    }
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
    }else if (indexPath.section == 1){
        return 55;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, 500, 43)];
        label.text = @"请选择支付方式";
        label.textColor = [UIColor colorWithHex:0x868686];
        label.font = [UIFont systemFontOfSize:14.0];
        
        [view addSubview:label];
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //支付方式单选处理
    if (indexPath.section == 1) {
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
}



#pragma mark -Private
- (void)creatUI{
    
    self.payButton = [[UIButton alloc]init];
    [self.view addSubview:self.payButton];
    [self.payButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view).offset(-60);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.height.equalTo(@45);
    }];
    
    [self.payButton setTitle:@"立即支付" forState:UIControlStateNormal];
    [self.payButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [self.payButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.payButton.layer.masksToBounds= YES;
    self.payButton.layer.cornerRadius = 22.5f;
    [self.payButton addTarget:self action:@selector(payButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.payButton setBackgroundColor:[UIColor colorWithHex:0xDADADA]];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHex:0xE1E2E3];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[WYPayDepositTableViewCell class] forCellReuseIdentifier:WYPayDepositTableViewCellID];
    [_tableView registerClass:[WYChoosePayWayTableViewCell class] forCellReuseIdentifier:WYChoosePayWayTableViewCellID];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.payButton.mas_top).offset(-20);
    }];
    
    _tableView.estimatedRowHeight = 55.0;
}

#pragma mark -GeterAndSetter
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30, 45);
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
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
