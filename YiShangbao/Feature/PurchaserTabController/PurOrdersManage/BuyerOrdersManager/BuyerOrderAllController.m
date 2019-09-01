//
//  BuyerOrderAllController.m
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BuyerOrderAllController.h"
#import "OrderCellHeaderView.h"
#import "OrderProductCell.h"
#import "OrderCellFooterView.h"

#import "BuyerInfoController.h"
#import "SellerOrderDetailViewController.h"

#import "WYChoosePayWayViewController.h"
#import "PurApplyRefundsViewController.h"
#import "WYPurOrderCommitViewController.h"
#import "WYVerificationCodeViewController.h"
#import "PurOrederSuccessfulDealViewController.h"

#import "AlertChoseController.h"


@interface BuyerOrderAllController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,ZXLabelsTagsViewDelegate,WYVerificationCodeViewControllerDelegate,ZXAlertChoseControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong)ZXModalTransitionDelegate *transitonModelDelegate;

@property(nonatomic,strong)WYVerificationCodeViewController* wyverificationcodeViewController; //验证码弹框
@end


static NSString * const reuse_Cell  = @"Cell";
static NSString * const reuse_FooterView  = @"FooterView";
static NSString * const reuse_HeaderView  = @"HeaderView";



@implementation BuyerOrderAllController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"2222";
    // Do any additional setup after loading the view.
    [self setUI];
    
    [self setData];
}

- (void)dealloc
{
    
}
- (void)setUI
{
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderProductCell class]) bundle:nil] forCellReuseIdentifier:reuse_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCellFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_FooterView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCellHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_HeaderView];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    emptyVC.contentOffest = CGSizeMake(0, -50);
    self.emptyViewController = emptyVC;
    
}
#pragma mark  确认收货
-(void)requestBuyerConfirmReceiptBizOrderId:(NSString*)bcBizOrderId
{
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi]  postOrderBuyerConfirmReceiptWithBizOrderId:bcBizOrderId success:^(id data) {
        [_wyverificationcodeViewController wy_remove];

        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
        
        
        PurOrederSuccessfulDealViewController *vc = (PurOrederSuccessfulDealViewController *)[self zx_getControllerWithStoryboardName:@"Purchaser" controllerWithIdentifier:SBID_PurOrederSuccessfulDealViewController];
        vc.bizOrderId = bcBizOrderId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
        
    } failure:^(NSError *error) {
        [_wyverificationcodeViewController wy_remove];
        [MBProgressHUD zx_showSuccess:[error localizedDescription] toView:nil];
    }];
}
- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(327));
    //拒绝退款,确认订单成功,发货成功,评价成功,关闭订单等
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update:) name:Noti_Order_update_OrderListAndDetail object:nil];
}

- (void)update:(NSNotification *)sender
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSLog(@"我的标题是：%@,状态:%ld",self.nTitle,(long)self.orderListStatus);
        [weakSelf requestHeaderData];
 
    }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:weakSelf.orderListStatus search:nil pageNo:1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"pic_qiugouzhongkong"] emptyTitle:@"您还没有相关订单" updateBtnHide:YES];
        [weakSelf.tableView reloadData];
        weakSelf.pageNo = 1;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        
    }];
}

- (void)footerWithRefreshing:(NSInteger)totalPage
{
    if (_pageNo>=totalPage)
    {
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        return;
    }
    WS(weakSelf);
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        [weakSelf requestFooterData];
    }];
}

- (void)requestFooterData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:self.orderListStatus search:nil pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        _pageNo ++;
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0)
        {
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:section];
    return model.subBizOrders.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    OrderProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_Cell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.dataMArray.count>0)
    {
        GetOrderManagerModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        [cell setData:[model.subBizOrders objectAtIndex:indexPath.item]];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 117;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    OrderCellHeaderView *headerView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuse_HeaderView];
    [headerView setData:[self.dataMArray objectAtIndex:section]];
    [headerView.shopNameBtn addTarget:self action:@selector(shopNameBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    return headerView;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    static OrderCellFooterView *cell = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        cell = (OrderCellFooterView *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:reuse_FooterView];
    });
    CGFloat height = [cell getCellHeightWithContentData:[self.dataMArray objectAtIndex:section]];
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    
    OrderCellFooterView * footView = [tableView dequeueReusableHeaderFooterViewWithIdentifier:reuse_FooterView];
    [footView setData:[self.dataMArray objectAtIndex:section]];
    [footView.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    footView.labelsTagsView.delegate = self;
    footView.moreBtn.tag = 200+section;
    footView.labelsTagsView.tag = section;
    return footView;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    SellerOrderDetailViewController* viewC = [[SellerOrderDetailViewController alloc] init ];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.bizOrderId = model.bizOrderId;
    [self.navigationController pushViewController:viewC animated:YES];
}



#pragma mark - ZXLabelsTagsViewDelegate

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:labelsTagView.tag];
    OrderButtonModel *buttonModel = [model.buttons objectAtIndex:indexPath.item];
    if ([buttonModel.style isEqualToNumber:@(1)])
    {
        //默认设置
        cell.titleLab.textColor = UIColorFromRGB(83.f, 83.f, 83.f);
        cell.titleLab.backgroundColor = [UIColor whiteColor];
        cell.titleLab.layer.borderColor = UIColorFromRGB(177.f, 177.f, 177.f).CGColor;
    }
    else
    {
        //橙色
        cell.titleLab.textColor = [UIColor whiteColor];
        UIImage *backgroundImage = [UIImage zx_getGradientImageFromHorizontalTowColorWithSize:cell.frame.size  startColor:UIColorFromRGB(255.f, 186.f, 73.f) endColor:UIColorFromRGB(255.f, 141.f, 50.f)];
        cell.titleLab.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        cell.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
    }
}


- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:labelsTagView.tag];
    OrderButtonModel *buttonModel = [model.buttons objectAtIndex:indexPath.item];
    
    //关闭订单
    if (buttonModel.code == ButtonCode_closeOrder2)
    {
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.alertTitle = @"请选择关闭原因";
        vc.titles = @[@"我不想买了",@"信息填写错误，重新拍",@"卖家缺货"];
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.userInfo = @{@"bizOrderId":model.bizOrderId};
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];

    }
    //立即支付
    else if (buttonModel.code == ButtonCode_payOrder2)
    {
        WYChoosePayWayViewController *payWayVC = [[WYChoosePayWayViewController alloc]init];
        payWayVC.orderId =model.bizOrderId;//订单号
        payWayVC.priceString = model.finalPrice;//待支付金额
        self.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:payWayVC animated:YES];
    }
    //申请退款
    else if (buttonModel.code ==ButtonCode_refund2)
    {
        PurApplyRefundsViewController *viewC = [[PurApplyRefundsViewController alloc] init ];
        viewC.bizOrderId = model.bizOrderId;
        viewC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    //查看详情
    else if (buttonModel.code ==ButtonCode_detail2)
    {
        SellerOrderDetailViewController* viewC = [[SellerOrderDetailViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    //查看物流-h5
    else if (buttonModel.code == ButtonCode_showLogistics2)
    {
        NSString *url = [[buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:model.bizOrderId] copy];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    //确认收货
    else if (buttonModel.code ==ButtonCode_confirmReceipt2)
    {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"SellerOrder" bundle:[NSBundle mainBundle]];
        self.wyverificationcodeViewController = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_WYVerificationCodeViewController];
        self.wyverificationcodeViewController.type = 7;  //确认收货7
        self.wyverificationcodeViewController.delegate = self;
        self.wyverificationcodeViewController.bizOrderId = model.bizOrderId;

        [self.tabBarController addChildViewController:_wyverificationcodeViewController];
        [self.tabBarController.view addSubview:_wyverificationcodeViewController.view];
    }
    //评价
    else if (buttonModel.code == ButtonCode_evaluate2)
    {
        WYPurOrderCommitViewController *viewC = [[WYPurOrderCommitViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    //已评价-h5
    else if (buttonModel.code == ButtonCode_evaluated2)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:model.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }

    
}
#pragma mark - 验证码验证成功-push
-(void)jl_WYVerificationCodeViewControllerVerificationCodeIsCorrect:(WYVerificationCodeViewController *)wyvCodeController
{
    [self requestBuyerConfirmReceiptBizOrderId:wyvCodeController.bizOrderId];
}
#pragma mark - Action

- (void)shopNameBtnAction:(id)sender
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    NSLog(@"indexPath = %@",indexPath);
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    NSString *shopUrl = [model.entityUrl stringByReplacingOccurrencesOfString:@"{id}" withString:model.entityId];
    [[WYUtility dataUtil]routerWithName:shopUrl withSoureController:self];
}


- (void)moreBtnAction:(UIButton *)sender
{
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:sender.tag-200];
    SellerOrderDetailViewController* viewC = [[SellerOrderDetailViewController alloc] init ];
    viewC.hidesBottomBarWhenPushed = YES;
    viewC.bizOrderId = model.bizOrderId;
    [self.navigationController pushViewController:viewC animated:YES];
}


- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseOrderWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:[userInfo objectForKey:@"bizOrderId"] closeReason:content success:^(id data) {
        
        [_tableView.mj_header beginRefreshing];
        [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
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
