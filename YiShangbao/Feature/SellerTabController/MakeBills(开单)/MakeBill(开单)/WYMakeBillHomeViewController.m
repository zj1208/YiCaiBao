//
//  WYMakeBillViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillHomeViewController.h"
#import "WYMakeBillListTableViewCell.h"
#import "WYMakeBillViewController.h"
#import "WYPayDepositViewController.h"

#import "WYPublicModel.h"

//#import "MakeBillServiceViewController.h"
//#import "MakeBillServiceExpireViewController.h"
#import "WYMakeBillPreviewViewController.h"
#import "WYSearchViewViewController.h"
#import "WYBillSearchResultViewController.h"

#import "MakeBillsTabController.h"
#import "ZXSegmentedControl.h"

#import "WYTimeManager.h"

@interface WYMakeBillHomeViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,WYMakeBillListTableViewCellDelegate,ZXEmptyViewControllerDelegate,WYSearchViewViewControllerDelegate,ZXSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *headLeftLabel;
@property (weak, nonatomic) IBOutlet UILabel *headRightLabel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewYConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *headViewHeightConstraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ZXSegmentedControl *segmentView;

@property (nonatomic, strong) UIButton *addNewButton;//添加
@property (nonatomic, strong) UIButton *searchButton;//添加
@property (nonatomic, strong) UIButton *makeBillButton;//空白页开单

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic) NSInteger billStatusType;

@end

@implementation WYMakeBillHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    self.headViewHeightConstraint.constant = 0.0;
    self.headView.hidden = YES;
    
    self.navigationItem.title = @"单据列表";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestData) name:Noti_update_WYMakeBillHomeViewController object:nil];
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:Noti_update_WYMakeBillHomeViewController object:nil];
}

#pragma mark- WYMakeBillListTableViewCellDelegate

- (void)selectedType:(MakeBillOperationType)type index:(NSInteger)index{
    MakeBillHomeInfoModel* model = self.array[index];
    if (type == MakeBillOperationTypePreview){
        [self previewByBillId:model.billId];
    }else if (type == MakeBillOperationTypeDelete){
        [MobClick event:kUM_kdb_openbill_list_delete];
        WS(weakSelf)
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"删除后，数据将无法恢复，是否删除" message:nil cancelButtonTitle:@"删除" cancleHandler:^(UIAlertAction * _Nonnull action) {
            [weakSelf requestDeleteByBillId:model.billId];
        } doButtonTitle:@"取消" doHandler:nil];
    }else if (type == MakeBillOperationTypeEdit){
        [MobClick event:kUM_kdb_openbill_list_editbutton];
        WYMakeBillViewController *vc = (WYMakeBillViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
        vc.billId = model.billId;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)previewByBillId:(NSString *)billId{
    [MobClick event:kUM_kdb_openbill_list_preview];
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    WYMakeBillPreviewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYMakeBillPreviewViewController];
    VC.billId = billId;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark- ButtonAction

- (IBAction)dissmissControllerAction:(id)sender {
    if ([self.navigationController.childViewControllers.firstObject isEqual:self]) {
        [self.tabBarController.navigationController popViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (IBAction)headViewADVAction:(id)sender {
    [MobClick event:kUM_kdb_openbill_list_pay];
    MakeBillsTabController *tabbarVC = (MakeBillsTabController *)self.tabBarController;
    //点击横幅
    [tabbarVC checkOpenBillTimeIsExpireView:OBShowType_must checkService:OBServiceType_newBill succes:nil];
}

- (IBAction)closeHeadViewAction:(id)sender {
    [MobClick event:kUM_kdb_openbill_list_close];
    [[WYTimeManager shareTimeManager] isShowMakeBillTipViewIsNeedSave:YES];
    
    self.headViewHeightConstraint.constant = 0;
    self.headView.hidden = YES;
}

- (void)addNewBillByEmpty{
    [MobClick event:kUM_kdb_openbill_list_openbillcenter];
    [self addNewBill];
}

//搜索
- (void)showSearchView{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    WYSearchViewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYSearchViewViewController];
    VC.delegate = self;
    [self presentViewController:VC animated:NO completion:nil];
}

- (void)addNewBillByRightButton{
    
    [MobClick event:kUM_kdb_openbill_list_openbilltop];
    [self addNewBill];
}

- (void)addNewBill{
    if (self.tabBarController) {
        MakeBillsTabController *tabbarVC = (MakeBillsTabController *)self.tabBarController;
        WS(weakSelf);
           [tabbarVC checkOpenBillTimeIsExpireView:OBShowType_renewal checkService:OBServiceType_newBill succes:^(CheckBlockType isOk) {
               if (isOk == CheckBlockType_oK) {
                   [weakSelf goAddVC];
               }
           }];
    }
}

#pragma mark- WYSearchViewViewControllerDelegate
- (void)searchWord:(NSString *)searchWord{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    WYBillSearchResultViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYBillSearchResultViewController];
    VC.searchWord = searchWord;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark- ZXEmptyViewControllerDelegate
- (void)zxEmptyViewUpdateAction{
    [self requestData];
}

#pragma mark- Request
- (void)requestData{
    [MobClick event:kUM_kdb_openbill_list_search];
    
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillListBySearchWord:@"" payStatus:@(self.billStatusType) pageNo:1 pageSize:10 success:^(id data) {
        MakeBillHomeModel *model = data;
        
        if (model.remark.show && [[WYTimeManager shareTimeManager] isShowMakeBillTipViewIsNeedSave:NO]) {
            weakSelf.headViewHeightConstraint.constant = 37.0;
            weakSelf.headLeftLabel.text = model.remark.contentLeft;
            weakSelf.headRightLabel.text = model.remark.contentRight;
            weakSelf.headView.hidden = NO;
        }else{
            weakSelf.headViewHeightConstraint.constant = 0.0;
            weakSelf.headView.hidden = YES;
        }
        weakSelf.array = [NSMutableArray array];
        [weakSelf.array addObjectsFromArray:model.list];
        [weakSelf.tableView reloadData];
        
        
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.page = 1;
        weakSelf.totalPage = [model.page.totalPage integerValue];
        if ([model.page.currentPage integerValue]==[model.page.totalPage integerValue] &&[model.page.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }else{
            weakSelf.tableView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingTarget:weakSelf refreshingAction:@selector(requestMoreData)];
        }
        if (weakSelf.array.count == 0){
            [weakSelf showEmptyView:nil];
        }else{
            weakSelf.segmentView.hidden = NO;
            weakSelf.headViewYConstraint.constant = 40.0;
            self.addNewButton.hidden = NO;
            self.searchButton.hidden = NO;
            [weakSelf.emptyViewController hideEmptyViewInController:weakSelf];
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
        weakSelf.array = [NSMutableArray array];
        [weakSelf.tableView reloadData];
        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

- (void)requestMoreData{
    WS(weakSelf)
    
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillListBySearchWord:@"" payStatus:@(self.billStatusType) pageNo:self.page + 1 pageSize:10 success:^(id data) {
        MakeBillHomeModel *model = data;
        
        [weakSelf.array addObjectsFromArray:model.list];
        
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_footer endRefreshing];
        weakSelf.page ++;
        weakSelf.totalPage = [model.page.totalPage integerValue];
        if ([model.page.currentPage integerValue]==[model.page.totalPage integerValue] &&[model.page.totalPage integerValue]>0){
            weakSelf.tableView.mj_footer = nil;
        }
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_footer endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        //        [weakSelf showEmptyView:[error localizedDescription]];
    }];
}

- (void)requestDeleteByBillId:(NSString *)billId{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postBillDeleteByBillId:billId success:^(id data) {
        NSLog(@"%@",data);
        [MBProgressHUD zx_hideHUDForView:nil];
        [weakSelf requestData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark - ZXSegmentedControlDelegate

- (void)zx_segmentView:(ZXSegmentedControl *)zxSegmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)zx_segmentView:(ZXSegmentedControl *)zxSegmentedControl didSelectedIndex:(NSInteger)index{
    self.billStatusType = index;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    WYMakeBillListTableViewCell *cell = (WYMakeBillListTableViewCell *)[tableView dequeueReusableCellWithIdentifier:WYMakeBillListTableViewCellID forIndexPath:indexPath];
//    if (self.array.count >= indexPath.row){
        [cell updateData:self.array[indexPath.row] index:indexPath.row];
        cell.delegate = self;
//    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 148.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [MobClick event:kUM_kdb_openbill_list_edit];
    MakeBillHomeInfoModel* model = self.array[indexPath.row];
    WYMakeBillViewController *vc = (WYMakeBillViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
    vc.billId = model.billId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    
    
    _segmentView = [[ZXSegmentedControl alloc]init] ;
    _segmentView.delegate = self;
    _segmentView.fontSize = 15;
    [self.view addSubview:_segmentView];
    _segmentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    _segmentView.sectionTitles = @[@"全部",@"未收款",@"部分收款"];
    _segmentView.selectionIndicatorColor = [UIColor colorWithHex:0xFF5434];
    _segmentView.selectedColor = [UIColor colorWithHex:0xFF5434];
    _segmentView.normalColor = [UIColor colorWithHex:0x535353];
    _segmentView.selectionStyle = ZXSegmentedControlSelectionStyleExtendTextWidthStripe;
    _segmentView.widthStyle = ZXSegmentedControlSegmentWidthStyleFixed;
    [_segmentView reloadData];
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    [button setImage:[UIImage imageNamed:@"ic_add_black"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(addNewBillByRightButton) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.addNewButton = button;
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
    [searchButton setImage:[UIImage imageNamed:@"ic_search_black"] forState:UIControlStateNormal];
//    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton addTarget:self action:@selector(showSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn2 = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItems = @[rightBtn,rightBtn2];
    self.searchButton = searchButton;
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.delegate = self;
    
    self.addNewButton.hidden = YES;
    self.searchButton.hidden = YES;
    self.segmentView.hidden = YES;
    self.headViewYConstraint.constant = 0.0;
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        self.makeBillButton.hidden = YES;
        self.addNewButton.hidden = NO;
        self.searchButton.hidden = NO;
        UIImage *image = [UIImage imageNamed:@"无人接单"];
        string = @"\n暂无相关单据信息~";
        if (self.billStatusType == 0){
            self.headViewYConstraint.constant = 0.0;
            string = @"\n您还没有单据记录，快去开单吧~";
            image = [UIImage imageNamed:@"产品公开为空"];
            self.makeBillButton.hidden = NO;
            self.addNewButton.hidden = YES;
            self.searchButton.hidden = YES;
        }
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:image emptyTitle:string updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
        
    }else{
        self.makeBillButton.hidden = YES;
        self.addNewButton.hidden = YES;
        self.searchButton.hidden = YES;
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
    }
    
}

- (void)addToTabBarWithView:(UIView *)view{
    [self.tabBarController.view addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.tabBarController.view);
        make.bottom.equalTo(self.tabBarController.view);
        make.left.equalTo(self.tabBarController.view);
        make.right.equalTo(self.tabBarController.view);
    }];
}

- (void)goWebViewByUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

- (void)goAddVC{
    WYMakeBillViewController *vc = (WYMakeBillViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- GetterAndSetter
- (UIButton *)makeBillButton{
    if (!_makeBillButton) {
        _makeBillButton = [[UIButton alloc]init];
        [_makeBillButton setTitle:@"立即开单" forState:UIControlStateNormal];
        [_makeBillButton addTarget:self action:@selector(addNewBillByEmpty) forControlEvents:UIControlEventTouchUpInside];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.startPoint = CGPointMake(0, 0);
        gradientLayer.endPoint = CGPointMake(1, 0);
        gradientLayer.frame = CGRectMake(0, 0, 215 , 45);
        gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
        [_makeBillButton.layer insertSublayer:gradientLayer atIndex:0];
        _makeBillButton.layer.cornerRadius = 22.5;
        _makeBillButton.layer.masksToBounds = YES;
        
        [self.emptyViewController.view addSubview:_makeBillButton];
        [_makeBillButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.emptyViewController.label.mas_bottom).offset(23.0);
            make.centerX.equalTo(self.emptyViewController.view);
            make.width.equalTo(@215);
            make.height.equalTo(@45);
        }];
    }
    return _makeBillButton;
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
