//
//  BuyerPageMenuController.m
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BuyerPageMenuController.h"
#import "ZXSegmentedPageController.h"
#import "ZXSegmentMenuView.h"

#import "BuyerOrderAllController.h"

@interface BuyerPageMenuController ()<ZXSegmentPageControllerDelegate,ZXSegmentMenuViewDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic, strong) ZXSegmentMenuView *segmentMenuView;
@property (nonatomic, strong) ZXSegmentedPageController *segPageController;
@property (nonatomic, strong) UIButton *choseBtn;
@property (nonatomic, copy) NSArray *segTitles;
@property (nonatomic, strong) NSMutableArray *orderCountsMArray;

@end

@implementation BuyerPageMenuController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"订单管理";
    
    [self setUI];
    [self setData];
}

- (void)setUI
{
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    
    [self addSegmentMenuView];
    
    CGRect bounds = [UIScreen mainScreen].bounds;
    self.choseBtn.frame = CGRectMake(bounds.size.width-60, 0, 60, 39);
    
}

- (void)addSegmentMenuView
{
    ZXSegmentMenuView *menuView = [[ZXSegmentMenuView alloc] init];
    menuView.delegate = self;
    menuView.frame =  self.view.frame;
    menuView.selectedIndex = 0;
    
    self.segmentMenuView = menuView;
}



- (void)setData
{
    
    self.segTitles = @[@"全部",@"待支付",@"待发货",@"待收货",@"待评价",@"退款中",@"交易成功",@"交易关闭"];
    
    for (int i = 0; i < self.segTitles.count; i++) {
        
        BuyerOrderAllController *vc = (BuyerOrderAllController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_BuyerOrderAllController];
        vc.nTitle = [NSString stringWithFormat:@"标题%d",i];
        vc.orderListStatus = [self convertIndexToStatus:i];
        [self.dataMArray addObject:vc];
    }
    self.segPageController.segmentTitles = self.segTitles;
    self.segPageController.viewControllers = self.dataMArray;
    CGRect frame = self.view.frame;
    CGFloat Y = HEIGHT_NAVBAR;
    frame.origin.y += Y;
    frame.size.height -= Y;
    self.segPageController.view.frame = frame;
    
    
    self.segmentMenuView.itemTitles = self.segTitles;
    _orderCountsMArray = [NSMutableArray array];
    
    //先加载pageController的某个controller
    [_segPageController setSelectedPageIndex:[self convertRequestStatusNum:self.orderListStatus] animated:YES];
    BuyerOrderAllController *vc = [self.dataMArray objectAtIndex:[self convertRequestStatusNum:self.orderListStatus]];
    vc.orderListStatus = self.orderListStatus;
    [vc.tableView.mj_header beginRefreshing];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

}

- (NSInteger)convertRequestStatusNum:(NSInteger)status
{
    switch (status) {
        case OrderListStatus_Obligation: return 1;break;
        case OrderListStatus_WaitForDelivery: return 2;break;
        case OrderListStatus_ToBeReceive: return 3;break;
        case OrderListStatus_ToBeCommit: return 4;break;
        case OrderListStatus_Refunding:return 5;break;
        case OrderListStatus_TradeSuccessfully:return 6;break;
        case OrderListStatus_TradeClose:return 7;break;
        default: return status;
            break;
    }
}

- (NSInteger)convertIndexToStatus:(NSInteger)index
{
    switch (index) {
        case 0:return OrderListStatus_All;break;
        case 1:return OrderListStatus_Obligation;break;
        case 2:return OrderListStatus_WaitForDelivery;break;
        case 3:return OrderListStatus_ToBeReceive;break;
        case 4:return OrderListStatus_ToBeCommit;break;
        case 5:return OrderListStatus_Refunding;break;
        case 6:return OrderListStatus_TradeSuccessfully;break;
        case 7: return OrderListStatus_TradeClose;break;
        default: return index;
            break;
    }
}



- (ZXSegmentedPageController *)segPageController
{
    if (!_segPageController)
    {
        ZXSegmentedPageController *segVC = [[ZXSegmentedPageController alloc]init];
        segVC.segmentFontSize = 15.f;
        segVC.segmentHeight = 40.f;
        segVC.segmentTitleNormalColor = UIColorFromRGB(83.f, 83.f, 83.f);
        segVC.segmentTitleSelectedColor = UIColorFromRGB(245.f, 143.f, 35.f);
        segVC.segmentSelectionIndicatorColor = segVC.segmentTitleSelectedColor;
        segVC.segmentSeletedFontSize = 16.f;
        segVC.segmentMinimumItemSpacing = 26.f;
        segVC.segmentFontSize = 15.f;
        segVC.delegate = self;
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


- (UIButton *)choseBtn
{
    if (!_choseBtn)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setBackgroundColor:[UIColor clearColor]];
//        btn.layer.shadowColor = [UIColor blackColor].CGColor;
//        btn.layer.shadowOffset=CGSizeMake(-3, 0);
//        btn.layer.shadowOpacity=0.3;
//        [btn setImage:[UIImage imageNamed:@"arrows_down"] forState:UIControlStateNormal];
        btn.adjustsImageWhenHighlighted = NO;
        [btn setImage:[UIImage imageNamed:@"ic_zhankai"] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(popMenuView:) forControlEvents:UIControlEventTouchUpInside];
        [self.segPageController.view addSubview:btn];
        _choseBtn = btn;
    }
    return _choseBtn;
}



- (void)popMenuView:(UIButton *)sender
{
    [MobClick event:kUM_c_listopen];
    
    self.segmentMenuView.selectedIndex = self.segPageController.currentIndex;
    [self.segmentMenuView showInView:self.segPageController.view];
}



#pragma mark - ZXSegmentPageControllerDelegate

- (void)zx_segmentPageControllerWithSegmentView:(ZXSegmentedControl *)segmentedControl didSelectedIndex:(NSInteger)index
{
    [MobClick event:kUM_c_slideabove];

    BuyerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
//    vc.orderListStatus =  [self convertIndexToStatus:index];
    [vc.tableView.mj_header beginRefreshing];
}

// 有bug，滑动切换的时候；不应该每次请求刷新； 传的viewControllers数组，controller的status状态属性无效；
- (void)zx_segmentPageControllerWithTransitionToViewControllersIndex:(NSInteger)index transitionCompleted:(BOOL)completed
{
    
    [MobClick event:kUM_c_slidedown];

    if (completed)
    {
        BuyerOrderAllController *vc = [self.dataMArray objectAtIndex:index];
//        vc.orderListStatus =  [self convertIndexToStatus:index];
        [vc.tableView.mj_header beginRefreshing];
    }
}


#pragma mark - ZXSegmentMenuViewDelegate

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.segPageController setSelectedPageIndex:indexPath.item animated:YES];
    BuyerOrderAllController *vc = [self.dataMArray objectAtIndex:indexPath.item];
//    vc.orderListStatus = [self convertIndexToStatus:indexPath.item];
    [vc.tableView.mj_header beginRefreshing];
}

- (void)zx_segmentMenuView:(ZXSegmentMenuView *)menuView labelTagsView:(ZXLabelsTagsView *)tagsView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (cell.selected)
    {
        cell.titleLab.textColor = UIColorFromRGB(245.f, 143.f, 35.f);
        cell.layer.borderColor = UIColorFromRGB(245.f, 143.f, 35.f).CGColor;
        cell.titleLab.backgroundColor = [UIColor colorWithHexString:@"FFF5F1"];
    }
    else
    {
        cell.titleLab.textColor = UIColorFromRGB(83.f, 83.f, 83.f);
        cell.layer.borderColor = [UIColor colorWithHexString:@"0x868686"].CGColor;
        cell.titleLab.backgroundColor = nil;
    }

}

- (void)setSelectedPageIndexWithOrderListStatus:(PurchaserOrderListStatus)status
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
