//
//  WYPurchaserMainViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserMainViewController.h"
#import "CheckVersionManager.h"
#import "WYTimeManager.h"
#import "WYLayoutManager.h"

#import "MessageModel.h"
#import "ZXModalAnimatedTranstion.h"
#import "ZXAlphaTransitionDelegate.h"
#import "ZXAdvModalController.h"

#import "PurchaserLunBoLabellingCollectionViewCell.h" //义采宝头条

#import "PurMainCycleViewAdvCell.h"
#import "PurchasrLunboAdvCell.h"
#import "PurMenuBarCell.h"
#import "PurScrollHorizontallyCell.h"
#import "PurTbzgAdvCell.h"
#import "PurchaserGoodShopCollectionViewCell.h"
#import "PurchaserProjectCollectionViewCell.h"
#import "PurchaserTuiJianCollectionViewCell.h"
#import "PurchasrBestProductsAdvCell.h"

#import "PurYcbBuyNewsRView.h"
#import "PurCommonTitleHeaderRView.h"
#import "PurRecommendFooterRView.h"

#import "WYMessageListViewController.h"
#import "WYScanQRViewController.h"
#import "SearchViewController.h"
#import "SearchDetailViewController.h"
#import "SearchProductDetailController.h"
#import "SearchShopDetailController.h"

#import "PurchaserModel.h"
#import "WYDataCache.h"
#import "ZXNotiAlertViewController.h"


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

typedef NS_ENUM(NSInteger,WYPurTag){
    
    PurTag_mainCycleView         = 1001,  //顶部轮播图
    PurTag_ycbNewsCycleView      = 1002 , //义采宝头条
    PurTag_goldAdvCycleView      = 1003,  //义采宝头条下方单张广告图
    PurTag_lunboAdvCycleView     = 1004 , //精品推荐广告位下方-轮播广告位

    PurTag_ScrHorMenuView        = 2001,  //横向列表-淘宝直供上方
    PurTag_bestProdMenuView      = 2002,  //横向列表-精品推荐广告位
};
@interface WYPurchaserMainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout, UIViewControllerTransitioningDelegate,ZXAdvModalControllerDelegate,SearchViewControllerDelegate,JLCycleScrollerViewDatasource,JLCycleScrollerViewDelegate,JLDynamicMenuViewDataSource,JLDynamicMenuViewDelegate,PurchaserProjectCollectionViewCellDelegate,PurTbzgAdvCellDelegate,PurchaserGoodShopCollectionViewCellDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) WYLayoutManager *layoutManager;
@property (nonatomic, strong)UIView *mjRefreshView;

@property (nonatomic, strong) ZXAlphaAnimatedTranstion *modalAnimation;
@property (nonatomic, strong) ZXAlphaTransitionDelegate *transitonModelDelegate;
@property(nonatomic,strong) AdvModel *advmodel; //弹窗广告model

@property (nonatomic, strong)SearchViewController *searchViewC;
@property (nonatomic, assign)NSInteger PageNo; //第几页
@property(nonatomic, strong)NSString* firstPageRequestTime; //请求第一页的时间
@property(nonatomic, strong)NSString* lastFirstPageRequesTime;//用户上次请求第一页时间(eg昨天)

@property(nonatomic, strong)NSArray *advInfoArray;             //顶部轮播图广告
@property(nonatomic, strong)NSArray *funcBarInfoArray;         //功能条
@property(nonatomic, strong)NSArray *ycbRegInfoArray;          //"入驻商铺:50000   上传产品:350000"
@property(nonatomic, strong)YcbBuyNewsModel* ycbBuyNews;  //采购资讯

@property(nonatomic, strong)NSArray *goldAdvInfoArray;    //单张广告图（存在则展示）
@property(nonatomic, strong)NSArray *specialAdvInfoArray; //单张广告图下正方形列表
@property(nonatomic, strong)NSArray *lowPriceStockAdvArray;        //底价库存广告位
@property(nonatomic, strong)NSArray *hotShopAdvArray;              //热销店铺广告位
@property(nonatomic, strong)NSArray *tbzgAdvArray;                 //淘宝直供广告位

@property(nonatomic, strong)NSArray *bestProductsAdvArray;     //精品推荐广告位，每个广告相当于一个产品链接
@property(nonatomic, strong)NSArray *lunboAdvArray;            //精品推荐广告位下方-轮播广告位

@property(nonatomic, strong)NSArray* topCategory;      //人气分类
@property(nonatomic, strong)NSString* shopRecmd;       //单个商铺推荐，1：表示展示，0：不展示
@property(nonatomic, strong)NSString* shopSpecial;     //商铺专题，1：表示展示，0：不展示
@property(nonatomic, strong)NSString* productSpecial;  //产品专题，1：表示展示，0：不展示
@property(nonatomic, strong)NSString* guessYouLike;    //为你推荐产品，1：表示展示，0：不展示

@property(nonatomic, strong)NSArray* shopRecmdArray;       //商铺推荐(单个商铺)
@property(nonatomic, strong)NSArray* shopSpecialArray;     //商铺专题
@property(nonatomic, strong)NSArray* productSpecialArray;  //产品专题
@property(nonatomic, strong)NSMutableArray* guessYouLikeArrayM;    //为你推荐产品数据源

@end

//对应plist中identifier
static  NSString* const PurMainCycleViewAdvCell_advInfo = @"advInfo";
static  NSString* const PurchasrLunboAdvCell_goldAdvInfo = @"goldAdvInfo";
static  NSString* const PurchasrLunboAdvCell_lunboAdv = @"lunboAdv";
static  NSString* const PurMenuBarCell_funcBarInfo = @"funcBarInfo";
static  NSString* const PurMenuBarCell_topCategory = @"topCategory";
static  NSString* const PurchaserGoodShopCollectionViewCell_shopRecmd = @"shopRecmd";
static  NSString* const PurchaserProjectCollectionViewCell_shopSpecial = @"shopSpecial";
static  NSString* const PurchaserProjectCollectionViewCell_productSpecial = @"productSpecial";
static  NSString* const PurchasrBestProductsAdvCell_bestProductsAdv = @"bestProductsAdv";
static  NSString* const PurScrollHorizontallyCell_specialAdvInfo = @"specialAdvInfo";
static  NSString* const PurTbzgAdvCell_THL = @"tbzgAdv&hotShopAdv&lowPriceStockAdv";
static  NSString* const PurchaserTuiJianCollectionViewCell_guessYouLike = @"guessYouLike";

static  NSString* const DefaultCellResign = @"UICollectionViewCell";
static  NSString* const DefaultHeaderResign = @"UICollectionSectionHeader";
static  NSString* const DefaultFooterResign = @"UICollectionSectionFooter";
@implementation WYPurchaserMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.layoutManager = [[WYLayoutManager alloc] initWithKey:@"WYPurchaserMainViewController"];

//    [self initData];
    
    [self initLastData]; //读取缓存数据
    
    [self requestPurchaserMainData];

    [self buildUI];
    [self headerRefresh];
    
    [self addNotificationCenters];
}
-(void)initData
{
    self.PageNo = 1;
    self.advInfoArray = [NSArray array];
    self.funcBarInfoArray = [NSArray array];
    self.ycbRegInfoArray =  [NSArray array];
    
    self.goldAdvInfoArray = [NSArray array];
    self.specialAdvInfoArray = [NSArray array];
    self.lowPriceStockAdvArray = [NSArray array];
    self.hotShopAdvArray = [NSArray array];
    self.tbzgAdvArray = [NSArray array];
    
    self.bestProductsAdvArray = [NSArray array];
    self.lunboAdvArray = [NSArray array];
    self.guessYouLikeArrayM = [NSMutableArray array];

}
-(void)initLastData
{

    PurchaserModel *MainModel = [[[AppAPIHelper shareInstance] getPurchaserAPI] getPurchaserIndexConfigWithMarketId_DataCache];
    if (!MainModel) {
        [self initData];
        return;
    }
    [self updateRuzhuLabel];
    
    self.advInfoArray =  [NSArray arrayWithArray:MainModel.advInfo];
    self.funcBarInfoArray = [NSArray arrayWithArray:MainModel.funcBarInfo];
    self.ycbRegInfoArray = [NSArray arrayWithArray:MainModel.ycbRegInfo];
    self.ycbBuyNews = MainModel.ycbBuyNews;
    
    self.goldAdvInfoArray = [NSArray arrayWithArray:MainModel.goldAdvInfo];
    self.specialAdvInfoArray = [NSArray arrayWithArray:MainModel.specialAdvInfo];
    self.lowPriceStockAdvArray = [NSArray arrayWithArray:MainModel.lowPriceStockAdv];
    self.hotShopAdvArray = [NSArray arrayWithArray:MainModel.hotShopAdv];
    self.tbzgAdvArray = [NSArray arrayWithArray:MainModel.tbzgAdv];
    
    self.bestProductsAdvArray = [NSArray arrayWithArray:MainModel.bestProductsAdv];
    self.lunboAdvArray = [NSArray arrayWithArray:MainModel.lunboAdv];
    
    self.topCategory = MainModel.topCategory;
    self.shopRecmd = MainModel.shopRecmd;
    self.shopSpecial = MainModel.shopSpecial;
    self.productSpecial = MainModel.productSpecial;
    self.guessYouLike = MainModel.guessYouLike;

    if ([self.shopRecmd isEqualToString:@"1"]) {
        id data = [[[AppAPIHelper shareInstance] getPurchaserAPI] getShopStandAloneRecmdWithSuccess_DataCache];
        self.shopRecmdArray = [NSArray arrayWithArray:data]; //推荐商铺
    }
    if ([self.shopSpecial isEqualToString:@"1"]) {
        id data = [[[AppAPIHelper shareInstance] getPurchaserAPI] getShopRecmdListWithSuccess_DataCache];
        self.shopSpecialArray = [NSArray arrayWithArray:data];//商铺专题
    }
    if ([self.productSpecial isEqualToString:@"1"]) {
        id data = [[[AppAPIHelper shareInstance] getPurchaserAPI] getProdRecmdWithSuccess_DataCache];
        self.productSpecialArray = [NSArray arrayWithArray:data];//产品专题
    }
    if ([self.guessYouLike isEqualToString:@"1"]) {
        self.PageNo = 0;//不缓存为你推荐,打开网络上拉获取第一页
        self.guessYouLikeArrayM  = [NSMutableArray array];
        [self footerWithRefreshing];

//        [[[AppAPIHelper shareInstance] getPurchaserAPI] getPurchaserListWithTimestamp_DataCache:^(NSInteger maxPage, NSArray *array) {
//            if (array.count>0) {
//                self.PageNo = maxPage;
//                self.guessYouLikeArrayM  = [NSMutableArray arrayWithArray:array];//为你推荐
//                [self footerWithRefreshing];
//            }
//        }];

    }
}
-(void)addNotificationCenters
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(scrollToTop) name:Noti_update_WYPurchaserMainViewController object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPurchaserMainData) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(requestPurchaserMainData) name:kNotificationUserLoginOut object:nil];
    
}
-(void)scrollToTop
{
    [self.collectionView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
}

-(void)buildUI
{
    if (@available(iOS 11.0, *)){
        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    //消息按钮
    [_messageBadgeView setImage:[UIImage imageNamed:@"ic_message_normal"]];
    [_messageBadgeView setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
    
    //ihponeX
    [self.stateView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(HEIGHT_STATEBAR);
    }];

    self.naviBackgroundImageView.image = [WYUTILITY getPurBarImageWithSize:CGSizeMake(1, 1)];
    self.mjRefreshView.backgroundColor = [WYUISTYLE colorF3F3F3];
    
    //layoutManager
    self.layoutManager = [[WYLayoutManager alloc] initWithKey:@"WYPurchaserMainViewController"];
    [self.layoutManager registerPlistNibCellsWithCollectionView:self.collectionView];
}
-(UIView *)mjRefreshView
{
    if (!_mjRefreshView) {
        _mjRefreshView = [[UIView alloc] initWithFrame:CGRectMake(0,0,LCDW,0)];
        self.collectionView.backgroundView = [[UIView alloc] init];
        self.collectionView.backgroundView.backgroundColor = [UIColor whiteColor];
        [self.collectionView.backgroundView addSubview:_mjRefreshView];
    }
    return _mjRefreshView;
}
#pragma mark - UICollectionView代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.layoutManager.sections;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMainCycleViewAdvCell_advInfo]) {
        if (self.advInfoArray.count>0) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_goldAdvInfo]) {
        if (self.goldAdvInfoArray.count>0) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_lunboAdv]) {
        if (self.lunboAdvArray.count>0) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        if (self.topCategory.count>0) {
            return self.topCategory.count>8?8:self.topCategory.count;
        }
    }
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        if (self.funcBarInfoArray.count>0) {
            return self.funcBarInfoArray.count;
        }
    }
    if ([identifier isEqualToString:PurScrollHorizontallyCell_specialAdvInfo]) {
        if (self.specialAdvInfoArray.count>0) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurTbzgAdvCell_THL]) {
        if ((self.tbzgAdvArray.count>0 || self.lowPriceStockAdvArray.count>0 || self.hotShopAdvArray.count>0)) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurchasrBestProductsAdvCell_bestProductsAdv]) {
        if (self.bestProductsAdvArray.count>0) {
            return 1;
        }
    }
    if ([identifier isEqualToString:PurchaserGoodShopCollectionViewCell_shopRecmd]) {
        if (self.shopRecmd && [self.shopRecmd isEqualToString:@"1"]) {
            return self.shopRecmdArray.count;
        }
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_shopSpecial]) {
        if ([self.shopSpecial isEqualToString:@"1"]) {
            return self.shopSpecialArray.count;
        }
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_productSpecial]) {
        if ([self.productSpecial isEqualToString:@"1"]) {
            return self.productSpecialArray.count;
        }
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        if ([self.guessYouLike isEqualToString:@"1"]) {
            return self.guessYouLikeArrayM.count;
        }
    }
    return 0;
}
//最小垂直间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
            return 10;
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
            return 10;
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        return 10;
    }
    return 0.f;
}
//最小水平间距
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        return LCDScale_iPhone6_Width(20.f);
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        return LCDScale_iPhone6_Width(20.f);
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        return 10;
    }
    return 0.f;
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        if (self.funcBarInfoArray.count>0) {
            return UIEdgeInsetsMake(10.f, LCDScale_iPhone6_Width(20.f), 10.f, LCDScale_iPhone6_Width(20.f));
        }
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        if (self.topCategory.count>0) {
            return UIEdgeInsetsMake(0, LCDScale_iPhone6_Width(20.f), 20.f, LCDScale_iPhone6_Width(20.f));
        }
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        if (self.guessYouLikeArrayM.count>0) {
            return UIEdgeInsetsMake(0, 10, 10,10);
        }
    }
    return UIEdgeInsetsZero;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    NSString *identifier = [self.layoutManager identifierWithSection:indexPath.section];
    if ([identifier isEqualToString:PurMainCycleViewAdvCell_advInfo]) {
        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(124.f));
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_goldAdvInfo]) {
        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(120.f));
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_lunboAdv]) {
        return CGSizeMake(LCDW,LCDScale_iPhone6_Width(60.f));
    }
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        CGFloat W = (LCDW-5.0*LCDScale_iPhone6_Width(20.f))/4;
        CGFloat H = 10+LCDScale_iPhone6_Width(40.f)+8+18;
        return CGSizeMake(W,H);
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        CGFloat W = (LCDW-5.0*LCDScale_iPhone6_Width(20.f))/4;
        CGFloat H = 10+LCDScale_iPhone6_Width(64.f)+8+18;
        return CGSizeMake(W,H);
    }
    if ([identifier isEqualToString:PurScrollHorizontallyCell_specialAdvInfo]) {
        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(140.f));
    }
    if ([identifier isEqualToString:PurTbzgAdvCell_THL]) {
        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(180.f));
    }
    if ([identifier isEqualToString:PurchasrBestProductsAdvCell_bestProductsAdv]) {
        return CGSizeMake(LCDW,31.f+4+8+LCDScale_iPhone6_Width(85.f)+8+16+15);
    }
    if ([identifier isEqualToString:PurchaserGoodShopCollectionViewCell_shopRecmd]) {
        return CGSizeMake(LCDW, 310.f+ (-108+(LCDW-50)/3) + (-70.f+LCDScale_iPhone6_Width(70)) );
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_shopSpecial]) {
        return CGSizeMake(LCDW, 244.f+(-108+(LCDW-50)/3));//无价格label
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_productSpecial]) {
        return CGSizeMake(LCDW, 268.f+(-108+(LCDW-50)/3));
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        return CGSizeMake((LCDW-30)/2, 268.f+(-188+(LCDW-30)/2));
    }
    return CGSizeZero;
}
//组头CGSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        if (self.topCategory.count>0) {
            return CGSizeMake(LCDW, 43.f);
        }
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        if ([self.guessYouLike isEqualToString:@"1"]) {
            return CGSizeMake(LCDW, 43.f);
        }
    }
    return CGSizeZero;
}
//组尾CGSize
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    NSString *identifier = [self.layoutManager identifierWithSection:section];
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        if (self.ycbBuyNews) {
            return CGSizeMake(LCDW, 48.f);//义采宝头条
        }
    }
    if ([identifier isEqualToString:PurScrollHorizontallyCell_specialAdvInfo]) {
        if (self.specialAdvInfoArray.count>0) {
            return CGSizeMake(LCDW, 10.f);//F3F3F3间隙组尾,collectionView背景需要设置为白色
        }
    }
    if ([identifier isEqualToString:PurTbzgAdvCell_THL]) {
        if ((self.tbzgAdvArray.count>0 || self.lowPriceStockAdvArray.count>0 || self.hotShopAdvArray.count>0)) {
            return CGSizeMake(LCDW, 10.f);
        }
    }
    if ([identifier isEqualToString:PurchasrBestProductsAdvCell_bestProductsAdv]) {
        if (self.bestProductsAdvArray.count>0) {
            return CGSizeMake(LCDW, 10.f);
        }
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_lunboAdv]) {
        if (self.lunboAdvArray.count>0) {
            return CGSizeMake(LCDW, 10.f);
        }
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        if (self.topCategory.count>0) {
            return CGSizeMake(LCDW, 10.f);
        }
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        if ([self.guessYouLike isEqualToString:@"1"] && self.guessYouLikeArrayM.count>0 && self.collectionView.mj_footer == nil) { //数据到底啦
            return CGSizeMake(LCDW, 50.f);
        }
    }
    return CGSizeZero;//其他为不带间隙组尾或cell自带组尾
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.layoutManager identifierWithSection:indexPath.section];
    if (kind == UICollectionElementKindSectionHeader) {
        NSString *SectionHeader = [self.layoutManager UICollectionSectionHeaderWithSection:indexPath.section];
        if ([SectionHeader isEqualToString:@"PurCommonTitleHeaderRView"]) {
            PurCommonTitleHeaderRView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PurCommonTitleHeaderRView" forIndexPath:indexPath];
            if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
                view.pTitleLabel.text = @"人气分类";
            }
            if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
                view.pTitleLabel.text = @"为你推荐";
            }
            return view;
        }
       
        return  [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DefaultHeaderResign forIndexPath:indexPath];
        
    }else{
        NSString *SectionFooter = [self.layoutManager UICollectionSectionFooterWithSection:indexPath.section];
        if ([SectionFooter isEqualToString:@"PurRecommendFooterRView"]) {
            PurRecommendFooterRView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PurRecommendFooterRView" forIndexPath:indexPath];
            return view;
        }
        if ([SectionFooter isEqualToString:@"PurYcbBuyNewsRView"]) {
            PurYcbBuyNewsRView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"PurYcbBuyNewsRView" forIndexPath:indexPath];
            view.cycleTitleView.sourceArray = self.ycbBuyNews.news;
            view.cycleTitleView.delegate = self;
            view.cycleTitleView.tag = PurTag_ycbNewsCycleView;
            return view;
        }
        
        UICollectionReusableView *footColorView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:DefaultFooterResign forIndexPath:indexPath];
        footColorView.backgroundColor = [WYUISTYLE colorF3F3F3];//组尾作为间隙
        return footColorView;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.layoutManager identifierWithSection:indexPath.section];
    if ([identifier isEqualToString:PurMainCycleViewAdvCell_advInfo]) {
        PurMainCycleViewAdvCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurMainCycleViewAdvCell" forIndexPath:indexPath];
        cell.lunboView.sourceArray = self.advInfoArray; //顶部广告图
        cell.lunboView.tag = PurTag_mainCycleView;
        cell.lunboView.datasource = self;
        cell.lunboView.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_goldAdvInfo]) {
        PurchasrLunboAdvCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchasrLunboAdvCell" forIndexPath:indexPath];
        cell.lunboView.sourceArray = @[self.goldAdvInfoArray.firstObject] ;//单张的广告图
        cell.lunboView.tag = PurTag_goldAdvCycleView;
        cell.lunboView.datasource = self;
        cell.lunboView.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurchasrLunboAdvCell_lunboAdv]) {
        PurchasrLunboAdvCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchasrLunboAdvCell" forIndexPath:indexPath];
        cell.lunboView.sourceArray = self.lunboAdvArray;
        cell.lunboView.tag = PurTag_lunboAdvCycleView;
        cell.lunboView.datasource = self;
        cell.lunboView.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) {
        PurMenuBarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurMenuBarCell" forIndexPath:indexPath];
        [cell setCellData:self.funcBarInfoArray[indexPath.row]];
        return cell;
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) {
        PurMenuBarCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurMenuBarCell" forIndexPath:indexPath];
        [cell setCellData:self.topCategory[indexPath.row]];
        return cell;
    }
    if ([identifier isEqualToString:PurScrollHorizontallyCell_specialAdvInfo]) {
        PurScrollHorizontallyCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurScrollHorizontallyCell" forIndexPath:indexPath];
        cell.menuView.tag = PurTag_ScrHorMenuView;
        [cell.menuView setArrayData:self.specialAdvInfoArray];
        cell.menuView.dataSource = self;
        cell.menuView.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurTbzgAdvCell_THL]) {
        PurTbzgAdvCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurTbzgAdvCell" forIndexPath:indexPath];
        [cell setDatalowPriceStockAdv:self.lowPriceStockAdvArray hotShopAdv:self.hotShopAdvArray tbzgAdv:self.tbzgAdvArray];
        cell.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurchasrBestProductsAdvCell_bestProductsAdv]) {
        PurchasrBestProductsAdvCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchasrBestProductsAdvCell" forIndexPath:indexPath];
        [cell layoutIfNeeded];
        cell.menuView.arrayData = self.bestProductsAdvArray;
        cell.menuView.dataSource = self;
        cell.menuView.tag = PurTag_bestProdMenuView;
        cell.menuView.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurchaserGoodShopCollectionViewCell_shopRecmd]) {
        PurchaserGoodShopCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchaserGoodShopCollectionViewCell" forIndexPath:indexPath];
        [cell settData:self.shopRecmdArray[indexPath.row] ];
        cell.delegate = self;
        return cell;
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_shopSpecial]) {
        PurchaserProjectCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchaserProjectCollectionViewCell" forIndexPath:indexPath];
        cell.type = PurchaserProjectCollectionViewCellShop;
        [cell settData:self.shopSpecialArray[indexPath.row]];
        cell.delegate = self;
        return cell;
        
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_productSpecial]) {
        PurchaserProjectCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchaserProjectCollectionViewCell" forIndexPath:indexPath];
        cell.type = PurchaserProjectCollectionViewCellProduct;
        [cell settData:self.productSpecialArray[indexPath.row] ];
        cell.delegate = self;
        return cell;

    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) {
        PurchaserTuiJianCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PurchaserTuiJianCollectionViewCell" forIndexPath:indexPath];
        PurchaserListModel* model = self.guessYouLikeArrayM[indexPath.row];
        [cell settData:model];
        return cell;

    }
    return [collectionView dequeueReusableCellWithReuseIdentifier:DefaultCellResign forIndexPath:indexPath];

}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *identifier = [self.layoutManager identifierWithSection:indexPath.section];
    if ([identifier isEqualToString:PurMenuBarCell_funcBarInfo]) { //功能菜单
        PurchaserCommonAdvModel* model = self.funcBarInfoArray[indexPath.row];
        
        [MobClick event:[NSString stringWithFormat:@"kUM_c_funcBar_%@",model.iid]];
        
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [MobClick event:[NSString stringWithFormat:@"c_funcBar_%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
    if ([identifier isEqualToString:PurMenuBarCell_topCategory]) { //人气分类
        TopCategoryModel* model = self.topCategory[indexPath.row];
        
        NSString* mobclcik = [NSString stringWithFormat:@"c_indexclassification_%ld",indexPath.row+1];
        [MobClick event:mobclcik];
        [self pushWithRouterName:model.route];
    }
    if ([identifier isEqualToString:PurchaserGoodShopCollectionViewCell_shopRecmd]) { //推荐商铺(单个商铺)
        ShopStandAloneRecmdModel* model = (ShopStandAloneRecmdModel*)self.shopRecmdArray[indexPath.row];
        
        [MobClick event:model.alias];
        
//        NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbShopDetail.html?id=%@&token=%@&ttid=%@&trackld=%@",[WYUserDefaultManager getkAPP_H5URL],model.shopId,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"106"];
        
        [self pushWithRouterName:model.url];
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_shopSpecial]) { //商铺专题
        ShopRecmdListModel* model = (ShopRecmdListModel*)self.shopSpecialArray[indexPath.row];
        
        NSString *mobClick = [NSString stringWithFormat:@"c_indexshoptopics%ldmore",indexPath.section+1];
        [MobClick event:mobClick];

        NSString* linkTure = [NSString stringWithFormat:@"%@=%@",model.link,model.index];
        [self pushWithRouterName:linkTure];
    }
    if ([identifier isEqualToString:PurchaserProjectCollectionViewCell_productSpecial]) { //产品专题
        prodRecmdModel* model = (prodRecmdModel*)self.productSpecialArray[indexPath.row];
        
        [MobClick event:model.alias];

        NSString* linkTure = [NSString stringWithFormat:@"%@=%@",model.link,model.iid];
        [self pushWithRouterName:linkTure];
    }
    if ([identifier isEqualToString:PurchaserTuiJianCollectionViewCell_guessYouLike]) { //为你推荐
        PurchaserListModel* model = self.guessYouLikeArrayM[indexPath.row];
        
        NSString* mobclcik = [NSString stringWithFormat:@"c_indexforyou_%ld",indexPath.row];
        [MobClick event:mobclcik];
        
        NSString *url = [model.link stringByReplacingOccurrencesOfString:@"{productId}" withString:model.iid];
//        NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbProductDetailYcb.html?id=%@&token=%@&ttid=%@&channel=%@",[WYUserDefaultManager getkAPP_H5URL],model.iid,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"0"];
        [self pushWithRouterName:url];
    }

}
#pragma mark - 滚动代理-导航栏动画设置
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView)
    { 
        CGFloat offset=scrollView.contentOffset.y;
        if (offset > 0) { //导航栏
          
            CGFloat top = offset>24.f?24.f:offset;
            CGFloat alpha = 1-offset/(30-6);
            self.searchBotton_ruzhuTopLay.constant = -top;
            self.ruzhuLabel.alpha = alpha;
            
//            CGFloat top = offset>44.f-6.f?38.f:offset;
//            CGFloat alpha = 1-offset/38.f;
//            self.CustomBarTopLay.constant = -top;
//            self.funContentView.alpha = alpha;
//            if (offset >38.f) {
//                CGFloat bott_top = offset-38.f>30-6?24:offset-38.f;
//                CGFloat alpha = 1-(offset-38.f)/20;
//                self.searchBotton_ruzhuTopLay.constant = -bott_top;
//                self.ruzhuLabel.alpha = alpha;
//            }
        }else{
            self.ruzhuLabel.alpha = 1;
//            self.funContentView.alpha = 1;
//            self.CustomBarTopLay.constant = 0;
            self.searchBotton_ruzhuTopLay.constant = 0;
        }
        if (offset < 0) {//下拉刷新背景
            CGRect frame = self.mjRefreshView.frame;
            frame.size.height = -offset;
            self.mjRefreshView.frame = frame;
        }else{
            CGRect frame = self.mjRefreshView.frame;
            frame.size.height = 0;
            self.mjRefreshView.frame = frame;
        }
        if (self.PageNo>1) {
            self.collectionView.showsVerticalScrollIndicator = YES;
        }else{
            self.collectionView.showsVerticalScrollIndicator = NO;
        }
    }
}
#pragma mark - 轮播图代理
//《注:义采宝头条自定义cell使用协议不会走这个代理》
-(id)jl_cycleScrollerView:(JLCycleScrollerView *)view defaultCell:(JLCycScrollDefaultCell *)cell cellForItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    cell.imageView.backgroundColor = [UIColor clearColor];
    if (view.tag == PurTag_mainCycleView) {
        PurchaserCommonAdvModel* model = sourceArray[index];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:model.pic];
        return url;
    }
    if (view.tag == PurTag_goldAdvCycleView) {
        PurchaserCommonAdvModel* model = sourceArray[index];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:model.pic];
        return url;
    }
    if (view.tag == PurTag_lunboAdvCycleView) {
        PurchaserCommonAdvModel* model = sourceArray[index];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:model.pic];
        return url;
    }
  
    return nil;
}
-(void)jl_cycleScrollerView:(JLCycleScrollerView *)view didSelectItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{    
    if (view.tag == PurTag_mainCycleView) {
        PurchaserCommonAdvModel* model = sourceArray[index];

        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
    if (view.tag == PurTag_ycbNewsCycleView) {
        NewsModel* model =  sourceArray[index];

        [self pushWithRouterName:model.newsUrl];
    }
    if (view.tag == PurTag_goldAdvCycleView) {
        PurchaserCommonAdvModel* model =  sourceArray[index];
        
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
    if (view.tag == PurTag_lunboAdvCycleView) {
        PurchaserCommonAdvModel* model =  sourceArray[index];
        
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
}
#pragma mark - 淘宝直供
-(void)jl_PurTbzgAdvCell:(PurTbzgAdvCell *)cell type:(PurTbzgAdvCellBtnType)type
{
    if (type == PurTbzgAdvCellBtnType_DiJiaBtn) {
        PurchaserCommonAdvModel* lowPriceStockAdvModel = self.lowPriceStockAdvArray.firstObject;
        [self requestClickAdvWithAreaId:lowPriceStockAdvModel.areaId advId:[NSString stringWithFormat:@"%@",lowPriceStockAdvModel.iid]];
        
        [self pushWithRouterName:lowPriceStockAdvModel.url];
    }
    if (type == PurTbzgAdvCellBtnType_ReXiaoBtn) {
        
        PurchaserCommonAdvModel* hotShopAdvModel = self.hotShopAdvArray.firstObject;
        [self requestClickAdvWithAreaId:hotShopAdvModel.areaId advId:[NSString stringWithFormat:@"%@",hotShopAdvModel.iid]];
        
        [self pushWithRouterName:hotShopAdvModel.url];
    }
    if (type == PurTbzgAdvCellBtnType_TaoBaoBtn) {
        
        PurchaserCommonAdvModel* tbzgAdvModel = self.tbzgAdvArray.firstObject;
        [self requestClickAdvWithAreaId:tbzgAdvModel.areaId advId:[NSString stringWithFormat:@"%@",tbzgAdvModel.iid]];
        
        [self pushWithRouterName:tbzgAdvModel.url];
    }
}
#pragma mark - 动态菜单代理
//动态菜单DataSource
-(void)jl_JLDynamicMenuView:(JLDynamicMenuView *)view cell:(JLDynamicMenuCollectionViewCell *)cell cellForItemAtInteger:(NSInteger)integer
{
    if (view.tag == PurTag_bestProdMenuView) { //精品推荐
        PurchaserCommonAdvModel* model = self.bestProductsAdvArray[integer];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:model.pic];
        [cell.iconIMV sd_setImageWithURL:url placeholderImage:AppPlaceholderImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
        cell.titleLabel.text = [NSString stringWithFormat:@"%@",model.desc];
        cell.titleLabel.textColor = [WYUISTYLE colorWithHexString:@"#F58F23"];
        cell.titleLabel.font = [UIFont systemFontOfSize:16.f];
    }
    if (view.tag == PurTag_ScrHorMenuView) { //淘宝直供上方横向列表
        PurchaserCommonAdvModel* model = self.specialAdvInfoArray[integer];
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:model.pic];
        [cell.backgroundIMV sd_setImageWithURL:url placeholderImage:nil];
        cell.titleLabel.text = @"";
        cell.iconIMV.image = nil;
    }
}
//动态菜单Delegate
-(void)jl_JLDynamicMenuView:(JLDynamicMenuView *)view didSelectItemAtInteger:(NSInteger)integer
{
    if (view.tag == PurTag_bestProdMenuView) { //精品推荐
        PurchaserCommonAdvModel* model = self.bestProductsAdvArray[integer];
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
    if (view.tag == PurTag_ScrHorMenuView) { //淘宝直供上方横向列表
        PurchaserCommonAdvModel* model = self.specialAdvInfoArray[integer];
        [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.iid]];
        [self pushWithRouterName:model.url];
    }
}
#pragma mark - 专题cell代理
//专题Cell上三个按钮点击
-(void)jl_PurchaserProjectCollectionViewCell:(PurchaserProjectCollectionViewCell *)cell didSelectItemAtInteger:(NSInteger)integer
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    if (cell.type == PurchaserProjectCollectionViewCellShop) {
        ShopRecmdListModel* model = (ShopRecmdListModel*)self.shopSpecialArray[indexPath.row];
        
        RecmdShopsModel* Rmodel = model.shops[integer];
       
        NSString* mobclcik = [NSString stringWithFormat:@"c_indexshoptopics%ld_%ld",indexPath.section+1,integer+1];
        [MobClick event:mobclcik];
        
//        NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbShopDetail.html?id=%@&token=%@&ttid=%@&trackld=%@",[WYUserDefaultManager getkAPP_H5URL],Rmodel.iid,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"106"];
        [self pushWithRouterName:Rmodel.url];
    }
    if (cell.type == PurchaserProjectCollectionViewCellProduct) {
        prodRecmdModel* model = (prodRecmdModel*)self.productSpecialArray[indexPath.row];
        prodsModel* Pmodel= model.prods[integer];
        
        [MobClick event:Pmodel.alias];

//        NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbProductDetailYcb.html?id=%@&token=%@&ttid=%@@&channel=%@",[WYUserDefaultManager getkAPP_H5URL],Pmodel.iid,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"0"];
        [self pushWithRouterName:Pmodel.url];
    }
}
#pragma mark - 单个商铺（商铺推荐）-产品点击 代理
-(void)jl_PurchaserGoodShopCollectionViewCell:(PurchaserGoodShopCollectionViewCell *)cell didSelectItemWithInteger:(NSInteger)integer
{
    NSIndexPath* indexPath = [self.collectionView indexPathForCell:cell];
    ShopStandAloneRecmdModel* mdoel =  self.shopRecmdArray[indexPath.row];
    NSArray* prodsArray = mdoel.prods;
    prodsModel* Pmodel = prodsArray[integer];
//    NSString* strurl = [NSString stringWithFormat:@"%@/ycb/page/ycbProductDetailYcb.html?id=%@&token=%@&ttid=%@@&channel=%@",[WYUserDefaultManager getkAPP_H5URL],Pmodel.iid,[UserInfoUDManager getToken],[BaseHttpAPI getCurrentAppVersion],@"0"];
    [self pushWithRouterName:Pmodel.link];

}
#pragma mark - 路由跳转
-(void)pushWithRouterName:(NSString *)urlstring
{
    [[WYUtility dataUtil] routerWithName:urlstring withSoureController:self];
}
#pragma mark - -----------数据请求---------------
-(void)headerRefresh{
    WS(weakSelf);
    MJRefreshNormalHeader * header = [MJRefreshNormalHeader   headerWithRefreshingBlock:^{
        [weakSelf requestPurchaserMainData];
    }];
    header.lastUpdatedTimeLabel.hidden = YES;
    self.collectionView.mj_header = header;
}

- (void)footerWithRefreshing
{
    MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(requestWeiNiTuiJianDataWithPageNumAdd_1)];
//    WS(weakSelf);//MJRefresh上拉加载有循环引用风险
//    MJRefreshAutoNormalFooter *footer= [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
//        [weakSelf requestWeiNiTuiJianDataWithPageNo:_PageNo+1];
//    }];
    //控制底部控件(默认高度44)出现百分比(0.0-1.0,默认1.0)来预加载，此处设置表示距离底部上拉控件顶部5*44高度即提前加载数据
    footer.triggerAutomaticallyRefreshPercent = -5;
    footer.stateLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.f)];
    self.collectionView.mj_footer = footer;

}
-(void)requestWeiNiTuiJianDataWithPageNumAdd_1
{
    [self requestWeiNiTuiJianDataWithPageNo:_PageNo+1];
}
#pragma mark - 请求主页接口
-(void)requestPurchaserMainData
{
    [[[AppAPIHelper shareInstance] getPurchaserAPI] getPurchaserIndexConfigWithMarketId:nil success:^(id data) {
        
        PurchaserModel* MainModel = (PurchaserModel*)data;
        
        self.advInfoArray =  [NSArray arrayWithArray:MainModel.advInfo];
        self.funcBarInfoArray = [NSArray arrayWithArray:MainModel.funcBarInfo];
        self.ycbRegInfoArray = [NSArray arrayWithArray:MainModel.ycbRegInfo];
        self.ycbBuyNews = MainModel.ycbBuyNews;

        self.goldAdvInfoArray = [NSArray arrayWithArray:MainModel.goldAdvInfo];
        self.specialAdvInfoArray = [NSArray arrayWithArray:MainModel.specialAdvInfo];
        self.lowPriceStockAdvArray = [NSArray arrayWithArray:MainModel.lowPriceStockAdv];
        self.hotShopAdvArray = [NSArray arrayWithArray:MainModel.hotShopAdv];
        self.tbzgAdvArray = [NSArray arrayWithArray:MainModel.tbzgAdv];

        self.bestProductsAdvArray = [NSArray arrayWithArray:MainModel.bestProductsAdv];
        self.lunboAdvArray = [NSArray arrayWithArray:MainModel.lunboAdv];
        
        self.topCategory = MainModel.topCategory;
        self.shopRecmd = MainModel.shopRecmd;
        self.shopSpecial = MainModel.shopSpecial;
        self.productSpecial = MainModel.productSpecial;
        self.guessYouLike = MainModel.guessYouLike;
     
        [self.collectionView.mj_header endRefreshing];
        [self.collectionView.mj_footer endRefreshing];
        [self updateRuzhuLabel];
        [self.collectionView reloadData];

        
        
        if ([self.shopRecmd isEqualToString:@"1"]) {
            [self requestShopRecmd]; //推荐商铺
        }
        if ([self.shopSpecial isEqualToString:@"1"]) {
            [self requestShopSpecial];//商铺专题
        }
        if ([self.productSpecial isEqualToString:@"1"]) {
            [self requestProductSpecial];//产品专题
        }
        if ([self.guessYouLike isEqualToString:@"1"]) {
            [self requestWeiNiTuiJianDataWithPageNo:1];//为你推荐
            [self footerWithRefreshing];
        }

    } failure:^(NSError *error) {
        [self.collectionView.mj_header endRefreshing];
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
#pragma mark - 请求《为你推荐》数据
-(void)requestWeiNiTuiJianDataWithPageNo:(NSInteger)PageNo
{
    if (PageNo == 1) { //获取时间参数
        _lastFirstPageRequesTime =  [WYTIMEMANAGER getLastRequestPurchaserListData];
        _firstPageRequestTime = [WYTIMEMANAGER setCurryTimeToLastRequestPurchaserListData];
    }

    [[[AppAPIHelper shareInstance] getPurchaserAPI]  getPurchaserListWithTimestamp:_firstPageRequestTime preTimestamp:_lastFirstPageRequesTime PageNo:PageNo pageSize:@(10) success:^(id data) {
        if (PageNo==1) {
            self.guessYouLikeArrayM  = [NSMutableArray arrayWithArray:data];
            _PageNo =1;
        }else{
            [self.guessYouLikeArrayM addObjectsFromArray:data];
            _PageNo ++;
        }

         if ([data count]<10)
         {
             self.collectionView.mj_footer = nil;
         }
        [self.collectionView reloadData];
        
        [self.collectionView.mj_footer endRefreshing];

     } failure:^(NSError *error) {
         [self.collectionView.mj_footer endRefreshing];
        
         [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];

         
     }];
}
#pragma  mark - -------------子接口-----------------
#pragma  mark - 商铺专题301032
-(void)requestShopSpecial
{
    [[[AppAPIHelper shareInstance] getPurchaserAPI] getShopRecmdListWithSuccess:^(id data) {
        self.shopSpecialArray = [NSArray arrayWithArray:data];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView reloadData];
    }];
}
#pragma  mark  商铺推荐301056(单个商铺)
-(void)requestShopRecmd
{
    [[[AppAPIHelper shareInstance] getPurchaserAPI] getShopStandAloneRecmdWithSuccess:^(id data) {
        self.shopRecmdArray = [NSArray arrayWithArray:data];

        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView reloadData];
    }];
}
#pragma  mark - 产品专题301057
-(void)requestProductSpecial
{
    [[[AppAPIHelper shareInstance] getPurchaserAPI] getProdRecmdWithSuccess:^(id data) {
        self.productSpecialArray = [NSArray arrayWithArray:data];
        [self.collectionView reloadData];
    } failure:^(NSError *error) {
        [self.collectionView reloadData];
    }];
}
#pragma mark  消息
//每次出现页面都得去请求检查
- (void)requestMessageInfo
{
    if (![UserInfoUDManager isLogin])
    {
        [_messageBadgeView setBadgeValue:0];
        return;
    }
    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *market =  [data objectForKey:@"buyernews"];
        NSNumber *trade = [data objectForKey:@"trade"];
        NSNumber *todo = [data objectForKey:@"todo"];
        // 活动咨询
        NSNumber *antsteam =  [data objectForKey:@"antsteam"];
        NSInteger total =[system integerValue]+[market integerValue]+[trade integerValue] +[todo integerValue] +antsteam.integerValue;
        NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
        NSInteger badgeValue = nimValue +total;
        
        [_messageBadgeView setBadgeValue:(badgeValue)];
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [_messageBadgeView setBadgeValue:nimValue];
        }
    }];
}
#pragma mark  检查更新及通知跳转
- (void)checkAppVersionAndNotificationPush
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed = [[WYUtility dataUtil] routerWithName:[WYUserDefaultManager getDidFinishLaunchRemoteNoti] withSoureController:self];
        if (!pushed)
        {
            [self checkAppVersion];
        }
    }
    else{
        
        [self checkAppVersion];
    }
}
#pragma mark  检查更新请求

- (void)checkAppVersion
{
    
    [[CheckVersionManager sharedInstance]checkAppVersionOnceWithNextStep:^{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            [self launchHomeAdvViewOrUNNotificationAlert];
            
        });
    }];
}
#pragma mark - 请求广告图
- (void)launchHomeAdvViewOrUNNotificationAlert
{    
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@2006 success:^(id data) {
        
        _advmodel = (AdvModel *)data;
        if (_advmodel.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(_advmodel.num)])
            {
                advArrModel *advItemModel = [_advmodel.advArr firstObject];
                [self launchHomeAdvView:advItemModel];
            }
            else
            {
                [self addUNNotificationAlert];
            }
        }
        else
        {
            [self addUNNotificationAlert];
        }
        
    } failure:^(NSError *error) {
        
        [self addUNNotificationAlert];
    }];
}
#pragma mark-广告图动画UIViewControllerTransitionDelegate
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.modalAnimation.type = ZXAnimationTypePresent;
    return self.modalAnimation;
}
- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.modalAnimation.type = ZXAnimationTypeDismiss;
    return self.modalAnimation;
}

- (void)launchHomeAdvView:(advArrModel *)model
{
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXAlphaTransitionDelegate alloc] init];
    }
    self.modalAnimation = [[ZXAlphaAnimatedTranstion alloc] init];
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self;
    ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:model.desc picString:model.pic url:model.url advId:model.iid];
    vc.advModel = zxModel;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma  mark -  广告图按钮点击回调代理
- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel
{
    [MobClick event:kUM_c_indexbanner];
    NSString *advid = [NSString stringWithFormat:@"%@",advModel.advId];
    [self requestClickAdvWithAreaId:@2006 advId:advid];
    //业务逻辑的跳转
    [self pushWithRouterName:advModel.url];
}

#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {

        //验证
//        [MBProgressHUD zx_showSuccess:[NSString stringWithFormat:@"后台广告点击统计成功areaId=%@_advId=%@",areaId,advId] toView:nil];
    } failure:^(NSError *error) {
        
    }];
    
}
- (void)addUNNotificationAlert
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self presentNotiAlert];
                });
            }
        }];
    }
    else
    {
        UIUserNotificationSettings * notiSettings = [[UIApplication sharedApplication]currentUserNotificationSettings];
        if (notiSettings.types == UIUserNotificationTypeNone)
        {
            [self presentNotiAlert];
        }
    }
}
- (void)presentNotiAlert
{
    if ([WYUserDefaultManager isCanPresentAlertWithIntervalDay:7])
    {
        ZXNotiAlertViewController *alertView = [[ZXNotiAlertViewController alloc] initWithNibName:@"ZXNotiAlertViewController" bundle:nil];
        [self.tabBarController addChildViewController:alertView];
        [self.tabBarController.view addSubview:alertView.view];
        alertView.view.frame = self.tabBarController.view.frame;
        __block ZXNotiAlertViewController *SELF = alertView;
        alertView.cancleActionHandleBlock = ^{
            
            [SELF removeFromParentViewController];
            [SELF.view removeFromSuperview];
        };
        alertView.doActionHandleBlock = ^{
            
            NSURL *openUrl = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            if ([[UIApplication sharedApplication]respondsToSelector:@selector(openURL:options:completionHandler:)])
            {
                [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:nil];
            }
            else
            {
                [[UIApplication sharedApplication] openURL:openUrl];
            }
        };
    }
}
#pragma mark - -------搜索Delegate----------
//搜索
-(void)jl_willDismissSearchViewController:(SearchViewController*)vc keywordType:(NSInteger)keywordType searchKeyword:(NSString*)searchKeyword
{
    [MobClick event:kUM_c_indexsearch];
  
//    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:sb_Purchaser bundle:[NSBundle mainBundle]];//SearchProductDetailController SearchShopDetailController
//    SearchShopDetailController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchShopDetailController];
//    searchDVC.searchKeyword = searchKeyword;
//    searchDVC.keywordType = keywordType;
//    searchDVC.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:searchDVC animated:YES];
//    return;
    
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
    SearchDetailViewController* searchDVC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchDetailViewController];
    searchDVC.searchKeyword = searchKeyword;
    searchDVC.keywordType = keywordType;
    searchDVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:searchDVC animated:YES];
}
-(void)jl_didDismissSearchViewController:(SearchViewController*)vc
{
    self.searchViewC = nil;
}
-(void)updateRuzhuLabel
{
    NSMutableString* str = [NSMutableString string];
    for (int i=0; i<self.ycbRegInfoArray.count; ++i) {
        YcbRegInfoModel* model = self.ycbRegInfoArray[i];
        [str appendFormat:@" %@: %@ ",model.name,model.value];
    }
    [self.ruzhuLabel jl_changeStringOfNumberStyle:str numberColor:[UIColor whiteColor] numberFont:[UIFont boldSystemFontOfSize:11]];
}

#pragma mark - --------Actions---------
#pragma mark 导航栏搜索
- (IBAction)searchBtnClick:(UIButton *)sender {
    if (!self.searchViewC) {
        UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"Purchaser" bundle:[NSBundle mainBundle]];
        self.searchViewC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_SearchViewController];
        self.searchViewC.delegate = self;
    }
    [self presentViewController:self.searchViewC animated:NO completion:nil];
}
#pragma mark 导航栏消息
- (IBAction)messageControlClick:(ZXBadgeIconButton *)sender {
    if ([self zx_performIsLoginActionWithPopAlertView:NO])
    {
        [MobClick event:kUM_message];
        
        WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
        messageList.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
}
#pragma mark 导航栏扫一扫
- (IBAction)scanQRBtnClick:(UIButton *)sender {
    WYScanQRViewController *vc = [[WYScanQRViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark 切换身份
- (IBAction)switchIdentitiesClick:(UIButton *)sender {

    [MBProgressHUD zx_showLoadingWithStatus:@"身份切换中" toView:nil];
    NSString *clientId = [UserInfoUDManager getClientId];
    [[[AppAPIHelper shareInstance] userModelAPI]postChangeUserRoleWithClientId:clientId source:WYTargetRoleSource_userChange targetRole:WYTargetRoleType_seller success:^(id data) {

        [MobClick event:kUM_c_home_switch];

        //        [MBProgressHUD zx_showSuccess:nil toView:self.view];
        [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_seller];
        [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_userChange];
        
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        APP_MainWindow.rootViewController = story.instantiateInitialViewController;
        [MBProgressHUD zx_hideHUDForView:nil];
        [MBProgressHUD zx_showText:nil customIcon:@"pic_change_gongyingshang" view:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}


#pragma mark - viewWillDisappear
-(void)viewWillDisappear:(BOOL)animated{
    if (!self.presentedViewController) {//如果跳转为Present继续隐藏导航栏
        [self.navigationController setNavigationBarHidden:NO animated:animated];
    }
    [super viewWillDisappear:animated];

}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self checkAppVersionAndNotificationPush];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if ([context isCancelled])
            {
                [self.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
    }
    
    //请求数据
    [self requestMessageInfo];
}
-(void)dealloc
{
    NSLog(@"jl_dealloc success");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark -  状态栏设置
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
