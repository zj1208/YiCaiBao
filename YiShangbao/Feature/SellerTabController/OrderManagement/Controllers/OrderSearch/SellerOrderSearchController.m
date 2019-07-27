//
//  SellerOrderSearchController.m
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellerOrderSearchController.h"

#import "OrderCellHeaderView.h"
#import "OrderProductCell.h"
#import "OrderCellFooterView.h"

#import "BuyerInfoController.h"
#import "SellerOrderDetailViewController.h"
#import "ModifyOrderPriceController.h"
#import "SendGoodsController.h"
#import "SellerOrderCommitViewController.h"
#import "RefundingDetailController.h"
#import "AlertChoseController.h"

@interface SellerOrderSearchController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,ZXLabelsTagsViewDelegate,ZXAlertChoseControllerDelegate,UISearchResultsUpdating>

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSMutableArray *dataMArray;

@property (nonatomic) NSInteger pageNo;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) ZXModalTransitionDelegate *transitonModelDelegate;
 
@end


static NSString * const reuse_Cell  = @"Cell";
static NSString * const reuse_FooterView  = @"FooterView";
static NSString * const reuse_HeaderView  = @"HeaderView";


@implementation SellerOrderSearchController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
  
    
//    [UIView zx_NSLogSubviewsFromView:self.searchBar andLevel:1];

    [self setUI];
    
    [self setData];

}
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController
{
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        UISearchBar *bar = [[UISearchBar alloc] init];
        bar.searchBarStyle = UISearchBarStyleMinimal;
        bar.tintColor = UIColorFromRGB(255.f, 84.f, 52.f);
        bar.placeholder = @"输入产品名、订单号查询订单";
        [bar sizeToFit];
        bar.delegate = self;
        bar.barTintColor = [UIColor clearColor];
        [bar setShowsCancelButton:YES animated:YES];
        UIImage *image = [UIImage imageNamed:@"bg_search"];
        UIImage *resizableImage = [image resizableImageWithCapInsets: UIEdgeInsetsMake(0, image.size.width/2, 0, image.size.width/2)];
        [bar setSearchFieldBackgroundImage:resizableImage forState:UIControlStateNormal];
        
        if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11))
        {
            UITextField *txfSearchField = [bar valueForKey:@"_searchField"];
            [txfSearchField setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
            bar.searchTextPositionAdjustment = UIOffsetMake(2, 0);
        }
        _searchBar = bar;
    }
    return _searchBar;
}




- (void)setUI
{
    [self xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [self xm_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];

    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.navigationItem.titleView = self.searchBar;
    
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderProductCell class]) bundle:nil] forCellReuseIdentifier:reuse_Cell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCellFooterView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_FooterView];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([OrderCellHeaderView class]) bundle:nil] forHeaderFooterViewReuseIdentifier:reuse_HeaderView];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
    [self.searchBar becomeFirstResponder];

}

- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];

    self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(407));
    
    //拒绝退款,确认订单成功,发货成功,评价成功,关闭订单等
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(update:) name:Noti_Order_update_OrderListAndDetail object:nil];
}

- (void)update:(NSNotification *)sender
{
    [self.tableView.mj_header beginRefreshing];
}

-(void)searchBarCancelButtonClicked:(UISearchBar*)searchBar
{
    if([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [MobClick event:kUM_b_ordersearchinput];

    [_emptyViewController hideEmptyViewInController:self];
    [self.tableView.mj_header beginRefreshing];
    if([searchBar isFirstResponder])
    {
        [searchBar resignFirstResponder];
    }
    UIButton *cancelBtn = [searchBar valueForKey:@"cancelButton"];
    cancelBtn.enabled = YES;
}



- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [weakSelf requestHeaderData];
    }];
}

- (void)requestHeaderData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray removeAllObjects];
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:@"没有搜到相关订单信息" updateBtnHide:YES];
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
    if (_pageNo >=totalPage)
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
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderListWithRoleType:[WYUserDefaultManager getUserTargetRoleType] orderStatus:0 search:self.searchBar.text pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
        
        [weakSelf.dataMArray addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.pageNo ++;
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
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryNone;
    if (self.dataMArray.count>indexPath.section)
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
    footView.labelsTagsView.tag = section;
    footView.moreBtn.tag = 200+section;
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
        //默认设置
        cell.titleLab.textColor = [UIColor whiteColor];
        UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:cell.frame.size];
        cell.titleLab.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        cell.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
    }
}



- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:labelsTagView.tag];
    OrderButtonModel *buttonModel = [model.buttons objectAtIndex:indexPath.item];
    
    // 关闭订单
    if (buttonModel.code == ButtonCode_closeOrder1)
    {
        
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.titles = @[@"缺货",@"买家信息填写错误",@"买家不想买了",@"与买家协商一致关闭",@"买家未及时付款"];
        vc.alertTitle = @"请选择关闭原因";
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.userInfo = @{@"bizOrderId":model.bizOrderId,@"tag":@"ButtonCode_closeOrder1"};
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
        vc.userInfo = @{@"bizOrderId":model.bizOrderId,@"tag":@"ButtonCode_refundAndClose1"};
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
    //确认订单
    else if (buttonModel.code == ButtonCode_confirmOrder1)
    {
        ModifyOrderPriceController *vc = (ModifyOrderPriceController *)[self xm_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_ModifyOrderPriceController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //立即发货
    else if (buttonModel.code ==ButtonCode_delivery1)
    {
        SendGoodsController *vc = (SendGoodsController *)[self xm_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_SendGoodsController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 查看物流-h5
    else if (buttonModel.code ==ButtonCode_showLogistics1)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:model.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    // 处理退款
    else if (buttonModel.code == ButtonCode_handleRefund1)
    {
        RefundingDetailController *vc = (RefundingDetailController *)[self xm_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_RefundingDetailController];
        vc.hidesBottomBarWhenPushed = YES;
        vc.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:vc animated:YES];
    }
    // 已评价-h5
    else if (buttonModel.code ==ButtonCode_evaluated1)
    {
        NSString *url = [buttonModel.url stringByReplacingOccurrencesOfString:@"{bizOrderId}" withString:model.bizOrderId];
        [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    }
    // 评价
    else if (buttonModel.code ==ButtonCode_evaluate1)
    {
        SellerOrderCommitViewController*  viewC = [[SellerOrderCommitViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.orderId = model.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
    // 查看详情
    else if (buttonModel.code ==ButtonCode_detail1)
    {
        SellerOrderDetailViewController* viewC = [[SellerOrderDetailViewController alloc] init ];
        viewC.hidesBottomBarWhenPushed = YES;
        viewC.bizOrderId = model.bizOrderId;
        [self.navigationController pushViewController:viewC animated:YES];
    }
}

#pragma mark - Action

- (void)shopNameBtnAction:(id)sender
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    GetOrderManagerModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_BuyerInfoController withData:@{@"bizId":model.entityId, @"boolChat":@(YES),@"sourceType":@(AddOnlineCustomerSourceType_order)}];
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
    
    NSString *bizOrderId =[userInfo objectForKey:@"bizOrderId"];
    if ([[userInfo objectForKey:@"tag"] isEqualToString:@"ButtonCode_closeOrder1"])
    {
        [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseOrderWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:bizOrderId closeReason:content success:^(id data) {
            
             [_tableView reloadData];
            [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        }];
    }
    else
    {
        [[[AppAPIHelper shareInstance]hsOrderManagementApi]postCloseRefundOrderWithBizOrderId:bizOrderId closeReason:content success:^(id data) {
            
             [_tableView reloadData];
            [MBProgressHUD zx_showSuccess:@"关闭订单成功" toView:nil];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
            
        }];
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
