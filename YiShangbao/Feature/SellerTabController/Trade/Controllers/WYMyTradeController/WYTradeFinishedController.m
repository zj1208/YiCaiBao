//
//  WYTradeFinishedController.m
//  YiShangbao
//
//  Created by simon on 17/1/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTradeFinishedController.h"

#import "MyTradeFinishedTVCell.h"
#import "ZXEmptyViewController.h"

#import "WYTradeEvaluateViewController.h"

@interface WYTradeFinishedController ()<ZXEmptyViewControllerDelegate>

@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@end

@implementation WYTradeFinishedController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我接的生意";
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = YES;
        
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(commintedUpdateData:) name:Noti_Trade_evaluating object:nil];
    
    self.tableView.estimatedRowHeight = 135.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [self.tableView.mj_header beginRefreshing];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate =self;
    self.emptyViewController = emptyVC;
    
   
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    
   
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}


- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)commintedUpdateData:(id)notification
{
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - 请求失败／列表为空时候的代理请求

- (void)zxEmptyViewUpdateAction
{
    [self.tableView.mj_header beginRefreshing];
}


- (void)headerRefresh
{
    WS(weakSelf);
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        
        [[[AppAPIHelper shareInstance]getTradeMainAPI]getMyTradeBusinessListWithType:WYBuyType_finished pageNo:1 pageSize:@(10) success:^(id data ,PageModel *pageModel) {
            
            NSLog(@"data = %@",data);
            
            [weakSelf.dataMArray removeAllObjects];
            [weakSelf.dataMArray addObjectsFromArray:data];
            [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:@"您还没有接过生意，赶紧去接单吧～" updateBtnHide:YES];
            [weakSelf.tableView reloadData];
            _pageNo = 1;
            [weakSelf.tableView.mj_header endRefreshing];
            [weakSelf.tableView.mj_footer endRefreshing];
            [weakSelf footerWithRefreshing:[pageModel.totalPage integerValue]];

        } failure:^(NSError *error) {
            
            [weakSelf.tableView.mj_header endRefreshing];
            [_emptyViewController addEmptyViewInController:weakSelf hasLocalData:_dataMArray.count error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }];
        
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
        
        
        [[[AppAPIHelper shareInstance]getTradeMainAPI]getMyTradeBusinessListWithType:WYBuyType_finished pageNo:_pageNo+1 pageSize:@(10) success:^(id data,PageModel *pageModel) {
            
            NSLog(@"data = %@",data);
            
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
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.dataMArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10.f;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    
    MyTradeFinishedTVCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    if (self.dataMArray.count>0)
    {
        MYTradeUnderwayModel *model = [self.dataMArray objectAtIndex:indexPath.section];
        [cell setData:model];
        if (model.evluateBtnModel.buttonType ==0)
        {
            [cell.evaluateBtn addTarget:self action:@selector(commentAction:) forControlEvents:UIControlEventTouchUpInside];
        }
        [cell.evaluatedBtn addTarget:self action:@selector(evaluateAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;

    
    // Configure the cell...
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MYTradeUnderwayModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":model.postId,@"nTitle":@"生意"}];
}


#pragma mark - Navigation
- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return  [self.tableView isRefreshing];
}


- (void)commentAction:(UIButton *)sender
{
    
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    MYTradeUnderwayModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    
    WYTradeEvaluateViewController *vc = (WYTradeEvaluateViewController *)[self zx_getControllerWithStoryboardName:storyboard_Trade controllerWithIdentifier:SBID_WYTradeEvaluateViewController];
    vc.postId = model.postId;
    [self.navigationController pushViewController:vc animated:YES];
    
}

- (void)evaluateAction:(UIButton *)sender{
    NSIndexPath *indexPath = [sender zh_getIndexPathWithBtnInCellFromTableViewOrCollectionView:self.tableView];
    MYTradeUnderwayModel *model = [self.dataMArray objectAtIndex:indexPath.section];
    NSString *url = [NSString stringWithFormat:@"%@",model.evluateBtnModel.url];
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

@end
