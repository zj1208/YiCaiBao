//
//  SellerOrderDetailViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellerOrderDetailViewController.h"

#import "WYODPlaceOrderFlowTableViewCell.h"
#import "WYODAddressAndMessageTableViewCell.h"
#import "WYODCheatTableViewCell.h" //备忘Cell
#import "WYODProductTableViewCell.h"
#import "WYODInformationTableViewCell.h"

#import "OrderManagementDetailModel.h"

#import "ZXLabelsTagsView.h"

#import "ModifyOrderPriceController.h"
#import "PurRefundDetailViewController.h"
#import "RefundingDetailController.h"

#import "SendGoodsController.h"
#import "SellerOrderCommitViewController.h"
#import "WYChoosePayWayViewController.h"
#import "PurApplyRefundsViewController.h"
#import "WYPurOrderCommitViewController.h"
#import "WYVerificationCodeViewController.h"
#import "PurOrederSuccessfulDealViewController.h"
#import "AlertChoseController.h"


@interface SellerOrderDetailViewController ()<UITableViewDelegate,UITableViewDataSource,WYODCheatTableViewCellDelegate,SODProductsViewDelegate,ZXEmptyViewControllerDelegate,ZXLabelsTagsViewDelegate,WYVerificationCodeViewControllerDelegate,ZXAlertChoseControllerDelegate>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)ZXLabelsTagsView *bottonContentView;
@property(nonatomic,strong)WYODProductTableViewCell *productsCell;
@property(nonatomic,strong)WYODCheatTableViewCell *cheatCell;
@property(nonatomic,strong)WYODInformationTableViewCell *InfoCell;
@property(nonatomic,strong)WYODAddressAndMessageTableViewCell *AddressAndMessageCell;

@property(nonatomic,strong)OrderManagementDetailModel *ordermanagementDetailModel;

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong)WYVerificationCodeViewController *wyverificationcodeViewController;
@property (nonatomic, strong)ZXModalTransitionDelegate *transitonModelDelegate;


@end
static NSString* const WYODPlaceOrderFlowTableViewCell_Resign = @"WYODPlaceOrderFlowTableViewCell_Resign";
static NSString* const WYODAddressAndMessageTableViewCell_Resign = @"WYODAddressAndMessageTableViewCell_Resign";
static NSString* const WYODCheatTableViewCell_Resign = @"WYODCheatTableViewCell_Resign";
static NSString* const WYODProductTableViewCell_Resign = @"WYODProductTableViewCell_Resign";
static NSString* const WYODInformationTableViewCell_Resign = @"WYODInformationTableViewCell_Resign";


@implementation SellerOrderDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"订单详情";
    
    [self buildUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self requestDataIfLoading:YES];

}
#pragma mark - ---------网络---------
#pragma mark  请求订单详情
-(void)requestDataIfLoading:(BOOL)loading
{
    if (loading) {
        [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    }
    
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] getOrderManagementDetailWithRoleType:
     [WYUserDefaultManager getUserTargetRoleType] BizOrderId:_bizOrderId success:^(id data) {
         
        self.ordermanagementDetailModel = (OrderManagementDetailModel*)data;
        [self.tableView reloadData];

        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
         [MBProgressHUD zx_hideHUDForView:self.view];

        if (_ordermanagementDetailModel.downButtons.count>0) {

            [self.bottonContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(LCDScale_5Equal6_To6plus(45.f));
            }];
            
            NSMutableArray *titleArray = [NSMutableArray array];
            [_ordermanagementDetailModel.downButtons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [titleArray addObject:obj.name];
            }];
            [self.bottonContentView setData:titleArray];
        }else{
            [self.bottonContentView mas_updateConstraints:^(MASConstraintMaker *make) {
                make.height.mas_offset(0);
            }];
        }
        
    } failure:^(NSError *error) {
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
#pragma mark  卖家提交备忘
-(void)requestCommitCheatWithText:(NSString*)text
{
     [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostUppdateOrderRemarkWithBizOrderId:self.ordermanagementDetailModel.bizOrderId remark:text success:^(id data) {
         [MBProgressHUD zx_showSuccess:@"备忘成功" toView:self.view];
         _cheatCell.wanchenbtn.hidden = YES; //隐藏完成按钮
         
         [self requestDataIfLoading:NO];
         
     } failure:^(NSError *error) {
         [MBProgressHUD zx_showSuccess:[error localizedDescription] toView:nil];
     }];
}
#pragma mark  确认收货
-(void)requestBuyerConfirmReceiptBizOrderId
{
     [[[AppAPIHelper shareInstance] gethsOrderManagementApi]  postOrderBuyerConfirmReceiptWithBizOrderId:self.ordermanagementDetailModel.bizOrderId success:^(id data) {
         [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
         
         [_wyverificationcodeViewController wy_remove];

         PurOrederSuccessfulDealViewController *vc = (PurOrederSuccessfulDealViewController *)[self zx_getControllerWithStoryboardName:@"Purchaser" controllerWithIdentifier:SBID_PurOrederSuccessfulDealViewController];
         vc.bizOrderId = self.ordermanagementDetailModel.bizOrderId;
         vc.hidesBottomBarWhenPushed = YES;
         [self.navigationController pushViewController:vc animated:YES];
         
     } failure:^(NSError *error) {
         [_wyverificationcodeViewController wy_remove];
         [MBProgressHUD zx_showSuccess:[error localizedDescription] toView:nil];
     }];
}
#pragma mark - ---------UI---------
-(void)buildUI
{    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"#f3f3f3"];
//    self.tableView.bounces = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;

    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];

    [self.tableView registerNib:[UINib nibWithNibName:@"WYODPlaceOrderFlowTableViewCell" bundle:nil] forCellReuseIdentifier:WYODPlaceOrderFlowTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYODAddressAndMessageTableViewCell" bundle:nil] forCellReuseIdentifier:WYODAddressAndMessageTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYODCheatTableViewCell" bundle:nil] forCellReuseIdentifier:WYODCheatTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYODProductTableViewCell" bundle:nil] forCellReuseIdentifier:WYODProductTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYODInformationTableViewCell" bundle:nil] forCellReuseIdentifier:WYODInformationTableViewCell_Resign];
   
    _productsCell = [_tableView dequeueReusableCellWithIdentifier:WYODProductTableViewCell_Resign];
     _cheatCell = [_tableView dequeueReusableCellWithIdentifier:WYODCheatTableViewCell_Resign];
    _InfoCell = [_tableView dequeueReusableCellWithIdentifier:WYODInformationTableViewCell_Resign];
    _AddressAndMessageCell = [_tableView dequeueReusableCellWithIdentifier:WYODAddressAndMessageTableViewCell_Resign];

    
    _bottonContentView = [[ZXLabelsTagsView alloc] init];
//    _bottonContentView.backgroundColor = [UIColor redColor];
    [self.view addSubview:_bottonContentView];
    UIView* line  = [[UIView alloc] init];
    line.backgroundColor = [WYUISTYLE colorWithHexString:@"#E5E5E5"];
    [self.view addSubview:line];

    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottonContentView.mas_top);
    }];
    [self.bottonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom).offset(0.5f);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(45.f));
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-HEIGHT_TABBAR_SAFE);
    }];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(0.5);
    }];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;

    
    self.bottonContentView.maxItemCount = 3;
    self.bottonContentView.apportionsItemWidthsByContent = NO;
    CGFloat top = (LCDScale_5Equal6_To6plus(45.f)-self.bottonContentView.itemSameSize.height)/2;
    self.bottonContentView.sectionInset = UIEdgeInsetsMake(top, 15, top, 15);
    [self.bottonContentView setCollectionViewLayoutWithEqualSpaceAlign:AlignWithRight withItemEqualSpace:10.f animated:NO];
    self.bottonContentView.delegate = self;
    
    self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
        self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(407));
    }else{
        self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(327));
    }
}
#pragma mark - 氛围图
-(void)zxEmptyViewUpdateAction
{
    [self requestDataIfLoading:NO];
}
#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if (self.ordermanagementDetailModel) {
        if (section == 2) {
            if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //	角色 2-采购商 4-供应商
                return 1;
            }else{
                return 0; //采购商没有备忘
            }
        }
        return 1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            return 167.f;
        case 1:
            return [_AddressAndMessageCell getCellHeightWithContentData:_ordermanagementDetailModel];
            
        case 2:
            return 85.f;
            
        case 3:
            return 440.f+(-218+[_productsCell.productsview getCellHeightWithContentData:_ordermanagementDetailModel.subBizOrders]);
            
        case 4:
            return [_InfoCell getCellHeightWithContentData:_ordermanagementDetailModel];
            
        default:
            return 0.f;

    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 2) {
        if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //number	角色 2-采购商 4-供应商
            return 10.f;
        }else{
            return 0.1f;
        }
    }
    return 10.f;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        WYODPlaceOrderFlowTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WYODPlaceOrderFlowTableViewCell_Resign];
        [cell.flowview addflowviewsWithArray:_ordermanagementDetailModel.statusHubs statusSta:_ordermanagementDetailModel.statusSta];
        [cell setCellData:_ordermanagementDetailModel];
        [cell.rightBtn addTarget:self action:@selector(clcikRefund:) forControlEvents:UIControlEventTouchUpInside];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;

    }else if (indexPath.section == 1) {
       
        [_AddressAndMessageCell setCellData:_ordermanagementDetailModel];
        
        _AddressAndMessageCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _AddressAndMessageCell;

    }else if (indexPath.section == 2) {
        _cheatCell = [tableView dequeueReusableCellWithIdentifier:WYODCheatTableViewCell_Resign];
        _cheatCell.selectionStyle = UITableViewCellSelectionStyleNone;
       
        [_cheatCell setCellData:_ordermanagementDetailModel];
        _cheatCell.delegate = self;
        return _cheatCell;

    }else if (indexPath.section == 3) {

        _productsCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [_productsCell.productsview setArray: _ordermanagementDetailModel.subBizOrders];
        _productsCell.productsview.delegate = self;
        [_productsCell setCellData:_ordermanagementDetailModel];
        [_productsCell.shopBtn addTarget:self action:@selector(clcikShopBtn:) forControlEvents:UIControlEventTouchUpInside];
        return _productsCell;

    }else { // if (indexPath.section == 4)
        _InfoCell.selectionStyle = UITableViewCellSelectionStyleNone;

        [_InfoCell setCellData:_ordermanagementDetailModel];
        return _InfoCell;
    }
    
}
#pragma mark - 点击“退款中”／“退款成功”按钮
-(void)clcikRefund:(UIButton*)sender
{
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家 4卖家
        RefundingDetailController *vc = (RefundingDetailController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_RefundingDetailController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        PurRefundDetailViewController*  viewC = [[PurRefundDetailViewController alloc] init ];
        viewC.bizOrderId = _bizOrderId;
        viewC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewC animated:YES];
    }
}
#pragma mark - 点击完成
-(void)jl_WYODCheatTableViewCell:(WYODCheatTableViewCell *)WYODCheatTableViewCell didBtn:(UIButton *)sender text:(NSString *)text
{
    [self requestCommitCheatWithText:text];
}

#pragma mark - 产品列表产品点击
-(void)jl_SODProductsView:(SODProductsView *)sodProductsView sourceArray:(NSArray *)array integer:(NSInteger)integer
{
    OMDSubBizOrdersMode* model = _ordermanagementDetailModel.subBizOrders[integer];
    NSMutableString* prodUrlM = [NSMutableString stringWithFormat:@"%@",model.prodUrl];
    NSString* prodUrl =  [prodUrlM stringByReplacingOccurrencesOfString:@"{id}" withString:model.prodId];
    [[WYUtility dataUtil] routerWithName:prodUrl withSoureController:self];

}
#pragma mark - 点击进入商铺/采购商资料
-(void)clcikShopBtn:(UIButton*)sender
{
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家 4卖家
       
        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_BuyerInfoController withData:@{@"bizId":_ordermanagementDetailModel.entityId, @"boolChat":@(YES),@"sourceType":@(AddOnlineCustomerSourceType_order)}];

    }else{
        NSMutableString* prodUrlM = [NSMutableString stringWithFormat:@"%@",_ordermanagementDetailModel.entityUrl];
        NSString* prodUrl =  [prodUrlM stringByReplacingOccurrencesOfString:@"{id}" withString:_ordermanagementDetailModel.entityId];
        
        [[WYUtility dataUtil] routerWithName:prodUrl withSoureController:self];

    }
   
}
#pragma 底部动态按钮
- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    OrderButtonModel *buttonModel = [_ordermanagementDetailModel.downButtons objectAtIndex:indexPath.item];
    NSLog(@"%@",buttonModel.style);
    if ([buttonModel.style isEqualToNumber:@(1)])
    {
        //默认设置
        cell.titleLab.textColor = UIColorFromRGB(83.f, 83.f, 83.f);
        cell.titleLab.backgroundColor = [UIColor whiteColor];
        cell.titleLab.layer.borderColor = UIColorFromRGB(177.f, 177.f, 177.f).CGColor;
    }
    else
    {
        //默认设置
        cell.titleLab.textColor = [UIColor whiteColor];
        if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //	角色 2-采购商 4-供应商
            UIImage *backgroundImage_Seller = [WYUTILITY getCommonVersion2RedGradientImageWithSize:cell.frame.size];
            cell.titleLab.backgroundColor = [UIColor colorWithPatternImage:backgroundImage_Seller];
            
        }else{
            UIImage *backgroundImage_puraser = [WYUISTYLE imageWithStartColorHexString:@"#FFBA49" EndColorHexString:@"#FF8D32" WithSize:cell.frame.size];
            cell.titleLab.backgroundColor = [UIColor colorWithPatternImage:backgroundImage_puraser];
            
        }
        cell.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    OrderButtonModel *buttonModel = [_ordermanagementDetailModel.downButtons objectAtIndex:indexPath.item];
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) {
        [self WYTargetRoleType_sellerOperation:buttonModel];
    }else{
        [self WYTargetRoleType_buyerOperation:buttonModel];
    }


}
#pragma mark - 卖家
-(void)WYTargetRoleType_sellerOperation:(OrderButtonModel *)buttonModel
{
    // 关闭订单
    if (buttonModel.code == ButtonCode_closeOrder1)
    {
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.titles = @[@"缺货",@"买家信息填写错误",@"买家不想买了",@"与买家协商一致关闭",@"买家未及时付款"];
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.alertTitle = @"请选择关闭原因";
        vc.userInfo = @{@"bizOrderId":_ordermanagementDetailModel.bizOrderId,@"tag":@"ButtonCode_closeOrder1"};
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    //   关闭订单2
    else if (buttonModel.code ==ButtonCode_refundAndClose1)
    {
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.titles = @[@"缺货",@"买家信息填写错误",@"买家不想买了",@"与买家协商一致关闭",@"买家未及时付款"];
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.alertTitle = @"请选择关闭原因";
        vc.userInfo = @{@"bizOrderId":_ordermanagementDetailModel.bizOrderId,@"tag":@"ButtonCode_refundAndClose1"};
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    //确认订单
    else if (buttonModel.code == ButtonCode_confirmOrder1)
    {
        ModifyOrderPriceController *vc = (ModifyOrderPriceController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_ModifyOrderPriceController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //立即发货
    else if (buttonModel.code ==ButtonCode_delivery1)
    {
        SendGoodsController *vc = (SendGoodsController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_SendGoodsController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 查看物流-h5
    else if (buttonModel.code ==ButtonCode_showLogistics1)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:_ordermanagementDetailModel.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    // 处理退款
    else if (buttonModel.code == ButtonCode_handleRefund1)
    {
        RefundingDetailController *vc = (RefundingDetailController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_RefundingDetailController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 已评价-h5
    else if (buttonModel.code ==ButtonCode_evaluated1)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:_ordermanagementDetailModel.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    // 评价
    else if (buttonModel.code ==ButtonCode_evaluate1)
    {
        SellerOrderCommitViewController*  viewC = [[SellerOrderCommitViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.orderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
   

}
#pragma mark - 买家
-(void)WYTargetRoleType_buyerOperation:(OrderButtonModel *)buttonModel
{
    //关闭订单
    if (buttonModel.code == ButtonCode_closeOrder2)
    {
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.alertTitle = @"请选择关闭原因";
        vc.titles = @[@"我不想买了",@"信息填写错误，重新拍",@"卖家缺货"];
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.userInfo = @{@"bizOrderId":_ordermanagementDetailModel.bizOrderId};
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    //立即支付
    else if (buttonModel.code == ButtonCode_payOrder2)
    {
        WYChoosePayWayViewController *payWayVC = [[WYChoosePayWayViewController alloc]init];
        payWayVC.orderId =_ordermanagementDetailModel.bizOrderId;//订单号
        payWayVC.priceString = _ordermanagementDetailModel.finalPrice;//待支付金额<实际付款>
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payWayVC animated:YES];
    }
    //申请退款
    else if (buttonModel.code ==ButtonCode_refund2)
    {
        PurApplyRefundsViewController *viewC = [[PurApplyRefundsViewController alloc] init ];
        viewC.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        viewC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    //查看物流-h5
    else if (buttonModel.code == ButtonCode_showLogistics2)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:_ordermanagementDetailModel.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    //确认收货
    else if (buttonModel.code ==ButtonCode_confirmReceipt2)
    {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"SellerOrder" bundle:[NSBundle mainBundle]];
        self.wyverificationcodeViewController = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_WYVerificationCodeViewController];
        self.wyverificationcodeViewController.type = 7;  //确认收货7
        self.wyverificationcodeViewController.delegate = self;

        [self.tabBarController addChildViewController:_wyverificationcodeViewController];
        [self.tabBarController.view addSubview:_wyverificationcodeViewController.view];
    }
    //评价
    else if (buttonModel.code == ButtonCode_evaluate2)
    {
        WYPurOrderCommitViewController *viewC = [[WYPurOrderCommitViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.bizOrderId = _ordermanagementDetailModel.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    //已评价-h5
    else if (buttonModel.code == ButtonCode_evaluated2)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:_ordermanagementDetailModel.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }

}
#pragma mark - 验证码验证成功
-(void)jl_WYVerificationCodeViewControllerVerificationCodeIsCorrect:(WYVerificationCodeViewController *)wyvCodeController
{
    [self requestBuyerConfirmReceiptBizOrderId];
}
#pragma mark - 关闭订单确定
- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller)
    {
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
        NSString *bizOrderId =[userInfo objectForKey:@"bizOrderId"];
        if ([[userInfo objectForKey:@"tag"] isEqualToString:@"ButtonCode_closeOrder1"])
        {
            [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseOrderWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:bizOrderId closeReason:content success:^(id data) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];

                [self requestDataIfLoading:NO];
                [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }];
        }
        else
        {
            [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseRefundOrderWithBizOrderId:bizOrderId closeReason:content success:^(id data) {
                [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];

                [self requestDataIfLoading:NO];
                [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
                
            } failure:^(NSError *error) {
                
                [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            }];
        }
    }
    else
    {
        [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
        [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseOrderWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:[userInfo objectForKey:@"bizOrderId"] closeReason:content success:^(id data) {
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
    
            [self requestDataIfLoading:NO];
            [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
    
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }];
    }

    
    
}





-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //通知跳转时移除
    [self.wyverificationcodeViewController wy_remove];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"jl_dealloc success");
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
