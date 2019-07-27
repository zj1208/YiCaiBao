//
//  WYIntroduceViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
#define SCR_W     [UIScreen mainScreen].bounds.size.width
#define SCR_H     [UIScreen mainScreen].bounds.size.height

#import "WYIntroduceViewController.h"
#import "WYIntroduceCollectionViewCell.h"
#import "WYUserDefaultManager.h"


//＊＊＊＊＊＊＊＊没有值，第一次启动，YES, 选择身份后，非第一次＊＊＊＊＊＊＊＊
//当更换引导页从新加载引导页，需要跟换@"GuideVersion_4"字符串中数字，必须递增（方便删除之前的单利）
static NSString *const FirstStartSaveString = @"GuideVersion_4";

@interface WYIntroduceViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)UICollectionView* collectionView;
@property(nonatomic,strong)NSMutableArray* arrayImages;  //图片name数组
@property(nonatomic,strong)UIImage* imageSelectBackgroundImage;//选择身份背景图
@property(nonatomic,strong)UIImage* imageNowGotoBackgroundImage;//立即进入背景图
@property(nonatomic,strong)UIViewController *rootViewController; //切换Window根控制器

/**
 返回单例
 */
+ (WYIntroduceViewController *)sharedGuide;


/**
 *  是否首次安装app加载的根视图设置;
 *
 *  @param vc tabBarController/广告控制器
 */
- (void)firstLaunchAppWithRootController:(UIViewController *)vc;
@end

@implementation WYIntroduceViewController
+ (WYIntroduceViewController *)sharedGuide
{
    @synchronized(self)
    {
        static WYIntroduceViewController *sharedGuide = nil;
        if (sharedGuide == nil)
        {
            sharedGuide = [[self alloc] init];
        }
        return sharedGuide;
    }
}
+ (BOOL)hadLaunchedGuide
{
    return   [[NSUserDefaults standardUserDefaults] boolForKey:FirstStartSaveString];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //清除引导页跟换之前的单例
    NSString* numstr = [[FirstStartSaveString componentsSeparatedByString:@"_"] lastObject];
    for (int i = 1; i<numstr.integerValue; ++i) {
        NSString* strKey = [NSString stringWithFormat:@"GuideVersion_%d",i];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:strKey];
    }

    
    self.view.backgroundColor = [UIColor whiteColor];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
    //根据是否选择身份设置
//    if ([WYUserDefaultManager getUserTargetRoleType]){
//        [self addButtonForNowGoToMainTabbarController:self.view];
//    }else{
        [self addTwoSelectButtonsToSuperView:self.view]; //不要判断了
//    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [self.collectionView reloadData];
    [super viewWillAppear:animated];
}
#pragma mark - 设置引导页
+ (void)guideFigureWithImages:(NSArray *)images NowGotoImage:(NSString *)gotoBackgroundimage SelectIdentityImage:(NSString *)IdentitySelectBackgroundImage finishWithRootController:(UIViewController *)vc
{
    [[WYIntroduceViewController sharedGuide] setData:images];
    [WYIntroduceViewController sharedGuide].imageNowGotoBackgroundImage = [UIImage imageNamed:gotoBackgroundimage];
    [WYIntroduceViewController sharedGuide].imageSelectBackgroundImage = [UIImage imageNamed:IdentitySelectBackgroundImage];
   
    [[WYIntroduceViewController sharedGuide] firstLaunchAppWithRootController:vc];
}
- (void)setData:(NSArray*)data
{
    if (!data)return;
    self.arrayImages = [NSMutableArray arrayWithArray:data];
}
- (void)firstLaunchAppWithRootController:(UIViewController *)vc
{
    
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:FirstStartSaveString])
    {
        window.rootViewController = self;
        self.rootViewController =vc;
        [window makeKeyAndVisible];
    }
    else
    {
        window.rootViewController = vc;
        [window makeKeyAndVisible];
    }
}

#pragma mark ---------UI-------------
-(UICollectionView *)collectionView
{
    if (!_collectionView) {
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumLineSpacing = 0.f;
        flowLayout.minimumInteritemSpacing = 0.f;
        // 设置滚动方向(水平)
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        flowLayout.itemSize = CGSizeMake(SCR_W, SCR_H);
        flowLayout.sectionInset = UIEdgeInsetsMake(0, 0,0,0);
        _collectionView = [[UICollectionView alloc ] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView.pagingEnabled = YES;
        [self.view addSubview:_collectionView];
        
        // 注册cell
        [_collectionView registerClass:[WYIntroduceCollectionViewCell class] forCellWithReuseIdentifier:@"WYI"];
        
        // 注册尾视图
        [_collectionView registerClass:[UICollectionReusableView class]forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"INTRODUCT"];
    }
    return _collectionView;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayImages.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    WYIntroduceCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WYI" forIndexPath:indexPath];
    
    UIImage* image = [UIImage imageNamed:self.arrayImages[indexPath.row]];
    cell.imageView.image = image;
    //    cell.backgroundColor = [UIColor colorWithRed:arc4random() % 255 / 255.f green:arc4random() % 255 / 255.f blue:arc4random() % 255 / 255.f alpha:1.0];
    
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [MobClick event:[NSString stringWithFormat:@"kUM_y_slide_%ld",indexPath.row]];
}
#pragma mark 设置尾视图的大小
- (CGSize )collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeZero;
//    return CGSizeMake(SCR_W, SCR_H);
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"INTRODUCT" forIndexPath:indexPath];

    if (kind == UICollectionElementKindSectionFooter) {
        
        //根据是否选择身份切换不同组尾
        if ([WYUserDefaultManager getUserTargetRoleType])
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self addButtonForNowGoToMainTabbarController:view];
            });
        }
        else
        {
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                [self addTwoSelectButtonsToSuperView:view];
            });
        }
    }
    view.backgroundColor = [UIColor whiteColor];
    return view;
}
//立即进入View
-(void)addButtonForNowGoToMainTabbarController:(UIView*)view
{
    if (self.imageNowGotoBackgroundImage) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.image = self.imageNowGotoBackgroundImage;
        [view addSubview:imageView];
    }
//    CGFloat Y = 905.f/1334.f*SCR_H;
//    CGFloat X = 175.f/750.f*SCR_W;
   
    CGFloat X = LCDScale_iPhone6_Width(20.f);
    CGFloat btn_W = (SCR_W-3*X)/2.0;
    CGFloat btn_H = (SCR_W-3*X)/2.0*100.f/314.f;
    CGFloat btnNowGoTo_Y = SCR_H-LCDScale_iPhone6_Width(60)-btn_H;
    CGFloat btnNowGoTo_X = (SCR_W-btn_W)/2.f;

    UIButton *btnNowGoTo = [[UIButton alloc] initWithFrame:CGRectMake(btnNowGoTo_X,btnNowGoTo_Y-HEIGHT_TABBAR_SAFE, btn_W,btn_H)];
    btnNowGoTo.adjustsImageWhenHighlighted = NO;
    [btnNowGoTo setBackgroundImage:[UIImage imageNamed:@"startGo"] forState:UIControlStateNormal];
    [btnNowGoTo addTarget:self action:@selector(clickNowGoTo:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnNowGoTo];
    
}
//身份选择View
-(void)addTwoSelectButtonsToSuperView:(UIView*)view
{
    if (self.imageSelectBackgroundImage) {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:view.bounds];
        imageView.image = self.imageSelectBackgroundImage;
        [view addSubview:imageView];
    }
    CGFloat X = LCDScale_iPhone6_Width(20.f);
    CGFloat btn_W = (SCR_W-3*X)/2.0;
    CGFloat btn_H = (SCR_W-3*X)/2.0*100.f/314.f;
    CGFloat btnLeft_Y = SCR_H-LCDScale_iPhone6_Width(60.f)-btn_H;
    CGFloat btnRight_Y = SCR_H-LCDScale_iPhone6_Width(60.f)-btn_H;
    
    UIButton *btnPur = [[UIButton alloc] initWithFrame:CGRectMake(X, btnLeft_Y-HEIGHT_TABBAR_SAFE,btn_W, btn_H)];
    btnPur.adjustsImageWhenHighlighted = NO;
    [btnPur setBackgroundImage:[UIImage imageNamed:@"startPur"] forState:UIControlStateNormal];
    [btnPur addTarget:self action:@selector(clickbtnPur:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnPur];
    
    UIButton *btnSel = [[UIButton alloc] initWithFrame:CGRectMake(2*X+btn_W, btnRight_Y-HEIGHT_TABBAR_SAFE,btn_W,btn_H)];
    btnSel.adjustsImageWhenHighlighted = NO;
    [btnSel setBackgroundImage:[UIImage imageNamed:@"startSel"] forState:UIControlStateNormal];
    [btnSel addTarget:self action:@selector(clickbtnSel:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btnSel];
}
//我是商户
-(void)clickbtnSel:(UIButton*)sender
{
    [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_seller];
    [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_AppLanuch];
    
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstStartSaveString];
    [self setWindowRootViewController];
    [self upLoadID];

    [MobClick event:kUM_y_supplier];

    if ([self.delegate respondsToSelector:@selector(WYIntroduceViewController:didUIbutton:)])
    {
        [self.delegate WYIntroduceViewController:self didUIbutton:WYWYIntroduceViewControllerLeftBTN];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_PostDataToHost object:nil];

}
//我是采购商
-(void)clickbtnPur:(UIButton*)sender
{
    [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_buyer];
    [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_AppLanuch];

    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstStartSaveString];
    [self setWindowRootViewController];
    [self upLoadID];
    
    [MobClick event:kUM_y_purchasers];

    if ([self.delegate respondsToSelector:@selector(WYIntroduceViewController:didUIbutton:)])
    {
        [self.delegate WYIntroduceViewController:self didUIbutton:WYWYIntroduceViewControllerRightBTN];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_PostDataToHost object:nil];
}
-(void)clickNowGoTo:(UIButton*)sender
{
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:FirstStartSaveString];

    [self setWindowRootViewController];
    
    if ([self.delegate respondsToSelector:@selector(WYIntroduceViewController:didUIbutton:)])
    {
        [self.delegate WYIntroduceViewController:self didUIbutton:WYWYIntroduceViewControllerNowGoToBTN];
    }
}
-(void)setWindowRootViewController
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    window.rootViewController = self.rootViewController;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    
}
-(void)upLoadID
{
    WYTargetRoleSource source = [WYUserDefaultManager getChangeUserTargetRoleSource];
    [[[AppAPIHelper shareInstance]getUserModelAPI]postChangeUserRoleWithClientId:nil source:source targetRole:[WYUserDefaultManager getUserTargetRoleType] success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];

}
//隐藏状态栏
- (BOOL)prefersStatusBarHidden
{
    return YES;
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
