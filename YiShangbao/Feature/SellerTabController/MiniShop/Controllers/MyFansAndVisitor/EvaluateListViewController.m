//
//  EvaluateListViewController.m
//  YiShangbao
//
//  Created by light on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "EvaluateListViewController.h"
#import "BuyerEvaluatedCell.h"

@interface EvaluateListViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic ,strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;

@end

@implementation EvaluateListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"评价详情";
    [self setUI];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- Request
-(void)requestData{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getTradeEvaluateListByBuyerId:self.buyerId pageNum:@1 pageSize:@10 success:^(id data, PageModel *pageModel) {
        weakSelf.array = [NSMutableArray array];
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.page = 1;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestMoreData)];
        }
//        if (weakSelf.array.count == 0){
//            [weakSelf showEmptyView:nil];
//        }else{
//            [weakSelf.emptyViewController hideEmptyViewInController:weakSelf];
//        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getTradeMainAPI] getTradeEvaluateListByBuyerId:self.buyerId pageNum:@(self.page + 1) pageSize:@10 success:^(id data, PageModel *pageModel) {
        
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.page ++;
        weakSelf.totalPage = [pageModel.totalPage integerValue];
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] &&[pageModel.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 1) {
//        return 40.0;
//    }
//    return 0.0;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10.0;
}

//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    return [[UIView alloc]initWithFrame:CGRectZero];
//}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    BuyerEvaluatedCell *cell = (BuyerEvaluatedCell *)[tableView dequeueReusableCellWithIdentifier:BuyerEvaluatedCellID];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.evaluateContentLab.numberOfLines = 0;
    [cell setData:self.array[indexPath.section]];
    return cell;
}

#pragma mark- UITableViewDelegate
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (indexPath.section == 0){
//        WYEvaluateTradeTableViewCell *cell = (WYEvaluateTradeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:WYEvaluateTradeTableViewCellID];
//        cell.heightChangeBlock = ^(CGFloat height) {
//            [tableView setNeedsUpdateConstraints];
//            [tableView needsUpdateConstraints];
////            return height;
//        };
//        return 170.0;
//    }
//    return 170.0;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- Private
- (void)setUI{
    _tableView = [[UITableView alloc]init];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    _tableView.rowHeight = UITableViewAutomaticDimension;
    _tableView.estimatedRowHeight = 100.0;
    
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    [_tableView registerNib:[UINib nibWithNibName:@"BuyerEvaluatedCell" bundle:nil] forCellReuseIdentifier:BuyerEvaluatedCellID];
    _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
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
