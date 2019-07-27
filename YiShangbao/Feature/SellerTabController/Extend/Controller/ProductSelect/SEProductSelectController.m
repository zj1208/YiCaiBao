//
//  SEProductSelectController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SEProductSelectController.h"
#import "SMSelectProductCell.h"

@interface SEProductSelectController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UITableView *classifyTabView;

@property(nonatomic,strong)NSMutableArray *arrayProduct;
@property(nonatomic,strong)NSMutableArray *arrayClassify;
@property (nonatomic, assign)NSInteger PageNo; //第几页
//已选择的产品
@property(nonatomic,strong)NSMutableArray<__kindof ExtendSelectProcuctModel *> *arrayProductSelected;

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong)WYShopCategoryInfoModel *shopCategoryInfoModel;
@property (nonatomic, strong)NSString *searchName; //处理用户输入不搜索，上拉第二页


@end
static NSString *const UITableViewCell_resign = @"UITableViewCell_resign";
static NSString *const SMSelectProductCell_resign = @"SMSelectProductCell_resign";
@implementation SEProductSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorF3F3F3];
    
    [self setData];
    [self buildUI];

    [self requestClassifyData];
}
-(void)setData
{
    self.arrayProduct = [NSMutableArray array];
    self.arrayClassify = [NSMutableArray array];
    if (!self.arrayProductSelected) {
        self.arrayProductSelected = [NSMutableArray array];
    }
    self.PageNo = 1;
}
-(void)buildUI
{
    self.screenContentView.hidden = YES;
    
    self.textfild.layer.masksToBounds = YES;
    self.textfild.layer.cornerRadius = 16.f;
    self.textfild.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    self.textfild.leftViewMode = UITextFieldViewModeAlways;

    
    self.productTabView.allowsMultipleSelection = YES;
    self.productTabView.rowHeight = 100;
    self.productTabView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
    [self.productTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCell_resign];
    [self.productTabView registerNib:[UINib nibWithNibName:@"SMSelectProductCell" bundle:nil] forCellReuseIdentifier:SMSelectProductCell_resign];
   
    [self.sureBtn setBackgroundImage:[WYUIStyle imageFF8848_FF5535:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    [self.currySelectLabel jl_changeStringOfNumberStyle:nil numberColor:[WYUISTYLE colorWithHexString:@"F58F23"] numberFont:[UIFont boldSystemFontOfSize:17]];

}
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
        emptyVC.view.frame = self.view.bounds ;
        emptyVC.delegate = self;
        self.emptyViewController = emptyVC;
    }return _emptyViewController;
}
-(void)zxEmptyViewUpdateAction
{
    if (self.arrayClassify.count>0) {
        [self requestProductDataWithPage:1];
    }else{
        [self requestClassifyData];
    }
}
#pragma mark - -----------数据请求---------------
-(void)headerRefresh
{
    WS(weakSelf);
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestProductDataWithPage:1];
    }];
    self.productTabView.mj_header = header;
}
- (void)footerWithRefreshing
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestWeiNiTuiJianDataWithPageNumAdd_One)];
    //控制底部控件(默认高度44)出现百分比(0.0-1.0,默认1.0)来预加载，此处设置表示距离底部上拉控件顶部5*44高度即提前加载数据
    footer.triggerAutomaticallyRefreshPercent = -5;
    self.productTabView.mj_footer = footer;
}
-(void)requestWeiNiTuiJianDataWithPageNumAdd_One
{
    [self requestProductDataWithPage:_PageNo+1];
}
#pragma mark - 请求第page页
//请求第page页
-(void)requestProductDataWithPage:(NSInteger)page
{
    NSString *ShopCategoryId = self.shopCategoryInfoModel.categoryId;
    [[[AppAPIHelper shareInstance] getExtendProductAPI] getExtendChooseProductWithShopCategoryId:ShopCategoryId name:self.searchName pageNum:page pageSize:10 Success:^(id data, PageModel *pageModel) {

        if (page==1) {
            self.arrayProduct  = [NSMutableArray arrayWithArray:data];
            _PageNo =1;
        }else{
            [self.arrayProduct addObjectsFromArray:data];
            _PageNo ++;
        }
        
        if (self.productTabView.mj_footer==nil) {
            if ([pageModel.totalPage integerValue]>1) {
                [self footerWithRefreshing];
            }
        }
        if ([pageModel.currentPage integerValue]==[pageModel.totalPage integerValue] ) {
            self.productTabView.mj_footer = nil;
        }
        
        NSString *title = [ShopCategoryId isEqualToString:@"0"]?@"您还没有上传产品噢～\n快去“商铺-产品管理”里面上传您的产品吧！":@"该分类下还没有产品，快添加些产品吧~";
        if (![NSString zhIsBlankString:self.searchName]&&![self.searchName isEqualToString:@""]) {
            [_emptyViewController addEmptyViewInController:self hasLocalData:self.arrayProduct.count error:nil emptyImage:[UIImage imageNamed:@"无人接单"] emptyTitle:@"没有搜索到相关产品,\n检查下您的关键词是否正确哦～" updateBtnHide:YES];
        }else{
            [self.emptyViewController addEmptyViewInController:self hasLocalData:self.arrayProduct.count error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:title updateBtnHide:YES];
        }
        self.emptyViewController.view.frame = CGRectMake(0, HEIGHT_NAVBAR+45, LCDW, LCDH-(HEIGHT_NAVBAR+45)-54-HEIGHT_TABBAR_SAFE);

        
        [self.productTabView.mj_header endRefreshing];
        [self.productTabView.mj_footer endRefreshing];
        [self.productTabView reloadData];
        
    } failure:^(NSError *error) {
        [self.productTabView.mj_header endRefreshing];
        [self.productTabView.mj_footer endRefreshing];
        self.emptyViewController.view.frame = CGRectMake(0, HEIGHT_NAVBAR+45, LCDW, LCDH-45);
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
#pragma mark - 请求分类
-(void)requestClassifyData
{
    NSString *shopId = [UserInfoUDManager getShopId];
    [[[AppAPIHelper shareInstance] getExtendProductAPI] getExtentShopCategoryDataWithShopId:shopId appendNoGroup:NO success:^(id data) {
        [self.emptyViewController hideEmptyViewInController:self hasLocalData:YES];

        NSArray *arr = (NSArray *)data;
        if (arr.count>0)
        {
            self.arrayClassify = [NSMutableArray arrayWithArray:data];
            self.shopCategoryInfoModel = self.arrayClassify.firstObject;
            self.screenLabel.text = _shopCategoryInfoModel.name;
            [self updateScreenLabelWidth];
            self.screenContentView.hidden = NO;

            [self headerRefresh];
            [self requestProductDataWithPage:1];
        }
    } failure:^(NSError *error) {
        [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
#pragma mark 展示分类
-(void)showClassifyTabView:(BOOL)show
{
    if (show)
    {
        if (self.arrayClassify.count==0) {
            return;
        }
        if (!self.classifyTabView){
            UITableView *classTV = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
            classTV.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.01)];
            classTV.rowHeight = 45;
            classTV.bounces = NO;
            classTV.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            classTV.dataSource = self;
            classTV.delegate = self;
            self.classifyTabView = classTV;
            [self.classifyTabView registerClass:[UITableViewCell class] forCellReuseIdentifier:UITableViewCell_resign];
        }
        self.classifyTabView.frame = CGRectMake(0, CGRectGetMinY(self.productTabView.frame), LCDW, LCDH-CGRectGetMinY(self.productTabView.frame));
        [self.view addSubview:self.classifyTabView];
        [self.view bringSubviewToFront:self.classifyTabView];//氛围图影响
        [self.classifyTabView reloadData];
    }
    else
    {
        if (self.classifyTabView) {
            [self.classifyTabView removeFromSuperview];
        }
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.productTabView) {
        return self.arrayProduct.count;
    }
    if (tableView == self.classifyTabView) {
        return self.arrayClassify.count;
    }
    return 0;
}
-(BOOL)isSelectedModel:(ExtendSelectProcuctModel *)model
{
    for (ExtendSelectProcuctModel *mod in self.arrayProductSelected) {
        if (mod.iid == model.iid) {
            return YES;
        }
    }return NO;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productTabView)
    {
        SMSelectProductCell *cell  = [tableView dequeueReusableCellWithIdentifier:SMSelectProductCell_resign forIndexPath:indexPath];
        ExtendSelectProcuctModel *model = self.arrayProduct[indexPath.row];
        [cell setData:model];
        if ([self isSelectedModel:model]) { //根据产品id匹配
            [tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
        }else{
            [tableView deselectRowAtIndexPath:indexPath animated:NO];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        UITableViewCell *cell  = [tableView dequeueReusableCellWithIdentifier:UITableViewCell_resign forIndexPath:indexPath];
        WYShopCategoryInfoModel *model = self.arrayClassify[indexPath.row];
        cell.textLabel.text = model.name;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        if ([cell.textLabel.text isEqualToString:self.screenLabel.text]) {
            cell.textLabel.textColor = [WYUISTYLE colorWithHexString:@"#FF5434"];
        }else{
            cell.textLabel.textColor = [WYUISTYLE colorWithHexString:@"#535353"];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
   
}
- (nullable NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productTabView){
        NSInteger num = self.arrayProductSelected.count;
        if (num>=self.maxProsucts) {
            [MBProgressHUD zx_showError:[NSString stringWithFormat:@"只能选择%ld个噢～",self.maxProsucts] toView:self.view];
            return nil;
        }
    }
    return indexPath;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productTabView){
        ExtendSelectProcuctModel *model = self.arrayProduct[indexPath.row];
        [self.arrayProductSelected addObject:model];
        [self updateCurrySelectLabelNumbers:self.arrayProductSelected.count];
    }
    if (tableView == self.classifyTabView){
        self.shopCategoryInfoModel = self.arrayClassify[indexPath.row];
        self.screenLabel.text = _shopCategoryInfoModel.name;
        [self updateScreenLabelWidth];
        self.screenBtn.selected = NO;
        [self showClassifyTabView:NO];
        [self beginRequestProdcutData];
    }
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.productTabView){
        ExtendSelectProcuctModel *model = self.arrayProduct[indexPath.row];
        [self.arrayProductSelected removeObject:model];
        [self updateCurrySelectLabelNumbers:self.arrayProductSelected.count];
    }
}
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [self showClassifyTabView:NO];
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField
{
    self.shopCategoryInfoModel =  self.arrayClassify.firstObject;
    self.screenLabel.text = self.shopCategoryInfoModel.name;
    [self updateScreenLabelWidth];
    self.searchName = @"";
    [self beginRequestProdcutData];
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    self.searchName = textField.text;
    [self beginRequestProdcutData];
    return YES;
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
- (IBAction)screenBtnClick:(UIButton *)sender{
    [self.textfild resignFirstResponder];
    sender.selected = !sender.selected;
    [self showClassifyTabView:sender.selected];
    
}
- (IBAction)searchBtnClick:(UIButton *)sender {
    [self.textfild resignFirstResponder];
    [self showClassifyTabView:NO];
    self.searchName = self.textfild.text;
    [self beginRequestProdcutData];
}
- (IBAction)sureBtnClick:(UIButton *)sender {
    NSLog(@"%@",_arrayProductSelected);

    if (self.arrayProductSelected.count ==0 ) {
        [MBProgressHUD zx_showError:@"您还没有选择产品噢～" toView:self.view];
        return;
    }
    [self.navigationController popViewControllerAnimated:NO];

    if (self.productDidSelectBlock) {
        self.productDidSelectBlock(self.arrayProductSelected);
    }
}
-(void)updateScreenLabelWidth
{
    NSInteger len = self.screenLabel.text.length;
    len = len>4?4:len; //若不用代码限制screenLabel宽度，当textFild输入较多字符时会宽度自适应变宽，label变窄(设置label小于等于4个字符宽度不行)
    CGRect rect = [[self.screenLabel.text substringToIndex:len] boundingRectWithSize:CGSizeMake(MAXFLOAT,20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil];    
    self.screenLabelWidthLay.constant = ceilf(rect.size.width);
}
-(void)updateCurrySelectLabelNumbers:(NSInteger)number
{
    NSString *text = [NSString stringWithFormat:@"总选择了%ld件",number];
    [self.currySelectLabel jl_changeStringOfNumberStyle:text numberColor:[WYUISTYLE colorWithHexString:@"F58F23"] numberFont:[UIFont boldSystemFontOfSize:17]];
}
-(void)beginRequestProdcutData
{
    [self.productTabView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];//多页数据beginRefreshing不能滚动顶部bug
    [self.productTabView.mj_header beginRefreshing];
}
@end
