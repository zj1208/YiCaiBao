//
//  AddProFreightListViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "AddProFreightListViewController.h"
#import "CCRightButton.h"
#import "FreightListTableViewCell.h"


@interface AddProFreightListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CCRightButton *confirmButton;

@property (nonatomic, strong) FreightListModel *model;
@property (nonatomic, strong) NSString *freightName;

@end

@implementation AddProFreightListViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"选择模版", @"选择模版");
    
    [self setUI];
    [self requestFreightList];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ------ButtonAction------
- (void)confirmButtonAction{
    if (self.freightId.integerValue <= 0) {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请选择运费模版", @"请选择运费模版") toView:self.view];
        return;
    }
    if (self.block) {
        self.block(self.freightId, self.freightName);
//        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)detailButtonAction:(UIButton *)sender{
    CGPoint point = sender.center;
    point = [self.tableView convertPoint:point fromView:sender.superview];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    NSLog(@"--%@",indexPath);
    if (indexPath.row < self.model.freightList.count) {
        FreightTemplateModel *model = self.model.freightList[indexPath.row];
        [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
    }
}

#pragma mark ------Request------
- (void)requestFreightList{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [ProductMdoleAPI getShopFreightListWithAppendMore:NO success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.model = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.freightList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreightListTableViewCell *cell = (FreightListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FreightListTableViewCellID forIndexPath:indexPath];
    [cell.detailButton addTarget:self action:@selector(detailButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [cell updateModel:self.model.freightList[indexPath.row]];
    FreightTemplateModel *model = self.model.freightList[indexPath.row];
    if (self.freightId && self.freightId.integerValue == model.fid.integerValue){
        [cell selectedCell];
    }
    
    return cell;
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (self.model.desc.length > 0) {
        return 50.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (self.model.desc.length > 0) {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 50)];
        view.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, SCREEN_WIDTH - 30, 40)];
        label.font = [UIFont systemFontOfSize:13.0];
        label.textColor = [UIColor colorWithHex:0x757575];
        label.numberOfLines = 0;
        label.text = self.model.desc;
        [view addSubview:label];
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    FreightTemplateModel *model = self.model.freightList[indexPath.row];
    self.freightId = @(model.fid.integerValue);
    self.freightName = model.fname;
    [self.tableView reloadData];
}

#pragma mark ------Private------

- (void)setUI{
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    
    self.confirmButton = [[CCRightButton alloc] initWithFrame:CGRectMake(0, 0, 52, 22)];
    self.confirmButton.rightButtonType = CCRightButtonTypeSeller;
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.confirmButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    [self.confirmButton setTitle:NSLocalizedString(@"确定", @"确定") forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
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
