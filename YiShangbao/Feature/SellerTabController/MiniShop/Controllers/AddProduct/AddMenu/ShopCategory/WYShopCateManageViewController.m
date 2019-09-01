//
//  WYShopCateManageViewController.m
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCateManageViewController.h"
#import "WYShopCateGoodsTableViewCell.h"
#import "WYChooseShopCateViewController.h"

@interface WYShopCateManageViewController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *removeButton;
@property (weak, nonatomic) IBOutlet UIButton *moveToButton;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSArray *array;

@end

@implementation WYShopCateManageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    self.title = self.shopCatgName;
    [self requestData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateData) name:Noti_ShopCateProducts_update object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ShopCateProducts_update object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_ProductManager_Edit_goBackUpdate object:nil];
}

- (void)updateData{
    [self requestData];
}

#pragma mark- ButtonAction

- (IBAction)removeButtonAction:(id)sender {
    
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (WYShopCategoryGoodsModel *model in self.array) {
        if (model.isSelected) {
            [selectedArray addObject:@(model.goodsId)];
        }
    }
    if ([self.shopCatgId isEqualToString:@"0"]){
        [MBProgressHUD zx_showError:@"当前已是未分类产品，无法移除产品～" toView:self.view];
        return;
    }
    if (selectedArray.count == 0){
        [MBProgressHUD zx_showError:@"请先选中产品" toView:self.view];
        return;
    }
    NSString *prodIds = [selectedArray componentsJoinedByString:@","];
    
// 确认弹窗
    WS(weakSelf)
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"是否确认移除产品" message:@"移除后，产品依然存在" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        [weakSelf requestMove:prodIds];
    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

- (IBAction)moveToOtherButtonAction:(id)sender {
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (WYShopCategoryGoodsModel *model in self.array) {
        if (model.isSelected) {
            [selectedArray addObject:@(model.goodsId)];
        }
    }
    if (selectedArray.count == 0){
        [MBProgressHUD zx_showError:@"请先选中产品" toView:self.view];
        return;
    }
    NSString *prodIds = [selectedArray componentsJoinedByString:@","];
    WYChooseShopCateViewController *vc = (WYChooseShopCateViewController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYChooseShopCateViewController];
    [vc moveFromCate:self.shopCatgId withProds:prodIds];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- ZXEmptyViewControllerDelegate
- (void)zxEmptyViewUpdateAction{
    [self requestData];
}

#pragma mark- Request
- (void)requestData{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [ProductMdoleAPI getShopCategoryListByShopId:shopId shopCatgId:self.shopCatgId pageNo:-1 pageSize:10 success:^(id data, PageModel *pageModel) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.array = data;
        [weakSelf.tableView reloadData];
        if (self.array.count == 0){
            [weakSelf showEmptyView:nil];
        }else{
            [weakSelf.emptyViewController hideEmptyViewInController:weakSelf];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        //        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

- (void)requestMove:(NSString *)prodIds{
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryBatchDelById:self.shopCatgId prodIds:prodIds success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"分类移除成功" toView:weakSelf.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ShopCateProducts_update object:nil userInfo:nil];
//        [weakSelf requestData];
        [weakSelf localMove];
    } failure:^(NSError *error) {
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYShopCateGoodsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"WYShopCateGoodsTableViewCellID" forIndexPath:indexPath];
    [cell setData:self.array[indexPath.section]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 138.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYShopCateGoodsTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WYShopCategoryGoodsModel *model = self.array[indexPath.section];
    model.isSelected = !model.isSelected;
    [cell changeStatus:model];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    [self.removeButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    self.removeButton.layer.cornerRadius = 22.5;
    self.removeButton.layer.masksToBounds = YES;
    
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0 - 25 , 45);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    [self.moveToButton.layer insertSublayer:gradientLayer2 atIndex:0];
    self.moveToButton.layer.cornerRadius = 22.5;
    self.moveToButton.layer.masksToBounds = YES;
    
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        string = @"该分类下还没有产品，快添加些产品吧～";
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view).offset(-60);
        }];
    }else{
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view).offset(-60);
        }];
    }
    
}

- (void)localMove{
    NSMutableArray *selectedArray = [NSMutableArray array];
    for (WYShopCategoryGoodsModel *model in self.array) {
        if (!model.isSelected) {
            [selectedArray addObject:model];
        }
    }
    self.array = selectedArray;
    [self.tableView reloadData];
    if (self.array.count == 0){
        [self showEmptyView:nil];
    }else{
        [self.emptyViewController hideEmptyViewInController:self];
    }
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
