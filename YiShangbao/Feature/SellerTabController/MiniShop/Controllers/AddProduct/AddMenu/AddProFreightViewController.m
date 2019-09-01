//
//  AddProFreightViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "AddProFreightViewController.h"
#import "CCRightButton.h"
#import "TMDiskManager.h"

#import "FreightTableViewCell.h"

#import "AddProFreightListViewController.h"

@interface AddProFreightViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) CCRightButton *confirmButton;

@property (nonatomic, strong) TMDiskManager *diskManager;
@property (nonatomic, strong) AddProductModel *model;
@property (nonatomic, strong) NSNumber *freightId;
@property (nonatomic, strong) NSString *freightName;

@end

@implementation AddProFreightViewController

#pragma mark ------LifeCircle------

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"运费设置", @"运费设置");
    
    //获取本地数据表管理器
    self.diskManager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.model = (AddProductModel *)[self.diskManager getData];
    self.freightId = self.model.freightId;
    self.freightName = self.model.freightName;
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
    if (!self.freightId) {
        [MBProgressHUD zx_showError:NSLocalizedString(@"请选择运费类型", @"请选择运费类型") toView:self.view];
        return;
    }
    
    [self.diskManager setPropertyImplementationValue:self.freightId forKey:@"freightId"];
    [self.diskManager setPropertyImplementationValue:self.freightName forKey:@"freightName"];
    
    //返回当前页面上一个页面
    NSArray *VCArray = self.navigationController.viewControllers;
    UIViewController *vc;
    BOOL isSelfClass = NO;
    for (int i = 0; i < VCArray.count; i++) {
        vc = VCArray[VCArray.count - i - 1];
        if (isSelfClass) {
            break;
        }
        if ([vc isKindOfClass:[self class]]) {
            isSelfClass = YES;
        }
    }
    if (isSelfClass && vc) {
        [self.navigationController popToViewController:vc animated:YES];
    }
}

#pragma mark ------Request------
- (void)requestFreightList{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [ProductMdoleAPI getShopFreightListWithAppendMore:NO success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        FreightListModel *model = data;
        weakSelf.hasFreightTemp = !model.freightList.count;
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark ------UITableviewDatasource------
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FreightTableViewCell *cell = (FreightTableViewCell *)[tableView dequeueReusableCellWithIdentifier:FreightTableViewCellID forIndexPath:indexPath];
    if (indexPath.section == 0){
        [cell setTitleString:NSLocalizedString(@"买家到付", @"买家到付")];
        
        if (self.freightId.integerValue == -1) {
            [cell selectedCell];
        }
    }else if (indexPath.section == 1){
        [cell setTitleString:NSLocalizedString(@"免运费", @"免运费")];
        if (self.freightId && self.freightId.integerValue == 0) {
            [cell selectedCell];
        }
    }else if (indexPath.section == 2){
        [cell setTitleString:NSLocalizedString(@"使用运费模版", @"使用运费模版") contentString:NSLocalizedString(@"请选择模版", @"请选择模版")];
        if (self.freightId.integerValue > 0) {
            [cell setTitleString:NSLocalizedString(@"使用运费模版", @"使用运费模版") contentString:self.freightName];
            [cell selectedCell];
        }
    }
    return cell;
}

#pragma mark ------UITableViewDelegate------
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 10.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  45.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        self.freightId = @(-1);
        [tableView reloadData];
    }else if (indexPath.section == 1) {
        self.freightId = @(0);
        [tableView reloadData];
    }else if (indexPath.section == 2 && self.hasFreightTemp) {
        [self showAlertView];
    }else if (indexPath.section == 2 && !self.hasFreightTemp){
        [self goFreightListVC];
    }
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

//未设置模版弹窗
- (void)showAlertView{
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:NSLocalizedString(@"您还没有设置运费模版，您可以用电脑打开：www.iyicaibao.com进行设置",@"您还没有设置运费模版，您可以用电脑打开：www.iyicaibao.com进行设置") message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* alertAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"我知道了", @"我知道了") style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
        
    }];
    [alertView addAction:alertAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

//跳转到运费模版列表页
- (void)goFreightListVC{
    WS(weakSelf)
    AddProFreightListViewController *freightListVC = (AddProFreightListViewController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_AddProFreightListViewController];
    freightListVC.freightId = self.freightId;
    freightListVC.block = ^(NSNumber *freightId, NSString *freightName) {
        weakSelf.freightId = freightId;
        weakSelf.freightName = freightName;
//        [weakSelf.tableView reloadData];
        [weakSelf confirmButtonAction];
//        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    freightListVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:freightListVC animated:YES];
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
