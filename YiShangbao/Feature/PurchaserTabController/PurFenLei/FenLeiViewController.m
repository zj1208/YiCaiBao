//
//  FenLeiViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FenLeiViewController.h"

#import "UICollectionViewLeftAlignedLayout.h"

#import "FenLeiTableViewCell.h"

#import "FenLeiTitleCollectionReusableView.h"
#import "FenLeiTitleCell.h"
#import "FenLeiLunBoCell.h"
#import "FenLeiHotSysCateCell.h"

#import "SearchDetailViewController.h"
#import "SearchViewController.h"
#import "ZXEmptyViewController.h"
#import "MessageModel.h"

#import "PurClassifyModel.h"


@interface FenLeiViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource,ZXEmptyViewControllerDelegate,JLCycleScrollerViewDatasource,JLCycleScrollerViewDelegate,SearchViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)UICollectionViewLeftAlignedLayout* flowLayout;

@property(nonatomic,strong)NSMutableArray* arrayTableViewData;  //一级类目
@property(nonatomic,strong)NSArray* arrayCollectionViewHeaderData; //二级类目
@property(nonatomic,strong)NSMutableArray* arrayCollectionViewData; //三级类目（二维数组）
@property(nonatomic,assign)NSInteger curryCount;//按照二级请求类目请求三级类目，当前请求成功个数

@property(nonatomic,strong)ZXEmptyViewController* emptyViewController;

@property(nonatomic,strong)NSMutableArray* arrayLunboData; //分类顶部轮播图数据源

@property(nonatomic,assign)NSInteger curryTableSelected; //tableview的cell选中section
@property(nonatomic,strong)NSIndexPath *currySelectIndexPath; //collectionView的cell选中IndexPath

@property (nonatomic, strong)SearchViewController *searchViewC;

@property (nonatomic, strong)PurClassifyModel *hotClassModel; //插入的市场推荐数据源

@end

static NSString *FenLeiTitleCellResign = @"FenLeiTitleCellResign";
static NSString *FenLeiLunBoCellResign = @"FenLeiLunBoCellResign";
static NSString *FenLeiHotSysCateCellResign = @"FenLeiHotSysCateCellResign";
static NSString *FenLeiMarketRecomedCellResign = @"FenLeiMarketRecomedCellResign";
@implementation FenLeiViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"分类查找";
    self.automaticallyAdjustsScrollViewInsets = NO;
  
    [self initData];
    [self buildUI];
    [self requestLevel_1_TableViewData];
    
}
-(void)initData
{
    _curryTableSelected = 0;
    self.arrayTableViewData = [NSMutableArray array];
    self.arrayCollectionViewData = [NSMutableArray array];
    self.arrayLunboData = [NSMutableArray array];

}
#pragma mark - 请求热门(市场)推荐
-(void)requestgetHotSysCate
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    [[[AppAPIHelper shareInstance] getSearchAPI] getHotSysCateSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        self.hotClassModel = data;
                
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.arrayCollectionViewData removeAllObjects];
        [self.collectionView reloadData];
        
        [MBProgressHUD zx_hideHUDForView:self.view];
        self.emptyViewController.view.frame = self.collectionView.frame;
        [_emptyViewController addEmptyViewInController:self hasLocalData:self.hotClassModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
#pragma mark - 请求轮播广告
-(void)requestLunBoDataWithsysCatesId:(NSString*)sysCatesId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] GetFenLeiAdvWithType:@2007 sysCatesId:sysCatesId success:^(id data) {
        self.arrayLunboData = [NSMutableArray arrayWithArray:data];
        [self.collectionView reloadData];
        
    } failure:^(NSError *error) {

    }];
}
#pragma mark 氛围图刷新代理
-(void)zxEmptyViewUpdateAction
{
    if (self.arrayTableViewData.count>0)
    {
        if (_curryTableSelected == 0) {
            [self requestgetHotSysCate];
        }else{
            SysCateModel* model = self.arrayTableViewData[_curryTableSelected];
            [self requestLevel_2_DataWithID:model.v ];
        }
    }else{
        [self requestLevel_1_TableViewData];
    }
}
#pragma mark - 请求类目数据
-(void)requestLevel_1_TableViewData
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    
    [[[AppAPIHelper shareInstance ] getSearchAPI ] getCatSysCatesURLWithId:nil level:@1 Success:^(id data) {
        self.arrayTableViewData = [NSMutableArray arrayWithArray:data];
        self.emptyViewController.view.frame = self.view.frame;
        [_emptyViewController addEmptyViewInController:self hasLocalData:self.arrayTableViewData.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:@"暂无数据" updateBtnHide:NO];
        
        if (self.arrayTableViewData.count>0) {
            //本地插入一列：市场推荐
            [self.arrayTableViewData insertObject:@"市场推荐" atIndex:0];
            [self.tableView reloadData];
            
            if (self.categroyId)
            {//指定到某个类目
                for (int i= 1; i<self.arrayTableViewData.count; ++i) { 
                    SysCateModel* model = self.arrayTableViewData[i];
                    if ([self.categroyId isEqualToNumber:model.v]){
                        _curryTableSelected = (NSInteger)i;
                        [self requestLevel_2_DataWithID:model.v];
                        break;
                    }
                }
            }
            else
            {//获取默认市场推荐
                [self requestgetHotSysCate];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{ //刷新完成后定位到某一个类目
                NSIndexPath* indexP = [NSIndexPath indexPathForRow:0 inSection:_curryTableSelected];
                [self.tableView scrollToRowAtIndexPath:indexP atScrollPosition:UITableViewScrollPositionTop animated:NO];
            });
            
        }else{
            [MBProgressHUD zx_hideHUDForView:self.view];
        }
       
    } failure:^(NSError *error) {
        [MBProgressHUD zx_hideHUDForView:self.view];

        self.emptyViewController.view.frame = self.view.frame;
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}

-(void)requestLevel_2_DataWithID:(NSNumber*)iid
{
    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
    
    [[[AppAPIHelper shareInstance ] getSearchAPI ] getCatSysCatesURLWithId:iid level:@2 Success:^(id data) {
        self.arrayCollectionViewHeaderData = [NSArray arrayWithArray:data];
        [self.arrayCollectionViewData removeAllObjects];

        if (self.arrayCollectionViewHeaderData.count>0)
        {//循环请求二级类目id对应的三级类目
            _curryCount = 0;
            SysCateModel* model = self.arrayCollectionViewHeaderData.firstObject;
            [self requestLevel_3_DataWithID:model.v];
        }
        else
        {//没有数据
            [self.collectionView reloadData];
            [MBProgressHUD zx_hideHUDForView:self.view];

            self.emptyViewController.view.frame = self.collectionView.frame;
            [_emptyViewController addEmptyViewInController:self hasLocalData:self.arrayCollectionViewHeaderData.count>0?YES:NO error:nil emptyImage:[UIImage imageNamed:@"我的接单生意为空"] emptyTitle:@"数据空空如也～" updateBtnHide:YES];
        }

        
    } failure:^(NSError *error) {
        [self.arrayCollectionViewData removeAllObjects];
        [self.collectionView reloadData];

        [MBProgressHUD zx_hideHUDForView:self.view];
        self.emptyViewController.view.frame = self.collectionView.frame;
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}
-(void)requestLevel_3_DataWithID:(NSNumber*)iid
{
    [[[AppAPIHelper shareInstance ] getSearchAPI ] getCatSysCatesURLWithId:iid level:@3 Success:^(id data) {
        NSArray* array = [NSArray arrayWithArray:data];
        [self.arrayCollectionViewData addObject:array];

        _curryCount ++;
        if (_curryCount == self.arrayCollectionViewHeaderData.count)
        {
            [MBProgressHUD zx_hideHUDForView:self.view];

            [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
          
            [self.arrayLunboData removeAllObjects];;
            [self.collectionView reloadData];

            //获取某个类的广告轮播
            SysCateModel* model = self.arrayTableViewData[_curryTableSelected];
            [self requestLunBoDataWithsysCatesId:[NSString stringWithFormat:@"%@",model.v]];

        }else{
            SysCateModel* model = self.arrayCollectionViewHeaderData[_curryCount];
            [self requestLevel_3_DataWithID:model.v];
        }

    } failure:^(NSError *error) {
        [self.arrayCollectionViewData removeAllObjects];
        [self.collectionView reloadData];

        [MBProgressHUD zx_hideHUDForView:self.view];
        self.emptyViewController.view.frame = self.collectionView.frame;
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];

    }];
}
-(void)buildUI
{
    //导航栏设置
    if (self.pushstyle == FenLeiPushDefault) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"searchfenlei_search"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(popoToSearchViewController)];
    }
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) style:UITableViewStylePlain];
    _tableView.rowHeight = 52.f*LCDW/375.f+1;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"#FAFAFA"];
    self.tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);//分割线
    self.tableView.tableFooterView=[[UIView alloc]init];//去除多余线
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    _flowLayout = [[UICollectionViewLeftAlignedLayout alloc] init];
    _flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 1, 1) collectionViewLayout:_flowLayout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor whiteColor];
//    _collectionView.alwaysBounceVertical = YES;
    [self.view addSubview:_collectionView];
    // 注册cell
    [_collectionView registerNib:[UINib nibWithNibName:@"FenLeiTitleCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:FenLeiTitleCellResign];
    [_collectionView registerNib:[UINib nibWithNibName:@"FenLeiLunBoCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:FenLeiLunBoCellResign];
    [_collectionView registerNib:[UINib nibWithNibName:@"FenLeiHotSysCateCell"bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:FenLeiHotSysCateCellResign];
    
    [_collectionView registerNib:[UINib nibWithNibName:@"FenLeiTitleCollectionReusableView" bundle: [NSBundle mainBundle]] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HeaderTitle"];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64.f);
        make.left.mas_equalTo(self.view);
        make.width.mas_equalTo(100.f*LCDW/375.f);
        make.bottom.mas_equalTo(self.view);
    }];
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_top);
        make.right.mas_equalTo(self.view);
        make.left.mas_equalTo(self.tableView.mas_right);
        make.bottom.mas_equalTo(self.tableView.mas_bottom);
    }];
    
    self.emptyViewController = [[ZXEmptyViewController alloc] init];
    self.emptyViewController.contentOffest = CGSizeMake(0, 40);
    self.emptyViewController.delegate = self;
    
}
#pragma mark - table delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.arrayTableViewData.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FenLeiTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"LEFT"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"FenLeiTableViewCell" owner:nil options:nil][0];
    }
    
    cell.curryType = FenLeiTableViewCellDefaultStyle;
    if(indexPath.section == _curryTableSelected) {
        cell.curryType = FenLeiTableViewCellSelectedStyle;
    }
    
    if (indexPath.section == 0)
    {
        cell.myTitlelabel.text = self.arrayTableViewData.firstObject;
    }
    else
    {
        SysCateModel* model = self.arrayTableViewData[indexPath.section];
        cell.myTitlelabel.text = model.n;
    }
   
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.emptyViewController hideEmptyViewInController:self hasLocalData:YES];
    _curryTableSelected = indexPath.section;
    [self.tableView reloadData];

    if (indexPath.section == 0) {
        [self requestgetHotSysCate];
    }else{
        SysCateModel* model = self.arrayTableViewData[_curryTableSelected];
        [self requestLevel_2_DataWithID:model.v ];
    }
}
#pragma - mark --------UICollectionView的Delegate-------
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    if (_curryTableSelected == 0)
    {
        return 4;
    }
    else
    {
        if (self.arrayCollectionViewData.count>0)
        {
            return self.arrayCollectionViewData.count+1;
        }
        return 0;
    }
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (_curryTableSelected == 0)
    {
        if (section == 0)
        {
            if (self.hotClassModel.banModel.ban.count>0)
            {
                return 1;
            }
        }
        else if(section == 1)
        {
            if (self.hotClassModel.marketNavModel.marketNav) {
                return self.hotClassModel.marketNavModel.marketNav.count;
            }
        }
        else if(section == 2)
        {
            if (self.hotClassModel.recModel.rec) {
                return self.hotClassModel.recModel.rec.count;
            }
        }
        else{
            if (self.hotClassModel.hotModel.hot) {
                return self.hotClassModel.hotModel.hot.count;
            }
        }
    }else{
        if (section == 0)
        {
            if (self.arrayLunboData.count>0)
            {
                return 1;
            }
        }
        else
        {
            NSArray* array = self.arrayCollectionViewData[section-1];
            return array.count;
        }
    }
    return 0;
}
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat W = self.collectionView.bounds.size.width;
    if (_curryTableSelected == 0)
    {
        if (indexPath.section == 0)
        {
            return CGSizeMake(W-20, (W-20)*190/510);
        }
        else
        {
            CGFloat IMG_WH = (W-40.f)/3.f;
            return CGSizeMake(IMG_WH, IMG_WH+20);
        }
    }
    else
    {
        if (indexPath.section == 0)
        {
            return CGSizeMake(W-20, (W-20)*190/510);
        }
        else
        {
            NSArray* array = self.arrayCollectionViewData[indexPath.section-1];
            SysCateModel* model = array[indexPath.row];
            return [self jl_SizeWidthWithStr:model.n];
        }
    }
}
//计算所需宽度
-(CGSize)jl_SizeWidthWithStr:(NSString*)str
{
    CGFloat MaxW = self.collectionView.frame.size.width-25-25;
    NSMutableParagraphStyle   *paragraphStyle   = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setMinimumLineHeight:25];
    CGRect rect = [str boundingRectWithSize:CGSizeMake(MaxW, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSParagraphStyleAttributeName:paragraphStyle} context:nil];
    CGFloat Width = ceilf(rect.size.width+25.f);
    return CGSizeMake(Width, LCDScale_5Equal6_To6plus(25.f));
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (_curryTableSelected == 0)
    {
        if (section == 0  && self.hotClassModel.banModel.ban.count>0)
        {
            return  UIEdgeInsetsMake(10, 10, 10, 10);
        }
        else if(section == 1 && self.hotClassModel.marketNavModel.marketNav.count>0)
        {
            return  UIEdgeInsetsMake(0, 10, 10, 10);
        }
        else if(section == 2 && self.hotClassModel.recModel.rec.count>0)
        {
            return  UIEdgeInsetsMake(0, 10, 10, 10);
        }
        else if(section == 3 && self.hotClassModel.hotModel.hot.count>0)
        {
            return  UIEdgeInsetsMake(0, 10, 10, 10);
        }
    }else{
        if (section == 0)
        {
            if (self.arrayLunboData.count >0)
            {
                return  UIEdgeInsetsMake(10, 10, 10, 10);
            }else{
                return  UIEdgeInsetsZero;
            }
        }
        return  UIEdgeInsetsMake(0, 10, 10, 15);
    }
    return  UIEdgeInsetsZero;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (_curryTableSelected == 0)
    {
        return 10;
    }else{
        return 20;
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (_curryTableSelected == 0) {
        return 10;
    }else{
        return 15;
    }
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (_curryTableSelected == 0)
    {
        if (section == 0)
        {
            return CGSizeZero;
        }
        else if(section == 1 && self.hotClassModel.marketNavModel.marketNav.count>0)
        {
            return CGSizeMake(self.collectionView.frame.size.width, 30+10+8);
        }
        else if(section == 2 && self.hotClassModel.recModel.rec.count>0)
        {
            return CGSizeMake(self.collectionView.frame.size.width, 30+10+8);
        }
        else if(section == 3 && self.hotClassModel.hotModel.hot.count>0)
        {
            return CGSizeMake(self.collectionView.frame.size.width, 30+10+8);
        }
        return CGSizeZero;
    }
    else
    {
        if (section == 0)
        {
            return CGSizeZero;
        }
        else
        {
            return CGSizeMake(self.collectionView.frame.size.width, 30+10+8);
        }
    }
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    FenLeiTitleCollectionReusableView* view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"HeaderTitle" forIndexPath:indexPath];
    return view;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    FenLeiTitleCollectionReusableView* fenleiview = (FenLeiTitleCollectionReusableView*)view;
    fenleiview.lookMoreBtn.hidden = YES;
    if (_curryTableSelected == 0) {
        if (indexPath.section == 0)
        {
            fenleiview.myTitleLabel.text = @"";
        }
        else if(indexPath.section == 1)
        {
            fenleiview.myTitleLabel.text = self.hotClassModel.marketNavModel.name;
            fenleiview.lookMoreBtn.hidden = NO;
            [fenleiview.lookMoreBtn addTarget:self action:@selector(clickMarketNavLookMoreBtn:) forControlEvents:UIControlEventTouchUpInside];
        }
        else if(indexPath.section == 2)
        {
            fenleiview.myTitleLabel.text = self.hotClassModel.recModel.name;
        }
        else
        {
            fenleiview.myTitleLabel.text = self.hotClassModel.hotModel.name;
        }
    }else{
        if (indexPath.section == 0)
        {
            fenleiview.myTitleLabel.text = @"";
        }
        else
        {
            SysCateModel* model = self.arrayCollectionViewHeaderData[indexPath.section-1];
            fenleiview.myTitleLabel.text = [NSString stringWithFormat:@"%@",model.n];
        }
    }
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_curryTableSelected == 0) {
        if (indexPath.section == 0)
        {
            FenLeiLunBoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiLunBoCellResign forIndexPath:indexPath];
            cell.lunboView.sourceArray = self.hotClassModel.banModel.ban;
            cell.lunboView.tag = 10002;
            cell.lunboView.datasource = self;
            cell.lunboView.delegate = self;
            
            return cell;
        }
        else if (indexPath.section == 1)
        {
            FenLeiHotSysCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiHotSysCateCellResign forIndexPath:indexPath];
            ClassifyAdvModel *model = self.hotClassModel.marketNavModel.marketNav[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.pic]];
            cell.TitleLabel.text = model.title;
            return cell;
        }
        else if (indexPath.section == 2)
        {
            FenLeiHotSysCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiHotSysCateCellResign forIndexPath:indexPath];
            ClassifyAdvModel *model = self.hotClassModel.recModel.rec[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.pic]];
            cell.TitleLabel.text = model.title;
            return cell;
        }
        else
        {
            FenLeiHotSysCateCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiHotSysCateCellResign forIndexPath:indexPath];
            ClassifyHotModel *model = self.hotClassModel.hotModel.hot[indexPath.row];
            [cell.imageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.picUrl]];
            cell.TitleLabel.text = model.sysCateName;
            return cell;
        }

    }else{
        if (indexPath.section == 0) {
            FenLeiLunBoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiLunBoCellResign forIndexPath:indexPath];
            cell.lunboView.sourceArray = self.arrayLunboData;
            cell.lunboView.tag = 10001;
            cell.lunboView.datasource = self;
            cell.lunboView.delegate = self;
            return cell;
        }else{
            FenLeiTitleCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:FenLeiTitleCellResign forIndexPath:indexPath];
            
            NSArray* array = self.arrayCollectionViewData[indexPath.section-1];
            SysCateModel* model = array[indexPath.row];
            cell.titleLabel.text = model.n;

            return cell;
        }
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_curryTableSelected == 0)
    {
        if (indexPath.section == 1) {
            ClassifyAdvModel *model = self.hotClassModel.marketNavModel.marketNav[indexPath.row];
            
            [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
            [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
        }
        if (indexPath.section == 2) {
            ClassifyAdvModel *model = self.hotClassModel.recModel.rec[indexPath.row];
           
            [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
            [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
        }
        if (indexPath.section == 3) {
            ClassifyHotModel *model = self.hotClassModel.hotModel.hot[indexPath.row];
            if (model.hotRef && ![model.hotRef isEqualToString:@""])
            { //配置的话进行路由跳转
                [[WYUtility dataUtil] routerWithName:model.hotRef withSoureController:self];
            }
            else
            { //不配置默认到产品搜索详情页
                
                if (self.pushstyle == FenLeiDellocLast)
                { //从搜索详情页过来的，跳转前把上个搜索详情页移除了
                    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
                    UIViewController *VC = arrayM[arrayM.count-2];
                    if ([VC isKindOfClass:[SearchDetailViewController class] ]) {
                        [arrayM removeObject:VC];
                        [self.navigationController setViewControllers:arrayM];
                    }
                }
                
                UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];
                SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
                searchDVC.searchKeyword = model.sysCateName;
                searchDVC.keywordType = 1;
                searchDVC.catId = [NSNumber numberWithInteger:model.sysCateId.integerValue];
                searchDVC.hidesBottomBarWhenPushed = YES;
                searchDVC.hiddenFenLeiBtn = YES;
                [self.navigationController pushViewController:searchDVC animated:NO];
            }
        }
    }
    else
    {
        if (indexPath.section==0) {//轮播
            return;
        }
        
        NSArray* array = self.arrayCollectionViewData[indexPath.section-1];
        SysCateModel* model = array[indexPath.row];
        
        if (self.pushstyle == FenLeiDellocLast)
        { //从搜索详情页过来的，跳转前把上个搜索详情页移除了
            NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
            UIViewController *VC = arrayM[arrayM.count-2];
            if ([VC isKindOfClass:[SearchDetailViewController class] ]) {
                [arrayM removeObject:VC];
                [self.navigationController setViewControllers:arrayM];
            }
        }

        //push搜索详情页面
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];
        SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
        searchDVC.searchKeyword = model.n;
        searchDVC.keywordType = 1;
        searchDVC.catId = model.v;
        searchDVC.hidesBottomBarWhenPushed = YES;
        searchDVC.hiddenFenLeiBtn = YES;
        [self.navigationController pushViewController:searchDVC animated:NO];
    }
}
#pragma mark - 查看更多>
-(void)clickMarketNavLookMoreBtn:(UIButton *)sender
{
    NSString *url = self.hotClassModel.marketNavModel.url;
    [[WYUtility dataUtil] routerWithName:url withSoureController:self];
}
#pragma mark - 轮播图DataSource代理方法－
-(id)jl_cycleScrollerView:(JLCycleScrollerView *)view defaultCell:(JLCycScrollDefaultCell *)cell cellForItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    if (view.tag == 10001) {
        FenLeiLunboAdvModel* model = sourceArray[index];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:model.pic];
        return url;
    }
    if (view.tag == 10002) {
        ClassifyAdvModel* model = sourceArray[index];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:model.pic];
        return url;
    }
    return nil;
}
#pragma mark 轮播图Cell点击代理方法
-(void)jl_cycleScrollerView:(JLCycleScrollerView *)view didSelectItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    if (view.tag == 10001) {
        FenLeiLunboAdvModel* model = sourceArray[index];
        [self requestClickAdvWithAreaId:@2007 advId:[NSString stringWithFormat:@"%@",model.iid]];
        
        [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
    }
  
    if (view.tag == 10002) {
        ClassifyAdvModel* model = sourceArray[index];
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        
        [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
    }
}
#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
//        NSLog(@"%@-%@广告点击统计成功",areaId,advId);
    } failure:^(NSError *error) {
        
    }];
    
}

#pragma mark - 弹窗搜索界面
-(void)popoToSearchViewController
{
    if (!self.searchViewC) {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
        self.searchViewC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchViewController];
        self.searchViewC.delegate = self;
    }
    [self presentViewController:self.searchViewC animated:NO completion:nil];

}
#pragma mark - 搜索控制器代理方法
-(void)jl_willDismissSearchViewController:(SearchViewController*)vc keywordType:(NSInteger)keywordType searchKeyword:(NSString*)searchKeyword
{
    [MobClick event:kUM_c_categorysearch];

    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
    SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
    searchDVC.searchKeyword = searchKeyword;
    searchDVC.keywordType = keywordType;
    searchDVC.catId = nil;
    searchDVC.hidesBottomBarWhenPushed = YES;
    searchDVC.hiddenFenLeiBtn = YES;
    [self.navigationController pushViewController:searchDVC animated:YES];
}
-(void)jl_didDismissSearchViewController:(SearchViewController*)vc
{
    self.searchViewC = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}
-(void)dealloc
{
    NSLog(@"jl_dealloc success");

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

@end
