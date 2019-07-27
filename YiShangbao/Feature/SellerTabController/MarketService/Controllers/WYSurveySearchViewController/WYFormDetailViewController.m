//
//  WYFormDetailViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/23.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYFormDetailViewController.h"
#import <MJRefresh/MJRefresh.h> 
#import "ZXTitleView.h"
#import "WYFeedbackTableViewCell.h"
#import "WYFormInfoTableViewCell.h"
#import "WYComplainDetailTableViewCell.h"
#import "Survey_EmptyView.h"

#import "SurveyModel.h"

@interface WYFormDetailViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic, strong)UITableView *feedBackTable;
@property(nonatomic, strong)UITableView *enterpriseTable;
@property(nonatomic, strong)Survey_EmptyView *emptyView;
@property(nonatomic, strong)ReportedDetailModel *model;
@property(nonatomic, assign)float cellHeight;
@property(nonatomic, assign)float cellHeight2;
@property(nonatomic, assign)float cellHeight3;
@end

@implementation WYFormDetailViewController
{
    BOOL feedBack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WYUISTYLE.colorBWhite;
    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)creatUI{
    //导航栏 seg
    UISegmentedControl * segmentedControl =[[UISegmentedControl alloc] initWithFrame:CGRectMake(80.0f, 8.0f, 150.0f, 30.0f) ];
    segmentedControl.tintColor = WYUISTYLE.colorMred;
    [segmentedControl insertSegmentWithTitle:@"反馈结果" atIndex:0 animated:YES];
    [segmentedControl insertSegmentWithTitle:@"企业信息" atIndex:1 animated:YES];
    segmentedControl.momentary = NO;
    segmentedControl.multipleTouchEnabled=NO;
    [segmentedControl addTarget:self action:@selector(segmentChangedValue:) forControlEvents:UIControlEventValueChanged];
    segmentedControl.selectedSegmentIndex=0;
    [self.navigationItem setTitleView:segmentedControl];
    
    
    //table view
//    _feedBackTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _feedBackTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.feedBackTable];
    [_feedBackTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    
    _feedBackTable.delegate = self;
    _feedBackTable.dataSource = self;
    _feedBackTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _feedBackTable.backgroundColor = [UIColor clearColor];
    [_feedBackTable registerClass:[WYFeedbackTableViewCell class] forCellReuseIdentifier:kCellIdentifier_WYFeedbackTableViewCell];
    
    _feedBackTable.hidden = NO;
    
//    _enterpriseTable = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    _enterpriseTable = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.enterpriseTable];
    [_enterpriseTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(64);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    _enterpriseTable.delegate = self;
    _enterpriseTable.dataSource = self;
    _enterpriseTable.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _enterpriseTable.backgroundColor = [UIColor clearColor];
    [_enterpriseTable registerClass:[WYFormInfoTableViewCell class] forCellReuseIdentifier:kCellIdentifier_WYFormInfoTableViewCell];
    [_enterpriseTable registerClass:[WYComplainDetailTableViewCell class] forCellReuseIdentifier:kCellIdentifier_WYComplainDetailTableViewCell];
    
    _enterpriseTable.hidden = YES;
    
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

-(void)initData{
    self.model = [[ReportedDetailModel alloc] init];
    [[[AppAPIHelper shareInstance] SurveyMainAPI] getReportedDetailWithid:self.jzID success:^(id data) {
        self.model = (ReportedDetailModel *)data;
        if (self.model.feedbacks.count) {
            self.emptyView.hidden = YES;
            [self.feedBackTable reloadData];
        }else{
            feedBack = YES;
            self.emptyView.hidden = NO;
            self.emptyView.label_title.text = @"暂无信息";
        }
        if (self.model.complains.count) {
            if (feedBack) {
                [self.enterpriseTable reloadData];
            }else{
                self.emptyView.hidden = YES;
                [self.enterpriseTable reloadData];
            }
        }else{
            self.emptyView.hidden = NO;
        }
        
    } failure:^(NSError *error) {
        self.emptyView.hidden = NO;
        self.emptyView.label_title.text = @"网络加载失败";
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}

- (void)segmentChangedValue:(id)sender {
    switch([(UISegmentedControl *)sender selectedSegmentIndex])
    {
        case 0:
            self.feedBackTable.hidden = NO;
            self.enterpriseTable.hidden=YES;
            if (self.model.feedbacks.count) {
                self.emptyView.hidden = YES;
            }else{
                self.emptyView.hidden = NO;
                self.emptyView.label_title.text = @"暂无信息";
            }
            break;
            
        case 1:
            self.feedBackTable.hidden = YES;
            self.enterpriseTable.hidden=NO;
            if (self.model.complains.count) {
                self.emptyView.hidden = YES;
            }else{
                self.emptyView.hidden = NO;
                self.emptyView.label_title.text = @"暂无信息";
            }
            break;
            
            
        default:
            
            break;
    }
}


#pragma mark - tableview
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _feedBackTable) {
        return 1;
    }else if (tableView == _enterpriseTable){
        return 2;
    }else{
        return 0;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _feedBackTable) {
        return self.model.feedbacks.count;
    }else if (tableView == _enterpriseTable){
        if (section == 0) {
            return 4;
        }else{
            return self.model.complains.count;
        }
    }else{
    return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取数据
    if (tableView == _feedBackTable) {
        return _cellHeight;
    }else{
        if (indexPath.section == 0) {
            return _cellHeight3;
        }else{

            return  _cellHeight2;
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView * view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 36)];
    view.backgroundColor =WYUISTYLE.colorBGgrey;
    ZXTitleView * titleLab = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXTitleView owner:self options:nil] lastObject];
    titleLab.frame =CGRectMake(12, 11, 150, 14);
    [view addSubview:titleLab];
    if (tableView == _feedBackTable) {
            titleLab.titleLab.text =@"公安／工商反馈结果";
    }else if (tableView == _enterpriseTable){
        if (section == 0) {
            titleLab.titleLab.text =@"填报信息";
        }else{
            titleLab.titleLab.text =@"投诉详情";
        }
    }else{
        return 0;
    }
    return view;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _feedBackTable) {
        WYFeedbackTableViewCell * cell = [_feedBackTable dequeueReusableCellWithIdentifier:kCellIdentifier_WYFeedbackTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        FeedbacksModel *feedbacks = (FeedbacksModel *)self.model.feedbacks[indexPath.row];
        cell.content.text = feedbacks.content;
        self.cellHeight = [cell getAutoCellHeight];
        return cell;
    }else{
        if (indexPath.section == 0) {
            WYFormInfoTableViewCell * cell = [_enterpriseTable dequeueReusableCellWithIdentifier:kCellIdentifier_WYFormInfoTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (indexPath.row == 0) {
                cell.title.text = @"公司/个人";
                cell.content.text = self.model.companyname;
            }
            if (indexPath.row == 1) {
                cell.title.text = @"联系地址";
                if (self.model.comaddr.length) {
                    cell.content.text = self.model.comaddr;
                }else{
                    cell.content.text = @"未知";
                }
                
            }
            if (indexPath.row == 2) {
                cell.title.text = @"采购人";
                if (self.model.buyman.length) {
                    cell.content.text = self.model.buyman;
                }else{
                    cell.content.text = @"未知";
                }
            }
            if (indexPath.row == 3) {
                cell.title.text = @"联系方式";
                if (self.model.buymantel.length) {
                    cell.content.text = self.model.buymantel;
                }else{
                    cell.content.text = @"未知";
                }
            }
            self.cellHeight3 = [cell getAutoCellHeight];
            return cell;
        }else{
            WYComplainDetailTableViewCell * cell = [_enterpriseTable dequeueReusableCellWithIdentifier:kCellIdentifier_WYComplainDetailTableViewCell];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            ComplainsModel *complain = (ComplainsModel *)self.model.complains[indexPath.row];
            cell.content.text = complain.content;
             self.cellHeight2 = [cell getAutoCellHeight];
            cell.date.text = complain.signtime;
            return cell;
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}


@end
