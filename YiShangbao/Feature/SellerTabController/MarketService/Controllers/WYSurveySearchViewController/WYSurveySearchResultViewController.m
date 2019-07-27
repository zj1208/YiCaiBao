//
//  WYSurveySearchResultViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/27.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYSurveySearchResultViewController.h"
#import <MJRefresh/MJRefresh.h>

#import "WYSurveyResultTableViewCell.h"
#import "Survey_EmptyView.h"

#import "SurveyModel.h"
#import "WYFormDetailViewController.h"
#import "CircularDetailViewController.h"

@interface WYSurveySearchResultViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)Survey_EmptyView *emptyView;
@property (nonatomic,strong)NSMutableArray *dataMArray;
@property (nonatomic) NSInteger pageNo;

@end

@implementation WYSurveySearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) createUI{
    self.title = @"查询结果";
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
    
    [_tableView registerClass:[WYSurveyResultTableViewCell class] forCellReuseIdentifier:kCellIdentifier_WYSurveyResultTableViewCell];
    _emptyView = [[Survey_EmptyView alloc] init];
    [self.view addSubview:self.emptyView];
    _emptyView.hidden = YES;
    
    [_emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
}

-(void)setData{
    self.dataMArray = [NSMutableArray array];
    [self headerRefresh];
    [_tableView.mj_header beginRefreshing];
}

#pragma mark - 加载最新数据

- (void)headerRefresh{
    self.tableView.mj_header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [[[AppAPIHelper shareInstance] SurveyMainAPI] getDetectionSearchListWithsearchKey:self.text hasReadReported:@(-1) comType:@"0" pageNo:@"1" pageSize:@"10" success:^(id data) {
            [self.dataMArray removeAllObjects];
            [self.dataMArray addObjectsFromArray:data];
            if (self.dataMArray.count) {
                self.emptyView.hidden = YES;
                [self.tableView reloadData];
            }else{
                self.emptyView.hidden = NO;
                if (self.text.length>6) {
                    NSString *longStr = [self.text substringToIndex:6];
                    self.emptyView.label_title.text =[NSString stringWithFormat:@"抱歉，查询“%@...”无结果",longStr];
                }else{
                    self.emptyView.label_title.text =[NSString stringWithFormat:@"抱歉，查询“%@”无结果",self.text];
                }
            }
            _pageNo = 1;
            [self.tableView.mj_header endRefreshing];
            [self.tableView.mj_footer endRefreshing];
            [self footerWithRefreshing];
            if ([data count]<10)
            {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            }
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
        [[[AppAPIHelper shareInstance] SurveyMainAPI] getDetectionSearchListWithsearchKey:self.text hasReadReported:@(-1) comType:@"0" pageNo:[NSString stringWithFormat:@"%ld",(_pageNo+1)] pageSize:@"10" success:^(id data) {
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
    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
        return 72;
    }else{
        return 64;
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSurveyResultTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_WYSurveyResultTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count>0)
    {
        DetectSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        [cell setData:model];
        
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetectSearchModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    if ([model.type isEqualToString:@"C"]) {
        CircularDetailViewController * vc =[[CircularDetailViewController alloc] init];
        vc.jzID = model.jzID.description;
        [self.navigationController pushViewController:vc animated:YES];
    }else{
        WYFormDetailViewController *vc = [[WYFormDetailViewController alloc] init];
        vc.jzID = model.jzID.description;
        [self.navigationController pushViewController:vc animated:YES];
    }

}
@end
