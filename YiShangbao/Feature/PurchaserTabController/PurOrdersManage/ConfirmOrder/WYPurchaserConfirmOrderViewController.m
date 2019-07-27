//
//  WYPurchaserCofirmOrderViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderViewController.h"
#import "WYPurchaserReceiverInformationView.h"
#import "WYPurchaserConfirmOrderToolView.h"
#import "WYPurchaserConfirmOrderTableViewCell.h"
#import "WYLosePurchaserConfirmOrderTableViewCell.h"
#import "WYPurchaserConfirmOrderHeaderView.h"
#import "WYPurchaserConfirmOrderFooterView.h"

#import "WYPlaceOrderModel.h"

#import "WYPurchaserConfirmOrderEditAddressViewController.h"
#import "WYPurchaserPlaceOrderSuccessViewController.h"
#import "WYChoosePayWayViewController.h"
#import "BuyerPageMenuController.h"

@interface WYPurchaserConfirmOrderViewController ()<UITableViewDelegate,UITableViewDataSource,WYPurchaserConfirmOrderHeaderViewDelegate,WYPurchaserConfirmOrderFooterViewDelegate>

@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) WYConfirmOrderInfoModel *model;

@property (nonatomic ,strong) WYPurchaserConfirmOrderToolView * confirmOrderToolView;
@property (nonatomic ,strong) WYPurchaserReceiverInformationView *receiverInformationView;

@property (nonatomic ) CGFloat addressViewHeight;
@property (nonatomic ,strong) NSString *leaveMessage;//留言

@end

@implementation WYPurchaserConfirmOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"确认订单";
    self.tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    
    [self creatUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requsetData)];
//    [self.tableView.mj_header beginRefreshing];
    
    self.addressViewHeight = 60;
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WYPurchaserConfirmOrderFooterViewDelegate
//修改产品数量回调
- (void)updateQuantity:(NSInteger)quantity{
    WYConfirmOrderModel *orderModel = self.model.orderList[0];
    if (orderModel.itemList.count > 0 && self.cartIds.length <= 0){
        self.leaveMessage = orderModel.leaveMessage;
    }
    
    self.quantity = quantity;
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [self requsetData];
}

#pragma mark - ButtonTouchAction
- (void)editAddressAction:(UIButton *)sender{
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
    WYPurchaserConfirmOrderEditAddressViewController *editAddressVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_EditAddressViewController];
    
    [self.navigationController pushViewController:editAddressVC animated:YES];
}

- (void)placeOrderAction:(UIButton *)sender{
    [MobClick event:kUM_c_submit];
    [self creatOrderRequest];
    
}

- (void)goShopId:(NSString *)shopId{
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.model.orderList.count + 1 - !self.model.invalidOrderList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (section < self.model.orderList.count) {
        WYConfirmOrderModel *orderModel = self.model.orderList[section];
        return orderModel.itemList.count;
    }else{
        WYConfirmInvalidOrderModel *invalidOrderModel = self.model.invalidOrderList[section - self.model.orderList.count];
        return invalidOrderModel.itemList.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section < self.model.orderList.count) {
        WYPurchaserConfirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYPurchaserConfirmOrderTableViewCellID];
        if (!cell) {
            cell = [[WYPurchaserConfirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYPurchaserConfirmOrderTableViewCellID];
        }
        WYConfirmOrderModel *orderModel = self.model.orderList[indexPath.section];
        [cell updateData:orderModel.itemList[indexPath.row]];
        return cell;
    }else{
        WYLosePurchaserConfirmOrderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYLosePurchaserConfirmOrderTableViewCellID];
        if (!cell) {
            cell = [[WYLosePurchaserConfirmOrderTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYLosePurchaserConfirmOrderTableViewCellID];
        }
        WYConfirmInvalidOrderModel *invalidOrderModel = self.model.invalidOrderList[indexPath.section - self.model.orderList.count];
        [cell updateData:invalidOrderModel.itemList[indexPath.row]];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    CGFloat headerHeight;
    if (section < self.model.orderList.count) {
        headerHeight = 44.0;
    }else{
        headerHeight =  0.01;
    }
    //加地址高度
    if (section == 0) {
        headerHeight += self.addressViewHeight;
    }
    return headerHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section < self.model.orderList.count && self.cartIds.length > 0) {
        return 140.0;
    }else if (section < self.model.orderList.count && self.cartIds.length <= 0) {
        return 140.0 + 45.0;
    }else{
        return 0.01;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WYPurchaserConfirmOrderHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WYPurchaserConfirmOrderHeaderViewID];
    if (!headerView) {
        headerView = [[WYPurchaserConfirmOrderHeaderView alloc]initWithReuseIdentifier:WYPurchaserConfirmOrderHeaderViewID];
    }
    if (section == 0) {
        [headerView addSubview:self.receiverInformationView];
    }else if(headerView == [self.receiverInformationView superview]){
        [self.receiverInformationView removeFromSuperview];
    }
    if (section < self.model.orderList.count) {
        WYConfirmOrderModel *orderModel = self.model.orderList[section];
        headerView.delegate = self;
        [headerView updateData:orderModel];
        return headerView;
    }else if(section == 0){
        return headerView;
    }else{
        return nil;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    WYPurchaserConfirmOrderFooterView *fooderView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WYPurchaserConfirmOrderFooterViewID];
    if (!fooderView) {
        fooderView = [[WYPurchaserConfirmOrderFooterView alloc]initWithReuseIdentifier:WYPurchaserConfirmOrderFooterViewID];
    }
    if (self.cartIds.length > 0){
        fooderView.countView.hidden = YES;
    }else {
        fooderView.countView.hidden = NO;
        fooderView.delegate = self;
    }
    if (section < self.model.orderList.count) {
        WYConfirmOrderModel *orderModel = self.model.orderList[section];
        [fooderView updateData:orderModel];
        return fooderView;
    }else{
        return nil;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    
}

#pragma mark -Request
- (void)requsetData{
//    @(604)@(2)
//    self.cartIds = nil;
//    self.itemId = 1129;//1129;//337
//    self.quantity = 5886;
//    self.cartIds = [NSString stringWithFormat:@"%@,108,111",self.cartIds];
//    self.cartIds = @"108,111";
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] placeOrderAPI] getBuyerConfirmOrderWithItemId:self.itemId quantity:self.quantity skuId:nil cartIds:self.cartIds success:^(id data) {
        weakSelf.model = data;
        [weakSelf reloadInfo];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zx_hideHUDForView:self.view];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zx_hideHUDForView:self.view];
    }];
}

- (void)creatOrderRequest{
    if(self.model.orderList.count == 0){
        return;
    }
    //处理创建订单所需信息
    NSDictionary *addressDic = @{@"storage":self.model.address.storage,};
    NSMutableArray *orderList = [NSMutableArray array];
    for (WYConfirmOrderModel *orderModel in self.model.orderList) {
        NSMutableArray *itemList = [NSMutableArray array];
        for (WYConfirmOrderGoodsModel *goodsModel in orderModel.itemList) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:goodsModel.storage];
            [dic setObject:@(goodsModel.quantity) forKey:@"quantity"];
            goodsModel.storage = dic;
            [itemList addObject:@{@"storage":goodsModel.storage}];
        }
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:orderModel.storage];
        if (!orderModel.leaveMessage) {
            orderModel.leaveMessage = @"";
        }
        [dic setObject:orderModel.leaveMessage forKey:@"memo"];
        orderModel.storage = dic;
        [orderList addObject:@{@"storage":orderModel.storage,
                               @"itemList":itemList}];
    }
    
//    if (orderList.count == 0) {
//#warning 全失效处理
//    }
    
//    [self.navigationController popViewControllerAnimated:YES];
//    [[WYUtility dataUtil]routerWithName:@"www.baidu.com" withSoureController:self];
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] placeOrderAPI] postBuyerCreatOrderAddress:addressDic orderList:orderList success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        WYCreatOrderSuccessModel *model = data;
        if ([model.extraInfo.jumpPage isEqualToString:@"payPage"]){
            WYChoosePayWayViewController *payWayVC = [[WYChoosePayWayViewController alloc]init];
            payWayVC.orderId =model.orderIds;//订单号
            payWayVC.priceString = model.orderSumInfo.sumTotalPrice;//待支付金额
            weakSelf.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:payWayVC animated:YES];
        } else if ([model.extraInfo.jumpPage isEqualToString:@"orderListPage"]){
            BuyerPageMenuController *vc = [[BuyerPageMenuController alloc] init];
            vc.orderListStatus = OrderListStatus_Obligation;
            vc.hidesBottomBarWhenPushed = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
        }
        NSMutableArray *marr = [[NSMutableArray alloc]initWithArray:weakSelf.navigationController.viewControllers];
        for (UIViewController *vc in marr) {
            if ([vc isKindOfClass:[WYPurchaserConfirmOrderViewController class]]) {
                [marr removeObject:vc];
                break;
            }
        }
        weakSelf.navigationController.viewControllers = marr;
//        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
//        WYPurchaserPlaceOrderSuccessViewController *placeOrderSuccessVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_PlaceOrderSuccessViewController];
//        placeOrderSuccessVC.model = data;
//        [weakSelf.navigationController pushViewController:placeOrderSuccessVC animated:YES];
    } failure:^(NSError *error) {
        NSString *code = [error.userInfo objectForKey:@"code"];
        if ([code isEqualToString:@"order_all_invalid"]) {
            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:nil message:[error.userInfo objectForKey:@"NSLocalizedDescription"] cancelButtonTitle:@"知道了" cancleHandler:^(UIAlertAction * _Nonnull action) {
                [weakSelf.navigationController popViewControllerAnimated:YES];
            } doButtonTitle:nil doHandler:^(UIAlertAction * _Nonnull action) {
            }];
        }else{
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }
    }];
}

#pragma mark - Private function

- (void)creatUI{
    
    self.confirmOrderToolView = [[WYPurchaserConfirmOrderToolView alloc]init];
    [self.view addSubview:self.confirmOrderToolView];
    [self.confirmOrderToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view);
        }
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@53);
    }];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[WYPurchaserConfirmOrderTableViewCell class] forCellReuseIdentifier:WYPurchaserConfirmOrderTableViewCellID];
    [_tableView registerClass:[WYLosePurchaserConfirmOrderTableViewCell class] forCellReuseIdentifier:WYLosePurchaserConfirmOrderTableViewCellID];
    [_tableView registerClass:[WYPurchaserConfirmOrderFooterView class] forHeaderFooterViewReuseIdentifier:WYPurchaserConfirmOrderFooterViewID];
    [_tableView registerClass:[WYPurchaserConfirmOrderHeaderView class] forHeaderFooterViewReuseIdentifier:WYPurchaserConfirmOrderHeaderViewID];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(64);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.confirmOrderToolView.mas_top);
    }];
    
    
    self.receiverInformationView = [[WYPurchaserReceiverInformationView alloc]init];
    [self.tableView addSubview:self.receiverInformationView];
    [self.receiverInformationView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView);
        make.left.equalTo(self.tableView);
//        make.right.equalTo(self.tableView);
        make.width.equalTo(@SCREEN_WIDTH);
    }];
    [self.receiverInformationView.editButton addTarget:self action:@selector(editAddressAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.separatorInset = UIEdgeInsetsMake(-50, 0, 0, 0);
    
    [self.confirmOrderToolView.settleAccountsButton addTarget:self action:@selector(placeOrderAction:) forControlEvents:UIControlEventTouchUpInside];
}



- (void)reloadInfo{
    [self.confirmOrderToolView settleAccountsButtonIsTouch:self.model.orderList.count];
    [self.confirmOrderToolView updateData:self.model.orderSumInfo];
    [self.receiverInformationView updateData:self.model.address];
    CGFloat height = [self.receiverInformationView.addressLabel sizeThatFits:CGSizeMake(SCREEN_WIDTH-75-48, MAXFLOAT)].height;
    self.addressViewHeight =  height > 16? 90:75;
    
    //立即购买时保存留言
    if (self.model.orderList.count > 0 && self.cartIds.length <= 0) {
        WYConfirmOrderModel *orderModel = self.model.orderList[0];
        orderModel.leaveMessage = self.leaveMessage;
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
