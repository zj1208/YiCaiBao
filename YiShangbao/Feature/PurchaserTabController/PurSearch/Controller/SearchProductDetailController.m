//
//  SearchProductDetailController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SearchProductDetailController.h"

#import "SearchDetailViewController.h"

#import "SearchModel.h"
#import "WYSelectedTableView.h"
#import "SearchDetailScreenController.h"

#import "SearchDetailDefaultCollViewCell.h"
#import "SearchDetailAllLCDWCollViewCell.h"
#import "SearchDetailHeBingCollectionViewCell.h"


@interface SearchProductDetailController ()<UICollectionViewDelegate,UICollectionViewDataSource,WYSelectedTableViewDelegate,SearchDetailScreenControllerDelegate,ZXPhotosViewDelegate,ZXEmptyViewControllerDelegate>

@property(nonatomic, assign)SearchDetailCellType curryType;

@property(nonatomic,strong) NSArray* arrayTitleAuthStatus ;//@[@"已认证",@"未认证"]
@property(nonatomic,strong) NSMutableArray* arrayProduct;
@property(nonatomic,strong) NSMutableArray* arrayProductHeBing;

//请求id，pageNo为1的情况可以为空，pageNo大于1的情况必须设置为前一次请求返回来的responseId
@property(nonatomic,strong)NSString *requestId;

//当前页数
@property(nonatomic,assign)NSInteger pageNumProduct;
@property(nonatomic,assign)NSInteger pageNumHeBingSame;

@property (nonatomic, weak) WYSelectedTableView* selectedTableView;  //@[@"已认证",@"未认证"] 选择View

@property(nonatomic,strong) SearchDetailScreenController *productScreenVC;//产品筛选器
@property(nonatomic,strong) ZXEmptyViewController* emptyViewController; //氛围图

@end

static NSString* const UDSearchDetailCellType = @"UDSearchDetailCellType";//用户上次选中cell样式
static NSInteger singlePageCount = 15;//分页每页个数

@implementation SearchProductDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorWithHexString:@"FAFAFA"];

    //1.获取并初始化用户上次选择Cell样式
    [self getLastSearchDetailCellType];
    
    //初始化数据
    [self setData];
    //初始化UI
    [self buildUI];
    
    //2.请求搜索产品数据
    [self requsetSearchDataWithType:self.curryType];
   
}
- (void)setData
{
    _pageNumProduct = 1;
    _pageNumHeBingSame = 1;

    self.arrayTitleAuthStatus = @[@"已认证",@"未认证"];    
    self.arrayProduct = [NSMutableArray array];
    self.arrayProductHeBing = [NSMutableArray array];
    

}
#pragma mark - 获取用户上次选择样式(参数存储:@"0"/@"1")
-(void)getLastSearchDetailCellType
{
    NSString* CellType =  [[NSUserDefaults standardUserDefaults] objectForKey:UDSearchDetailCellType];
    if (!CellType)
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:UDSearchDetailCellType];
        [[NSUserDefaults standardUserDefaults] synchronize];
        self.curryType = SearchDetailCellTypeAllLCDStyle;
        self.styleqiehuan.selected = self.curryType;
    }
    else
    {
        self.curryType = CellType.integerValue;
        self.styleqiehuan.selected = self.curryType;
    }
}
- (void)buildUI
{
    [_productCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailDefaultCollViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"HALFLCDW"];
    [_productCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailAllLCDWCollViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"AllLCDW"];
    [_productCollectionView registerNib:[UINib nibWithNibName:@"SearchDetailHeBingCollectionViewCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:@"hebing"];
    
    //设置产品默认《已认证》
    [self.renzhengBtn setTitle:_arrayTitleAuthStatus.firstObject forState:UIControlStateNormal];
    [self.renzhengBtn setTitle:_arrayTitleAuthStatus.firstObject forState:UIControlStateSelected];
}

#pragma mark - *********************请求数据**************
#pragma mark 请求产品搜索数据
//@param pageNo 第几页，未设置的情况默认第一页
//@param pageSize 每页几条，未设置的情况默认每页十条
//@param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
//@param productSourceType 产品货源类型 0-全部 1-现货 2-订做  >>筛选条件
//@param keywordType 关键词类型 0-搜索 1-类目 2-产品（猜你想找）
//@param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
//@param submarketIdFilter 筛选条件 所在市场id，多个筛选条件用逗号分隔，可为空
//@param catIdFilter 筛选条件 类目id，多个筛选条件用逗号分隔，可为空
//@param authStatus    认证状态 0-未认证 1-已认证，未设置的情况默认为1
-(void)requsetSearchDataWithType:(SearchDetailCellType)type
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    self.curryType = type;

    NSInteger  curry_authStatus = [_arrayTitleAuthStatus indexOfObject:self.renzhengBtn.titleLabel.text];
    NSInteger  curry_authStatus_fan = curry_authStatus ==0?1:0; //取反(后台与UI展示逻辑刚好相反)，后台1表示已认证，0未认证
    NSInteger productSourceType = self.productScreenVC.productSourceType;
    NSString *currySubmarketIdFilter = self.productScreenVC.currySubmarketIdFilter;
    NSString *curryCatIdFilter = self.productScreenVC.curryCatIdFilter;
    
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchProductWithPageNo:1 pageSize:singlePageCount searchKeyword:self.searchKeyword productSourceType:productSourceType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter catIdFilter:curryCatIdFilter authStatus:curry_authStatus_fan requestId:nil success:^(id data) {
        
        NSLog(@"JL__产品第一页");
        self.productCollectionView.backgroundColor = [UIColor whiteColor];
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController hideEmptyViewInController:self];
        
        _pageNumProduct = 1;
        SearchProMainModel *model = (SearchProMainModel *)data;
        self.requestId = model.responseId;
        self.arrayProduct = [NSMutableArray arrayWithArray:model.products];
        [self.productCollectionView reloadData];

        if (self.arrayProduct.count == 0) {
            [self moveCustomNavigationBarDownWhenNeed];
            self.emptyViewController.view.frame = self.productCollectionView.frame;
            [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:[UIImage imageNamed:@"searchproductempty"] emptyTitle:@"没有找到相关产品~" updateBtnHide:YES];
        }
        
        [self footerWithProductRefreshing];//根据数组是否有值来是否加载、移除mj_footer
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [self moveCustomNavigationBarDownWhenNeed];
        self.emptyViewController.view.frame = self.productCollectionView.frame;
        [self.emptyViewController addEmptyViewInController:self hasLocalData:self.arrayProduct.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
#pragma mark - 请求合并相同商家搜索数据
-(void)requsetSearchHeBingShangJiaDataWithType:(SearchDetailCellType)type
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    self.curryType = type;

    NSInteger curry_authStatus = [_arrayTitleAuthStatus indexOfObject:self.renzhengBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    NSInteger productSourceType = self.productScreenVC.productSourceType;
    NSString *currySubmarketIdFilter = self.productScreenVC.currySubmarketIdFilter;
    NSString *curryCatIdFilter = self.productScreenVC.curryCatIdFilter;
    
    [[[AppAPIHelper shareInstance] getSearchAPI] getSearchProductByShopWithPageNo:1 pageSize:singlePageCount searchKeyword:self.searchKeyword productSourceType:productSourceType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter catIdFilter:curryCatIdFilter authStatus:curry_authStatus_fan success:^(id data) {
        
        NSLog(@"JL__合并商家第一页");
        self.productCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
        [MBProgressHUD zx_hideHUDForView:self.view];
        [_emptyViewController hideEmptyViewInController:self];

        _pageNumHeBingSame = 1;
        self.arrayProductHeBing = [NSMutableArray arrayWithArray:data];
        [self.productCollectionView reloadData];
        
        if (self.arrayProductHeBing.count==0) {
            [self moveCustomNavigationBarDownWhenNeed];
            self.emptyViewController.view.frame = self.productCollectionView.frame;
            [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:[UIImage imageNamed:@"searchproductempty"] emptyTitle:@"没有找到相关产品~" updateBtnHide:YES];
        }

        [self footerWithProductRefreshing];//根据数组是否有值来是否加载、移除mj_footer
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [self moveCustomNavigationBarDownWhenNeed];
        self.emptyViewController.view.frame = self.productCollectionView.frame;
        [self.emptyViewController addEmptyViewInController:self hasLocalData:self.arrayProductHeBing.count>0?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
- (void)moveCustomNavigationBarDownWhenNeed
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_scrollViewDidScrollWithMoveUp:)])
    {
        [self.delegate jl_scrollViewDidScrollWithMoveUp:NO];
    }
}
#pragma mark 产品
- (BOOL)footerWithProductRefreshing
{
    if (self.hebingshangjiaBtn.selected) {
        if (self.arrayProductHeBing.count<singlePageCount)
        {
            if (self.productCollectionView.mj_footer)
            {
                self.productCollectionView.mj_footer = nil;
            }
            return NO;
        }
    }else{
        if (self.arrayProduct.count<singlePageCount)
        {
            if (self.productCollectionView.mj_footer)
            {
                self.productCollectionView.mj_footer = nil;
            }
            return NO;
        }
    }

    WS(weakSelf);
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestNextPageData];
    }];
    //控制底部控件(默认高度44)出现百分比(0.0-1.0,默认1.0)来预加载，此处设置负数表示距离底部"上拉控件顶部"一定高度660.f即提前加载数据
    footer.triggerAutomaticallyRefreshPercent = -660.f/44.f;
    footer.stateLabel.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    footer.stateLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
    self.productCollectionView.mj_footer = footer;
    
    return YES;
}
//修改产品提前加载高度
//修改成更大提前量，第一页设置就设置这么大的话，从右边指示条会感觉刚滑动几个产品就请求了下一页体验差点，所以第一页设置小点给一种滑到最后几个提前加载的感觉,第2页开始就不用担心这个问题（感觉就这样设计提前预加载比较麻烦，还是抽空想想怎么封装预加载好点，考虑是否可以将预请求和reload分开，请求成功不一定要立即去刷新等拉到底部再去刷新）
-(void)updateFooterPreloadingHeight:(CGFloat)preloadingHeight
{
    if (self.productCollectionView.mj_footer) {
        MJRefreshAutoNormalFooter *footer = (MJRefreshAutoNormalFooter *)self.productCollectionView.mj_footer;
        footer.triggerAutomaticallyRefreshPercent = -preloadingHeight/44.f;
    }
}
-(void)requestNextPageData
{
    NSInteger curry_authStatus = [self.arrayTitleAuthStatus indexOfObject:self.renzhengBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    
    NSInteger productSourceType = self.productScreenVC.productSourceType;
    NSString *currySubmarketIdFilter = self.productScreenVC.currySubmarketIdFilter;
    NSString *curryCatIdFilter = self.productScreenVC.curryCatIdFilter;
    
    self.chanpinshaixuanBackView.userInteractionEnabled = NO;

    if (self.hebingshangjiaBtn.selected) {  //合并相同商家
        NSLog(@"JL__合并商家上拉加载第%ld页",_pageNumHeBingSame+1);
        
        [[[AppAPIHelper shareInstance] getSearchAPI] getSearchProductByShopWithPageNo:_pageNumHeBingSame+1 pageSize:singlePageCount searchKeyword:self.searchKeyword productSourceType:productSourceType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter catIdFilter:curryCatIdFilter authStatus:curry_authStatus_fan success:^(id data) {
            
            self.chanpinshaixuanBackView.userInteractionEnabled = YES;
            [self.productCollectionView.mj_footer endRefreshing];
            
            [self.arrayProductHeBing addObjectsFromArray:data];
            [self.productCollectionView reloadData];
            
            _pageNumHeBingSame ++;
            if ([data count]<singlePageCount)
            {   //后面没数据了,去掉组尾
                self.productCollectionView.mj_footer = nil;
            }
            else
            {   //第二页开始修改成更大提前量
                [self updateFooterPreloadingHeight:1400.f];
            }
        } failure:^(NSError *error) {
            self.chanpinshaixuanBackView.userInteractionEnabled = YES;
            [self.productCollectionView.mj_footer endRefreshing];
            
            //请求失败了修改提前量,eg:请求第一页后关闭网络，由于提前加载会陆续多次进入上拉，多次toast提示
            [self updateFooterPreloadingHeight:0.f];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        }];
        
    }else{
        NSLog(@"JL__产品上拉加载第%ld页",_pageNumProduct+1);
        
        [[[AppAPIHelper shareInstance] getSearchAPI] getSearchProductWithPageNo:_pageNumProduct+1 pageSize:singlePageCount searchKeyword:self.searchKeyword productSourceType:productSourceType keywordType:self.keywordType catId:self.catId submarketIdFilter:currySubmarketIdFilter catIdFilter:curryCatIdFilter authStatus:curry_authStatus_fan requestId:self.requestId success:^(id data){
            
            self.chanpinshaixuanBackView.userInteractionEnabled = YES;
            [self.productCollectionView.mj_footer endRefreshing];
            
            SearchProMainModel *model = (SearchProMainModel *)data;
            self.requestId = model.responseId;
            
            [self.arrayProduct addObjectsFromArray:model.products];
            [self.productCollectionView reloadData];
            
            _pageNumProduct ++;
            if ([model.products count]<singlePageCount)
            {   //后面没数据了,去掉组尾
                self.productCollectionView.mj_footer = nil;
            }
            else
            {   //第二页开始修改成更大提前量
                [self updateFooterPreloadingHeight:1400.f];
            }
        } failure:^(NSError *error) {
            self.chanpinshaixuanBackView.userInteractionEnabled = YES;
            [self.productCollectionView.mj_footer endRefreshing];
            
            //请求失败了修改提前量,eg:请求第一页后关闭网络，由于提前加载会陆续多次进入上拉，多次toast提示
            [self updateFooterPreloadingHeight:0];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        }];
    }
}
#pragma mark - collectionView代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.curryType == SearchDetailCellTypeHeBingStyle) {
        return self.arrayProductHeBing.count;
    }else{
        return self.arrayProduct.count;
    }
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (self.curryType == SearchDetailCellTypeHalfStyle)
    {
        return UIEdgeInsetsMake(10, 10, 0, 10);
    }
    else{
        return UIEdgeInsetsZero;
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (self.curryType == SearchDetailCellTypeHalfStyle )
    {
        return 10;
    }
    else if (self.curryType == SearchDetailCellTypeHeBingStyle)
    {
        return 10;
    }
    else{
        return 0;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.curryType == 0)
    {
        return CGSizeMake(LCDW, 118.f);
    }
    else if (self.curryType == 1)
    {
        return CGSizeMake((LCDW-10*3)/2.f, (LCDW-30)/2.f+98.f);
    }
    else if (self.curryType == 2)
    {
        SearchShopModel* model = self.arrayProductHeBing[indexPath.row];
        CGFloat pohotoView_H =model.products.count>0? -108.f+(LCDW-10.f*3-20.f)/3.f+1.f :-108.f+1.f;
        return CGSizeMake(LCDW, 241.f+pohotoView_H);
    }
    return CGSizeZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.curryType == SearchDetailCellTypeHalfStyle)
    {
        SearchDetailDefaultCollViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"HALFLCDW" forIndexPath:indexPath];
        SearchModel* model = self.arrayProduct[indexPath.row];
        [cell setHalfLCDWCellData:model];
        return cell;
    }
    else if (self.curryType == SearchDetailCellTypeHeBingStyle)
    {
        SearchDetailHeBingCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"hebing" forIndexPath:indexPath];
        SearchShopModel* model = self.arrayProductHeBing[indexPath.row];
        [cell setHeBingCellData:model];
        cell.photosView.delegate = self;
        return cell;
    }
    else
    {
        SearchDetailAllLCDWCollViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AllLCDW" forIndexPath:indexPath];
        SearchModel* model = self.arrayProduct[indexPath.row];
        [cell setAllLCDWCellData:model];
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.curryType == SearchDetailCellTypeHeBingStyle)
    { //合并相同商家
        SearchShopModel* model = self.arrayProductHeBing[indexPath.row];
        [self pushShopHtmlWithId:model.iid baseUrl:model.link];
    }else{
        SearchModel* model = self.arrayProduct[indexPath.row];
        [self pushProductHtmlWithId:model.iid baseUrl:model.link];
    }
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
#pragma mark - 点击合并相同商家、商铺中产品图片delegate
-(void)zx_photosView:(ZXPhotosView *)photosView didSelectWithIndex:(NSInteger)index photosArray:(NSArray *)photos
{
    //合并相同商家-产品图片
    NSIndexPath *indexPath = [photosView jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:self.productCollectionView];
    
    SearchShopModel* model = self.arrayProductHeBing[indexPath.row];
    SearchShopProductsModel* productModel =  model.products[index];
    
    [self pushProductHtmlWithId:productModel.iid baseUrl:productModel.link];
}
#pragma mark - 已认证、未认证
-(void)jl_wySelectedTableView:(WYSelectedTableView *)wyselectedTableView type:(WYSelectedTableViewType)type didSelectWithInteget:(NSInteger)integer changed:(BOOL)changed
{
    [self.renzhengBtn setTitle:_arrayTitleAuthStatus[integer] forState:UIControlStateNormal];
    [self.renzhengBtn setTitle:_arrayTitleAuthStatus[integer] forState:UIControlStateSelected];
    
    if (changed) {
        //改变认证条件后清空筛选条件
        self.productScreenVC = nil;
        self.shaixuanBtn.selected = NO; //无筛选条件UI状态
        
        [self requestaDatare_RemoveCurryTypeSourceData];
    }
}
//选择器移除代理
-(void)jl_wySelectedTableViewViewWillRemove:(WYSelectedTableView *)wyselectedTableView type:(WYSelectedTableViewType)type
{
    self.renzhengBtn.selected = NO;
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
    self.shaixuanBtn.selected = vc.isHaveData;
}

#pragma mark - 网络失败氛围图
-(void)zxEmptyViewUpdateAction
{
    if (self.hebingshangjiaBtn.selected) {
        [self requsetSearchHeBingShangJiaDataWithType:self.curryType];
    }else{
        [self requsetSearchDataWithType:self.curryType];
    }
}
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
    NSLog(@"jl__SearchProductDetailController delloc");
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
//切换合并相同商家状态
- (void)requestaData_RemoveLastTypeSourceData
{
    if (self.hebingshangjiaBtn.selected) {
        [self.arrayProduct removeAllObjects];
        [self.productCollectionView reloadData];
       
        self.productCollectionView.mj_footer = nil;
        self.productCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
        [self requsetSearchHeBingShangJiaDataWithType:SearchDetailCellTypeHeBingStyle];
    }else{
        [self.arrayProductHeBing removeAllObjects];
        [self.productCollectionView reloadData];
       
        self.productCollectionView.mj_footer = nil;
        self.productCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
        NSString* curryTypeStr = [[NSUserDefaults standardUserDefaults] objectForKey:UDSearchDetailCellType];
        [self requsetSearchDataWithType:curryTypeStr.integerValue];
    }
}
//认证条件改变、筛选时重新获取数据
- (void)requestaDatare_RemoveCurryTypeSourceData
{
    if (self.hebingshangjiaBtn.selected) {
        [self.arrayProductHeBing removeAllObjects];
        [self.productCollectionView reloadData];
       
        self.productCollectionView.mj_footer = nil;
        self.productCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
        [self requsetSearchHeBingShangJiaDataWithType:SearchDetailCellTypeHeBingStyle];
    }else{
        [self.arrayProduct removeAllObjects];
        [self.productCollectionView reloadData];
        
        self.productCollectionView.mj_footer = nil;
        self.productCollectionView.backgroundColor = [WYUISTYLE colorWithHexString:@"f3f3f3"];
        NSString* curryTypeStr = [[NSUserDefaults standardUserDefaults] objectForKey:UDSearchDetailCellType];
        [self requsetSearchDataWithType:curryTypeStr.integerValue];
    }
}
#pragma mark - =========actions===========
#pragma mark - 产品-已认证
- (IBAction)renzhengBtnClick:(UIButton*)sender
{
    if (self.selectedTableView.superview) {
        self.renzhengBtn.selected = NO;
        [self.selectedTableView removeFromSuperview];
    }else{
        self.renzhengBtn.selected = YES;

        WYSelectedTableView* selView = [[WYSelectedTableView alloc] initWithFrame:CGRectMake(0, CGRectGetMinY(self.productCollectionView.frame),LCDW, CGRectGetHeight(self.view.frame)-CGRectGetMinY(self.productCollectionView.frame)) WithArray:_arrayTitleAuthStatus];
        selView.DefaultSelectedTitle = self.renzhengBtn.titleLabel.text;
        self.selectedTableView = selView;
        self.selectedTableView.delegate = self;
        [self.view addSubview:self.selectedTableView];
//        [self.selectedTableView mas_remakeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.chanpinshaixuanBackView.mas_bottom);
//            make.left.mas_equalTo(self.view);
//            make.right.mas_equalTo(self.view);
//            make.bottom.mas_equalTo(self.view);
//        }];
    }
}
-(void)removeWYSelectedTableViewIfNeed
{
    //收起选择(已认证，未认证等)
    if (self.renzhengBtn.selected) {
        [self renzhengBtnClick:self.renzhengBtn];
    }
}
#pragma mark - 合并相同商家
- (IBAction)hebingSameBtnClick:(UIButton*)sender
{
    sender.selected = !sender.selected;
    //重新获取数据
    [self requestaData_RemoveLastTypeSourceData];
    
    //合并相同商家时不允许切换cell样式
    if (sender.selected) {
        self.styleqiehuan.userInteractionEnabled = NO;
        self.styleqiehuan.alpha = 0.3;//不用enabled是enabled只显示UIControlStateNormal下图片
    }else{
        self.styleqiehuan.userInteractionEnabled = YES;
        self.styleqiehuan.alpha = 1;
    }
    
    //收起选择(已认证，未认证等)
    if (self.renzhengBtn.selected) {
        [self renzhengBtnClick:self.renzhengBtn];
    }
}
#pragma mark - 样式切换
- (IBAction)styleqiehuanBtnClick:(UIButton*)sender {
    
    if (!self.hebingshangjiaBtn.selected) {
        
        sender.selected = !sender.selected;
        self.curryType = sender.selected;
        [self.productCollectionView reloadData];
        
        //存储用户上次选择样式
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%ld",self.curryType] forKey:UDSearchDetailCellType];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    //收起选择(已认证，未认证等)
    if (self.renzhengBtn.selected) {
        [self renzhengBtnClick:self.renzhengBtn];
    }
}

#pragma mark - 筛选
- (IBAction)ShaixuanBtnClick:(UIButton *)sender {
    
    //收起选择(已认证，未认证等)
    if (self.renzhengBtn.selected) {
        [self renzhengBtnClick:self.renzhengBtn];
    }
    
    [self presentViewController:self.productScreenVC animated:NO completion:nil];
}
- (SearchDetailScreenController *)productScreenVC
{
    if (!_productScreenVC) {
        SearchDetailScreenController *vc = [[SearchDetailScreenController alloc] init];
        vc.searchKeyword = self.searchKeyword;
        vc.keywordType = self.keywordType;
        vc.catId  = self.catId;
        vc.type = 0;
        vc.delegate = self;
        [vc setModalPresentationStyle:UIModalPresentationOverCurrentContext];
        _productScreenVC = vc;
    }
    NSInteger curry_authStatus = [self.arrayTitleAuthStatus indexOfObject:self.renzhengBtn.titleLabel.text];
    NSInteger curry_authStatus_fan = curry_authStatus ==0?1:0; //取反，后台1表示已认证，0未认证
    _productScreenVC.authStatus = curry_authStatus_fan;
    return _productScreenVC;
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
