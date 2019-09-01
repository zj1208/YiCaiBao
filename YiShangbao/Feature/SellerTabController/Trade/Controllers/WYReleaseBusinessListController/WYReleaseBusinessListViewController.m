//
//  WYReleaseBusinessListViewController.m
//  YiShangbao
//
//  Created by light on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYReleaseBusinessListViewController.h"
#import "WYReleaseBusinessTableViewCell.h"

@interface WYReleaseBusinessListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;

@end

@implementation WYReleaseBusinessListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"发布的生意";
    [self creatUI];
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Request
- (void)requestLoadData{
//    self.page = 1;
    [self requestData:0];
}

- (void)requestMoreData{
//    self.page++;
    [self requestData:self.page];
}

- (void)requestData:(NSInteger)page{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] tradeMainAPI] getkTradeReleaseBusinessListURLBuyerId:self.buyerId pageNum:page + 1 pageSize:10 Success:^(id data,PageModel *pageModel) {
        NSArray *array = data;
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
        if (page == 0) {
            weakSelf.array = [[NSMutableArray alloc]init];
        }
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
        }
        weakSelf.page = [pageModel.currentPage integerValue];
//        if (!array.count) {
//            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
//        }
        [weakSelf.array addObjectsFromArray:array];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.tableView.mj_footer endRefreshing];
//        weakSelf.page--;
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYReleaseBusinessTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYReleaseBusinessTableViewCellID];
    if (!cell) {
        cell = [[WYReleaseBusinessTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYReleaseBusinessTableViewCellID];
    }
    [cell updateData:self.array[indexPath.section]];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ReleaseBusniessModel *model = self.array[indexPath.section];
    
    if (model.valid) {
        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_TradeDetailController withData:@{@"postId":model.subjectId,@"nTitle":@"生意"}];
        [MobClick event:kUM_gotoBuild];
    }else{
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"这个生意已经被人抢啦，下次来早点哦～" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
    }
}

#pragma mark -Private
- (void)creatUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[WYReleaseBusinessTableViewCell class] forCellReuseIdentifier:WYReleaseBusinessTableViewCellID];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
}
-(void)dealloc{
    NSLog(@"jl_delloc WYReleaseBusinessListViewController");
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
