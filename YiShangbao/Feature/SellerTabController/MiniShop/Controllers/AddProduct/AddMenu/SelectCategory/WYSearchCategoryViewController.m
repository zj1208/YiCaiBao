//
//  WYSearchCategoryViewController.m
//  YiShangbao
//
//  Created by light on 2017/10/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYSearchCategoryViewController.h"
#import "WYSearchCategoryTableViewCell.h"
#import "WYSearchCategoryHeaderView.h"
#import "WYPublicModel.h"

#import "WYAllCategoryViewController.h"
@interface WYSearchCategoryViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZXEmptyViewControllerDelegate,WYAllCategoryViewControllerDelegate>

@property (nonatomic, strong) UILabel *tipLabel;
@property (nonatomic, strong) UIView *searchView;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) UIView *buttonView;
@property (nonatomic, strong) NSMutableArray *array;

@property (nonatomic, strong) UIView *emptyView;
@property (nonatomic) NSInteger page;

@end

@implementation WYSearchCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"选择所属类目";
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self creatUI];
    [self isShowEmptyView];
    
    [self.searchTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestLoadData)];
    
    
//    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
    // Do any additional setup after loading the view.
}
- (void)dealloc
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action
- (void)cancelButtonAction{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)feedbackButtonAction{
    WS(weakSelf)
    NSString *shopId = [UserInfoUDManager getShopId];
    [ProductMdoleAPI postNotFoundcategoryString:self.searchTextField.text shopId:shopId success:^(id data) {
        [MBProgressHUD zx_showSuccess:@"提交成功" toView:weakSelf.view];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)allCategoryButtonAction{
    [MobClick event:kUM_b_allcategory];
    WYAllCategoryViewController *allCategoryVC = [[WYAllCategoryViewController alloc]init];
    allCategoryVC.delegate = self;
    [self.navigationController pushViewController:allCategoryVC animated:YES];
}

#pragma mark - WYAllCategoryViewControllerDelegate
- (void)selectedCategory:(NSString *)categoryString categoryId:(NSNumber *)cateId{
    [self returnCategoryString:categoryString categoryId:cateId];
}

#pragma mark - 氛围图
- (void)zxEmptyViewUpdateAction{
    //点击事件
}

#pragma mark -UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}

//- (void)textFieldDidEndEditing:(UITextField *)textField{
//    [self requestLoadData];
//}

- (void)textFieldChanged:(UITextField *)textField{
    if (textField.markedTextRange == nil) {
        [self requestLoadData];
    }
}

#pragma mark —Request

- (void)requestLoadData{
    WS(weakSelf)
    if (self.searchTextField.text.length == 0){
        [self.tableView.mj_header endRefreshing];
//        [MBProgressHUD zx_showError:@"请输入要搜索的关键字" toView:weakSelf.view];
        self.array = nil;
        [self.tableView reloadData];
        [self isShowEmptyView];
        return;
    }
    [MobClick event:kUM_b_searchcategory];
    NSString *shopId = [UserInfoUDManager getShopId];
    [ProductMdoleAPI getSearchCategoryWithWord:self.searchTextField.text shopId:shopId pageNum:@"1" pageSize:@"10" success:^(id data, PageModel *page) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.page = 1;
        if ([page.currentPage integerValue]==[page.totalPage integerValue] &&[page.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
        }
        weakSelf.array = [NSMutableArray arrayWithArray:data];
        [weakSelf isShowEmptyView];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf isShowEmptyView];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    NSString *page = [NSString stringWithFormat:@"%ld",self.page + 1];
    NSString *shopId = [UserInfoUDManager getShopId];
    [ProductMdoleAPI getSearchCategoryWithWord:self.searchTextField.text shopId:shopId pageNum:page pageSize:@"10" success:^(id data, PageModel *page) {
        [weakSelf.tableView.mj_footer endRefreshing];
        self.page ++;
        if ([page.currentPage integerValue]==[page.totalPage integerValue] && [page.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestMoreData)];
        }
        [weakSelf.array addObjectsFromArray:data];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.searchTextField.text.length > 0){
        return self.array.count;
    }else{
        return self.historyArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYSearchCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYSearchCategoryTableViewCellID forIndexPath:indexPath];
    if (!cell) {
        cell = [[WYSearchCategoryTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSearchCategoryTableViewCellID];
    }
    WYCategoryModel *model;
    if (self.searchTextField.text.length > 0){
        model = self.array[indexPath.row];
    }else{
        model = self.historyArray[indexPath.row];
    }
    [cell updateData:model.sysCateName];
    return cell;
}

#pragma mark -UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    WYSearchCategoryHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:WYSearchCategoryHeaderViewID];
    if (!view) {
        view = [[WYSearchCategoryHeaderView alloc]initWithReuseIdentifier:WYSearchCategoryHeaderViewID];
    }
    if (self.searchTextField.text.length > 0){
        view.titleLabel.text = @"搜索结果";
    }else if(self.historyArray.count > 0){
        view.titleLabel.text = @"最近使用";
    }else{
        return [[UIView alloc]initWithFrame:CGRectZero];
    }
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    WYCategoryModel *model;
    if (self.searchTextField.text.length > 0){
        model = self.array[indexPath.row];
    }else{
        model = self.historyArray[indexPath.row];
    }
    [self returnCategoryString:model.sysCateName categoryId:model.sysCateId];
}

#pragma mark -Private
- (void)creatUI{
    
    UIView *tipView = [[UIView alloc]init];
    [self.view addSubview:tipView];
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
    }];
    tipView.backgroundColor = [UIColor colorWithHex:0xFFEEE0];
    
    self.tipLabel = [[UILabel alloc]init];
    [tipView addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView).offset(10);
        make.left.equalTo(tipView).offset(10);
        make.right.equalTo(tipView).offset(-10);
        make.bottom.equalTo(tipView).offset(-10);
    }];
    
    self.tipLabel.numberOfLines = 0;
    self.tipLabel.font = [UIFont systemFontOfSize:13];
    self.tipLabel.textColor = [UIColor colorWithHex:0xFD7652];
    self.tipLabel.text = @"请谨慎选择类目，选错类目可能会导致您的产品搜不到";
    
    //搜索框View    ----------------------------
    self.searchView = [[UIView alloc]init];
    [self.view addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).offset(10);
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-65);
        make.height.equalTo(@32);
    }];
    self.searchView.backgroundColor = [UIColor colorWithHex:0xEEEEEE];
    self.searchView.layer.masksToBounds= YES;
    self.searchView.layer.cornerRadius = 16.0f;
    
    UIImageView *searchImageView = [[UIImageView alloc]init];
    [self.searchView addSubview:searchImageView];
    [searchImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.searchView);
        make.left.equalTo(self.searchView).offset(16.0);
    }];
    searchImageView.image = [UIImage imageNamed:@"ic_search_grey"];
    
    self.searchTextField = [[UITextField alloc]init];
    [self.searchView addSubview:self.searchTextField];
    [self.searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView);
        make.bottom.equalTo(self.searchView);
        make.left.equalTo(self.searchView).offset(39.0);
        make.right.equalTo(self.searchView) ;
    }];
    self.searchTextField.placeholder = @"请输入您想要的类目名称";
    self.searchTextField.font = [UIFont systemFontOfSize:14.0];
    self.searchTextField.delegate = self;
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.clearButtonMode = UITextFieldViewModeAlways;
    
    UIButton *cancelButton = [[UIButton alloc]init];
    [self.view addSubview:cancelButton];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipView.mas_bottom).offset(10);
        make.left.equalTo(self.searchView.mas_right);
        make.right.equalTo(self.view);
        make.height.equalTo(@32);
    }];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithHex:0x868686] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    
    //底部按钮View     ----------------------------
    self.buttonView = [[UIView alloc]init];
    [self.view addSubview:self.buttonView];
    [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view).offset(60);
        make.height.equalTo(@60);
    }];
    self.buttonView.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.7];
    
    UIButton *feedbackButton = [[UIButton alloc]init];
    [self.buttonView addSubview:feedbackButton];
    [feedbackButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.buttonView).offset(8);
        make.left.equalTo(self.buttonView).offset(15);
        make.right.equalTo(self.buttonView).offset(-15);
        make.bottom.equalTo(self.buttonView).offset(-8);
    }];
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH-30, 45);
    [feedbackButton.layer addSublayer:gradientLayer];
    [feedbackButton setTitle:@"没有我想要的类目" forState:UIControlStateNormal];
    [feedbackButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
    [feedbackButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    feedbackButton.layer.masksToBounds = YES;
    feedbackButton.layer.cornerRadius = 22.0f;
    [feedbackButton addTarget:self action:@selector(feedbackButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    //        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = [UIColor colorWithHex:0xE1E2E3];
    [_tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    [_tableView registerClass:[WYSearchCategoryTableViewCell class] forCellReuseIdentifier:WYSearchCategoryTableViewCellID];
    [_tableView registerClass:[WYSearchCategoryHeaderView class] forHeaderFooterViewReuseIdentifier:WYSearchCategoryHeaderViewID];
    [self.view addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.searchView.mas_bottom).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.buttonView.mas_top);
    }];
    
    if ([_tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [_tableView setSeparatorInset:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    if ([_tableView respondsToSelector:@selector(setLayoutMargins:)])  {
        [_tableView setLayoutMargins:UIEdgeInsetsMake(0, 15, 0, 15)];
    }
    
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
    
    
    
    self.emptyView = [[UIView alloc] init];
    [self.view addSubview:self.emptyView];
    [self.emptyView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tableView.mas_top);
        make.left.equalTo(self.tableView.mas_left);
        make.width.equalTo(self.tableView);
        make.bottom.equalTo(self.view);
    }];
    
    UIImageView *imageView = [[UIImageView alloc]init];
    [self.emptyView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.emptyView).offset(10);
        make.centerX.equalTo(self.emptyView);
    }];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    imageView.image = [UIImage imageNamed:@"bg_tishiyu"];
    
    [self creatRightButton];
}

- (void)creatRightButton{
    UIButton * allCategoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 78, 28)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:allCategoryButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [allCategoryButton addTarget:self action:@selector(allCategoryButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [allCategoryButton setTitle:@"全部类目" forState:UIControlStateNormal];
    [allCategoryButton setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    [allCategoryButton.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [allCategoryButton setBackgroundColor:[UIColor colorWithHex:0xFFF5F6]];
    allCategoryButton.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    allCategoryButton.layer.borderWidth = 0.5;
    allCategoryButton.layer.cornerRadius = 14.0;
    allCategoryButton.layer.masksToBounds= YES;
}

//是否展示氛围图
- (void)isShowEmptyView{
    self.emptyView.hidden = YES;
    if (self.array.count > 0) {
        [self.emptyViewController hideEmptyViewInController:self];
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view);
        }];
    }else if (self.searchTextField.text.length > 0){
//        self.emptyViewController.contentOffest = CGSizeMake(0, 0);
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:@"没有搜索到您想要的东西，\n换个关键词再搜一次吧！\n\n（本次搜索结果已上报，我们会不断完善类目信息）" updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.left.equalTo(self.tableView.mas_left);
            make.width.equalTo(self.tableView);
            make.height.equalTo(self.tableView);
        }];
        
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(60);
        }];
    }else if(self.historyArray.count == 0){
        self.emptyView.hidden = NO;
        [self.emptyViewController hideEmptyViewInController:self];
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(60);
        }];
    }else{
        [self.buttonView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(60);
        }];
    }
}

- (void)returnCategoryString:(NSString *)string categoryId:(NSNumber *)cateId{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedCategory: categoryId:)]) {
        [self.delegate selectedCategory:string  categoryId:cateId];
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
