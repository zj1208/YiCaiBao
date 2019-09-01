//
//  WYServiceViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYServiceViewController.h"

#import "SubletServiceTableViewCell.h"
#import "InfosServiceTableViewCell.h"
#import "NoticeServiceTableViewCell.h"
//#import "SurveyTableViewCell.h"
#import "ServiceHeadView.h"
#import "WYServiceTableViewCell.h"

#import "SurveyModel.h"
#import "ServiceModel.h"

//#import "MarketInfoTableViewCell.h"
//#import "WYMessageListViewController.h"
#import "WYSurveySearchViewController.h"
#import "FraudCaseListViewController.h"
#import "WYPerfectShopInfoViewController.h"
//#import "CircularListViewController.h"
#import "MessageDetailListViewController.h"

#import "UITableViewCell+HYBMasonryAutoCellHeight.h"
#import "ZXBadgeIconButton.h"
//#import "MSCViewController.h"

@interface WYServiceViewController ()<UITableViewDelegate, UITableViewDataSource,ZXHorizontalPageCollectionViewDelegate,ZXEmptyViewControllerDelegate>

//table
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
//市场资讯
@property (strong,nonatomic) NSMutableArray  *dataMArray;
//市场公告
@property (nonatomic, strong) NSMutableArray *notiArray;
//菜单
@property (nonatomic, strong) ServiceMenuModel *menuDic;
//转租转让
@property (nonatomic, strong) SubletListModel *subletListModel;
//@property (nonatomic, strong) NSMutableArray *subletArray;

@property (nonatomic, assign) BOOL doSomeThing;//认证中不能点击其他跳转

@property(nonatomic,strong) WYServiceTableViewCell* Menucell;
@end

@implementation WYServiceViewController

#pragma mark ------LifeCircle------
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"市场服务";
    [self creatUI];
    
    [self.tableView.mj_header beginRefreshing];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:Noti_update_WYServiceViewController object:nil];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    UIColor* color = [UIColor whiteColor];
//    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes= dict;
//
//    UIImage *backgroundImage = [WYUTILITY getCommonNavigationBarMarketServiceImageWithSize:CGSizeMake(self.navigationController.navigationBar.frame.size.width, 64)];
//    [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
//
//}
//
//- (void)viewWillDisappear:(BOOL)animated{
//    [super viewWillDisappear:animated];
//    UIColor* color = [UIColor blackColor];
//    NSDictionary* dict=[NSDictionary dictionaryWithObject:color forKey:NSForegroundColorAttributeName];
//    self.navigationController.navigationBar.titleTextAttributes= dict;
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = YES;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)requestData{
    [self.tableView setContentOffset:CGPointMake(0,0) animated:NO];
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ------Request------

- (void)requestLoadData{
    [self initData];
}

-(void)initData{
    //列表信息接口异步请求，最后只刷新一次TableView优化
    // 创建组
    dispatch_group_t group = dispatch_group_create();
    // 将网络请求任务添加到组中
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestMenu];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestInfos];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestNotice];
    });
    dispatch_group_async(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self requestSublet];
    });
    
    
    dispatch_group_notify(group, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSLog(@"完成了所有网络请求，不管网络请求失败了还是成功了。");
//        NSLog(@"3>>>>>%@",[NSThread currentThread]);
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView.mj_header endRefreshing];
            if (self.menuDic.menuList.count > 0) {
                [self.emptyViewController hideEmptyViewInController:self hasLocalData:YES];
                [self.tableView reloadData]; // 只刷新一次，优化UI多次刷新闪屏效果
            }else{
                self.emptyViewController.view.frame = self.view.bounds;
                [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
            }
        });
    });
}
//1.菜单
- (void)requestMenu{
    // 创建信号量
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[AppAPIHelper shareInstance] ServiceMainAPI] getMenuWithSuccess:^(id data) {
        self.menuDic = data;
        // 请求结束发送信号量
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        // 请求结束发送信号量
        dispatch_semaphore_signal(semaphore);
    }];
    // 在网络请求任务成功之前，信号量等待中
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//市场资讯
- (void)requestInfos{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[AppAPIHelper shareInstance] SurveyMainAPI] getFraudCaseListWithPageNo:1 pageSize:@4 success:^(id data) {
        [self.dataMArray removeAllObjects];
        [self.dataMArray addObjectsFromArray:data];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//3.市场公告
- (void)requestNotice{
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[[AppAPIHelper shareInstance] messageAPI] getPublicMsgListWithType:1 pageNo:1 pageSize:@2 success:^(id data) {
        [self.notiArray removeAllObjects];
        [self.notiArray addObjectsFromArray:data];
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//请求转租转让数据
- (void)requestSublet{
    WS(weakSelf)
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    [[[AppAPIHelper shareInstance] ServiceMainAPI]getSubletOrTransferListWithPage:@1 pageSize:@5 success:^(id data) {
        weakSelf.subletListModel = data;
        dispatch_semaphore_signal(semaphore);
    } failure:^(NSError *error) {
        weakSelf.subletListModel = nil;
        dispatch_semaphore_signal(semaphore);
    }];
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
}

//市场内身份认证接口
- (void)requestIsInMarket:(MenuListModel *)detailmodel{
    WS(weakSelf);
    //请求时不能在点击菜单
    _doSomeThing = YES;
    //判断是否在市场内
    [[[AppAPIHelper shareInstance]getServiceMainAPI]getAuthResultWithModuleTypeName:detailmodel.alias success:^(id data) {
        NSString *dsf= [data objectForKey:@"d_s_f"];
        [weakSelf isAuthenticationType:dsf model:detailmodel];
        weakSelf.doSomeThing = NO;
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        weakSelf.doSomeThing = NO;
    }];
}

#pragma mark ------TapAction------
//跳转搜索页
-(void)searchButtonAction{
    WYSurveySearchViewController *vc = [[WYSurveySearchViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}

//市场公告
-(void)noticeTap{
    [MobClick event:kUM_b_ServiceNotice];
    if ([self zx_performIsLoginActionWithPopAlertView:NO]){
        MessageDetailListViewController *vc = [[MessageDetailListViewController alloc] init];
        vc.typeName = @"市场公告";
        vc.type = @(1);
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//转租转让更多
- (void)moreSubletTap{
    [MobClick event:kUM_b_service_rentingmore];
    if (self.subletListModel.subletListUrl.length){
        [[WYUtility dataUtil]routerWithName:self.subletListModel.subletListUrl withSoureController:self];
    }
}

//市场资讯更多
-(void)moreInfosTap{
    [MobClick event:kUM_b_ServiceInformationMore];
    FraudCaseListViewController *vc = [[FraudCaseListViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ZXHorizontalPageCollectionViewDelegate------
//动态菜单
- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView willDisplayCell:(ZXBadgeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    cell.imgViewLayoutWidth.constant = LCDScale_iPhone6_Width(40);
}

-(void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self MenuClickViewWithIndex:indexPath.row];
}

#pragma mark ------ZXEmptyViewControllerDelegate------
- (void)zxEmptyViewUpdateAction{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(self.menuDic.menuList.count > 0){
        return 4;
    }else{
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0 || section == 1){
        return 1;
    }else if (section == 2){
        return self.subletListModel.records.count;
    }else if (section == 3){
        return self.dataMArray.count;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        [self.Menucell  setMenuDic:self.menuDic notiArray:self.notiArray];
        self.Menucell .selectionStyle = UITableViewCellSelectionStyleNone;
        return self.Menucell ;
    }else if (indexPath.section == 1){
        NoticeServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NoticeServiceTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell updateDate:self.notiArray];
        return cell;
    }else if (indexPath.section == 2){
        SubletServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SubletServiceTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.subletListModel.records.count > 0) {
            [cell updateDate:self.subletListModel.records[indexPath.row]];
        }
        return cell;
    }else if (indexPath.section == 3){
        InfosServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:InfosServiceTableViewCellID forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataMArray.count > 0) {
            [cell updateDate:[self.dataMArray objectAtIndex:indexPath.row]];
        }
        return cell;
    }else{
        UITableViewCell *cell = [[UITableViewCell alloc] init];
        return cell;
    }
}

#pragma mark ------UITableViewDelegate-----
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 2 && self.subletListModel.records.count > 0){
        return 45;
    }else if (section == 3){
        return 45;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 10;
    }else if (section == 1 && self.notiArray.count > 0){
        return 10;
    }else if (section == 2 && self.subletListModel.records.count > 0){
        return 10;
    }
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        CGFloat  JLDynamicMenuView_H = [self.Menucell.itemPageView getCellHeightWithContentData:self.menuDic.menuList];
        return JLDynamicMenuView_H + 88.0f;
    }else if (indexPath.section == 1) {
        if (self.notiArray.count > 0) {
            return 60;
        }
        return 0;
    }else if (indexPath.section == 2) {
        return 105;
    }else{
        return 110;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(section == 2){
        ServiceHeadView *headView = [[ServiceHeadView alloc] init];
        [headView.btnMore addTarget:self action:@selector(moreSubletTap) forControlEvents:UIControlEventTouchUpInside];
        [headView headViewUITitle:NSLocalizedString( @"转租转让", @"")];
        return headView;
    }else if(section == 3){
        ServiceHeadView *headView = [[ServiceHeadView alloc] init];
        [headView.btnMore addTarget:self action:@selector(moreInfosTap) forControlEvents:UIControlEventTouchUpInside];
        [headView headViewUITitle:NSLocalizedString( @"资讯", @"")];
        return headView;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
        [self noticeTap];
    }else if (indexPath.section == 2) {
        [MobClick event:kUM_b_service_rentinglist];
        ServiceModel *model = self.subletListModel.records[indexPath.row];
        NSString *webUrl = [self.subletListModel.subletDetailUrl stringByReplacingOccurrencesOfString:@"{id}" withString:model.zrzzID];
        [[WYUtility dataUtil]routerWithName:webUrl withSoureController:self];
    }else if (indexPath.section == 3) {
        SurveyModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        NSString *webUrl = model.contentUrl;
        [[WYUtility dataUtil]routerWithName:webUrl withSoureController:self];
        [MobClick event:kUM_fraudcase];
    }
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
//    if (scrollView == self.tableView)
//    {
//        CGFloat sectionHeaderHeight = 45; //sectionHeaderHeight
//        if (scrollView.contentOffset.y<=sectionHeaderHeight&&scrollView.contentOffset.y>=0) {
//            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
//        } else if (scrollView.contentOffset.y>=sectionHeaderHeight) {
//            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
//        }
//    }
//}

#pragma mark ------PrivateFunction------
- (void)creatUI{
    
    //主页面
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    //    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.showsVerticalScrollIndicator = NO;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SubletServiceTableViewCell" bundle:nil] forCellReuseIdentifier:SubletServiceTableViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"InfosServiceTableViewCell" bundle:nil] forCellReuseIdentifier:InfosServiceTableViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoticeServiceTableViewCell" bundle:nil] forCellReuseIdentifier:NoticeServiceTableViewCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"WYServiceTableViewCell" bundle:nil] forCellReuseIdentifier:WYServiceTableViewCellID];
    
    //    [self.tableView registerClass:[SurveyTableViewCell class] forCellReuseIdentifier:kCellIdentifier_SurveyTableViewCell];
    //    [self.tableView registerClass:[MarketInfoTableViewCell class] forCellReuseIdentifier:kCellIdentifier_MarketInfoTableViewCell];
    //菜单cell
    
    self.Menucell = [self.tableView dequeueReusableCellWithIdentifier:WYServiceTableViewCellID];
    self.Menucell.itemPageView.delegate = self;
    [self.Menucell.searchButton addTarget:self action:@selector(searchButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];
    
    
    self.dataMArray = [NSMutableArray array];
    self.notiArray = [NSMutableArray array];
    self.menuDic = [[ServiceMenuModel alloc] init];
    
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
}



#pragma mark ------MenuDelegate------
-(void)MenuClickViewWithIndex:(NSInteger)index{
    MenuListModel *detailmodel = self.menuDic.menuList[index];
    if (_doSomeThing){
        return;
    }
    if (!detailmodel.login1st.integerValue){
        //不需要需要登录
        [self menuRounter:detailmodel];
    }else if (![self zx_performIsLoginActionWithPopAlertView:NO]){
        //判断是否登陆   未登录弹登陆界面
    }else if (detailmodel.forceShop2nd.integerValue && ![UserInfoUDManager getShopId]){
        //需要开店 && 没开店
        [self addShopAlert];
    }else if (detailmodel.idtf3rd.integerValue){
        //需要认证
        [self requestIsInMarket:detailmodel];
    }else{
        [self menuRounter:detailmodel];
    }
}

//菜单内容跳转
-(void)menuRounter:(MenuListModel *)model{
    if (![NSString zhIsBlankString: model.alias]) {
        NSString* mobstr = model.alias;
        [MobClick event:mobstr];
    }
    [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
}

//市场内认证状态判断
- (void)isAuthenticationType:(NSString *)dsf model:(MenuListModel *)detailmodel{
    if ([dsf isEqualToString:@"okey"]){
        //在市场内
        [self menuRounter:detailmodel];
    }else if ([dsf isEqualToString:@"sorry"]){
        //未认证
        [self AlertUnverify];
    }else if ([dsf isEqualToString:@"needOwner"]){
        //通过认证，需要摊主身份
        [MBProgressHUD zx_showError:NSLocalizedString(@"抱歉，此功能只有市场内摊主身份登录才有权限访问", nil) toView:self.view];
    }else if ([dsf isEqualToString:@"needManager"]){
        //通过认证，需要经营人身份
        [self needTransactorAlert];
    }
}

//未认证弹窗
- (void)AlertUnverify{
    WS(weakSelf)
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"您未通过义乌国际商贸城市场认证，无法使用该功能喔~", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"去认证", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//        NSString *h5URL = [WYUserDefaultManager getkAPP_H5URL];
//        NSString *webUrl = [NSString stringWithFormat:@"%@/ysb/page/unverify.html",h5URL];
////        [vc loadTitle:@"市场认证" AndUrl:[NSString stringWithFormat:@"%@/ysb/page/unverify.html",h5URL]];
//        [[WYUtility dataUtil]routerWithName:webUrl withSoureController:self];
        
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.unverify;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_unverify withSoureController:weakSelf];
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//未开店弹窗
- (void)addShopAlert{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"完善商铺信息，手机轻松办服务！", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil) style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction *doAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"立即完善", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
        fastOpenShop.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:fastOpenShop animated:YES];
        
    }];
    [alertController addAction:cancelAction];
    [alertController addAction:doAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

//需要经营人身份弹窗
- (void)needTransactorAlert{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"抱歉，此功能只有市场内实际经营人身份登录才有权限访问", nil) message:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) cancleHandler:^(UIAlertAction * _Nonnull action) {
    } doButtonTitle:NSLocalizedString(@"联系客服", nil) doHandler:^(UIAlertAction * _Nonnull action) {
        [self.view zx_performCallPhoneApplication:NSLocalizedString(@"4006660998", nil)];
    }];
}

@end
