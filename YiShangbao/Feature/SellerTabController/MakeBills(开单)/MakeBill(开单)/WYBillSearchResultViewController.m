//
//  WYBillSearchResultViewController.m
//  YiShangbao
//
//  Created by light on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYBillSearchResultViewController.h"
#import "WYMakeBillListTableViewCell.h"
#import "WYMakeBillViewController.h"
#import "ZXSegmentedControl.h"
#import "WYSearchViewViewController.h"
#import "WYMakeBillPreviewViewController.h"

@interface WYBillSearchResultViewController () <UITableViewDelegate,UITableViewDataSource,WYMakeBillListTableViewCellDelegate,WYSearchViewViewControllerDelegate,ZXSegmentedControlDelegate>

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentedControl;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) UIButton *titleViewButton;
@property (nonatomic, strong) ZXSegmentedControl *segmentView;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic, strong) NSMutableArray *array;
@property (nonatomic) NSInteger page;
@property (nonatomic) NSInteger totalPage;

@property (nonatomic) NSInteger billStatusType;

@end

@implementation WYBillSearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    [self.tableView.mj_header beginRefreshing];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.titleViewButton setTitle:self.searchWord forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ButtonAction
- (void)goSearchView{
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    WYSearchViewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYSearchViewViewController];
    VC.serachWord = self.searchWord;
    VC.delegate = self;
    [self presentViewController:VC animated:NO completion:nil];
}

#pragma mark- WYSearchViewViewControllerDelegate
- (void)searchWord:(NSString *)searchWord{
    self.searchWord = searchWord;
    [self.tableView.mj_header beginRefreshing];
}

#pragma mark - ZXSegmentedControlDelegate

- (void)zx_segmentView:(ZXSegmentedControl *)zxSegmentedControl willDisplayCell:(ZXSegmentCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    
}

- (void)zx_segmentView:(ZXSegmentedControl *)zxSegmentedControl didSelectedIndex:(NSInteger)index{
    self.billStatusType = index;
    [self.tableView.mj_header beginRefreshing];
}


#pragma mark- WYMakeBillListTableViewCellDelegate

- (void)selectedType:(MakeBillOperationType)type index:(NSInteger)index{
    MakeBillHomeInfoModel* model = self.array[index];
    if (type == MakeBillOperationTypePreview){
        [self previewByBillId:model.billId];
    }else if (type == MakeBillOperationTypeDelete){
//        [MobClick event:kUM_kdb_openbill_list_delete];
        WS(weakSelf)
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"删除后，数据将无法恢复，是否删除" message:nil cancelButtonTitle:@"删除" cancleHandler:^(UIAlertAction * _Nonnull action) {
            [weakSelf requestDeleteByBillId:model.billId];
        } doButtonTitle:@"取消" doHandler:nil];
    }else if (type == MakeBillOperationTypeEdit){
//        [MobClick event:kUM_kdb_openbill_list_editbutton];
        WYMakeBillViewController *vc = (WYMakeBillViewController *)[self zx_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
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

#pragma mark- Request
- (void)requestData{
//    [MobClick event:kUM_kdb_openbill_list_search];
    
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillListBySearchWord:self.searchWord payStatus:@(self.billStatusType) pageNo:1 pageSize:10 success:^(id data) {
        MakeBillHomeModel *model = data;
        
//        weakSelf.headViewYConstraint.constant = 45.0;
//        weakSelf.searchTextField.hidden = NO;
//        if (model.remark.show && [[WYTimeManager shareTimeManager] isShowMakeBillTipViewIsNeedSave:NO]) {
//            weakSelf.headViewHeightConstraint.constant = 37.0;
//            weakSelf.headLeftLabel.text = model.remark.contentLeft;
//            weakSelf.headRightLabel.text = model.remark.contentRight;
//            weakSelf.headView.hidden = NO;
//        }else{
//            weakSelf.headViewHeightConstraint.constant = 0.0;
//            weakSelf.headView.hidden = YES;
//        }
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
//            self.addNewButton.hidden = NO;
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
    
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillListBySearchWord:self.searchWord payStatus:@(self.billStatusType) pageNo:self.page + 1 pageSize:10 success:^(id data) {
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
//    [MobClick event:kUM_kdb_openbill_list_edit];
    
    MakeBillHomeInfoModel* model = self.array[indexPath.row];
    WYMakeBillViewController *vc = (WYMakeBillViewController *)[self zx_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillViewController];
    vc.billId = model.billId;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark- Private
- (void)setUI{
    self.segmentedControl.tintColor = [UIColor clearColor];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF5434],NSFontAttributeName:[UIFont boldSystemFontOfSize:16]} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0x535353],NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];

    
    _segmentView = [[ZXSegmentedControl alloc]init] ;
    _segmentView.delegate = self;
    _segmentView.fontSize = 15;
    [self.view addSubview:_segmentView];
    _segmentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 40);
    _segmentView.sectionTitles = @[@"全部",@"未收款",@"部分收款"];
    _segmentView.selectionIndicatorColor = [UIColor colorWithHex:0xFF5434];
    _segmentView.selectedColor = [UIColor colorWithHex:0xFF5434];
    _segmentView.normalColor = [UIColor colorWithHex:0x535353];
    _segmentView.selectionStyle = ZXSegmentedControlSelectionStyleTextWidthStripe;
    _segmentView.widthStyle = ZXSegmentedControlSegmentWidthStyleFixed;
    [_segmentView reloadData];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    [_tableView registerNib:[UINib nibWithNibName:@"WYMakeBillListTableViewCell" bundle:nil] forCellReuseIdentifier:WYMakeBillListTableViewCellID];
    
    UIButton *titleButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 28)];
    [titleButton addTarget:self action:@selector(goSearchView) forControlEvents:UIControlEventTouchUpInside];
    [titleButton setTitle:@"" forState:UIControlStateNormal];
    [titleButton setImage:[UIImage imageNamed:@"ic_search"] forState:UIControlStateNormal];
    [titleButton setTitleColor:[UIColor colorWithHex:0x2F2F2F] forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
    [titleButton setBackgroundColor:[UIColor colorWithHex:0xEEEEEE]];
    titleButton.layer.masksToBounds = YES;
    titleButton.layer.cornerRadius = 16;
    titleButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.titleView = titleButton;
    self.titleViewButton = titleButton;
    
    UIButton *searchButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    [searchButton.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [searchButton addTarget:self action:@selector(goSearchView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:searchButton];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(requestData)];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    
}

- (void)showEmptyView:(NSString *)string{
    if (!string) {
        UIImage *image = [UIImage imageNamed:@"无人接单"];
        string = @"\n暂无相关单据信息~";
//        if (!self.searchTextField.text.length) {
//            self.headViewYConstraint.constant = 0.0;
//            self.searchTextField.hidden = YES;
//            string = @"\n您还没有单据记录，快去开单吧~";
//            image = [UIImage imageNamed:@"产品公开为空"];
//            self.makeBillButton.hidden = NO;
//            self.addNewButton.hidden = YES;
//        }
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:image emptyTitle:string updateBtnHide:YES];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
        
    }else{
//        self.makeBillButton.hidden = YES;
//        self.addNewButton.hidden = YES;
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:string updateBtnHide:NO];
        [self.emptyViewController.view mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.tableView.mas_top);
            make.left.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(self.view);
        }];
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
