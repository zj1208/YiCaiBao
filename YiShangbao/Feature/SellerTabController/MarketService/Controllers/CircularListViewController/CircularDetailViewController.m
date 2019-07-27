//
//  CircularDetailViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CircularDetailViewController.h"

#import "WYTitleTagVIew.h"
#import "CircularDetailCaseTableViewCell.h"
#import "CircularDetailPersonTableViewCell.h"
#import "SurveyModel.h"

@interface CircularDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

//table
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CircularDetailModel *model;
@property (nonatomic, strong) UIButton *btn_all;
@property (nonatomic, assign) float cellHeight;
@property (nonatomic, assign) float cellEditHeight1;
@property (nonatomic, assign) float cellEditHeight2;
@end

@implementation CircularDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"通报详情";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.btn_all = [[UIButton alloc] init];
    self.btn_all.selected = NO;
    self.cellHeight = 44;
    [self createUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void) createUI{
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tableView registerClass:[CircularDetailCaseTableViewCell class] forCellReuseIdentifier:kCellIdentifier_CircularDetailCaseTableViewCell];
    [self.tableView registerClass:[CircularDetailPersonTableViewCell class] forCellReuseIdentifier:kCellIdentifier_CircularDetailPersonTableViewCell];
    
//    self.dataMArray = [NSMutableArray array];
//    self.notiArray = [NSMutableArray array];
}

-(void)initData{
    [[[AppAPIHelper shareInstance] SurveyMainAPI] getCircularDetailWithid:self.jzID success:^(id data) {
        self.model = (CircularDetailModel *)data;
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}
#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return 6;
            break;
        case 1:
            return 1;
        default:
            break;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        if (0 == indexPath.row) {
            return _cellEditHeight1;
        }else if (1==indexPath.row){
            return _cellEditHeight2;
        }else if (5 == indexPath.row){
            return _cellHeight;
        }else{
            return 44;
        }
    }else{
        return 188;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (0 == section) {
        WYTitleTagVIew *tagView = [[WYTitleTagVIew alloc] init];
        tagView.label_title.text = @"事件情况";
        return tagView;
    }else if (1 == section){
        WYTitleTagVIew *tagView = [[WYTitleTagVIew alloc] init];
        tagView.label_title.text = @"人员信息";
        return tagView;
    }
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 44;
    }else{
        return 0;
    }
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section{
    [view addSubview:self.btn_all];
    [self.btn_all mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(view.mas_width);
        make.height.equalTo(view.mas_height);
    }];
    self.btn_all.backgroundColor = WYUISTYLE.colorBWhite;
    [self.btn_all setTitle:@"展开全文" forState:UIControlStateNormal];
    [self.btn_all setTitle:@"收起" forState:UIControlStateSelected];
    [self.btn_all setTitleColor:WYUISTYLE.colorSblue forState:UIControlStateNormal];
    self.btn_all.titleLabel.font = WYUISTYLE.fontWith30;
    [self.btn_all addTarget:self action:@selector(allTip) forControlEvents:UIControlEventTouchUpInside];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        CircularDetailCaseTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CircularDetailCaseTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (0 == indexPath.row) {
            cell.title.text = @"公司/个人";
            cell.content.text= self.model.companyname;
             _cellEditHeight1 = [cell getEditAutoCellHeight];
        }else if (1 == indexPath.row){
            cell.title.text = @"联系地址";
            if (self.model.companyaddress.length) {
                cell.content.text= self.model.companyaddress;
            }else{
                cell.content.text= @"未知";
            }
           _cellEditHeight2 = [cell getEditAutoCellHeight];
        }else if (2 == indexPath.row){
            cell.title.text = @"失信程度";
            cell.content.text= @"严重失信";
        }else if (3 == indexPath.row){
            cell.title.text = @"涉及金额";
            if (self.model.amount.description.length) {
                cell.content.text= [NSString stringWithFormat:@"%@万",self.model.amount.description];
            }else{
                cell.content.text = @"未知";
            }
            
        }else if (4 == indexPath.row){
            cell.title.text = @"受害人数";
            if (self.model.victims.description.length) {
                cell.content.text= [NSString stringWithFormat:@"%@人",self.model.victims.description];
            }else{
                cell.content.text= @"未知";
            }
        }else if (5 == indexPath.row){
            cell.title.text = @"事件概况";
            if (self.model.noticecontent.length) {
                cell.content.text= self.model.noticecontent;
            }else{
                cell.content.text= @"未知";
            }
            cell.line.hidden = YES;
            if (_btn_all.selected) {
                cell.content.numberOfLines = 0;
            }else{
                cell.content.numberOfLines = 1;
            }
            self.cellHeight = [cell getAutoCellHeight:_btn_all.selected];
        }
        return cell;
    }
    else if(1== indexPath.section){
        CircularDetailPersonTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_CircularDetailPersonTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setData:self.model];
        return cell;
    }
    return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)allTip{
    self.btn_all.selected = !self.btn_all.selected;
    [_tableView reloadData];
}

@end
