 //
//  WYSurveySearchViewController.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/12.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYSurveySearchViewController.h"

#import "WYTitleTagVIew.h"

#import "WYSurveySearchResultViewController.h"

@interface WYSurveySearchViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (nonatomic,strong) UISearchBar *searchBar;
@property (nonatomic, strong)UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *historyArray;
@end

@implementation WYSurveySearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //搜索框
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectZero];
    if ([WYUTILITY.getMainScreen isEqualToString:@"6p"]) {
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-90, 44);
    }else{
        _searchBar.frame = CGRectMake(0, 0, SCREEN_WIDTH-75, 44);
    }
    _searchBar.tintColor = [UIColor blueColor];
    _searchBar.delegate = self;
    _searchBar.placeholder = @"请输入企业名";
    if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(11))
    {
        UITextField *txfSearchField = [_searchBar valueForKey:@"_searchField"];
        [txfSearchField setDefaultTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.5]}];
        _searchBar.searchTextPositionAdjustment = UIOffsetMake(2, 0);
    }
//    CGFloat offset = -0.7;
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_searchBar.placeholder
//                                                                                         attributes:@{
//                                                                     NSForegroundColorAttributeName:WYUISTYLE.colorLTgrey,
//                                                                               NSFontAttributeName :WYUISTYLE.fontWith24,
//                                                                     NSBaselineOffsetAttributeName : @(offset)}];
//    [[UITextField appearanceWhenContainedIn:[UISearchBar class], nil] setAttributedPlaceholder:attributedString];
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:_searchBar];
    self.navigationItem.leftBarButtonItems = [NSArray arrayWithObject:searchButton];
    
    //右边取消
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
    [backBtn setTitle:@"取消" forState:UIControlStateNormal];
    backBtn.titleLabel.font = WYUISTYLE.fontWith28;
    [backBtn sizeToFit];
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 12, 0, -12);
    UIBarButtonItem *myFillformBtnItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    self.navigationItem.rightBarButtonItem  = myFillformBtnItem;
    
    //搜索历史tableview
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.tableView];
    [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
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
    self.tableView.hidden = YES;
    self.historyArray = [NSMutableArray array];
//    [self initData];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    self.navigationController.navigationBar.barTintColor = WYUISTYLE.colorMred;
    self.navigationController.navigationBar.translucent = NO;
    [self initData];
    [_searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    self.navigationController.navigationBar.barTintColor = WYUISTYLE.colorBWhite;
    self.navigationController.navigationBar.translucent = YES;
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)initData{

    [[[AppAPIHelper shareInstance] SurveyMainAPI] getSearchHistoryListWithSuccess:^(id data) {
        [self.historyArray removeAllObjects];
        self.historyArray = [data mutableCopy];
        if (self.historyArray.count) {
            self.tableView.hidden = NO;
            [self.tableView reloadData];
        }else{
           self.tableView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark table view delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.historyArray.count) {
        return self.historyArray.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 36;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    WYTitleTagVIew *tagView = [[WYTitleTagVIew alloc] init];
    tagView.label_title.text = @"历史搜索";
    return tagView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=self.historyArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self initData];
    WYSurveySearchResultViewController *vc = [[WYSurveySearchResultViewController alloc] init];
    vc.text = self.historyArray[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - UISerachBarDelegate
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar endEditing:YES];
    [self serachResultWithKeyWord:searchBar.text];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    NSLog(@"%@",searchText);
}


#pragma mark -
- (void)serachResultWithKeyWord:(NSString *)text {
    if ([text isEqualToString:@""]) {
        return;
    }
    [self initData];
    [MobClick event:kUM_b_search];
    WYSurveySearchResultViewController *vc = [[WYSurveySearchResultViewController alloc] init];
    vc.text = text;
    [self.navigationController pushViewController:vc animated:YES];
}

-(void)backAction{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark -UIKeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    
    [UIView animateWithDuration:duration animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom).offset(safeBottom - keyboardRect.size.height);
        }];
//        self.viewBottomLayoutConstraint.constant = keyboardRect.size.height - safeBottom;
        [self.view layoutIfNeeded];
        [self.tableView needsUpdateConstraints];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        [_tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top);
            make.left.equalTo(self.view.mas_left);
            make.right.equalTo(self.view.mas_right);
            make.bottom.equalTo(self.view.mas_bottom);
        }];
//        self.viewBottomLayoutConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self.tableView needsUpdateConstraints];
    }];
}
@end
