//
//  SearchShopDetailController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SearchShopDetailController.h"

#import "SearchDetailViewController.h"

#import "SearchModel.h"
#import "WYSelectedTableView.h"
#import "SearchDetailScreenController.h"

#import "SearchDetailShangPuCollViewCell.h"

@interface SearchShopDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,WYSelectedTableViewDelegate,SearchDetailScreenControllerDelegate,ZXPhotosViewDelegate,ZXEmptyViewControllerDelegate,UITextViewDelegate>

//请求id，pageNo为1的情况可以为空，pageNo大于1的情况必须设置为前一次请求返回来的responseId
@property(nonatomic,strong) NSString *requestId;
@property(nonatomic,assign) NSInteger pageNumShop;

@property(nonatomic,strong) SearchDetailScreenController * shopScreenVC;//商铺筛选器
@property(nonatomic,strong) ZXEmptyViewController* emptyViewController; //氛围图

@property(nonatomic,strong) NSArray* arrayTitleAuthStatus ;//@[@"已认证",@"未认证"]
@property(nonatomic,strong) NSArray* arrayTitleShop ;//@[@"贸易类型",@"内贸为主",@"外贸为主"];
@property(nonatomic,strong) NSMutableArray* arrayShop;

@property (nonatomic, weak)WYSelectedTableView* selectedTableView;  //产品、商铺(已认证／贸易类型)选择View

@end

static NSInteger singlePageCount = 15;//分页每页个数

@implementation SearchShopDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorWithHexString:@"FAFAFA"];
    
    //初始化数据
    [self setData];
    //初始化UI
    [self buildUI];
    
    //请求搜索商铺数据
    [self requsetSearchShopData];

}
- (void)setData
{
    _pageNumShop = 1;
    
    self.arrayTitleAuthStatus = @[@"已认证",@"未认证"];
    self.arrayTitleShop = @[@"贸易类型",@"内贸为主",@"外贸为主"];
    self.arrayShop = [NSMutableArray array];
}
- (void)buildUI
{
    self.shopCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
    [self.shopCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailShangPuCollViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"ShangPu"];
}

#pragma mark - 请求商铺数据
-(void)requsetSearchShopData
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    
    NSInteger curryMaoYiType = [_arrayTitleShop indexOfObject:self.maoyileixingBtn.titleLabel.text];
    NSInteger curry_authStatus = [_arrayTitleAuthStatus indexOfObject:self.shangpuAuthStatusBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    NSString *currySubmarketIdFilter = self.shopScreenVC.currySubmarketIdFilter;
    
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchShopURLWithPageNo:1 pageSize:singlePageCount searchKeyword:self.searchKeyword sellChannel:curryMaoYiType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter authStatus:curry_authStatus_fan success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController hideEmptyViewInController:self];

        _pageNumShop = 1;
        self.arrayShop = [NSMutableArray arrayWithArray:data];
        [self.shopCollectionView reloadData];

        if (self.arrayShop.count==0) {
            [self moveCustomNavigationBarDownWhenNeed];
            self.emptyViewController.view.frame = self.shopCollectionView.frame;
            [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:[UIImage imageNamed:@"searchshopempty"] emptyTitle:@"  " updateBtnHide:YES];
            [self setEmptyViewControllerAttributedText:YES];//自定义title
        }       
        
        [self footerWithShopRefreshing];//根据数组是否有值来是否加载、移除mj_footer
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [self moveCustomNavigationBarDownWhenNeed];
        self.emptyViewController.view.frame = self.shopCollectionView.frame;
        [self setEmptyViewControllerAttributedText:NO];
        [self.emptyViewController addEmptyViewInController:self hasLocalData:self.arrayShop.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}


- (void)moveCustomNavigationBarDownWhenNeed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_scrollViewDidScrollWithMoveUp:)])
    {
        [self.delegate jl_scrollViewDidScrollWithMoveUp:NO];
    }
}

#pragma mark - *******上拉加载*******
#pragma mark 商铺
- (BOOL)footerWithShopRefreshing
{
    if (self.arrayShop.count<singlePageCount)
    {
        if (self.shopCollectionView.mj_footer)
        {
            self.shopCollectionView.mj_footer = nil;
        }
        return NO;
    }
    WS(weakSelf);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestNextPageShopData];
    }];
    //控制底部控件(默认高度44)出现百分比(0.0-1.0,默认1.0)来预加载，此处设置表示距离底部上拉控件顶部n*44高度800即提前加载数据
    footer.triggerAutomaticallyRefreshPercent = -880.f/44.f;
    footer.stateLabel.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    footer.stateLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
    self.shopCollectionView.mj_footer = footer;
    
    return YES;
}
//修改商铺提前加载高度
-(void)updateFooterPreloadingHeight:(CGFloat)preloadingHeight
{
    if (self.shopCollectionView.mj_footer) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.shopCollectionView.mj_footer;
        footer.triggerAutomaticallyRefreshPercent = -preloadingHeight/44.f;
    }
}
-(void)requestNextPageShopData
{
    NSLog(@"jl__上啦加载%ld页",_pageNumShop+1);

    NSInteger curryMaoYiType = [self.arrayTitleShop indexOfObject:self.maoyileixingBtn.titleLabel.text];
    NSInteger curry_authStatus = [_arrayTitleAuthStatus indexOfObject:self.shangpuAuthStatusBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    NSString *currySubmarketIdFilter = self.shopScreenVC.currySubmarketIdFilter;

    self.shangpushaixuanBackView.userInteractionEnabled = NO;
    
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchShopURLWithPageNo:_pageNumShop+1 pageSize:singlePageCount searchKeyword:self.searchKeyword sellChannel:curryMaoYiType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter authStatus:curry_authStatus_fan  success:^(id data) {
        
        self.shangpushaixuanBackView.userInteractionEnabled = YES;
        [self.shopCollectionView.mj_footer endRefreshing];
        
        [self.arrayShop addObjectsFromArray:data];
        [self.shopCollectionView reloadData];
        
        //后面没数据了,去掉组尾
        _pageNumShop ++;
        if ([data count]<singlePageCount)
        {
            self.shopCollectionView.mj_footer = nil;
        }else{
            [self updateFooterPreloadingHeight:1600.f];
        }
    } failure:^(NSError *error) {
        self.shangpushaixuanBackView.userInteractionEnabled = YES;
        [self.shopCollectionView.mj_footer endRefreshing];
        
        [self updateFooterPreloadingHeight:0];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}

#pragma mark - collectionView代理方法
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayShop.count;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}
//计算商铺所需宽度
-(CGFloat)jl_SizeShopHeightWithStr:(NSString*)str
{
    CGRect rect = [str boundingRectWithSize:CGSizeMake(LCDW-30.f, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil];
    CGFloat height = rect.size.height;
    if (height > 18.f ) {
        return 36.f;
    }
    return 18.f;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    SearchShopModel* model = self.arrayShop[indexPath.row];
    CGFloat zhuyingLabel_H = [self jl_SizeShopHeightWithStr:model.mainSell];
    CGFloat pohotoView_H =model.products.count>0? -108.f+(LCDW-10.f*3-20.f)/3.f+1.f : -108.f+1.f;
    return CGSizeMake(LCDW, 253.f-36.f+zhuyingLabel_H+pohotoView_H);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchDetailShangPuCollViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ShangPu" forIndexPath:indexPath];
    SearchShopModel* model = self.arrayShop[indexPath.row];
    [cell setShopCellData:model];
    cell.photosView.delegate = self;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    SearchShopModel* model = self.arrayShop[indexPath.row];
    [self pushShopHtmlWithId:model.iid baseUrl:model.link];
}
#pragma mark - UIScrollView delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.dragging && self.delegate && [self.delegate respondsToSelector:@selector(jl_scrollViewDidScrollWithMoveUp:)])
    {
        CGPoint translation = [scrollView.panGestureRecognizer translationInView:scrollView.superview];
        if (translation.y > 30.f) { //触摸移动向下30.f
            [self.delegate jl_scrollViewDidScrollWithMoveUp:NO];
        }
        if (translation.y< -100.f) { //触摸移动向上100.f
            [self.delegate jl_scrollViewDidScrollWithMoveUp:YES];
        }
    }
}
#pragma mark - 点击商铺中产品图片delegate
-(void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos
{
    NSIndexPath *indexPath = [photosView jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:self.shopCollectionView];
    
    SearchShopModel* model = self.arrayShop[indexPath.row];
    SearchShopProductsModel* productModel =  model.products[index];
    
    [self pushProductHtmlWithId:productModel.iid baseUrl:productModel.link];
}
#pragma mark - 产品认证、商铺认证、商铺贸易类型--
-(void)jl_wySelectedTableView:(WYSelectedTableView *)wyselectedTableView type:(WYSelectedTableViewType)type didSelectWithInteget:(NSInteger)integer changed:(BOOL)changed
{
    if (type == SelectedTableView_shop_renzheng) {    //商铺认证
        [self.shangpuAuthStatusBtn setTitle:_arrayTitleAuthStatus[integer] forState:UIControlStateNormal];
        [self.shangpuAuthStatusBtn setTitle:_arrayTitleAuthStatus[integer] forState:UIControlStateSelected];
    }
    
    if (type == SelectedTableView_shop_maoyileixing) { //商铺贸易类型
        [self.maoyileixingBtn setTitle:_arrayTitleShop[integer] forState:UIControlStateNormal];
        [self.maoyileixingBtn setTitle:_arrayTitleShop[integer] forState:UIControlStateSelected];
    }
    
    if (changed) {
        self.shopScreenVC = nil; //切换认证后重置筛选
        self.shichangquyuLookBtn.selected = NO; //无筛选条件状态
        
        [self requestaDatare_RemoveCurryTypeSourceData];
    }
}
-(void)jl_wySelectedTableViewViewWillRemove:(WYSelectedTableView *)wyselectedTableView type:(WYSelectedTableViewType)type
{
    if (type == SelectedTableView_shop_renzheng) {    //商铺认证
        self.shangpuAuthStatusBtn.selected = NO;
    }
    if (type == SelectedTableView_shop_maoyileixing) { //商铺贸易类型
        self.maoyileixingBtn.selected = NO;
    }
}
#pragma mark - 筛选代理
//筛选点击”完成“按钮代理
-(void)jl_SearchDetailScreenControllerTouchCompleteButton:(SearchDetailScreenController*)vc
{
    [self requestaDatare_RemoveCurryTypeSourceData];
}
//移除视图操作代理（完成、取消、点击背景dissmiss）
-(void)jl_SearchDetailScreenControllerWillRemove:(SearchDetailScreenController*)vc
{
    //有筛选条件时，选中字体颜色样式不一样
    self.shichangquyuLookBtn.selected = vc.isHaveData;
}
#pragma mark - 网络失败氛围图
- (void)zxEmptyViewUpdateAction
{
    [self requsetSearchShopData];
}
//认证条件改变、筛选时重新获取数据
- (void)requestaDatare_RemoveCurryTypeSourceData
{
    [self.arrayShop removeAllObjects];
    [self.shopCollectionView reloadData];
    
    self.shopCollectionView.mj_footer = nil;
    [self requsetSearchShopData];
}

#pragma mark - =========
#pragma mark - 跳转产品详情
- (void)pushProductHtmlWithId:(NSString*)iid baseUrl:(NSString *)baseUrl
{
    NSString *url = [baseUrl stringByReplacingOccurrencesOfString:@"{productId}" withString:iid];
    [self pushToWebViewController:url];
}
#pragma mark - 跳转商铺详情
-(void)pushShopHtmlWithId:(NSString*)iid baseUrl:(NSString *)baseUrl
{
    NSString *url = [baseUrl stringByReplacingOccurrencesOfString:@"{shopId}" withString:iid];
    [self pushToWebViewController:url];
}
#pragma mark 跳转h5界面
-(void)pushToWebViewController:(NSString*)webUrl
{
    [WYUTILITY routerWithName:webUrl withSoureController:self];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    NSLog(@"jl__SearchShopDetailController delloc");
}
#pragma mark 懒加载氛围图
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyViewController = [[ZXEmptyViewController alloc] init];
        emptyViewController.delegate = self;
        emptyViewController.contentOffest = CGSizeMake(0, 45);//为了在小手机正常显示
        _emptyViewController = emptyViewController;
    }return _emptyViewController;
}

-(void)removeWYSelectedTableViewIfNeed
{
    //收起选择(已认证，未认证等)
    if (self.maoyileixingBtn.selected) {
        [self maoyileixingClick:self.maoyileixingBtn];
    }
    //或者 收起选择(贸易类型，内贸为主，外贸等)
    if (self.shangpuAuthStatusBtn.selected) {
        [self shangpuAuthStatusBtnClick:self.shangpuAuthStatusBtn];
    }
}
#pragma mark - 商铺认证类型《已认证》
- (IBAction)shangpuAuthStatusBtnClick:(UIButton *)sender {
    //收起选择(已认证，未认证等)
    if (self.maoyileixingBtn.selected) {
        [self maoyileixingClick:self.maoyileixingBtn];
    }
    
    if (self.selectedTableView.superview) {
        [self.selectedTableView removeFromSuperview];
        sender.selected = NO;
    }else{
        sender.selected = YES;

        WYSelectedTableView* selView = [[WYSelectedTableView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(self.shopCollectionView.frame), LCDW, CGRectGetHeight(self.view.frame)-CGRectGetMinY(self.shopCollectionView.frame))  WithArray:_arrayTitleAuthStatus];
        selView.DefaultSelectedTitle = self.shangpuAuthStatusBtn.titleLabel.text;
        selView.type = SelectedTableView_shop_renzheng;
        self.selectedTableView = selView;
        self.selectedTableView.delegate = self;
        [self.view addSubview:self.selectedTableView];
//        [self.selectedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.shangpushaixuanBackView.mas_bottom);
//            make.left.mas_equalTo(self.view);
//            make.right.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(self.view);
//        }];
    }
}

#pragma mark - 贸易类型
- (IBAction)maoyileixingClick:(UIButton *)sender {
    //收起选择(贸易类型，内贸为主，外贸等)
    if (self.shangpuAuthStatusBtn.selected) {
        [self shangpuAuthStatusBtnClick:self.shangpuAuthStatusBtn];
    }
    
    if (self.selectedTableView.superview) {
        [self.selectedTableView removeFromSuperview];
        sender.selected = NO;
    }else{
        sender.selected = YES;

        WYSelectedTableView* selView = [[WYSelectedTableView alloc] initWithFrame:CGRectMake(0,CGRectGetMinY(self.shopCollectionView.frame), LCDW, CGRectGetHeight(self.view.frame)-CGRectGetMinY(self.shopCollectionView.frame))  WithArray:_arrayTitleShop];
        selView.DefaultSelectedTitle = self.maoyileixingBtn.titleLabel.text;
        selView.type = SelectedTableView_shop_maoyileixing;
        self.selectedTableView = selView;
        self.selectedTableView.delegate = self;
        [self.view addSubview:self.selectedTableView];
//        [self.selectedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.shangpushaixuanBackView.mas_bottom);
//            make.left.mas_equalTo(self.view);
//            make.right.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(self.view);
//        }];
    }
}

#pragma mark - 按市场区域查看
- (IBAction)shichangquyuClick:(UIButton *)sender {
    //收起选择(已认证，未认证等)
    if (self.maoyileixingBtn.selected) {
        [self maoyileixingClick:self.maoyileixingBtn];
    }
    //收起选择(贸易类型，内贸为主，外贸等)
    if (self.shangpuAuthStatusBtn.selected) {
        [self shangpuAuthStatusBtnClick:self.shangpuAuthStatusBtn];
    }
    
    [self presentViewController:self.shopScreenVC animated:NO completion:nil];
}
- (SearchDetailScreenController *)shopScreenVC
{
    if (!_shopScreenVC) {
        SearchDetailScreenController *vc = [[SearchDetailScreenController alloc] init];
        vc.searchKeyword = self.searchKeyword;
        vc.keywordType = self.keywordType;
        vc.catId  = self.catId;
        vc.type = 1;
        vc.delegate = self;
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        _shopScreenVC = vc;
    }
    NSInteger curry_authStatus = [self.arrayTitleAuthStatus indexOfObject:self.shangpuAuthStatusBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    _shopScreenVC.authStatus = curry_authStatus_fan;
    return _shopScreenVC;
}


-(void)setEmptyViewControllerAttributedText:(BOOL)show
{
    if (!show) {
        if (_emptyViewController) {
           UIView *view =  [_emptyViewController.view viewWithTag:8866];
            [view removeFromSuperview];
        }
    }
    else
    {
        [self.emptyViewController.view layoutIfNeeded];
        UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0,self.emptyViewController.label.frame.origin.y, 280, 35)];
        textView.zx_centerX = self.emptyViewController.label.center.x;
        textView.editable = NO;
        textView.delegate = self;
        textView.tag = 8866;
        [self.emptyViewController.label.superview addSubview:textView];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@"   没有找到相关商铺，试试发布求购 >"];
        NSRange rangeAll = NSMakeRange(0, [attributedString string].length);
        NSRange range = [[attributedString string] rangeOfString:@"试试发布求购 >"];
        UIFont *font = [UIFont systemFontOfSize:14.f];
        
        [attributedString addAttribute:NSFontAttributeName value:font range:rangeAll];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#B1B1B1"] range:rangeAll];
        [attributedString addAttribute:NSLinkAttributeName value:@"microants://" range:range];
        
        // 修改超链接文字的颜色
        textView.linkTextAttributes = @{
                                        NSForegroundColorAttributeName:[UIColor colorWithHexString:@"7BBFED"],
                                        };
        textView.attributedText = attributedString;
        
    }
}
-(BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange
{
    if ([[URL scheme] isEqualToString:@"microants"]){
        NSLog(@"microants---------------试试发布求购 >");
        [self fabuqiugou];
        return NO;
    }
    return YES;
}
#pragma mark - 商铺氛围图按钮:试试发布求购 >
- (void)fabuqiugou
{
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPurchaseForm;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPurchaseForm withSoureController:self];
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
