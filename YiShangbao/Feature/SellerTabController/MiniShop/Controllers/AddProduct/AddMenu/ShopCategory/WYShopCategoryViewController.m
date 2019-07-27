//
//  WYShopCategoryViewController.m
//  YiShangbao
//
//  Created by light on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCategoryViewController.h"
#import "WYShopCategoryTableViewCell.h"
#import "WYEditCategoryView.h"
#import "WYShopCateDetailViewController.h"

#import "MessageModel.h"

@interface WYShopCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,WYShopCategoryDelegate,WYEditCategoryViewDelegate,UIGestureRecognizerDelegate,ZXEmptyViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryButton;

@property (nonatomic ,strong) WYEditCategoryView *editView;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic) NSInteger editIndex;

@property (nonatomic ,strong) NSArray *array;

@end

@implementation WYShopCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"本店分类设置";
    
    [self setUI];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- 点击滑动
//点击手势判断
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return NO;
        
    }
    return YES;
}

- (void)handleTapGesture:( UITapGestureRecognizer *)tapRecognizer{
    self.editView.hidden = YES;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.editView.hidden = YES;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    self.editView.hidden = YES;
}

#pragma mark- ButtonAction
//添加分类
- (IBAction)addCategoryButtonAction:(id)sender {
    [MobClick event:kUM_b_pd_newclass];
    
    self.editView.hidden = YES;
    WS(weakSelf)
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"新建分类" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"填写您想要的分类名称";
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        UITextField *textField = alertView.textFields[0];
        NSString *name = textField.text;
        [weakSelf requestAddNewName:name];
    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
    
}

- (void)renameAction{
    WS(weakSelf)
    WYShopCategoryInfoModel *model = self.array[self.editIndex];
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"编辑分类名称" message:nil preferredStyle:UIAlertControllerStyleAlert];
    [alertView addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.clearButtonMode = UITextFieldViewModeWhileEditing;
        textField.placeholder = @"填写您想要的分类名称";
        textField.text = model.name;
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        UITextField *textField = alertView.textFields[0];
        NSString *name = textField.text;
        [weakSelf requestRename:name];
    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark- WYShopCategoryDelegate
- (void)selectedType:(ShopCategoryOperationType)type index:(NSInteger)index{
    self.editView.hidden = YES;
    if (type == ShopCategoryOperationTypeEdit) {
        [MobClick event:kUM_b_pd_editclass];
        CGRect rectInTableView = [self.tableView rectForSection:index];
        CGRect rect = [self.tableView convertRect:rectInTableView toView:self.view];
        self.editView.hidden = NO;
        CGRect frame = self.editView.frame;
        [self.editView setFrame:CGRectMake(frame.origin.x, rect.origin.y + 100, frame.size.width, frame.size.height)];
        if (self.editIndex == index) {
            self.editView.hidden = !self.editView.hidden;
            self.editIndex = 0;
        }else{
            self.editIndex = index;
        }
    }else if (type == ShopCategoryOperationTypeExtend) {
        [MobClick event:kUM_b_pd_extendclass];
        [self requestShareByIndex:index];
    }else if (type == ShopCategoryOperationTypeShiftUp) {
        [MobClick event:kUM_b_pd_sortup];
        [self requestUpDown:0 index:index];
    }else if (type == ShopCategoryOperationTypeShiftDown) {
        [MobClick event:kUM_b_pd_sortdown];
        [self requestUpDown:1 index:index];
    }
}

#pragma mark- WYEditCategoryViewDelegate
- (void)renameCategory{
    [self renameAction];
}

- (void)deleteCategory{
    // 确认弹窗
    WS(weakSelf)
    UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"是否确认删除分类" message:@"删除后，分类下的产品依然保留" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* _Nonnull action){
        
    }];
    UIAlertAction* confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction* _Nonnull action){
        [weakSelf requestDelete];
    }];
    [alertView addAction:cancelAction];
    [alertView addAction:confirmAction];
    [self presentViewController:alertView animated:YES completion:nil];
}

#pragma mark- Request
- (void)requestData{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    [ProductMdoleAPI getShopCategoryDataWithShopId:shopId appendNoGroup:YES success:^(id data) {
        [weakSelf.tableView.mj_header endRefreshing];
        
        weakSelf.array = data;
        [weakSelf.tableView reloadData];
        if (self.array.count <= 1){
            [weakSelf showEmptyView:nil];
        }else{
            [weakSelf.emptyViewController hideEmptyViewInController:weakSelf];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

- (void)requestAddNewName:(NSString *)name{
    if (name.length == 0) {
        [MBProgressHUD zx_showError:@"请填写分类名称噢～" toView:self.view];
        return;
    }else if (name.length > 20){
        [MBProgressHUD zx_showError:@"分类名称最多只能20个字噢～" toView:self.view];
        return;
    }
    
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryCreatNewByName:name success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"添加成功" toView:weakSelf.view];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestRename:(NSString *)name{
    if (name.length == 0) {
        [MBProgressHUD zx_showError:@"请填写分类名称噢～" toView:self.view];
        return;
    }else if (name.length > 20){
        [MBProgressHUD zx_showError:@"分类名称最多只能20个字噢～" toView:self.view];
        return;
    }
    WYShopCategoryInfoModel *model = self.array[self.editIndex];
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryRenameById:model.categoryId rename:name success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"修改成功" toView:weakSelf.view];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestDelete{
    WYShopCategoryInfoModel *model = self.array[self.editIndex];
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryDelById:model.categoryId success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"分类删除成功" toView:weakSelf.view];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestUpDown:(NSInteger)up index:(NSInteger)index{
    WYShopCategoryInfoModel *model = self.array[index];
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryRemoveById:model.categoryId upDown:up success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"移动成功" toView:weakSelf.view];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestShareByIndex:(NSInteger)index{
    WS(weakSelf);
    WYShopCategoryInfoModel *model = self.array[index];
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    NSString *shopId = [UserInfoUDManager getShopId];
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@(28) shopId:shopId shopCateName:model.name shopCateId:model.categoryId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:nil];
        shareModel *model = data;
        NSString *titleStr = model.title;
        NSString *link = model.link;
        NSString *picStr = model.pic;
        //1、创建分享参数 model.pic
        [WYShareManager shareInVC:weakSelf withImage:picStr withTitle:titleStr withContent:model.content withUrl:link];
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

#pragma mark- ZXEmptyViewControllerDelegate
- (void)zxEmptyViewUpdateAction{
    [self requestData];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.array.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYShopCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYShopCategoryTableViewCellID];
    cell.delegate = self;
    [cell updateData:self.array[indexPath.section] index:indexPath.section];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 60.0;
    }else{
        return 105.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.editView.hidden = YES;
    WYShopCategoryInfoModel *model = self.array[indexPath.section];
    WYShopCateDetailViewController *vc = (WYShopCateDetailViewController *)[self xm_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYShopCateDetailViewController];
    vc.shopCatgId = model.categoryId;
    vc.shopCatgName = model.name;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    if (indexPath.section == 0){
        [MobClick event:kUM_b_pd_unclass];
    }
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    
    UITapGestureRecognizer *sigleTapRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    sigleTapRecognizer.delegate = self;
    sigleTapRecognizer.numberOfTapsRequired = 1;
    [self.tableView addGestureRecognizer:sigleTapRecognizer];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30 , 45);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [self.addCategoryButton.layer insertSublayer:gradientLayer atIndex:0];
    self.addCategoryButton.layer.cornerRadius = 22.5;
    self.addCategoryButton.layer.masksToBounds = YES;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        string = @"您还没有创建商铺内分类哦～\n点击下方新建一个分类吧～";
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(70);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                make.height.equalTo(self.view).offset(-130);
            }
        }];
    }else{
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            if (@available(iOS 11.0, *)) {
                make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-60);
            } else {
                make.height.equalTo(self.view).offset(-60);
            }
        }];
    }
    
}
#pragma mark- GetterAndSetter
- (WYEditCategoryView *)editView{
    if (!_editView) {
        _editView = [[WYEditCategoryView alloc]initWithFrame:CGRectMake(10, 100, 120, 100)];
        [self.view addSubview:_editView];
        _editView.delegate = self;
    }
    return _editView;
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
