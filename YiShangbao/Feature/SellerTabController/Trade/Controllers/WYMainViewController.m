//
//  WYMainViewController.m
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
// 首页

#import "WYMainViewController.h"

#import <MJRefresh/MJRefresh.h>

#import "WYTradeTableViewCell.h"
#import "WYTradeAdvCell.h"
#import "WYMessageListViewController.h"

#import "TradeDetailController.h"

#import "MessageModel.h"
#import "ZXModalAnimatedTranstion.h"
#import "ZXModalTransitionDelegate.h"
#import "ZXAdvModalController.h"
#import "AlertChoseController.h"

#import "ZXEmptyViewController.h"
#import "XLPhotoBrowser.h"

#import "JLDragImageView.h"
#import "GuideTradeMainController.h"

#import "UIScrollView+AssistiveTouch.h"
#import "NIMSessionViewController.h"
#import "NIMSessionListViewController.h"

#import "WYTradeFinishedController.h"
#import "WYPerfectShopInfoViewController.h"

#import "WYTradeSetViewController.h"
#import "WYTradeSetAlertController.h"

#import "TradeSearchController.h"
#import "TradeSearchDetailController.h"

static NSString * const reuseIdentifier = @"Cell";
static NSString * const reuseAdvIdentifier = @"advCell";


@interface WYMainViewController ()<UITableViewDelegate,UITableViewDataSource,WYTradeListDelegate,UIViewControllerTransitioningDelegate,ZXEmptyViewControllerDelegate,ZXPhotosViewDelegate,XLPhotoBrowserDatasource,UIScrollViewDelegate,JLDragImageViewDelegate,ZXAlertChoseControllerDelegate,UITableViewDataSourcePrefetching>

@property (nonatomic, strong) WYTradeTableViewCell *tradeTableCell;
@property (nonatomic, strong) WYTradeAdvCell *tradeAdvCell;

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSInteger totalPage;
@property (nonatomic, copy) NSString * responseId;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) ZXModalTransitionDelegate *transitonModelDelegate;

@property (nonatomic, strong) NSMutableArray *photoArray;

@property (nonatomic, strong) ZXAssistiveTouch *assistiveTouch;

@property (nonatomic, strong) JLDragImageView* tradeMoveView ;//拖动图标
@property (nonatomic, strong) TradeMoveTitleModel * trademoveTitleModel; //走马灯model
@property (nonatomic, strong) AdvModel *advmodel; //弹窗广告model
@property (nonatomic, assign) BOOL ifRemoveDataWhenSwitchCategories;;//最新，智能，与我相关切换(请求数据失败判断是否清空数据)

@property (nonatomic, assign) BOOL isNowMoveAnimated;//导航栏等正在平移动画操作(动画控制)
@property (nonatomic, assign) BOOL StatusBarblackColor;//状态栏颜色黑色

//0-全部(最新发布，默认) 1-与我相关(2017.5.23) 2-智能排序(2017.8.7) 3-低价库存(2017.10.11) 9-其他求购(2017.10.11)
@property (nonatomic, assign) TradeRelatedToMeListType relatedToMeListType;

// 已接单的 生意id数组
@property (nonatomic, strong) NSMutableArray *bidedTradeMArray;
// 忽略关闭的 生意id数组
@property (nonatomic, strong) NSMutableArray *ignoredTradeMArray;



@end

@implementation WYMainViewController


#pragma mark lift cycle

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setUI];
    [self setData];
    [self requestData];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    [MobClick beginLogPageView:NSStringFromClass([self class])];

    //启动定时器
    [self.trademoveButton resumeJLMoveTitleButtonTimerAfterDuration:0];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

}

#pragma mark - 请求走马灯广告
-(void)requestTopMoveLabel
{
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getTradeAdvWithQuKuaiID:1006 success:^(id data) {
        
        self.trademoveTitleModel = data;
        if (self.trademoveTitleModel.items.count > 0 && _dataMArray.count>0) {
            TradeMoveTitleItemsModel* itemsModel = self.trademoveTitleModel.items[0];
            self.trademoveButton.moveString = itemsModel.desc;
            self.topbackview.hidden = NO;
        }else{
            self.topbackview.hidden = YES;
        }

    } failure:^(NSError *error) {
        if (self.trademoveTitleModel) {
            if (self.trademoveTitleModel.items.count > 0 && _dataMArray.count>0) {
                self.topbackview.hidden = NO;
            }else{
                self.topbackview.hidden = YES;
            }
        }
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
    
    if (self.presentedViewController)//如果跳转为Present
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }else{
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    //暂停定时器
    [self.trademoveButton pauseJLMoveTitleButtonTimer];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}
//#pragma mark -  状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle
{
    if (self.StatusBarblackColor) {
        return UIStatusBarStyleDefault;
    }
    return UIStatusBarStyleLightContent;

}
- (void)setUI{
    
    //UI
    self.customNavigationBarImageView.image = [WYUTILITY getCommonNavigationBarRedGradientImageWithSize:CGSizeMake(LCDW, 64)];
//    self.customNavigationBarImageView.image = [WYUIStyle imageBF352D_BD2B23:CGSizeMake(LCDW, 64)];
//    [self.newsBtn setTitleColor:[WYUIStyle colorBD2F26] forState:UIControlStateSelected];
//    [self.stockBtn setTitleColor:[WYUIStyle colorBD2F26] forState:UIControlStateSelected];
//    [self.relatedToMeBtn setTitleColor:[WYUIStyle colorBD2F26] forState:UIControlStateSelected];
//    [self.moveline setBackgroundColor:[WYUIStyle colorBD2F26]];
    
    self.view.backgroundColor = WYUISTYLE.colorF3F3F3;
    self.tableView.backgroundColor = self.view.backgroundColor;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYTradeTableViewCell" bundle:nil] forCellReuseIdentifier:reuseIdentifier];

    [self.tableView registerNib:[UINib nibWithNibName:@"WYTradeAdvCell" bundle:nil] forCellReuseIdentifier:@"advCell"];

    
    self.tableView.estimatedRowHeight = 200;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    if ([self.tableView respondsToSelector:@selector(prefetchDataSource)])
    {
        self.tableView.prefetchDataSource = self;
    }
    self.tradeTableCell = [self.tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    self.tradeAdvCell = [self.tableView dequeueReusableCellWithIdentifier:reuseAdvIdentifier];
    
    //失败氛围图
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    emptyVC.view.frame = CGRectMake(0, 64+40, LCDW, LCDH);
    self.emptyViewController = emptyVC;
    
//    [self.tableView addAssistiveTouchTo:self.view withTarget:self action:nil];
    
    //发求购拖动按钮
    JLDragImageView *dragView = [[JLDragImageView alloc] init];
    dragView.image = [UIImage imageNamed:@"qiugou"];
    dragView.jl_sectionInset = UIEdgeInsetsMake(HEIGHT_NAVBAR+40,0,40,0);
    dragView.jl_isAdsorption = NO;
    dragView.jl_outBounds = YES;
    dragView.delegate = self;
    [dragView showSuperview:self.view frameOffsetX:15 offsetY:80+HEIGHT_TABBAR_SAFE Width:LCDScale_iPhone6_Width(100) Height:LCDScale_iPhone6_Width(40)];
    self.tradeMoveView = dragView;
    
    //走马灯容器
    self.topbackview.hidden = YES;
    
    //接生意设置
    if (![WYUserDefaultManager getTouchTradeSet]) {
        self.businessRedPointIMV.image = [UIImage imageNamed:@"icon_yuandian"];
    }
    
    //功能引导
    if (![WYUserDefaultManager getNewFunctionGuide_Trade]) {
        UIStoryboard* SB = [UIStoryboard storyboardWithName:storyboard_Main bundle:[NSBundle mainBundle]];
        GuideTradeMainController *tradeSearchVC= [SB instantiateViewControllerWithIdentifier:SBID_GuideTradeMainController];
        
        [self.tabBarController.view addSubview:tradeSearchVC.view];
        [self.tabBarController addChildViewController:tradeSearchVC];
    }
    
    //iphoneX适配自定义导航栏
    [self.customNavigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_NAVBAR);
    }];   

}

- (void)setData{
    
    self.dataMArray = [NSMutableArray array];
    self.bidedTradeMArray = [NSMutableArray array];
    self.ignoredTradeMArray = [NSMutableArray array];

    // 已接单
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedTradeFinish:) name:Noti_Trade_haveReceivedTrade object:nil];
    
    // 重复接单 或  已经被别人接单了；
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(receivedTradeFinish:) name:Noti_Trade_subjectCompleted object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    
////
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
//
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestrelatedToMeNumData) name:Noti_Trade_Push_NewTrades object:nil];
    
    NSMutableArray *photos = [NSMutableArray array];
    _photoArray = photos;

    [self headerRefresh];
}
#pragma mark - 请求失败／列表为空时候的代理请求
- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - // 已接单 // 重复接单 或  已经被别人接单了；

- (void)receivedTradeFinish:(id)notification
{
    NSNotification *noti = (NSNotification *)notification;
    NSString *tradeId = [noti.userInfo objectForKey:@"tradeId"];
    if (![self.bidedTradeMArray containsObject:tradeId])
    {
        [self.bidedTradeMArray addObject:tradeId];
        WS(weakSelf);
        [self.dataMArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            WYTradeModel *model = (WYTradeModel *)obj;
            if ([model.postId isEqualToString:tradeId])
            {
                [weakSelf.dataMArray removeObjectAtIndex:idx];
                NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:idx];
                [weakSelf.tableView beginUpdates];
                [weakSelf.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
                [weakSelf.tableView endUpdates];
                
                if (weakSelf.dataMArray.count==0)
                {
                    if (weakSelf.tableView.mj_footer)
                    {
                        weakSelf.tableView.mj_footer = nil;
                    }
                    [weakSelf.tableView.mj_header beginRefreshing];
                }
                else
                {
                    if (weakSelf.tableView.contentSize.height<(LCDH+weakSelf.tableView.rowHeight) &&weakSelf.totalPage>1 &&weakSelf.pageNo<weakSelf.totalPage)
                    {
                        [weakSelf.tableView.mj_header beginRefreshing];
                    }
                }
                *stop = YES;
            }
        }];
    }
}

#pragma mark - 登陆
//登陆的时候需要重新检查系统推荐数，系统推荐的列表
- (void)loginIn:(id)notification
{
    [self moveCustomNavigationBarDownWhenNeed];
    [self requestrelatedToMeNumData]; //请求系统推荐数
    [self requestData];
    
}

//#pragma mark - 退出
//- (void)loginOut:(id)notification
//{
//    //默认最新发布
//    [self newsBtnClickMobClick:NO];
//    [self moveCustomNavigationBarDownWhenNeed];
//    self.numsLabel.hidden = YES;;
//}

#pragma  mark - 请求
- (void)requestData
{
    if ([UserInfoUDManager isOpenShop]) {
        [self relatedToMeBtnClickMobClick:NO];
    }else{
        [self newsBtnClickMobClick:NO];
    }
}

#pragma mark - 主页列表请求
- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.topbackview.hidden = YES; //走马灯

        weakSelf.shaixuanContentView.userInteractionEnabled = NO;
    
        [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradeBussinessListWithBided:nil ignored:nil pageNo:1 pageSize:@(10) relatedToMe:weakSelf.relatedToMeListType requestId:nil success:^(id data, PageModel *pageModel, NSString *responseId) {
            
            //最新发布/系统推荐/库存专区容器
            weakSelf.shaixuanContentView.userInteractionEnabled = YES;
            [weakSelf.bidedTradeMArray removeAllObjects];
            [weakSelf.dataMArray removeAllObjects];
            [weakSelf.dataMArray addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
            weakSelf.pageNo = 1;
            weakSelf.totalPage = [pageModel.totalPage integerValue];
            weakSelf.responseId = responseId;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dataMArray.count==0) {
                    [weakSelf moveCustomNavigationBarDownWhenNeed];
                }
                if (weakSelf.relatedToMeListType == TradeRelatedToMeListType_systemRecommend){ //系统推荐
                    weakSelf.numsLabel.hidden = YES; //点击后清空系统推荐数
                    NSMutableString* strBlack = [NSMutableString stringWithFormat:@"暂时没有与您相关的信息，\n完善商铺经营信息可获得更多相关生意～"];
                    [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:strBlack updateBtnHide:YES];
                    [weakSelf.view layoutIfNeeded];
                    CGFloat empty_y = CGRectGetMinY(weakSelf.tableView.frame);
                    weakSelf.emptyViewController.view.frame = CGRectMake(0,empty_y, LCDW, LCDH);
                }else{ //0239
                    [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"首页氛围图"] emptyTitle:nil updateBtnHide:YES];
                    [weakSelf.view layoutIfNeeded];
                    CGFloat empty_y = CGRectGetMinY(weakSelf.tableView.frame);
                    weakSelf.emptyViewController.view.frame = CGRectMake(0,empty_y, LCDW, LCDH);
                    
                }
            });
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf requestTopMoveLabel];//1s后
                
            });
            
        } failure:^(NSError *error) {
            
            weakSelf.shaixuanContentView.userInteractionEnabled = YES;
            [weakSelf.tableView.mj_header endRefreshing];
            
            if (weakSelf.ifRemoveDataWhenSwitchCategories) {//切换后
                [weakSelf.dataMArray removeAllObjects];
                [weakSelf.tableView reloadData];
                [weakSelf footerWithRefreshing:0];
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                if (weakSelf.dataMArray.count==0) {
                    [weakSelf moveCustomNavigationBarDownWhenNeed];
                }
                [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
                [weakSelf.view layoutIfNeeded];
                CGFloat empty_y = CGRectGetMinY(weakSelf.tableView.frame);
                weakSelf.emptyViewController.view.frame = CGRectMake(0,empty_y, LCDW, LCDH);
            });
        }];
        
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
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{

        weakSelf.shaixuanContentView.userInteractionEnabled = NO; //暂停交互

        [[[AppAPIHelper shareInstance] getTradeMainAPI]getTradeBussinessListWithBided:weakSelf.bidedTradeMArray ignored:weakSelf.ignoredTradeMArray pageNo:weakSelf.pageNo+1 pageSize:@(10) relatedToMe:weakSelf.relatedToMeListType requestId:weakSelf.responseId success:^(id data, PageModel *pageModel, NSString *responseId){
            
            [weakSelf.dataMArray addObjectsFromArray:data];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.mj_footer endRefreshing];
            
            weakSelf.pageNo ++;
            weakSelf.totalPage = [pageModel.totalPage integerValue];
            if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0)
            {
                weakSelf.tableView.mj_footer = nil;
            }
            weakSelf.shaixuanContentView.userInteractionEnabled = YES;
            
        } failure:^(NSError *error) {
            weakSelf.shaixuanContentView.userInteractionEnabled = YES;
            
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }];
    //控制底部控件(默认高度44)出现百分比(0.0-1.0,默认1.0)来预加载，此处设置表示距离底部上拉控件顶部10*44高度即提前加载数据
    footer.triggerAutomaticallyRefreshPercent = -10;
    self.tableView.mj_footer = footer;
}



#pragma mark - 请求系统推荐数
-(void)requestrelatedToMeNumData
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getkTradeGetOrderSubjectIncrementsuccess:^(id data) {
        NSNumber* num  = [data objectForKey:@"increment"];
        if (num.integerValue>0) {
            weakSelf.numsLabel.hidden = NO;
            [weakSelf.numsLabel zh_digitalIconWithBadgeValue:[num integerValue] maginY:1.f badgeFont:[UIFont systemFontOfSize:12.f] titleColor:[UIColor whiteColor] backgroundColor:[WYUISTYLE colorWithHexString:@"FF0000"]];
        }
        
    } failure:^(NSError *error) {

    }];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return self.dataMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        if (model.cellType ==WXCellType_Trade)
        {
            WYTradeTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
            cell.photosView.delegate = self;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.deleteBtn addTarget:self action:@selector(deleteCellAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell setData:model];
            return cell;
        }
     }
    WYTradeAdvCell *advCell = (WYTradeAdvCell *)[tableView dequeueReusableCellWithIdentifier:@"advCell" forIndexPath:indexPath];
    advCell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        [advCell setData:model];
    }
    return advCell;
}

#pragma mark table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (self.dataMArray.count>0)
    {
        WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        if (model.cellType ==WXCellType_Trade) {
            CGFloat height = [self.tradeTableCell getCellHeightWithContentData:model];
            return height;
        }
        else
        {
            return [self.tradeAdvCell getCellHeightWithContentData:model];
        }
    }
    return 0.f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    if (model.cellType ==WXCellType_Trade)
    {
        if (model.orderingBtnModel.buttonType ==1)
        {
            if ([self xm_performActionWithIsLogin:ISLOGIN withPopAlertView:NO])
            {
                [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":model.postId,@"nTitle":@"生意"}];
                [MobClick event:kUM_gotoBuild];
            }
        }
        else
        {
            [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"这个生意已经被人抢啦，下次来早点哦～" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
        }
    }
    else
    {

        if (_relatedToMeListType == TradeRelatedToMeListType_all) {
            //最新发布
            [self requestClickAdvWithAreaId:@1007 advId:model.postId];
        }
        else if (_relatedToMeListType == TradeRelatedToMeListType_systemRecommend) { //与我相关
            [self requestClickAdvWithAreaId:@10072 advId:model.postId];
        }
        else if (_relatedToMeListType == TradeRelatedToMeListType_inventory){
            //智能排序-库存专区
            [self requestClickAdvWithAreaId:@10071 advId:model.postId];
        }
        [[WYUtility dataUtil]routerWithName:model.h5Url withSoureController:self];
    }
}

- (void)tableView:(UITableView *)tableView prefetchRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths 
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.dataMArray.count>indexPath.section)
        {
            WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
            if (model.cellType ==WXCellType_Trade)
            {
                WYTradeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.URL.absoluteString];
                [cell.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
            }
        }

    }];
}

- (void)tableView:(UITableView *)tableView cancelPrefetchingForRowsAtIndexPaths:(NSArray<NSIndexPath *> *)indexPaths
{
    [indexPaths enumerateObjectsUsingBlock:^(NSIndexPath * _Nonnull indexPath, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (self.dataMArray.count>indexPath.section)
        {
            WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
            if (model.cellType ==WXCellType_Trade)
            {
                WYTradeTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
                [cell.headBtn sd_cancelImageLoadForState:UIControlStateNormal];
            }
        }
        
    }];
}
#pragma mark - 导航栏平移处理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!scrollView.dragging) {
        return;
    }
    if (self.isNowMoveAnimated) {
        return;
    }
    CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];

    if (translation.y< -100) {//向上滑动
        [self.customNavigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(-HEIGHT_NAVBAR).priority(1000);
        }];
        [self.shaixuanContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40+HEIGHT_STATEBAR).priority(1000);
        }];
        self.StatusBarblackColor = YES;
        [self setNeedsStatusBarAppearanceUpdate]; //刷新状态栏
        self.isNowMoveAnimated = YES;
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            if (self.tradeMoveView.frame.origin.y<=HEIGHT_NAVBAR+40) {
                CGRect frame = self.tradeMoveView.frame;
                frame.origin.y= HEIGHT_NAVBAR;
                self.tradeMoveView.frame = frame;
            }
        } completion:^(BOOL finished) {
            self.isNowMoveAnimated = NO;
            self.tradeMoveView.jl_sectionInset = UIEdgeInsetsMake(HEIGHT_NAVBAR,0,40,0);
        }];
        
    }else if(translation.y> 30.f){
        
        [self.customNavigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).priority(1000);
        }];
        [self.shaixuanContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(40).priority(1000);
        }];
        self.StatusBarblackColor = NO;
        [self setNeedsStatusBarAppearanceUpdate];
        self.isNowMoveAnimated = YES;
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded];
            if (self.tradeMoveView.frame.origin.y<=HEIGHT_NAVBAR+40) {
                CGRect frame = self.tradeMoveView.frame;
                frame.origin.y= HEIGHT_NAVBAR+40;
                self.tradeMoveView.frame = frame;
            }
        } completion:^(BOOL finished) {
            self.isNowMoveAnimated = NO;
            self.tradeMoveView.jl_sectionInset = UIEdgeInsetsMake(HEIGHT_NAVBAR+40,0,40,0);
        }];
        
        
    }
}
#pragma mark - 将平移导航栏下来
-(void)moveCustomNavigationBarDownWhenNeed
{
    [self.customNavigationBarView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).priority(1000);
    }];
    [self.shaixuanContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40).priority(1000);
    }];
    self.StatusBarblackColor = NO;
    [self setNeedsStatusBarAppearanceUpdate];
    [UIView animateWithDuration:0.15 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
#pragma mark - 发求购 JLDragImageViewDelegate
-(void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer *)tapGes
{
    [MobClick event:kUM_b_inquiry];

//    NSString *string = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseForm.html",[WYUserDefaultManager getkAPP_H5URL]];
//    [[WYUtility dataUtil]routerWithName:string withSoureController:self];
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPurchaseForm;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPurchaseForm withSoureController:self];

}
#pragma  mark - MWPhotoBrowser

- (void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos userInfo:(nullable id)userInfo
{
    
    [_photoArray removeAllObjects];
    //大图浏览
    [photos enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *zxPhoto = (ZXPhoto*)obj;
        NSURL *url = [NSURL URLWithString:zxPhoto.original_pic];
        //大图浏览
        [_photoArray addObject:url];
    }];
    
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:index imageCount:photos.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
    //点击大图统计
    [[[AppAPIHelper shareInstance]getTradeMainAPI]getTradePicClickWithTradeId:userInfo success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    return _photoArray[index];
}

//#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
   return  [self.tableView isRefreshing];
}



#pragma mark - 删除某行

- (void)deleteCellAction:(id)sender
{
    [MobClick event:kUM_b_closepurchase];
    
    if (![self xm_performIsLoginActionWithPopAlertView:NO])
    {
        return;
    }
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    }
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(407));
    
    AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
    vc.addTextField = YES;
    vc.btnActionDelegate = self;
    vc.titles = @[@"这个商品我没有",@"起订量太低，做不了",@"采购信息不够详细",@"采购商不靠谱",@"这个是低价库存求购"];
    vc.textViewPlaceholder = @"请输入其它原因";
    vc.alertTitle = @"不再展示此条生意";
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    WYTradeModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    vc.userInfo = @{@"tradeId":model.postId,@"indexPath":indexPath};
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    [self presentViewController:vc animated:YES completion:nil];
}

- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
    NSString *tradeId =  [userInfo objectForKey:@"tradeId"];
    [[[AppAPIHelper shareInstance]getTradeMainAPI]postIgnoreSubjectWithTradeId:tradeId reason:content success:^(id data) {
        
        [MobClick event:@"kUM_b_closedsuccessful"];
//        [_tableView.mj_header beginRefreshing];
        NSIndexPath *indexPath = [userInfo objectForKey:@"indexPath"];
        [_dataMArray removeObjectAtIndex:indexPath.section];
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:indexPath.section];
        [self.tableView deleteSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
//        [_ignoredTradeMArray addObject:tradeId];
        [MBProgressHUD zx_showSuccess:@"您成功已关闭该条求购" toView:nil];
        
    } failure:^(NSError *error) {
      
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];

    }];
}
#pragma mark - -----------导航栏--------------
#pragma mark 导航栏已接单
- (IBAction)clickLeftTradeBarbutton:(UIButton *)sender {        
    if ([self isLoginAndOpenShopWithPresentAlert:NO]) {
        [MobClick event:kUM_yijie];
        [self xm_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_MyTradesController withData:nil];
    }
}
//不用了(18.8.24)
#pragma mark 导航栏消息
- (IBAction)clickMessageAction:(ZXBadgeIconButton *)sender {
    if ([self xm_performIsLoginActionWithPopAlertView:NO])
    {
        [MobClick event:kUM_message];
        
        WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
        messageList.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
}
#pragma mark 导航栏 接生意设置
- (IBAction)BusinessSetBtnClick:(UIButton *)sender {
    
    if ([self isLoginAndOpenShopWithPresentAlert:NO]) {
        [MobClick event:kUM_b_indexset];
        
        if (![WYUserDefaultManager getTouchTradeSet]) {
            [WYUserDefaultManager setTouchTradeSet];
            self.businessRedPointIMV.image = [UIImage new];
        }
        [self performSegueWithIdentifier:segue_WYTradeSetViewController sender:self];
    }
}
#pragma mark 生意搜索🔍
- (IBAction)clickBussinessButton:(UIButton *)sender {

    UIStoryboard* SB = [UIStoryboard storyboardWithName:storyboard_Trade bundle:[NSBundle mainBundle]];
    TradeSearchController *tradeSearchVC= [SB instantiateViewControllerWithIdentifier:SBID_TradeSearchController];
    
    [self presentViewController:tradeSearchVC animated:NO completion:nil];
}

#pragma mark -点击走马灯文字
- (IBAction)clickMoveButton:(id)sender {

    if (self.trademoveTitleModel.items.count>0)
    {
        TradeMoveTitleItemsModel* itemModel = self.trademoveTitleModel.items[0];
        NSString* advid = [NSString stringWithFormat:@"%@",itemModel.iid];
        [self requestClickAdvWithAreaId:@1006 advId:advid];
        
        [[WYUtility dataUtil]routerWithName:itemModel.url withSoureController:self];
    }

}
#pragma mark 返回
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma mark 关闭走马灯
- (IBAction)exitButton:(id)sender {
    [self.topbackview removeFromSuperview];
}

#pragma mark - 最新发布
- (IBAction)zhinengBtnClick:(UIButton *)sender {
   
    [self newsBtnClickMobClick:YES]; //是否埋点统计
}
//最新发布
-(void)newsBtnClickMobClick:(BOOL)needMobClick
{
    if (needMobClick) {
        [MobClick event:kUM_b_hometab1];
    }
    if (_newsBtn.selected) {
        self.ifRemoveDataWhenSwitchCategories = NO;
    }else{
        self.ifRemoveDataWhenSwitchCategories = YES;
    }
    self.relatedToMeListType = TradeRelatedToMeListType_all;
    [self.tableView.mj_header beginRefreshing];
    
    _newsBtn.selected = YES;
    _stockBtn.selected = NO;
    _relatedToMeBtn.selected = NO;
    _newsBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _stockBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _relatedToMeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self moveLineAlignedButton:_newsBtn];
    
}
#pragma mark - 库存专区
- (IBAction)stockBtnClick:(UIButton *)sender {
    [self stockBtnClickMobClick:YES];//是否埋点统计
}
//库存专区
-(void)stockBtnClickMobClick:(BOOL)needMobClick
{
    if (needMobClick) {
        [MobClick event:kUM_b_hometab2];
    }
    if (_stockBtn.selected) {
        self.ifRemoveDataWhenSwitchCategories = NO;
    }else{
        self.ifRemoveDataWhenSwitchCategories = YES;
    }
    self.relatedToMeListType = TradeRelatedToMeListType_inventory;
    [self.tableView.mj_header beginRefreshing];
    
    _stockBtn.selected = YES;
    _newsBtn.selected = NO;
    _relatedToMeBtn.selected = NO;
    _stockBtn.titleLabel.font = [UIFont systemFontOfSize:16];
    _newsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _relatedToMeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self moveLineAlignedButton:_stockBtn];
    
}
#pragma mark - 系统推荐
- (IBAction)relatedToMeBtnClick:(UIButton *)sender {
    [self relatedToMeBtnClickMobClick:YES];//是否埋点统计
}
//系统推荐
-(void)relatedToMeBtnClickMobClick:(BOOL)needMobClick
{
    if ([self isLoginAndOpenShopWithPresentAlert:YES]) {
        if (needMobClick) {
            [MobClick event:kUM_b_interrelatedme];
        }
        
        if (_relatedToMeBtn.selected) {
            self.ifRemoveDataWhenSwitchCategories = NO;
        }else{
            self.ifRemoveDataWhenSwitchCategories = YES;
        }
        self.relatedToMeListType = TradeRelatedToMeListType_systemRecommend;
        [self.tableView.mj_header beginRefreshing];
        
        _relatedToMeBtn.selected = YES;
        _newsBtn.selected = NO;
        _stockBtn.selected = NO;
        _relatedToMeBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        _stockBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        _newsBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [self moveLineAlignedButton:_relatedToMeBtn];
    }
}
#pragma mark - 移动下划线
-(void)moveLineAlignedButton:(UIButton*)button
{
    [self.moveline mas_remakeConstraints:^(MASConstraintMaker *make) { //更新约束前删除已有约束
        make.height.mas_equalTo(3);
        make.width.mas_equalTo(70);
        make.bottom.mas_equalTo(self.shaixuanContentView.mas_bottom);
        make.centerX.equalTo(button.mas_centerX);
    }];
    [UIView animateWithDuration:0.1 animations:^{
        [self.view layoutIfNeeded];
    } completion:^(BOOL finished) {
    }];
}
#pragma mark - 判断是否登录/开店
-(BOOL)isLoginAndOpenShopWithPresentAlert:(BOOL)alertVC
{
    if ([UserInfoUDManager isLogin]) {
        if ([UserInfoUDManager isOpenShop])
        {  //登陆开店了
            return YES;
        }else
        { //登陆未开店
            if (alertVC) {
                UIStoryboard *Main =  [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                WYTradeSetAlertController *VC = (WYTradeSetAlertController *)[Main instantiateViewControllerWithIdentifier:SBID_WYTradeSetAlertController];
                VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
                VC.btnClcikBlock = ^(UIButton *btn) {
                    WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
                    fastOpenShop.hidesBottomBarWhenPushed = YES;
                    [self.navigationController pushViewController:fastOpenShop animated:YES];
                };
                [self presentViewController:VC animated:NO completion:nil];
            }else{
                WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
                fastOpenShop.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:fastOpenShop animated:YES];
            }
        }
    }else{ //未登陆
        [self xm_performIsLoginActionWithPopAlertView:NO];
    }
    return NO;
}

@end
