//
//  BankAccountViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BankAccountViewController.h"

#import "BankAccountListTableViewCell.h"
#import "BankAccountAddTableViewCell.h"

#import "SetBankAccountViewController.h"
#import "ShopModel.h"
@interface BankAccountViewController ()<UITableViewDelegate, UITableViewDataSource>

//table
@property (nonatomic, strong) UITableView *tableView;

//存放tableView中显示数据的数组
@property (nonatomic, strong) NSMutableArray *dataMArray;

@end

@implementation BankAccountViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的银行卡";
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    [self createUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(void)createUI{
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
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
//     [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.tableView registerClass:[BankAccountAddTableViewCell class] forCellReuseIdentifier:kCellIdentifier_BankAccountAddTableViewCell];
    [self.tableView registerClass:[BankAccountListTableViewCell class] forCellReuseIdentifier:kCellIdentifier_BankAccountListTableViewCell];
    
    self.dataMArray = [NSMutableArray array];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
}

-(void)initData{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    [[[AppAPIHelper shareInstance] shopAPI] getAcctInfoWithType:nil Success:^(id data) {
        [self.dataMArray removeAllObjects];
        [self.dataMArray addObjectsFromArray:data];
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
            return 1;
            break;
        case 1:
            return self.dataMArray.count;
        default:
            break;
    }
    return 0;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        return 104;
    }else{
        return 122;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (0 == indexPath.section) {
        BankAccountAddTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BankAccountAddTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell.btn_all addTarget:self action:@selector(addTap) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else if(1== indexPath.section){
        BankAccountListTableViewCell * cell = [_tableView dequeueReusableCellWithIdentifier:kCellIdentifier_BankAccountListTableViewCell];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.dataMArray.count > 0) {
            AcctInfoModel *model = [self.dataMArray objectAtIndex:indexPath.row];
            [cell setData:model];
        }
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (1 == indexPath.section) {
        SetBankAccountViewController *vc = [[SetBankAccountViewController alloc] init];
        vc.type = @2;
        AcctInfoModel *model = [self.dataMArray objectAtIndex:indexPath.row];
        vc.accInfoModel = model;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

#pragma mark - buttonaciton
- (void)addTap{
    SetBankAccountViewController *vc = [[SetBankAccountViewController alloc] init];
    vc.type = @1;
    [self.navigationController pushViewController:vc animated:YES];
}
@end
