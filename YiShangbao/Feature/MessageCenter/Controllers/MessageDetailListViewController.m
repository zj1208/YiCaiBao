//
//  MessageDetailListViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageDetailListViewController.h"
#import "WYMessageDetailTableViewCell.h"
#import "MessageSystemCell.h"
#import "MessageModel.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import "ZXNotiAlertViewController.h"
#import "WYWKWebViewController.h"
#import "TradeDetailController.h"


@interface MessageDetailListViewController ()<UITableViewDelegate, UITableViewDataSource,ZXEmptyViewControllerDelegate,UIViewControllerPreviewingDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) WYMessageDetailTableViewCell *msgDetailCell;
@property (nonatomic, strong) MessageSystemCell *messageSystemCell;

@property (nonatomic, strong) NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;
@property (nonatomic, assign) NSInteger totalPage;

//空状态
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
@end

static NSString *const reuse_Cell  = @"Cell";
static NSString *const reuse_SystemCell = @"SystemCell";

@implementation MessageDetailListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self setData];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)creatUI
{
    self.navigationItem.title = self.typeName;
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    
    [self addTableView];
    [self addEmptyView];
    [self performSelector:@selector(addUNNotificationAlert) withObject:nil afterDelay:1.f];
    
    if (Device_SYSTEMVERSION_IOS9_OR_LATER)
    {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable)
        {
            [self registerForPreviewingWithDelegate:self sourceView:self.tableView];
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(previewActionShare:) name:@"previewActionShare" object:nil];
        }
    }
}

- (void)addEmptyView
{
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    emptyVC.contentOffest =CGSizeMake(0, 10);
    self.emptyViewController = emptyVC;
}

- (void)addTableView
{
    //tableView
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = self.view.backgroundColor;
    [self.view addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(self.view.mas_top);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    
    
    UINib *nib =[UINib nibWithNibName:NSStringFromClass([WYMessageDetailTableViewCell class]) bundle:nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:reuse_Cell];
    self.msgDetailCell = [self.tableView dequeueReusableCellWithIdentifier:reuse_Cell];
    
    UINib *systemNib =[UINib nibWithNibName:NSStringFromClass([MessageSystemCell class]) bundle:nil];
    [self.tableView registerNib:systemNib forCellReuseIdentifier:reuse_SystemCell];
    self.messageSystemCell = [self.tableView dequeueReusableCellWithIdentifier:reuse_SystemCell];

    
    
    self.tableView.tableFooterView = [[UIView alloc] init];
    
    self.tableView.estimatedRowHeight = 100.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

}
- (void)setData
{
    self.dataMArray = [NSMutableArray array];

    [[[AppAPIHelper shareInstance] messageAPI] markMsgReadWithType:self.type success:^(id data){
        
    } failure:^(NSError *error) {
    }];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
}

- (void)addUNNotificationAlert
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentNotiAlert];
                });
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [self presentNotiAlert];
        }
    }
}
- (void)presentNotiAlert
{
    if ([WYUserDefaultManager isCanPresentAlertWithIntervalDay:7])
    {

        ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
        [self.tabBarController addChildViewController:alertView];
        alertView.view.frame = self.tabBarController.view.frame;
        [self.tabBarController.view addSubview:alertView.view];
        __block ZXNotiAlertViewController *SELF = alertView;
        alertView.cancleActionHandleBlock = ^{

            [SELF removeFromParentViewController];
            [SELF.view removeFromSuperview];
        };
        alertView.doActionHandleBlock = ^{

            NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        };
    }
}

#pragma mark - 加载最新数据

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

    [[[AppAPIHelper shareInstance] messageAPI]getDetailMsgListWithType:self.type pageNo:1 pageSize:@10 success:^(id data,PageModel *pageModel) {
        
        [_dataMArray removeAllObjects];
        [_dataMArray addObjectsFromArray:data];
        [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"空消息"] emptyTitle:@"暂无新消息～" updateBtnHide:YES];
        
        [weakSelf.tableView reloadData];
        _pageNo = 1;
        _totalPage = [pageModel.totalPage integerValue];
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
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
    [[[AppAPIHelper shareInstance] messageAPI]getDetailMsgListWithType:self.type pageNo:_pageNo+1 pageSize:@10 success:^(id data,PageModel *pageModel) {
        
        [_dataMArray addObjectsFromArray:data];
        [_tableView reloadData];
        [_tableView.mj_footer endRefreshing];
        _pageNo ++;
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0)
        {
            weakSelf.tableView.mj_footer = nil;
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}


- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark - tableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectio
{
    return 1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.dataMArray.count > 0)
    {
        MessageDetailModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        if ([self.type isEqualToNumber:@(3)] || [self.type isEqualToNumber:@(7)])
        {
            CGFloat height = [self.messageSystemCell getCellHeightWithContentData:model];
            return height;
        }
        else
        {
            CGFloat height = [self.msgDetailCell getCellHeightWithContentData:model];
            return height;
        }
    }
    return 0.1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.type isEqualToNumber:@(3)] || [self.type isEqualToNumber:@(7)])
    {
        MessageSystemCell * systemCell = [tableView dequeueReusableCellWithIdentifier:reuse_SystemCell forIndexPath:indexPath];
        systemCell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.dataMArray.count>0)
        {
            MessageDetailModel *model = [self.dataMArray objectAtIndex:indexPath.section];
            [systemCell setData:model];
        }
        return systemCell;
    }
    WYMessageDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:reuse_Cell forIndexPath:indexPath];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count>0)
    {
        MessageDetailModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        [cell setData:model];
    }
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessageDetailModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
}

#pragma mark - UIViewControllerPreviewingDelegate

- (nullable UIViewController *)previewingContext:(id<UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location NS_AVAILABLE_IOS(9_0)
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
    if (indexPath)
    {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        CGRect rect = cell.frame;
        previewingContext.sourceRect = rect;
        MessageDetailModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        UIViewController *vc = [[WYUtility dataUtil] previewingNewControllerViewWithRouteUrl:model.url];
        if([vc isKindOfClass:[WYWKWebViewController class]])
        {
            WYWKWebViewController *wkVC = (WYWKWebViewController *)vc;
            wkVC.barTitle = model.title;
            return wkVC;
        }
        return vc;
    }
    return nil;
}

- (void)previewingContext:(id<UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit
{
    [self showViewController:viewControllerToCommit sender:self];
}


- (void)previewActionShare:(NSNotification *)notification
{
    NSDictionary *dic = notification.userInfo;
    // 默认图片地址
    NSString *picStr = @"http://public-read-bkt-oss.oss-cn-hangzhou.aliyuncs.com/app/icon/logo_zj.png";
    NSString *link = [dic objectForKey:@"url"];
    NSString *title = [dic objectForKey:@"title"];
    [WYShareManager shareInVC:self withImage:picStr withTitle:title withContent:@"用了义采宝，生意就是好!" withUrl:link];
}
@end
