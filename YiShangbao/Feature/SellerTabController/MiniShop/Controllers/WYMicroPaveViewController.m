//
//  WYMicroPaveViewController.m
//  YiShangbao
//
//  Created by Lance on 16/12/5.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import "WYMicroPaveViewController.h"
#import "ShopInfoViewController.h"
#import "ShopNoticeViewController.h"

#import "ManageMainProController.h"
#import "ManageBrandController.h"
#import "MessageModel.h"
#import "InfiniteCollectionCell.h"
#import "BtnCollectionCell.h"
#import "HeaderCollectionCell.h"
#import "HeaderCollectionCell2.h"
#import "UploadCollectionCell.h"
#import "ZXInfiniteScrollView.h"

#import "SellerPageMenuController.h"
#import "SendGoodsController.h"
#import "JLCycleScrollerView.h"
#import "AdvMustReadCell.h"
#import "MakeBillsTabController.h"
#import "ShopHomeAdvView.h"//底部悬浮广告位

#import "ZXModalAnimatedTranstion.h"
#import "ZXAlphaTransitionDelegate.h"
#import "ZXAdvModalController.h"
#import "CheckVersionManager.h"
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
#import <UserNotifications/UserNotifications.h>
#endif

#import "ZXNotiAlertViewController.h"

#import "WYPurchaserViewController.h"
#import "PageItemCollectionCell.h"
#import "BRCodePresentController.h"
#import "JLDragImageView.h"
#import "WYQRCodeViewController.h"
#import "GuideShopHomeController.h"
#import "ZXCustomNavigationBar.h"
#import "WYWKWebViewController.h"
#import "UINavigationController+ZXKuGouInteractivePopGestureRecognizer.h"
#import "ZXModalPresentaionController.h"

@interface WYMicroPaveViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,ZXEmptyViewControllerDelegate,ZXNoGapCellFlowLayoutDelegate,JLCycleScrollerViewDatasource,JLCycleScrollerViewDelegate,ZXAdvModalControllerDelegate,ZXHorizontalPageCollectionViewDelegate, JLDragImageViewDelegate,ShopHomeAdvViewDelegate,UIViewControllerTransitioningDelegate>

@property (nonatomic, strong) ShopHomeInfoModel *shopHomeInfoModel;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *infiniteDataMArray;
@property (nonatomic, strong) NSMutableArray *mustReadNotiMArray;

@property (nonatomic, strong) ShopMustReadAdvFatherModel *mustReadAdvFatherModel;


@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;
@property (nonatomic ,assign) UIStatusBarStyle stausBarStyle;
@property (nonatomic, strong) UIImageView * topImageView;

@property (strong, nonatomic)InfiniteCollectionCell *infiniteViewCell;
@property (strong, nonatomic) PageItemCollectionCell *pageCell;

@property (nonatomic, strong) advArrModel *rightAdvModel;

@property (nonatomic, strong) ZXAlphaTransitionDelegate *transitonModelDelegate;
@property (nonatomic, strong) AdvModel *advmodel; //弹窗广告model

@property (nonatomic, assign) CGFloat contentInsetTop;

@property (nonatomic, strong) UIBarButtonItem *leftBarButtonItem;

@property (nonatomic, strong) UIBarButtonItem *rightBarButtonItem;

@property (nonatomic, strong) JLDragImageView *tradeMoveView;

@property (nonatomic, strong) ZXCustomNavigationBar *customNavigationBar;

@property (nonatomic, strong) ShopHomeAdvView *advView;//底部悬浮广告位

@end

static NSString *const reuse_AdvMustReadCell =@"AdvMustReadCell";
static NSString *const reuse_headerCell = @"headerCell2";
static NSString *const reuse_pageCell = @"pageCell";
static NSString *const reuse_pageCell2 = @"pageCell2";

static NSString *const reuse_infiniteScrollView = @"infiniteScrollView";

static NSString * const reuse_HeaderViewIdentifier = @"Header";
static NSString * const reuse_FooterViewIdentifier = @"Footer";

@implementation WYMicroPaveViewController

#pragma mark lift cycle 

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self setData];
//    [self.navigationController zx_setNavigatonKuGouTransitionWithAnimationTransition:YES interactivePopGestureTransition:YES];

}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - set UI
- (void)setUI{
    
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
//    self.collectionView.backgroundColor = self.view.backgroundColor;
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;

    
    self.collectionView.alwaysBounceVertical = YES;
    self.flowLayout.delegate =self;
    
    // 没有数据的时候 展示用
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"fakeCell"];
    
    UINib *nib = [UINib nibWithNibName:NSStringFromClass([AdvMustReadCell class]) bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:reuse_AdvMustReadCell];
    
    [self.collectionView registerClass:[PageItemCollectionCell class] forCellWithReuseIdentifier:reuse_pageCell];
    
    [self.collectionView registerClass:[PageItemCollectionCell class] forCellWithReuseIdentifier:reuse_pageCell2];

     [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:reuse_FooterViewIdentifier];
    
    [self createScaleImageView];
    [self addNavigationBarView];
    [self lauchFirstNewFunction];

}

- (ShopHomeAdvView *)advView
{
    if (!_advView)
    {
        //底部悬浮广告位
        _advView = [[ShopHomeAdvView alloc]init];
        _advView.delegate = self;
        _advView.hidden = YES;
    }
    return _advView;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.customNavigationBar.frame = CGRectMake(0, 0, LCDW, HEIGHT_NAVBAR);
}

- (void)addNavigationBarView
{
    _stausBarStyle =UIStatusBarStyleDefault;

    ZXCustomNavigationBar *navigationBar = [ZXCustomNavigationBar zx_viewFromNib];
    [self.view addSubview:navigationBar];
    [navigationBar zx_setBarBackgroundColor:UIColorFromRGB_HexValue(0xBF352D)];
    self.customNavigationBar = navigationBar;
    self.customNavigationBar.hidden = YES;

    [self.customNavigationBar.leftBarButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customNavigationBar.rightBarButton1 addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.customNavigationBar.rightBarButton2 addTarget:self action:@selector(previewBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}


//前提是collectionView的背景要透明
- (void)createScaleImageView
{
    self.collectionView.backgroundColor = [UIColor clearColor];
    _topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, LCDW, LCDW*100.f/375.0)];
    _topImageView.backgroundColor = UIColorFromRGB_HexValue(0xBF352D);
//    UIImage *image = [UIImage zx_getGradientImageFromHorizontalTowColorWithSize:CGSizeMake(LCDW, LCDW*100.f/375.0) startColor:UIColorFromRGB(255.f, 180.f, 94.f) endColor:UIColorFromRGB(243.f, 117.f, 80.f)];
//    _topImageView.image =image;
    [self.view insertSubview:_topImageView belowSubview:self.collectionView];
    _topImageView.hidden = YES;
}
- (void)newFunctionGuideOfNextStep:(id)noti
{
    [self checkAppVersionAndNotificationPush];
}
- (void)lauchFirstNewFunction
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newFunctionGuideOfNextStep:) name:@"NewFunctionGuide_ShopHomeV1_Dismiss" object:nil];
    if (![WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
    {
        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        GuideShopHomeController *vc = [sb instantiateViewControllerWithIdentifier:SBID_GuideShopHomeController];
        [self.tabBarController addChildViewController:vc];
        [self.tabBarController.view addSubview:vc.view];
    }
}

#pragma mark - get data

- (void)setData{

    _contentInsetTop = 0;
//    if (@available(iOS 11.0, *))
//    {
//        self.collectionView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentScrollableAxes;
//        self.flowLayout.sectionInsetReference = UICollectionViewFlowLayoutSectionInsetFromSafeArea;
//    }
    self.collectionView.contentInset = UIEdgeInsetsMake(64-20, 0, 0, 0);
    self.collectionView.scrollIndicatorInsets = UIEdgeInsetsMake(64-20+ _contentInsetTop, 0, 0, 0);

    self.infiniteDataMArray = [NSMutableArray array];
    self.mustReadNotiMArray = [NSMutableArray array];
    //当有推送的时候，即使在当前页面也要及时刷新
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateFansVisitors:) name:Noti_Shop_ReceiveNewFansOrVisitors object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewOrder:) name:Noti_Shop_ReceiveNewOrder object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateNewTrade:) name:Noti_Trade_Push_NewTrades object:nil];

    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginIn:) name:kNotificationUserLoginIn object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loginOut:) name:kNotificationUserLoginOut object:nil];
    
    
    NSLog(@"%@",[UIApplication sharedApplication].windows);
    
}

#pragma mark - 请求失败／列表为空时候的代理请求

- (void)zxEmptyViewUpdateAction
{
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [self requestData];
}



#pragma mark - 登陆
//登陆的时候需要重新检查粉丝／访客，刷新数据；
- (void)loginIn:(id)notification
{
    [self requestData];
}
#pragma mark - 退出
- (void)loginOut:(id)notification
{
   [self requestData];
}

- (void)updateNewOrder:(id)notification
{
    [self requestData];
//    [self requestUpdateInfoWithFactor:@(1)];
}

- (void)updateFansVisitors:(id)notification
{
    [self requestData];
//    [self requestUpdateInfoWithFactor:@(3)];
}
- (void)updateNewTrade:(id)notification
{
    [self requestData];
}

#pragma mark - 

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self requestBottomAdv];//页面刷新请求底部广告
    
    if (self.presentedViewController)
    {
        return;
    }
    id<UIViewControllerTransitionCoordinator>tc = self.transitionCoordinator;
    if (tc && [tc initiallyInteractive])
    {
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:animated];
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        WS(weakSelf);
        [tc notifyWhenInteractionEndsUsingBlock:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
            if ([context isCancelled])
            {
                 [weakSelf.navigationController setNavigationBarHidden:NO animated:animated];
            }
        }];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:YES animated:animated];
        CGFloat offsetY = self.collectionView.contentOffset.y + self.collectionView.contentInset.top;
        if (offsetY<=0)
        {
            [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:YES];
        }
        else
        {
            CGFloat alpha = (offsetY>0 && offsetY<=_contentInsetTop)?offsetY/_contentInsetTop:1.f;
            [self.customNavigationBar zx_setBarBackgroundContainerAlpha:alpha animated:YES];
        }
    }
  
    NSLog(@"viewWillAppear");
    [MobClick beginLogPageView:NSStringFromClass([self class])];
    NSLog(@"%@",[UIApplication sharedApplication].windows);

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    

    [self requestData];
    [self checkShopId];
//    [self.infiniteView.timer resumeTimer];
    //   NSLitLog一定要注释掉
//    [UIView zx_NSLogSubviewsFromView:self.navigationController.navigationBar andLevel:1];
//    NSLog(@"%@",[UIApplication sharedApplication].windows);

}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
//    [self.infiniteView.timer pauseTimer];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.presentedViewController)
    {
        return;
    }
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    [MobClick endLogPageView:NSStringFromClass([self class])];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return _stausBarStyle;
}

#pragma mark - 检查更新及通知跳转
- (void)checkAppVersionAndNotificationPush
{
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        BOOL pushed = [[WYUtility dataUtil]routerWithName:[WYUserDefaultManager getDidFinishLaunchRemoteNoti] withSoureController:self];
        if (!pushed)
        {
            [self checkAppVersion];
        }
    }
    else{
        
        [self checkAppVersion];
    }
}


#pragma mark -检查更新请求

- (void)checkAppVersion
{
    WS(weakSelf);
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        /**
         *  版本更新
         */
        [[CheckVersionManager sharedInstance]checkAppVersionWithNextStep:^{
            
             [weakSelf launchHomeAdvViewOrUNNotificationAlert];
        }];
    });
}

#pragma mark - 请求广告弹窗图
- (void)launchHomeAdvViewOrUNNotificationAlert
{
    [self presentNotiAlert];
    /*
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1005 success:^(id data) {
        
        weakSelf.advmodel = (AdvModel *)data;
        if (weakSelf.advmodel.advArr.count>0)
        {
            [WYUserDefaultManager addTodayAppLanchAdvTimes];
            if ([WYUserDefaultManager isCanLanchAdvWithMaxTimes:@(weakSelf.advmodel.num)])
            {
                advArrModel *advItemModel = [weakSelf.advmodel.advArr firstObject];
                [weakSelf launchHomeAdvView:advItemModel];
            }
            else
            {
                [weakSelf addUNNotificationAlert];
            }
        }
        else
        {
            [weakSelf addUNNotificationAlert];
        }
        
    } failure:^(NSError *error) {
        
        [weakSelf addUNNotificationAlert];
    }];
     */
}

#pragma mark - 广告图动画UIViewControllerTransitionDelegate


- (void)launchHomeAdvView:(advArrModel *)model
{
    if (!self.transitonModelDelegate)
    {
        self.transitonModelDelegate = [[ZXAlphaTransitionDelegate alloc] init];
    }
    ZXAdvModalController *vc = [[ZXAdvModalController alloc] initWithNibName:nil bundle:nil];
    vc.btnActionDelegate = self;
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    ZXAdvModel *zxModel =[[ZXAdvModel alloc]initWithDesc:model.desc picString:model.pic url:model.url advId:model.iid];
    vc.advModel = zxModel;
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma  mark -  广告图按钮点击回调代理

- (void)zx_advModalController:(ZXAdvModalController *)controller advItem:(ZXAdvModel *)advModel
{
    [MobClick event:kUM_b_popups];
    
    NSString *advid = [NSString stringWithFormat:@"%@",advModel.advId];
    [self requestClickAdvWithAreaId:@1005 advId:advid];
    //业务逻辑的跳转
    [[WYUtility dataUtil]routerWithName:advModel.url withSoureController:self];
}


- (void)addUNNotificationAlert
{
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0)
    {
        WS(weakSelf);
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            
            if (settings.authorizationStatus ==UNAuthorizationStatusDenied)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [weakSelf presentNotiAlert];
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
        ZXNotiAlertViewController * __weak SELF = alertView;
        alertView.cancleActionHandleBlock = ^{
            
            [SELF removeFromParentViewController];
            [SELF.view removeFromSuperview];
        };
        alertView.doActionHandleBlock = ^{
            
        };
    }
}


#pragma mark - 请求数据

- (void)requestData
{
    [self requestShopHomeInfo];
    [self requestAdv];
    [self requestDragAdv];
    [self requestShopMustReadAdv];
    [self requestNewFansAndVisitorAndOrderAndTrade];
}

-(void)checkShopId
{
    if (![UserInfoUDManager isOpenShop] && ISLOGIN)
    {
        [[[AppAPIHelper shareInstance] getShopAPI] getMyShopIdsWithSuccess:^(id data) {
            [UserInfoUDManager setShopId:data];
        } failure:nil];
    }
}

- (void)requestShopHomeInfo
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getShopAPI]getShopHomeInfoWithFactor:@(0) Success:^(id data) {
        
        weakSelf.shopHomeInfoModel = nil;
        weakSelf.shopHomeInfoModel = [[ShopHomeInfoModel alloc] init];
        weakSelf.shopHomeInfoModel = data;
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.shopHomeInfoModel?YES:NO];
        if (weakSelf.shopHomeInfoModel)
        {
            weakSelf.customNavigationBar.hidden = NO;
            weakSelf.stausBarStyle = UIStatusBarStyleLightContent;
            [weakSelf setNeedsStatusBarAppearanceUpdate];
        }
        [weakSelf.collectionView reloadData];
        weakSelf.topImageView.hidden = NO;
        if ([WYUserDefaultManager getNewNewFunctionGuide_ShopHomeV1])
        {
            [weakSelf checkAppVersionAndNotificationPush];
        }
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.shopHomeInfoModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}

//1-基础服务，2-增值服务，3-粉丝访客，
- (void)requestUpdateInfoWithFactor:(NSNumber *)factorType
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getShopAPI]getShopHomeInfoWithFactor:factorType Success:^(id data) {
        
        [weakSelf.collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } failure:^(NSError *error) {
        
    }];
}


- (void)requestShopMustReadAdv
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI]getShopQuerySellerMustReadsWithListType:SellerMustReadsType_LastThree success:^(id data) {
        
        if (!weakSelf.mustReadNotiMArray)
        {
            weakSelf.mustReadAdvFatherModel = [[ShopMustReadAdvFatherModel alloc] init];
        }
        weakSelf.mustReadAdvFatherModel = data;
        [weakSelf.collectionView reloadData];
        
    } failure:nil];
}

- (void)requestAdv
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@10013 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        [weakSelf.infiniteDataMArray removeAllObjects];
        [model.advArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            advArrModel *advItemModel = (advArrModel *)obj;
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:advItemModel.pic];
            ZXADBannerModel *advModel = [[ZXADBannerModel alloc] initWithDesc:nil picString:picUrl.absoluteString url:advItemModel.url advId:advItemModel.iid];
            [weakSelf.infiniteDataMArray addObject:advModel];
            [weakSelf.collectionView reloadData];
        }];
        
    } failure:^(NSError *error) {
        
    }];
}

//商铺页底部悬浮广告
- (void)requestBottomAdv{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@10014 success:^(id data) {
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0){
            if (weakSelf.advView.hidden && [WYUserDefaultManager isShowAdvWithMaxTimes:@(model.num) advId:@10014]){
                advArrModel *advItemModel = [model.advArr firstObject];
                [weakSelf showAdvByModel:advItemModel];
            }
        }
    } failure:^(NSError *error) {
    }];
}


//拖动广告按钮内容
- (void)requestDragAdv
{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1009 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0){
            weakSelf.rightAdvModel = [model.advArr firstObject];
            
            //拖动按钮
            if (!weakSelf.tradeMoveView) {
                weakSelf.tradeMoveView = [[JLDragImageView alloc] init];
                weakSelf.tradeMoveView.delegate = self;
            }
            [weakSelf.tradeMoveView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:weakSelf.rightAdvModel.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [weakSelf.tradeMoveView showSuperview:weakSelf.view frameOffsetX:0 offsetY:50 Width:70 Height:70];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}


//检查新访客／粉丝/订单
- (void)requestNewFansAndVisitorAndOrderAndTrade
{
    if (![UserInfoUDManager isLogin])
    {
        return;
    }
    WS(weakSelf);
    [ProductMdoleAPI getCheckNewFansAndVisitorsWithSuccess:^(BOOL fansAdd, BOOL visitorsAdd, BOOL newOrderAdd, BOOL newBizAdd) {
    
        
        if (fansAdd ||visitorsAdd || newOrderAdd || newBizAdd)
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_ShopIcon_Red object:nil];
        }
        else
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_TabBarItem_ShopIcon_None object:nil];
        }
        [weakSelf.collectionView reloadData];
        
        
    } failure:^(NSError *error) {
        
    }];
}

- (IBAction)addInfomationAction:(UIButton *)sender {
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ShopInfoViewController withData:nil];
}


# pragma  mark - collectionViewDelegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.shopHomeInfoModel?5:0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        HeaderCollectionCell2 *cell2 = [collectionView dequeueReusableCellWithReuseIdentifier:reuse_headerCell forIndexPath:indexPath];
        [cell2.erWeiMaBtn addTarget:self action:@selector(QRCodeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.shopInfoActionBtn addTarget:self action:@selector(shopInfoAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell2.tradeLevelActionBtn addTarget:self action:@selector(tradeLevelBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
        [cell2.exposureBtn addTarget:self action:@selector(exposureBtnAction:) forControlEvents:UIControlEventTouchUpInside];

        if (_shopHomeInfoModel)
        {
            [cell2 setData:_shopHomeInfoModel];
        }
        
        return cell2;
    }

    else if (indexPath.section ==1)
    {
        AdvMustReadCell *advCell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse_AdvMustReadCell forIndexPath:indexPath];
        if (self.mustReadAdvFatherModel)
        {
            //头条
            advCell.cycleTitleView.sourceArray = self.mustReadAdvFatherModel.list;
            advCell.cycleTitleView.delegate = self;
            advCell.cycleTitleView.tag =  10002;
            [advCell setData:self.mustReadAdvFatherModel];
        }
        return advCell;
    }
    else if (indexPath.section ==2)
    {
        PageItemCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuse_pageCell forIndexPath:indexPath];
        if (_shopHomeInfoModel.baseService.count>0)
        {
            cell.itemPageView.delegate = self;
            cell.itemPageView.tag = 200;
            [cell setData:_shopHomeInfoModel.baseService];
        }
        return cell;
    }
    else if (indexPath.section ==3)
    {
        PageItemCollectionCell *cell =[collectionView dequeueReusableCellWithReuseIdentifier:reuse_pageCell2 forIndexPath:indexPath];
        if (_shopHomeInfoModel.appendService.count>0)
        {
            cell.itemPageView.delegate = self;
            cell.itemPageView.tag = 201;
            [cell setData:_shopHomeInfoModel.appendService];
        }
        return cell;
    }

    else if (indexPath.section ==4)
    {
        InfiniteCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuse_infiniteScrollView forIndexPath:indexPath];
        if (self.infiniteDataMArray.count>0)
        {
            cell.infiniteView.sourceArray = self.infiniteDataMArray;
            cell.infiniteView.datasource = self;
            cell.infiniteView.delegate = self;
        }
        return cell;
    }
  
    
    UICollectionViewCell*fakeCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"fakeCell" forIndexPath:indexPath];
    fakeCell.backgroundColor = [UIColor whiteColor];
    return fakeCell;

}

- (void)collectionView:(UICollectionView *)collectionView willDisplaySupplementaryView:(UICollectionReusableView *)view forElementKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    if (@available(iOS 11.0, *)) {
        if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
            view.layer.zPosition = 0;
        }
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader])
    {
        UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse_HeaderViewIdentifier forIndexPath:indexPath];
        view.backgroundColor = [UIColor whiteColor];
        UILabel *titleLab = [view viewWithTag:100];
        titleLab.textColor = UIColorFromRGB_HexValue(0x535353);
        titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
        if (indexPath.section ==2)
        {
            titleLab.text = @"基础服务";
        }
        else if (indexPath.section ==3)
        {
            titleLab.text = @"高级服务";
        }
        return view;
    }
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:reuse_FooterViewIdentifier forIndexPath:indexPath];
    view.backgroundColor = self.view.backgroundColor;
    return view;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        return CGSizeMake(LCDW, 108+53);
    }
    else if (indexPath.section ==1)
    {
        if (self.mustReadAdvFatherModel.list.count ==0)
        {
            return CGSizeMake(LCDW, 0.1);
        }
        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(45.f));
    }
    else if (indexPath.section ==2)
    {
        if (_shopHomeInfoModel.baseService.count ==0)
        {
            return CGSizeMake(LCDW, 0.1);
        }
        PageItemCollectionCell *cell = [[PageItemCollectionCell alloc] init];
        CGFloat height =  [cell getCellHeightWithContentData:_shopHomeInfoModel.baseService];

        return CGSizeMake(LCDW, height);
    }
    else if (indexPath.section ==3)
    {
        if (_shopHomeInfoModel.appendService.count ==0)
        {
            return CGSizeMake(LCDW, 0.1);
        }
        PageItemCollectionCell *cell = [[PageItemCollectionCell alloc] init];
        CGFloat height =  [cell getCellHeightWithContentData:_shopHomeInfoModel.appendService];

        return CGSizeMake(LCDW, height);
    }
    else if (indexPath.section==4)
    {
        if (_infiniteDataMArray.count ==0)
        {
            return CGSizeMake(LCDW, 0.1);
        }

        return CGSizeMake(LCDW, LCDScale_iPhone6_Width(95.f));
    }
    return CGSizeMake(LCDW, 50);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
  
    if (section==2 && _shopHomeInfoModel.baseService.count >0)
    {
        return CGSizeMake(LCDW, 30);
    }
    else if (section==3 && _shopHomeInfoModel.appendService.count >0)
    {
        return CGSizeMake(LCDW, 30);
    }
    return CGSizeMake(0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section ==1 ||section ==0)
    {
        return CGSizeMake(0, 10);
    }
    else if (section==2 && _shopHomeInfoModel.baseService.count >0)
    {
        return CGSizeMake(0, 10);
    }
    else if (section==3 && _shopHomeInfoModel.appendService.count >0)
    {
        return CGSizeMake(0, 10);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 4)
    {
        return UIEdgeInsetsMake(0, 0, 10, 0);
    }
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==1)
    {
        if ([self zx_performIsLoginActionWithPopAlertView:NO])
        {
            AdvMustReadCell *advCell = (AdvMustReadCell *)[collectionView cellForItemAtIndexPath:indexPath];
            NSInteger index = [advCell.cycleTitleView curryPage];
            [MobClick event:kUM_b_home_notice];
            ShopMustReadAdvModel* model =  [advCell.cycleTitleView.sourceArray objectAtIndex:index];
            [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
            [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.advId]];

            [self requestClickRefreshSubscribeWithName:@"announce"];
        }
    }
}

#pragma mark - ZXNoGapCellFlowLayoutDelegate

- (BOOL)ZXNoGapCellFlowLayout:(ZXNoGapCellFlowLayout *)noGapFlowLayout shouldNoGapAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==3)
    {
        return YES;
    }
    return NO;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    //注意,默认偏移为-20
    CGFloat offsetY = scrollView.contentOffset.y + scrollView.contentInset.top;
//    NSLog(@"%f,%f,%f",scrollView.contentOffset.y,scrollView.contentInset.top,offsetY);
    if (offsetY <= 0) {
        
        CGRect frame = _topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop-offsetY;
        _topImageView.frame = frame;
        
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:0 animated:YES];
    }
    else
    {
        CGFloat alpha = (offsetY>0 && offsetY<=20)?offsetY/20:1.f;
        [self.customNavigationBar zx_setBarBackgroundContainerAlpha:alpha animated:YES];

        if (alpha >0.5)
        {
//            _stausBarStyle = UIStatusBarStyleDefault;
//            [self setNeedsStatusBarAppearanceUpdate];
        }
        else
        {
//            _stausBarStyle = UIStatusBarStyleLightContent;
//            [self setNeedsStatusBarAppearanceUpdate];
        }
        CGRect frame = _topImageView.frame;
        frame.size.height= HEIGHT_NAVBAR+_contentInsetTop;
        _topImageView.frame = frame;
    }
}

#pragma mark - 交易得分

- (void)tradeLevelBtnAction:(UIButton *)sender {
    
    if (![self isNeedLoginAndOpenShop])
    {
        return;
    }
    if (_shopHomeInfoModel.tradeLevelUrl)
    {
        [MobClick event:kUM_b_home_score];
        [[WYUtility dataUtil]routerWithName:_shopHomeInfoModel.tradeLevelUrl withSoureController:self];
    }
}

#pragma mark - 曝光
- (void)exposureBtnAction:(UIButton *)sender {
 
    if (![self isNeedLoginAndOpenShop])
    {
        return ;
    }
    if (_shopHomeInfoModel.exposeModel.exposeUrl)
    {
        [[WYUtility dataUtil]routerWithName:_shopHomeInfoModel.exposeModel.exposeUrl withSoureController:self];
    }
}

#pragma mark - 编辑商铺信息

- (void)shopInfoAction:(id)sender
{
    [MobClick event:kUM_gotoInformation];
    
    if (![self isNeedLoginAndOpenShop])
    {
        return;
    }
    [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_ShopStore identifier:SBID_ShopInfoViewController withData:nil];
}

#pragma mark - 分享

- (void)shareAction:(id)sender {
        
    if (![self isNeedLoginAndOpenShop] || !_shopHomeInfoModel)
    {
        return;
    }
    
    WS(weakSelf);
    //分享
    [[[AppAPIHelper shareInstance] getMessageAPI] getShareWithType:@21 success:^(id data) {

        shareModel *model = data;
        NSString *titleStr = [model.title stringByReplacingOccurrencesOfString:@"{shopName}" withString:_shopHomeInfoModel.shopName];
        NSString *link = [model.link stringByReplacingOccurrencesOfString:@"{id}" withString:[UserInfoUDManager getShopId]];
        link = [link stringByReplacingOccurrencesOfString:@"{os}" withString:@"ios"];
        
        [WYShareManager shareInVC:weakSelf withImage:[_shopHomeInfoModel.shopIconURL absoluteString] withTitle:titleStr withContent:model.content withUrl:link];
//        [WYShareManager canPushInAPPWithShareType:^(WYShareType type) {
//            //推产品、清库存
//
//        }];
    } failure:^(NSError *error) {

        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}

// 预览
- (void)previewBtnAction:(UIButton *)sender
{
    [MobClick event:kUM_b_home_preview];
    if (![self isNeedLoginAndOpenShop] || !_shopHomeInfoModel)
    {
        return;
    }
    NSString *string1 = [NSMutableString stringWithString:_shopHomeInfoModel.viewUrl];
    NSString *string2 = [string1 stringByReplacingOccurrencesOfString:@"{token}" withString:[UserInfoUDManager getToken]];
    NSString *string3 =[string2 stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
    
    WYWKWebViewController *htmlVc = [[WYWKWebViewController alloc] init];
    [htmlVc loadWebPageWithURLString:string3];
    htmlVc.hidesBottomBarWhenPushed = YES;
    [self.navigationController.view.layer zx_addCATansitionWithAnimationType:@"cube" directionOfTransitionSubtype:kCATransitionFromRight];
    [self.navigationController pushViewController:htmlVc animated:NO];
//    [[WYUtility dataUtil]routerWithName:string3 withSoureController:self];
}
////转场管理器
//- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
//{
//    ZXModalPresentaionController *presentation =  [[ZXModalPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
//    presentation.frameOfPresentedView = CGRectMake(0, LCDH-300, LCDW, 300);
//    return presentation;
//}

#pragma mark - 身份切换

- (void)switchAction:(UIButton *)sender {
    
    [MobClick event:kUM_b_home_switch];
    [self switchIdentityRequest];
}

- (void)switchIdentityRequest{
    [MBProgressHUD zx_showLoadingWithStatus:@"身份切换中" toView:self.view];
    WS(weakSelf);
    NSString *clientId = [UserInfoUDManager getClientId];
    [[[AppAPIHelper shareInstance]userModelAPI]postChangeUserRoleWithClientId:clientId source:WYTargetRoleSource_userChange targetRole:WYTargetRoleType_buyer success:^(id data) {
        
        [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_buyer];
        [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_userChange];
        
        WYPurchaserViewController *vc = [[WYPurchaserViewController alloc] init];
        APP_MainWindow.rootViewController = vc;
        [MBProgressHUD zx_showText:nil customIcon:@"pic_change_caigoushang" view:nil];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark - QRCode 点击 跳转商铺资料

- (void)QRCodeBtnAction:(UIButton *)sender
{
    [MobClick event:kUM_b_home_code];
    if (![self zx_performActionWithIsLogin:ISLOGIN withPopAlertView:NO])
    {
        return ;
    }
    if (![UserInfoUDManager isOpenShop])
    {
        if (!self.transitonModelDelegate)
        {
            self.transitonModelDelegate = [[ZXAlphaTransitionDelegate alloc] init];
        }
        WS(weakSelf);
        BRCodePresentController *vc = (BRCodePresentController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:@"BRCodePresentController"];
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        vc.doActionHandleBlock = ^{
            
            [weakSelf requestClickQRCodeRefreshSubscribe];
            [[WYUtility dataUtil]routerWithName:@"microants://makeShopQuick" withSoureController:weakSelf];
        };
        [self presentViewController:vc animated:YES completion:nil];

        return ;
    }
    [self requestClickQRCodeRefreshSubscribe];
    [[WYUtility dataUtil]routerWithName:@"microants://shopqrcode" withSoureController:self];
}

#pragma mark - 同时需要登录，和开店
// 需要开店，需要登录
- (BOOL)isNeedLoginAndOpenShop
{
    if (![self zx_performActionWithIsLogin:ISLOGIN withPopAlertView:NO])
    {
        return NO;
    }
    else
    {
        if (![UserInfoUDManager isOpenShop])
        {
            [self addShopAlert];
            return NO;
        }
    }
    return YES;
}

#pragma mark- 完善商铺资料的弹出警告

- (void)addShopAlert
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"完善商铺资料后就能管理您的商铺啦～" message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"立即完善资料" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [[WYUtility dataUtil]routerWithName:@"microants://makeShopQuick" withSoureController:self];
    }];
}



#pragma mark -粉丝，访客跳转

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
{
    if ([identifier isEqualToString:segue_FansViewController] || [identifier isEqualToString:segue_VisitorViewController])
    {
        if ([self isNeedLoginAndOpenShop])
        {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *viewController= segue.destinationViewController;

    if ([viewController respondsToSelector:@selector(setShopId:)])
    {
        [viewController setValue:[UserInfoUDManager getShopId] forKey:@"shopId"];
    }
    if ([segue.identifier isEqualToString:segue_VisitorViewController])
    {
        [MobClick event:kUM_gotoVisitors];
    }
    else if ([segue.identifier isEqualToString:segue_FansViewController])
    {
        [MobClick event:kUM_gotoFans];
    }
}

#pragma mark - ZXHorizontalPageCollectionViewDelegate

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView willDisplayCell:(ZXBadgeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imgViewLayoutWidth.constant = 30;
}

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BadgeItemCommonModel *model = nil;
    if (pageView.tag ==200)
    {
        model = [_shopHomeInfoModel.baseService objectAtIndex:indexPath.item];
    }
    else if (pageView.tag ==201)
    {
        model = [_shopHomeInfoModel.appendService objectAtIndex:indexPath.item];
    }
    [MobClick event:model.name];
    if ([self getIsRouteWithModel:model])
    {
        if (ISLOGIN && [model.name isEqualToString:@"bidbar"])
        {
             [self requestClickRefreshSubscribeWithName:model.name];
        }
        else if (model.sideMarkType ==SideMarkType_image)
        {
            [self requestClickRefreshSubscribeWithName:model.name];
        }
        [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
    }
}

#pragma mark - 刷新红点及角标

// 刷新服务item点击
- (void)requestClickRefreshSubscribeWithName:(NSString *)name
{
    [[[AppAPIHelper shareInstance] getShopAPI] postShopStoreFlushClickWithName:name success:^(id data) {
        
    } failure:^(NSError *error) {
    }];
}

// 二维码点击后
- (void)requestClickQRCodeRefreshSubscribe
{
    [[[AppAPIHelper shareInstance] getShopAPI] postShopStoreFlushClickWithName:@"ercode" success:^(id data) {
        
        _shopHomeInfoModel.ercodeReddot = NO;
        [_collectionView reloadSections:[NSIndexSet indexSetWithIndex:0]];
        
    } failure:^(NSError *error) {
    }];
}

- (BOOL)getIsRouteWithModel:(BadgeItemCommonModel *)model
{
    if (model.needLogin)
    {
        if (![self zx_performActionWithIsLogin:ISLOGIN withPopAlertView:NO])
        {
            return NO;
        }
    }
    if (model.needOpenShop)
    {
        if (![UserInfoUDManager isOpenShop])
        {
            [self addShopAlert];
            return NO;
        }
    }
    return YES;
}


#pragma mark ------展示底部广告------
- (void)showAdvByModel:(advArrModel *)model{
    [self.view addSubview:self.advView];
    [self.advView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
        make.height.equalTo(@(SCREEN_WIDTH / 750.0 * 134.0));
    }];
    [self.advView updateAdvModel:model];
}

- (void)shopHomeAdvUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
}

# pragma  mark - 轮播点击，必读通知，广告
//轮播图代理
-(id)jl_cycleScrollerView:(JLCycleScrollerView *)view defaultCell:(JLCycScrollDefaultCell *)cell cellForItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
    ZXADBannerModel* model = sourceArray[index];
    return model.pic;
}


-(void)jl_cycleScrollerView:(JLCycleScrollerView *)view didSelectItemAtIndex:(NSInteger)index sourceArray:(nonnull NSArray *)sourceArray
{
//    必看通知
    if (view.tag == 10002)
    {
        if ([self zx_performIsLoginActionWithPopAlertView:NO])
        {
            [MobClick event:kUM_b_home_notice];
            ShopMustReadAdvModel* model =  sourceArray[index];
            [[WYUtility dataUtil] routerWithName:model.url withSoureController:self];
            [self requestClickAdvWithAreaId:model.areaId advId:[NSString stringWithFormat:@"%@",model.advId]];
            
            [self requestClickRefreshSubscribeWithName:@"announce"];
        }
        return;
    }
    ZXADBannerModel* model = sourceArray[index];
    [self requestClickAdvWithAreaId:@10013 advId:[NSString stringWithFormat:@"%@",model.advId]];
    [MobClick event:kUM_b_home_banner];
    
    [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
}


//
#pragma mark － 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

# pragma  mark - 广告点击 JLDragImageViewDelegate

-(void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer *)tapGes
{
    [self requestClickAdvWithAreaId:@1009 advId:[_rightAdvModel.iid stringValue]];
    [[WYUtility dataUtil]routerWithName:_rightAdvModel.url withSoureController:self];
}
-(void)dealloc
{
    NSLog(@"jl_dealloc success");
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
@end
