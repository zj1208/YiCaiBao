//
//  CircularListViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CircularListViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "CircularListTableViewCell.h"

#import "SurveyModel.h"
#import "CircularDetailViewController.h"

@interface CircularListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;

@end

@implementation CircularListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) createUI{
    self.title = @"失信通报";
    self.view.backgroundColor = [UIColor whiteColor];
    //查询列表
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [_tableView registerClass:[CircularListTableViewCell class] forCellReuseIdentifier:kCellIdentifier_CircularListTableViewCell];
    [self.view addSubview:self.tableView];
}

-(void)setData{
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 加载最新数据

- (void)headerRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [[[AppAPIHelper shareInstance] SurveyMainAPI] getCircularListWithSuccess:^(id data) {
            [self.dataMArray removeAllObjects];
            [self.dataMArray addObjectsFromArray:data];
            [self.tableView reloadData];
//            _pageNo = 1;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self footerWithRefreshing];
//              只有十条数据后期会更改
            [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            if ([data count] < 10)
//            {
//                [self.tableView.mj_footer endRefreshingWithNoMoreData];
//            }
        } failure:^(NSError *error) {
            [self.tableView.mj_header endRefreshing];
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }];
    
}

- (void)footerWithRefreshing
{
    if (self.dataMArray.count==0)
    {
        if (self.tableView.mj_footer)
        {
            self.tableView.mj_footer = nil;
        }
        return;
    }
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [[[AppAPIHelper shareInstance] SurveyMainAPI] getCircularListWithSuccess:^(id data) {
            [self.dataMArray addObjectsFromArray:data];
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
            _pageNo ++;
            if ([data count]<10)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }

        } failure:^(NSError *error) {
            [self.tableView.mj_footer endRefreshing];
            [self zhHUD_showErrorWithStatus:[error localizedDescription]];
        }];
    }];
}

#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.dataMArray.count) {
        return self.dataMArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据
    return 44;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CircularListTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CircularListTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count>0)
    {
        DetectSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    CircularListModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    CircularDetailViewController * vc =[[CircularDetailViewController alloc] init];
    vc.jzID = model.detectionID.description;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
