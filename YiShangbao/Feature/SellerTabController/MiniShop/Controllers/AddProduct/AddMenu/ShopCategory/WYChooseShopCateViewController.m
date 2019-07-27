//
//  WYChooseShopCateViewController.m
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYChooseShopCateViewController.h"
#import "WYChooseShopCateTableViewCell.h"

@interface WYChooseShopCateViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *addCategoryButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) NSArray *array;


@property (nonatomic) NSInteger isMove;
@property (nonatomic, strong) NSArray *selectedArray;
@property (nonatomic, copy) SelectedCate block;

@property (nonatomic, copy) NSString *prodIds;
@property (nonatomic, copy) NSString *fromCate;

@end

@implementation WYChooseShopCateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择本店分类";
    
    [self setUI];
    [self requestData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)selectedArray:(NSArray *)selectedArray return:(SelectedCate)block{
    self.selectedArray = selectedArray;
    self.block = block;
}

- (void)moveFromCate:(NSString *)fromCate withProds:(NSString *)prodIds{
    self.isMove = YES;
    self.fromCate = fromCate;
    self.prodIds = prodIds;
}

#pragma mark- buttonAction

- (IBAction)addCategoryButtonAction:(id)sender {
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

- (IBAction)confirmButtonActioon:(id)sender {

    NSMutableArray *selectedArray = [NSMutableArray array];
    if (self.isMove) {
        for (WYShopCategoryInfoModel *model in self.array) {
            if (model.isSelected) {
                [selectedArray addObject:model.categoryId];
            }
        }
        NSString *toCategory = [selectedArray componentsJoinedByString:@","];
        [self requestSaveTo:toCategory];
    }else{
        if (self.block) {
            for (WYShopCategoryInfoModel *model in self.array) {
                if (model.isSelected) {
                    CodeModel *codeModel = [[CodeModel alloc]init];
                    codeModel.value = model.name;
                    codeModel.code = @(model.categoryId.integerValue);
                    [selectedArray addObject:codeModel];
                }
            }
            self.block(selectedArray);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark- Request

- (void)requestData{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [ProductMdoleAPI getShopCategoryDataWithShopId:shopId appendNoGroup:NO success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.array = data;
        [weakSelf updateIsSelected];
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
//        [MBProgressHUD zx_showSuccess:@"添加成功" toView:weakSelf.view];
        [weakSelf saveSelectedCate];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestSaveTo:(NSString *)toCategory{
    WS(weakSelf)
    [ProductMdoleAPI postShopCategoryBatchMoveFromCategory:self.fromCate toCategory:toCategory prodIds:self.prodIds success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"移动成功" toView:weakSelf.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_ShopCateProducts_update object:nil userInfo:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
//        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYChooseShopCateTableViewCell *cell = (WYChooseShopCateTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"WYChooseShopCateTableViewCellID" forIndexPath:indexPath];
    [cell updateData:self.array[indexPath.row]];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    WYChooseShopCateTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    WYShopCategoryInfoModel *model = self.array[indexPath.row];
    model.isSelected = !model.isSelected;
    [cell changeStatus:model];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 40)];
//    [button setImage:[UIImage imageNamed:@"btn_baocun"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(save) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
//    
//    self.navigationItem.rightBarButtonItem = rightBtn;
    
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1, 0);
//    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0 - 25 , 45);
//    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFDAB53].CGColor,(id)[UIColor colorWithHex:0xFD7953].CGColor, nil];
//    [self.addCategoryButton.layer insertSublayer:gradientLayer atIndex:0];
    [self.addCategoryButton setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    self.addCategoryButton.layer.cornerRadius = 22.5;
    self.addCategoryButton.layer.masksToBounds = YES;
    
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, SCREEN_WIDTH/2.0 - 25 , 45);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    [self.confirmButton.layer insertSublayer:gradientLayer2 atIndex:0];
    self.confirmButton.layer.cornerRadius = 22.5;
    self.confirmButton.layer.masksToBounds = YES;
    
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
}

- (void)updateIsSelected{
    if (!self.isMove || self.selectedArray.count > 0) {
        [self updateAllArray];
    }else{
        [self isContain:self.array haveModeCode:self.fromCate.integerValue];
    }
    
    [self.tableView reloadData];
}

- (void)updateAllArray{
    for (CodeModel *model in self.selectedArray) {
        [self isContain:self.array haveModeCode:model.code.integerValue];
    }
}

- (void)isContain:(NSArray *)array haveModeCode:(NSInteger)code{
    for (WYShopCategoryInfoModel *model in array) {
        if (model.categoryId.integerValue == code) {
            model.isSelected = YES;
        }
    }
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        string = @"请先新建分类哦~";
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:YES];
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
    }else{
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:YES];
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

- (void)saveSelectedCate{
    NSMutableArray *selectedArray = [NSMutableArray array];
    
    for (WYShopCategoryInfoModel *model in self.array) {
        if (model.isSelected) {
            CodeModel *codeModel = [[CodeModel alloc]init];
            codeModel.value = model.name;
            codeModel.code = @(model.categoryId.integerValue);
            [selectedArray addObject:codeModel];
        }
    }
    self.selectedArray = [selectedArray copy];
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
