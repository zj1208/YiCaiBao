//
//  WYSelectBankCardViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//------选择银行卡

#import "WYSelectBankCardViewController.h"
#import "WYSelectBankCardTableViewCell.h"

#import "SetBankAccountViewController.h"


@interface WYSelectBankCardViewController ()<UITableViewDataSource,UITableViewDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property(nonatomic,strong)NSArray* arrayData;
@property(nonatomic,strong)NSIndexPath* currySelectIndexPath;
@end
static NSString* const WYSelectBankCardTableViewCell_Resign = @"WYSelectBankCardTableViewCell_Resign";
@implementation WYSelectBankCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorBGgrey];
    self.arrayData = [NSArray array];
    self.title = @"选择银行卡";

    [self buildUI];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestData];
}
-(void)buildUI
{
    UIButton* Addbtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 40)];
    [Addbtn addTarget:self action:@selector(clcikAddCard:) forControlEvents:UIControlEventTouchUpInside];
    [Addbtn setTitle:@"添加" forState:UIControlStateNormal];
    Addbtn.titleLabel.font = [UIFont systemFontOfSize:16];
    [Addbtn setTitleColor:[WYUISTYLE colorWithHexString:@"ff5434"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:Addbtn];

    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"WYSelectBankCardTableViewCell" bundle:nil] forCellReuseIdentifier:WYSelectBankCardTableViewCell_Resign];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}
#pragma mark - 氛围图
-(void)zxEmptyViewUpdateAction
{
    [self requestData];
}

//商铺资料里银行卡列表信息接口
-(void)requestData
{
    [[[AppAPIHelper shareInstance] shopAPI] getAcctInfoWithType:@(1) Success:^(id data) {
        self.arrayData  = [NSArray arrayWithArray:data];
        [self.tableView reloadData];
        
        NSMutableString* strBlack = [NSMutableString stringWithFormat:@"您还没有添加可提现银行卡"];
        [_emptyViewController addEmptyViewInController:self hasLocalData:_arrayData.count error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:strBlack updateBtnHide:YES];

    } failure:^(NSError *error) {
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
-(void)clcikAddCard:(UIButton*)sender
{
    SetBankAccountViewController *vc = [[SetBankAccountViewController alloc] init];
    vc.type = @1;
    vc.channel = @1;
    [self.navigationController pushViewController:vc animated:YES];

}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 78;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WYSelectBankCardTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:WYSelectBankCardTableViewCell_Resign];
    AcctInfoModel* model = self.arrayData[indexPath.section];
    
    [cell setCellData:model];
    
    
    if (self.AcctInfoModelDefaultSelected) {
        if ([_AcctInfoModelDefaultSelected isEqual:model]) {
            cell.selectIMV.image = [UIImage imageNamed:@"ic_xuanzhongyinhangka"];
        }else{
            cell.selectIMV.image = [UIImage imageNamed:@"ic_weixuanzhongyinhangka"];
        }
    }else{
        if ([_currySelectIndexPath isEqual:indexPath]) {
            cell.selectIMV.image = [UIImage imageNamed:@"ic_xuanzhongyinhangka"];
        }else{
            cell.selectIMV.image = [UIImage imageNamed:@"ic_weixuanzhongyinhangka"];
        }
    }
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.AcctInfoModelDefaultSelected = nil;//
    self.currySelectIndexPath = indexPath;
    [self.tableView reloadData];

    AcctInfoModel* model = self.arrayData[indexPath.section];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_WYImmediateWithdrawalViewController object:model];
    
    [self.navigationController performSelector:@selector(popViewControllerAnimated:) withObject:nil afterDelay:0.15];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
