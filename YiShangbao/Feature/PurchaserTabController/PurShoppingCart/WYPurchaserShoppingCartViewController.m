//
//  WYPurchaserShoppingCartViewController.m
//  YiShangbao
//
//  Created by light on 2017/8/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserShoppingCartViewController.h"
#import "WYPurchaserShoppingCartTableViewCell.h"
#import "WYLosePurchaserShoppingCartTableViewCell.h"
#import "WYPurchaserShoppingCartHeaderView.h"
#import "WYPurchaserShoppingCartToolView.h"
#import "ZXBadgeIconButton.h"
#import "WYBlankPageView.h"

#import "WYShopCartModel.h"

#import "WYMessageListViewController.h"
#import "WYPurchaserConfirmOrderViewController.h"

@interface WYPurchaserShoppingCartViewController ()<UITableViewDelegate,UITableViewDataSource,WYPurchaserShoppingCartHeaderViewDelegate,WYPurchaserShoppingCartTableViewCellDelegate>

@property (nonatomic ,strong) UITableView *tableView;

@property (nonatomic ,strong) ZXBadgeIconButton* messageBadgeButton;
@property (nonatomic ,strong) WYPurchaserShoppingCartToolView *bottomToolView;
@property (nonatomic ,strong) UIButton *cleanLoseGoodsButton;
@property (nonatomic ,weak) UIButton *editButton;

@property (nonatomic ,strong) WYBlankPageView *blankPageView;//空白页

@property (nonatomic ,strong) WYShopCartModel *model;
@property (nonatomic) BOOL isAllSelected;//是否全选
@property (nonatomic) BOOL isEdit;//是否编辑状态
@property (nonatomic) NSInteger selectedCount;//选中个数

@property (nonatomic ,strong) WYGoodsPriceModel *priceModel;//修改数量后单价

@end

@implementation WYPurchaserShoppingCartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"进货单";
    self.view.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
    
    [self creatUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestCartData)];
  
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //恢复默认设置
    self.isEdit = YES;
    [self editButtonAction:self.editButton];
    
    [self headerRefresh];
    [self requestMessageInfo];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
     
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -WY
- (void)loginOut:(id)notification{
    self.model = nil;
    [self.tableView reloadData];
}

#pragma mark -WYPurchaserShoppingCartTableViewCellDelegate

- (void)goodsChangeStatus:(ChangeGoodsCountStatus)status goodsId:(NSString *)cartId quantity:(NSInteger)quantity{
    [self requestChangeQuantityByCartId:cartId withQuantity:quantity];
    [self computeTotalPrice];
    switch (status) {
        case ChangeGoodsCountStatusSuccess:
            break;
        case ChangeGoodsCountStatusFailureByMax:
            [MBProgressHUD zx_showError:[NSString stringWithFormat:@"本产品最大订购量为%ld，超过不能购买噢",quantity] toView:self.view];
            break;
        case ChangeGoodsCountStatusFailureByMin:
            [MBProgressHUD zx_showError:[NSString stringWithFormat:@"本产品最小起订量为%ld，起订量以下不能购买噢",quantity] toView:self.view];
            break;
            
        default:
            break;
    }
    
    
}
//商品选择
- (void)goodsSelected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath{
    if (isSelected) {
        WYShopCartShopInfoModel *shopInfoModel = self.model.list[indexPath.section];
        shopInfoModel.isSelected = YES;
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            if (goodsModel.isSelected == NO){
                shopInfoModel.isSelected = NO;
                break;
            }
        }
        if (shopInfoModel.isSelected == YES) {
            [self shopAllSelected:YES section:indexPath.section];
        }
    }else{
        WYShopCartShopInfoModel *shopInfoModel = self.model.list[indexPath.section];
        shopInfoModel.isSelected = NO;
        self.isAllSelected = isSelected;
        [self.bottomToolView isAllSelected:self.isAllSelected];
    }
    [self.tableView reloadData];
    [self computeTotalPrice];
}

#pragma mark -WYPurchaserShoppingCartHeaderViewDelegate
//商铺选择
- (void)shopAllSelected:(BOOL)isSelected section:(NSInteger)section{
    WYShopCartShopInfoModel *shopInfoModel = self.model.list[section];
    for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
        goodsModel.isSelected = isSelected;
    }
    [self.tableView reloadData];
    
    if (isSelected) {
        self.isAllSelected = YES;
        for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
            if (shopInfoModel.isSelected == NO){
                self.isAllSelected = NO;
                break;
            }
        }
    }else{
        self.isAllSelected = NO;
    }
    [self.bottomToolView isAllSelected:self.isAllSelected];
    [self computeTotalPrice];
}

- (void)goShopId:(NSString *)shopId{
    [MobClick event:kUM_c_slnickname];
    [self.view endEditing:YES];
    if (self.isEdit) {
        [MBProgressHUD zx_showError:@"请先点击右上角完成" toView:self.view];
        return;
    }
    if (shopId.length == 0 || [UserInfoUDManager getToken].length == 0) {
        return;
    }
    NSString *url = self.model.shopUrl;
    url = [url stringByReplacingOccurrencesOfString:@"{shopId}" withString:shopId];
    url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
    url = [url stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
    [self goWebViewWithUrl:url];
}

#pragma mark - ButtonTouchAction
//全选
- (void)allSelectedAction:(UIButton *)sender{
    self.isAllSelected = !self.isAllSelected;
    [self.bottomToolView isAllSelected:self.isAllSelected];
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        shopInfoModel.isSelected = self.isAllSelected;
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            goodsModel.isSelected = self.isAllSelected;
        }
    }
    [self.tableView reloadData];
    [self computeTotalPrice];
}

//编辑完成
-(void)editButtonAction:(UIButton *)sender{
    [MobClick event:kUM_c_sledit];
    if (self.isEdit) {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor colorWithHex:0x222222] forState:UIControlStateNormal];
        self.bottomToolView.editView.hidden = YES;
    }else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        [sender setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
        self.bottomToolView.editView.hidden = NO;
    }
    self.isEdit = !self.isEdit;
}
//清空失效商品
- (void)cleanLoseGoodsAction:(UIButton *)sender{
    [MobClick event:kUM_c_slinvalid];
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:@"确认清空失效宝贝吗？" cancelButtonTitle:@"取消" cancleHandler:^(UIAlertAction * _Nonnull action) {
        
    } doButtonTitle:@"确认" doHandler:^(UIAlertAction * _Nonnull action) {
        [self requestCleanInvalidProduct];
    }];
}
//消息
- (void)messageBadgeButtonAction:(UIButton *)sender{
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        [MobClick event:kUM_message];
        
        WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
        messageList.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
}

//结算
- (void)settleAccountsAction:(UIButton *)sender{
    [MobClick event:kUM_c_slsettleaccounts];
    if (!self.selectedCount) {
        [MBProgressHUD zx_showError:@"您还没有选中产品噢～" toView:self.view];
        return;
    }
    
    NSMutableArray *array = [NSMutableArray array];
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            if (goodsModel.isSelected){
                [array addObject:[goodsModel.cartId copy]];
            }
        }
    }
    [self requestSettleValidateCartIds:array];
}
//移入收藏夹
- (void)collectAction:(UIButton *)sender{
    
}
//删除
- (void)deleteAction:(UIButton *)sender{
    if (!self.selectedCount) {
        [MBProgressHUD zx_showError:@"您还没有选中产品噢～" toView:self.view];
        return;
    }
    
    NSMutableArray *cartIds = [NSMutableArray array];
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            if (goodsModel.isSelected){
                [cartIds addObject:[goodsModel.cartId copy]];
            }
        }
        
    }
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:[NSString stringWithFormat:@"确认将这%ld个产品删除吗？",cartIds.count] cancelButtonTitle:@"取消" cancleHandler:^(UIAlertAction * _Nonnull action) {
        
    } doButtonTitle:@"确认" doHandler:^(UIAlertAction * _Nonnull action) {
        [self requestDeleteProducts:cartIds];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //判断有没有数据展示空白页
    if (self.model.list.count + self.model.invalidProducts.count) {
        _tableView.tableFooterView = nil;
    }else{
        _tableView.tableFooterView = _blankPageView;
    }
    return self.model.list.count + 1 - !self.model.invalidProducts.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section < self.model.list.count) {
        WYShopCartShopInfoModel *shopInfoModel = self.model.list[section];
        return shopInfoModel.products.count;
    }else{
        return self.model.invalidProducts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section < self.model.list.count) {
        WYShopCartShopInfoModel *shopInfoModel = self.model.list[indexPath.section];
        WYPurchaserShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYPurchaserShoppingCartTableViewCellID];
        if (!cell) {
            cell = [[WYPurchaserShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYPurchaserShoppingCartTableViewCellID];
        }
        cell.maxProductDigit = self.model.quantityLimit;
        cell.delegate = self;
        [cell updateData:shopInfoModel.products[indexPath.row] indexPath:indexPath];
        return cell;
    }else{
        WYLosePurchaserShoppingCartTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYLosePurchaserShoppingCartTableViewCellID];
        if (!cell) {
            cell = [[WYLosePurchaserShoppingCartTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYLosePurchaserShoppingCartTableViewCellID];
        }
        [cell updateData:self.model.invalidProducts[indexPath.row]];
        return cell;
    }
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 113.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section >= self.model.list.count) {
        return 0.01;
    }
    return 45.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section >= self.model.list.count && self.model.invalidProducts.count) {
        return 65.0 + 10;
    }
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section >= self.model.list.count) {
        return nil;
    }
    WYPurchaserShoppingCartHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WYPurchaserShoppingCartHeaderViewID];
    if (!headerView) {
        headerView = [[WYPurchaserShoppingCartHeaderView alloc]initWithReuseIdentifier:WYPurchaserShoppingCartHeaderViewID];
    }
    headerView.delegate = self;
    [headerView updateData:self.model.list[section] section:section];
    return headerView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section >= self.model.list.count && self.model.invalidProducts.count) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 600, 75)];
        [view setBackgroundColor:[UIColor whiteColor]];
        [view addSubview:self.cleanLoseGoodsButton];
        [self.cleanLoseGoodsButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(view);
            make.width.equalTo(@100);
        }];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, 65, 600, 10)];
        backView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
        [view addSubview:backView];
        return view;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
    if (self.isEdit) {
        [MBProgressHUD zx_showError:@"请先点击右上角完成" toView:self.view];
        return;
    }
    if (indexPath.section < self.model.list.count) {
        WYShopCartShopInfoModel *shopInfoModel = self.model.list[indexPath.section];
        WYShopCartGoodsModel *goodsModel = shopInfoModel.products[indexPath.row];
        NSString *url = self.model.productUrl;
        url = [url stringByReplacingOccurrencesOfString:@"{productId}" withString:goodsModel.goodsId];
        url = [url stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
        url = [url stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
        [self goWebViewWithUrl:url];
    }
}

#pragma mark - Request

- (void)headerRefresh{
    [self.tableView.mj_header beginRefreshing];
}

//获取购物车信息
- (void)requestCartData{
    [self.view endEditing:YES];
    self.isAllSelected = NO;
    [self.bottomToolView isAllSelected:self.isAllSelected];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] shopCartAPI] getBuyerShopCartSuccess:^(id data) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.model = data;
        weakSelf.navigationItem.title = [NSString stringWithFormat:@"进货单(%ld)",weakSelf.model.productCount];
        [weakSelf.tableView reloadData];
        [weakSelf computeTotalPrice];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestChangeQuantityByCartId:(NSString *)cartId withQuantity:(NSInteger)quantity{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] shopCartAPI] postBuyerModifyCartInfoCartId:cartId quantity:quantity success:^(id data) {
        [weakSelf changeGoodsPriceModel:data cartId:cartId];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestDeleteProducts:(NSArray *)cartIds{
    
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] shopCartAPI] postBuyerDeleteProductCartIds:cartIds success:^(id data) {
        [weakSelf deleteProductsReloaadUI];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestCleanInvalidProduct{
    self.isAllSelected = NO;
    [self.bottomToolView isAllSelected:self.isAllSelected];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] shopCartAPI] postBuyerClearInvalidProductSuccess:^(id data) {
        weakSelf.model = data;
        weakSelf.navigationItem.title = [NSString stringWithFormat:@"进货单(%ld)",weakSelf.model.productCount];
        [weakSelf.tableView reloadData];
        [weakSelf computeTotalPrice];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestSettleValidateCartIds:(NSArray *)cartIds{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [[[AppAPIHelper shareInstance] shopCartAPI] postBuySettleCartWithCartIds:cartIds success:^(id data) {
        [MBProgressHUD zx_showSuccess:nil toView:weakSelf.view];
        NSString *string = [cartIds componentsJoinedByString:@","];
        WYPurchaserConfirmOrderViewController *shoppingCartVC = [[WYPurchaserConfirmOrderViewController alloc]init];
        shoppingCartVC.hidesBottomBarWhenPushed = YES;
        shoppingCartVC.cartIds = string;
        [weakSelf.navigationController pushViewController:shoppingCartVC animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        //起订量不足和失效
        NSString *code = [error.userInfo objectForKey:@"code"];
        if ([code isEqualToString:@"contain_quantity_lessthan_minquantity"] || [code isEqualToString:@"contain_invalid_product"]) {
            [weakSelf headerRefresh];
        }
    }];
}

- (void)requestMessageInfo
{
    if (![UserInfoUDManager isLogin])
    {
        [_messageBadgeButton setBadgeValue:0];
        return;
    }
    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *market =  [data objectForKey:@"buyernews"];
        NSNumber *trade = [data objectForKey:@"trade"];
        NSNumber *todo = [data objectForKey:@"todo"];
        NSNumber *antsteam =  [data objectForKey:@"antsteam"];

        NSInteger total =[system integerValue]+[market integerValue]+[trade integerValue]+[todo integerValue]+antsteam.integerValue;
        NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
        NSInteger badgeValue = nimValue +total;
        [_messageBadgeButton setBadgeValue:(badgeValue)];
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [_messageBadgeButton setBadgeValue:nimValue];
        }
    }];
}

#pragma mark - private function
-(void)creatUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[WYPurchaserShoppingCartTableViewCell class] forCellReuseIdentifier:WYPurchaserShoppingCartTableViewCellID];
    [_tableView registerClass:[WYLosePurchaserShoppingCartTableViewCell class] forCellReuseIdentifier:WYLosePurchaserShoppingCartTableViewCellID];
    
    [_tableView registerClass:[WYPurchaserShoppingCartHeaderView class] forHeaderFooterViewReuseIdentifier:WYPurchaserShoppingCartHeaderViewID];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(-53);
    }];
    
    //空白页
    _blankPageView = [[WYBlankPageView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 53 - 64 - 49)];
    
    
    //右上角 编辑与消息按钮
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [btn setTitle:@"编辑" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0x222222] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [btn addTarget:self action:@selector(editButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.editButton = btn;
    UIBarButtonItem * editButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    
    self.messageBadgeButton = [[ZXBadgeIconButton alloc] initWithFrame:CGRectMake(20, 0, 30, 50)];
    [self.messageBadgeButton addTarget:self action:@selector(messageBadgeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_messageBadgeButton setImage:[UIImage imageNamed:@"ic_message_normal_black"]];
    [_messageBadgeButton setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];


    UIBarButtonItem * messageButton = [[UIBarButtonItem alloc]initWithCustomView:_messageBadgeButton];

    self.navigationItem.rightBarButtonItems = @[messageButton,editButton];
   
    
    self.bottomToolView = [[WYPurchaserShoppingCartToolView alloc] init];
    [self.view addSubview:self.bottomToolView];
    [self.bottomToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@53);
    }];
    
    [self.bottomToolView.selectedButton addTarget:self action:@selector(allSelectedAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView.settleAccountsButton addTarget:self action:@selector(settleAccountsAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView.collectButton addTarget:self action:@selector(collectAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomToolView.deleteButton addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
}

//修改数量后价格变化
- (void)changeGoodsPriceModel:(WYGoodsPriceModel *)model cartId:(NSString *)cartId {
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        for (WYShopCartGoodsModel *productModel in shopInfoModel.products) {
            if ([productModel.cartId isEqualToString:cartId]) {
                productModel.price = model.price.integerValue;
                productModel.price4Disp = model.price4Disp;
                [self computeTotalPrice];
                [self.tableView reloadData];
            }
        }
    }
}

//计算合计总价
- (void)computeTotalPrice{
    CGFloat totalPrice = 0.0;
    self.selectedCount = 0;
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            if (goodsModel.isSelected) {
                self.selectedCount ++;
            }
            if (goodsModel.isSelected && goodsModel.price != -1){
                totalPrice += goodsModel.price/100.0 * goodsModel.quantity;
            }
        }
    }
    if (self.model.tipInfo){
        self.bottomToolView.tipLabel.text = self.model.tipInfo;
    }
    [self.bottomToolView totalPrice:totalPrice selectdCount:self.selectedCount];
}

//删除商品刷新界面
- (void)deleteProductsReloaadUI{
    self.navigationItem.title = [NSString stringWithFormat:@"进货单(%ld)",self.model.productCount - self.selectedCount];
    for (WYShopCartShopInfoModel *shopInfoModel in self.model.list) {
        for (WYShopCartGoodsModel *goodsModel in shopInfoModel.products) {
            if (goodsModel.isSelected){
                shopInfoModel.products = [shopInfoModel.products mtl_arrayByRemovingObject:goodsModel];
            }
        }
        if (!shopInfoModel.products.count) {
            self.model.list = [self.model.list mtl_arrayByRemovingObject:shopInfoModel];
        }
    }
    self.selectedCount = 0;
    self.isAllSelected = NO;
    [self.bottomToolView isAllSelected:self.isAllSelected];
    [self.tableView reloadData];
    [self computeTotalPrice];
}

- (void)goWebViewWithUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

#pragma mark -GetterAndSetter

- (UIButton *)cleanLoseGoodsButton{
    if (!_cleanLoseGoodsButton) {
        _cleanLoseGoodsButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 100, 26)];
        [_cleanLoseGoodsButton setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
        [_cleanLoseGoodsButton setTitle:@"清空失效宝贝" forState:UIControlStateNormal];
        [_cleanLoseGoodsButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [_cleanLoseGoodsButton setBackgroundColor:[UIColor colorWithHex:0xF58F23 alpha:0.08]];
        _cleanLoseGoodsButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
        _cleanLoseGoodsButton.layer.borderWidth = 0.5;
        _cleanLoseGoodsButton.layer.cornerRadius = 13.0;
        _cleanLoseGoodsButton.layer.masksToBounds = YES;
        [_cleanLoseGoodsButton addTarget:self action:@selector(cleanLoseGoodsAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cleanLoseGoodsButton;
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
