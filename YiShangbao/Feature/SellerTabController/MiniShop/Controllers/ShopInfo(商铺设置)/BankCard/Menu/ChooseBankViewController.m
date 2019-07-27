//
//  ChooseBankViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChooseBankViewController.h"
#import "ChooseBankTableViewCell.h"

@interface ChooseBankViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong)UITableView *tableView;
//存放tableView中显示数据的数组
@property (nonatomic, strong) NSMutableArray *dataMArray;
@end

@implementation ChooseBankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择银行";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    [self createUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createUI{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    _tableView.dataSource= self;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _tableView.backgroundColor = [UIColor clearColor];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tableView registerClass:[ChooseBankTableViewCell class] forCellReuseIdentifier:kCellIdentifier_ChooseBankTableViewCell];
    
    self.dataMArray = [NSMutableArray array];

}

-(void)initData{
    [[[AppAPIHelper shareInstance] shopAPI] getBankListWithSuccess:^(id data) {
        [self.dataMArray removeAllObjects];
        [self.dataMArray addObjectsFromArray:data];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];

    }];
}
#pragma mark table view delegate
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
    return 48;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ChooseBankTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_ChooseBankTableViewCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataMArray.count > 0) {
        BankModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        [cell setData:model];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BankModel *model = [self.dataMArray objectAtIndex:indexPath.row];
    self.fatherVc.accInfoModel.bankValue = model.bankValue;
    self.fatherVc.accInfoModel.bankId = model.bankId;
    self.fatherVc.accInfoModel.bankCode = model.bankCode;
    self.fatherVc.bankModel = model;
    [self.navigationController popViewControllerAnimated:YES];
}

@end
