//
//  SellerPageMenuController.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellerPageMenuController.h"
#import "ZXSegmentedPageController.h"
#import "ZXSegmentMenuView.h"

#import "SellerOrderAllController.h"
#import "SellerOrderSearchController.h"
@interface SellerPageMenuController ()<ZXSegmentPageControllerDelegate,ZXSegmentMenuViewDelegate,UISearchBarDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic, strong) ZXSegmentMenuView *segmentMenuView;
@property (nonatomic, strong) ZXSegmentedPageController *segPageController;
@property (nonatomic, strong) UIButton *choseBtn;
@property (nonatomic, copy) NSArray *segTitles;
@property (nonatomic, strong) NSMutableArray *orderCountsMArray;

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) UIBarButtonItem *rightButtonItem;

@end

@implementation SellerPageMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"订单管理";
    
    [self setUI];
    [self setData];
}

-(UIBarButtonItem*)rightButtonItem{
    if (!_rightButtonItem) {
        
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 78, 28)];
        [backButton setTitle:@"我的收入" forState:UIControlStateNormal];
        [backButton setTitleColor:UIColorFromRGB_HexValue(0xBD2f26) forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColorFromRGB_HexValue(0xBD2f26) colorWithAlphaComponent:0.5] forState:UIControlStateHighlighted];
        [backButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [backButton setBackgroundColor:UIColorFromRGB_HexValue(0xfff5f6)];
        [backButton addTarget:self action:@selector(rightButtonItemAction:) forControlEvents:UIControlEventTouchUpInside];
        [backButton zx_setCornerRadius:28/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xBD2f26)];
        _rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
    return _rightButtonItem;
}


// 我的收入
- (void)rightButtonItemAction:(id)sender
{
//    [MobClick event:kUM_b_order_income];
//    NSString *url = [NSString stringWithFormat:@"%@/trade/wallet?token={token}&ttid={ttid}",[WYUserDefaultManager getkAPP_H5URL]];
//    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.wallet;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_wallet withSoureController:self];
}


- (void)setUI
{

    self.navigationItem.rightBarButtonItem = self.rightButtonItem;

//    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"searchfenlei_search"] style:UIBarButtonItemStyleDone target:self action:@selector(searchOrder:)];
//    self.navigationItem.rightBarButtonItem = barItem;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.choseBtn.frame = CGRectMake(bounds.size.width-60, 0, 60, 39);
    
    [self.view addSubview:self.searchBar];
    self.searchBar.frame = CGRectMake(0, HEIGHT_NAVBAR, LCDW, 49);
    
    [self.searchBar zx_setBorderWithTop:NO left:NO bottom:YES right:NO borderColor:UIColorFromRGB_HexValue(0xe5e5e5) borderWidth:0.5];

    CGRect frame = self.view.frame;
    CGFloat Y = CGRectGetMaxY(self.searchBar.frame);
    frame.origin.y += Y;
    frame.size.height -= Y;
    self.segPageController.view.frame = frame;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    [self searchOrder:nil];
    return NO;
}

- (ZXSegmentMenuView *)segmentMenuView
{
    if (!_segmentMenuView)
    {
        ZXSegmentMenuView *menuView = [[ZXSegmentMenuView alloc] init];
        menuView.delegate = self;
        menuView.frame =  self.view.frame;
        menuView.selectedIndex = 0;
        _segmentMenuView = menuView;
    }
    return _segmentMenuView;
}
// 每个类型的订单数量【1-8种类型】包括待确认
- (NSMutableArray *)getNSegmentTitlesWithOrderCountModel:(NSArray *)orderCountModels
{
    NSMutableArray *mTitles = [NSMutableArray array];
    [self.segTitles enumerateObjectsUsingBlock:^(NSString *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSMutableString *mStr = [NSMutableString stringWithString:obj];
        if (idx >0 && idx<self.segTitles.count)
        {
//            第一个是待确认
            GetOrderStautsCountModel *model = [orderCountModels objectAtIndex:idx];
            NSString *st = [NSString stringWithFormat:@"(%@)",model.orderCount];
            [mStr appendString:st];
        }
        [mTitles addObject:mStr];
    }];

    return mTitles;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self requestOrderCount];
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (UISearchBar *)searchBar
{
    if (!_searchBar)
    {
        UISearchBar *bar =[[UISearchBar alloc] init];
        bar.searchBarStyle = UISearchBarStyleMinimal;
        bar.tintColor = UIColorFromRGB(255.f, 84.f, 52.f);
        bar.placeholder = @"输入产品名、订单号查询订单";
        [bar sizeToFit];
        bar.delegate = self;
        bar.barTintColor = [UIColor clearColor];
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


// 3.23,去掉待确定一页
- (void)setData
{
    self.segTitles = @[@"全部",@"待支付",@"待发货",@"退款中",@"已发货",@"待评价",@"交易成功",@"交易关闭"];

    for (int i = 0; i < self.segTitles.count; i++) {
        
        SellerOrderAllController *vc = (SellerOrderAllController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_SellerOrderAllController];
        vc.nTitle = [NSString stringWithFormat:@"标题%d",i];
        if (i >0)
        {
            vc.orderListStatus = i+1;
        }
        else
        {
            vc.orderListStatus = i;
        }
        [self.dataMArray addObject:vc];
    }
    
//    self.extendedLayoutIncludesOpaqueBars = YES;
    self.segPageController.segmentTitles = self.segTitles;
    self.segPageController.viewControllers = self.dataMArray;
 
    
    
    self.segmentMenuView.itemTitles = self.segTitles;

    _orderCountsMArray = [NSMutableArray array];
    
    
    //先加载pageController的某个controller
    if (self.orderListStatus >0)
    {
          [_segPageController setSelectedPageIndex:self.orderListStatus-1 animated:YES];
    }
    else
    {
          [_segPageController setSelectedPageIndex:self.orderListStatus animated:YES];
    }
    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:self.orderListStatus];
    vc.orderListStatus = self.orderListStatus;
    [vc.tableView.mj_header beginRefreshing];
    
    [self requestCleanOrderMark];
}

#pragma mark - 清除商铺新订单

- (void)requestCleanOrderMark
{
    [[[AppAPIHelper shareInstance]shopAPI]postShopStorePruneNewOrderMarkWithSuccess:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestOrderCount
{
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderStatusCountWithRoleType:[WYUserDefaultManager getUserTargetRoleType] success:^(id data) {
        
        [_orderCountsMArray removeAllObjects];
        [_orderCountsMArray addObjectsFromArray:data];
        
        NSMutableArray *mArray = [self getNSegmentTitlesWithOrderCountModel:data];
        self.segPageController.segmentTitles = mArray;
        [MBProgressHUD zx_hideHUDForView:self.view];
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_hideHUDForView:self.view];
    }];
}


- (ZXSegmentedPageController *)segPageController
{
    if (!_segPageController)
    {
        ZXSegmentedPageController *segVC = [[ZXSegmentedPageController alloc]init];
        segVC.segmentFontSize = 15.f;
        segVC.segmentHeight = 40.f;
        segVC.delegate = self;
        segVC.segmentMinimumItemSpacing = 26.f;
        [self addChildViewController:segVC];
        [self.view addSubview:segVC.view];
        _segPageController = segVC;
    }
    return _segPageController;
}


- (NSMutableArray *)dataMArray
{
    if (!_dataMArray)
    {
        NSMutableArray *mArray = [NSMutableArray array];
        _dataMArray = mArray;
    }
    return _dataMArray;
}



- (void)searchOrder:(id)sender
{
    [MobClick event:kUM_b_ordersearch];

    SellerOrderSearchController *vc = (SellerOrderSearchController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_SellerOrderSearchController];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:nav animated:YES completion:nil];
}


- (UIButton *)choseBtn
{
    if (!_choseBtn)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
        [btn setImage:[UIImage imageNamed:@"ic_zhankai"] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        [btn addTarget:self action:@selector(popMenuView:) forControlEvents:UIControlEventTouchUpInside];

        [self.segPageController.view addSubview:btn];
        _choseBtn = btn;
    }
    return _choseBtn;
}



- (void)popMenuView:(UIButton *)sender
{
    [MobClick event:kUM_b_listopen];

    self.segmentMenuView.selectedIndex = self.segPageController.currentIndex;
    [self.segmentMenuView showInView:self.segPageController.view];
}


#pragma mark - ZXSegmentPageControllerDelegate


- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableAttributedString *mAtt1 = [[NSMutableAttributedString alloc] init];
    NSAttributedString *att1 = [[NSAttributedString alloc] initWithString:[self.segTitles objectAtIndex:indexPath.item] attributes:nil];
    [mAtt1 appendAttributedString:att1];
    NSAttributedString *att2 = nil;
//    第一个“全部”，最后2个“交易成功”，@“交易关闭”不需要数字
    if (indexPath.item >0 && indexPath.item<(self.segTitles.count-2) &&_orderCountsMArray.count>0)
    {
        //        第一个待确认不要了
        GetOrderStautsCountModel *model = [_orderCountsMArray objectAtIndex:indexPath.item];
        NSString *st = [NSString stringWithFormat:@"(%@)",model.orderCount];
        att2= [[NSAttributedString alloc] initWithString:st attributes:nil];
        [mAtt1 appendAttributedString:att2];
    }
   
    UIColor *selcteColor = [UIColor colorWithRed:255.f/255 green:84.f/255 blue:52.f/255 alpha:1];
    UIColor *normalColor = [UIColor colorWithRed:83./255 green:83.f/255 blue:83.f/255 alpha:1];

    if (cell.isSelected)
    {
        [mAtt1 addAttributes:@{NSForegroundColorAttributeName:selcteColor} range:NSMakeRange(0, mAtt1.length)];
        [mAtt1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:16] range:NSMakeRange(0, mAtt1.length)];
        cell.attributedTitle = mAtt1;
    }
    else
    {
        [mAtt1 addAttributes:@{NSForegroundColorAttributeName:normalColor} range:NSMakeRange(0, att1.length)];
        if (att2.length >0)
        {
            [mAtt1 addAttributes:@{NSForegroundColorAttributeName:selcteColor} range:[mAtt1.string rangeOfString:att2.string]];
        }
        [mAtt1 addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, mAtt1.length)];
        cell.attributedTitle = mAtt1;
    }
}

- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index
{
    [MobClick event:kUM_b_slideabove];

    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
    if (![vc.tableView isRefreshing])
    {
        [vc.tableView.mj_header beginRefreshing];
    }
}

// 传的viewControllers数组，controller的status状态属性无效；
- (void)zx_segmentPageControllerWithTransitionToViewControllersIndex:(NSInteger)index transitionCompleted:(BOOL)completed
{
    [MobClick event:kUM_b_slidedown];

//    NSLog(@"index=%ld",index);
    if (completed)
    {
//        NSLog(@"%ld",index);
        SellerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
        //        vc.orderListStatus = index;
        if ([vc isViewLoaded])
        {
            [vc.tableView.mj_header beginRefreshing];
        }
    }
}


#pragma mark - ZXSegmentMenuViewDelegate

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.segPageController setSelectedPageIndex:indexPath.item animated:YES];
    SellerOrderAllController *vc = [self.dataMArray objectAtIndex:indexPath.item];
//    vc.orderListStatus = indexPath.item;
    [vc.tableView.mj_header beginRefreshing];
}


- (void)setSelectedPageIndexWithOrderListStatus:(SellerOrderListStatus)status
{
    self.orderListStatus = status;
    
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
