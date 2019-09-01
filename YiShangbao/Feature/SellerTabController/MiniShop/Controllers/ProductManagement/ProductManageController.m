//
//  ProductManageController.m
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductManageController.h"
#import "SellingProductController.h"
#import "SoldOutProductController.h"
#import "AddProductController.h"
#import "ZXCenterBottomToolView.h"
#import "PrivacyProductsController.h"
#import "ProductSearchController.h"
#import "ZXWebViewController.h"
#import "WYShopCategoryViewController.h"
#import "ProMScreeningView.h"

@interface ProductManageController ()<ProMScreeningViewDelegate>

@property (nonatomic, strong) SellingProductController *firstController;

@property (nonatomic, strong) PrivacyProductsController *secondController;

@property (nonatomic, strong) SoldOutProductController *thirdController;

@property (nonatomic, strong) UIViewController *currentController;

@property (nonatomic, strong) UIImageView *indicateImageView;

@property (nonatomic, strong) ProMScreeningView *screenView;

@property (nonatomic, copy) NSArray *proNumArray;
@end

@implementation ProductManageController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setUI];
    [self setData];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (void)setUI
{
    self.title = NSLocalizedString(@"产品管理", nil);
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    [self addBottomView];
    [self addChildContrllerView];
    [self addSegmentedControl];
    [self addProMScreeningView];
}
-(void)addProMScreeningView
{
    ProMScreeningView *sView = [[ProMScreeningView alloc] initWithFrame:CGRectMake(0, HEIGHT_NAVBAR+60+10, LCDW,45)];
    sView.delegate = self;
    self.screenView = sView;
    [self.view addSubview:self.screenView];
}
- (void)addSegmentedControl
{
    [UIView zx_NSLogSubviewsFromView:self.segmentedControl andLevel:1];
    self.segmentedControl.tintColor = [UIColor whiteColor];
    self.numSegmentedControl.tintColor = [UIColor whiteColor];
    [self.segmentedControl setBackgroundImage:[UIImage zx_imageWithColor:[UIColor clearColor] andSize:CGSizeMake(100, 49)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.segmentedControl setBackgroundImage:[UIImage zx_imageWithColor:[UIColor clearColor] andSize:CGSizeMake(100, 49)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];

    
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(253.f, 118.f, 78.f),NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} forState:UIControlStateSelected];
    [self.segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(134.f, 134.f, 134.f),NSFontAttributeName:[UIFont systemFontOfSize:13]} forState:UIControlStateNormal];
    
    self.numSegmentedControl.userInteractionEnabled = NO;
    [self.numSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(253.f, 118.f, 78.f),NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} forState:UIControlStateSelected];
    [self.numSegmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:UIColorFromRGB(83.f, 83.f, 83.f),NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    [self.numSegmentedControl setTitle:@"0" forSegmentAtIndex:2];
    [self.numSegmentedControl setTitle:@"0" forSegmentAtIndex:0];
    [self.numSegmentedControl setTitle:@"0" forSegmentAtIndex:1];
    
    
    UIImage *indicateImg = [UIImage zx_imageWithColor:UIColorFromRGB_HexValue(0xFD764E) andSize:CGSizeMake(60, 10)];
    UIImageView *indicateView = [[UIImageView alloc] initWithImage:indicateImg];
    self.indicateImageView = indicateView;
    [self.segmentedContainerView addSubview:indicateView];
    self.indicateImageView.frame = [self getIndicateImageViewFrameWithIndex:0];
    [indicateView zx_setCornerRadius:CGRectGetHeight(self.indicateImageView.frame)/2 borderWidth:0 borderColor:nil];
}


- (void)addChildContrllerView
{
    // 初始化2个子控制器
    self.firstController = (SellingProductController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_SellingProductController];
    self.secondController = (PrivacyProductsController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_PrivacyProductsController];
    self.thirdController = (SoldOutProductController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_SoldOutProductController];
    self.firstController.view.frame = self.view.frame;
    
    [self addChildViewController:self.firstController];
    [self.view addSubview:self.firstController.view];
    self.currentController = self.firstController;
}


- (CGRect)getIndicateImageViewFrameWithIndex:(NSInteger)index
{
    CGRect segmentedFrame = CGRectMake(40, 0, LCDW-2*40, 29);
    
    CGFloat totalTitleWidth = 0.f;
    NSString *title1 =[self.segmentedControl titleForSegmentAtIndex:0];
    NSDictionary *attribute = [self.segmentedControl titleTextAttributesForState:UIControlStateNormal];
    CGRect rect1 = [title1 boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:attribute context:nil];
    totalTitleWidth = 3* rect1.size.width;
    
    CGFloat segementMaginX = (segmentedFrame.size.width-totalTitleWidth)/(self.segmentedControl.numberOfSegments*2);
    
    CGFloat indicateHeight = 3;
    CGFloat offsetTotalWidth =segementMaginX;
    for (int j =0; j<index; j++)
    {
        offsetTotalWidth = offsetTotalWidth+totalTitleWidth/3+2*segementMaginX;
    }
    CGRect rect = CGRectMake(segmentedFrame.origin.x+offsetTotalWidth-5, CGRectGetHeight(self.segmentedContainerView.frame)-indicateHeight-2, totalTitleWidth/3+10, indicateHeight);
    return rect;
}

#pragma mark 获取电脑上传H5地址

- (void)setData
{
    // 初始化选中哪个item
    [self setupSelectSegmentIndex];
    // 编辑完后要返回产品管理页面 指定私密 还是公开，并且刷新数据；更新选中哪个item，及刷新数据；
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateSelectIndex:) name:Noti_ProductManager_selectIndexUpdate object:nil];
    
    // 编辑及删除
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateCurrentController:) name:Noti_ProductManager_Edit_goBackUpdate object:nil];
    
    // 刷新产品数量数据
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProNumData:) name:Noti_ProductManager_updatePublic object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProNumData:) name:Noti_ProductManager_updatePrivacy object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateProNumData:) name:Noti_ProductManager_updateSoldouting object:nil];
    
    [self updateProNumData:nil];
}

- (void)updateProNumData:(id)notification
{
     [self reqeustProNumData];
}

- (void)reqeustProNumData
{
    WS(weakSelf);
    [ProductMdoleAPI getMyProductListProCountWithSuccess:^(id data) {
        
        weakSelf.proNumArray = data;
        [weakSelf setProductNum];
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)setProductNum
{
    [self.proNumArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ProductManagerCountModel *model = (ProductManagerCountModel *)obj;
        if ([model.status isEqualToNumber:@(0)])
        {
            [self.numSegmentedControl setTitle:[model.proCount stringValue] forSegmentAtIndex:2];
        }
        else if ([model.status isEqualToNumber:@(1)])
        {
            [self.numSegmentedControl setTitle:[model.proCount stringValue] forSegmentAtIndex:0];
        }
        else
        {
            [self.numSegmentedControl setTitle:[model.proCount stringValue] forSegmentAtIndex:1];
        }
    }];
}

- (void)addBottomView
{
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXTowBtnBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([ZXTowBtnBottomToolView class]) owner:self options:nil] firstObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    
    // 本店分类设置
    [view.leftBtn setBackgroundColor:[UIColor colorWithWhite:0 alpha:0.25]];
    [view.leftBtn setTitle:NSLocalizedString(@"本店分类设置", nil)  forState:UIControlStateNormal];
    [view.leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIImage *image = [[UIImage imageNamed:@"ic_fenleishezhi"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [view.leftBtn setImage:image forState:UIControlStateNormal];
    view.leftBtnWidthLayout.constant = LCDScale_iPhone6_Width(170);
    [view.leftBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [view.leftBtn addTarget:self action:@selector(classifyBtnAction:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.rightBtn.frame.size];
    [view.rightBtn setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    view.rightBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [view.rightBtn setTitle:NSLocalizedString(@"上传产品", nil)  forState:UIControlStateNormal];
    [view.rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [view.rightBtn addTarget:self action:@selector(bottomBtnAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - 上传产品

- (void)bottomBtnAction:(UIButton *)sender
{
    if (![UserInfoUDManager isOpenShop])
    {
        [self addShopAlert];
        return ;
    }
    [self performSegueWithIdentifier:@"AddProductControllerSegue" sender:self];
}

#pragma mark - 本店分类

- (void)classifyBtnAction:(UIButton *)sender forEvent:(UIEvent *)event
{
    [MobClick event:kUM_b_pd_myclass];
    
    if (![UserInfoUDManager isOpenShop])
    {
        [self addShopAlert];
        return ;
    }
    WYShopCategoryViewController *vc = (WYShopCategoryViewController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_WYShopCategoryViewController];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"本店分类设置跳转");
}

#pragma mark- 完善商铺资料的弹出警告

- (void)addShopAlert
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"完善商铺资料后就能管理您的商铺啦～" message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"立即完善资料" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [[WYUtility dataUtil]routerWithName:@"microants://makeShopQuick" withSoureController:self];
    }];
}

//设置2个子控制器view的frame；
- (void)viewDidLayoutSubviews {
    
    [super viewDidLayoutSubviews];
    CGFloat segmentedHeight = CGRectGetHeight(self.segmentedContainerView.frame);
    
    if (@available(iOS 11.0, *))
    {
        self.firstController.view.frame =CGRectMake(0, self.view.safeAreaLayoutGuide.layoutFrame.origin.y+(segmentedHeight+10+45), LCDW, self.view.safeAreaLayoutGuide.layoutFrame.size.height-CGRectGetHeight(self.bottomContainerView.frame)-(segmentedHeight+10+45));
    }
    else
    {
        self.firstController.view.frame = CGRectMake(0, self.topLayoutGuide.length+(segmentedHeight+10+45), LCDW, LCDH-self.topLayoutGuide.length-CGRectGetHeight(self.bottomContainerView.frame)-(segmentedHeight+10+45) );
    }
    
   
    self.secondController.view.frame =self.firstController.view.frame;
    self.thirdController.view.frame = self.firstController.view.frame;
    
//    UIOffset offset =  [self.segmentedControl contentPositionAdjustmentForSegmentType:UISegmentedControlSegmentAny barMetrics:UIBarMetricsDefault];
//    NSLog(@"%@",NSStringFromUIOffset(offset));
}

//- (void)viewDidLayoutSubviews
//{
//    UIEdgeInsets inset = self.tableView.contentInset;
//    inset.bottom = 60.f;
//    self.tableView.contentInset = inset;
    
//    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0.f, 60.f, 0.f);
//    [super viewDidLayoutSubviews];
//    
//}


// 初始化选中哪个item
- (void)setupSelectSegmentIndex
{
    //默认选中self.selectIndex变量
    self.segmentedControl.selectedSegmentIndex = self.selectIndex;
    [self segmentChangeAction:self.segmentedControl];
}

// 发送通知更新当前控制器，主要用于编辑返回，删除返回等；
- (void)updateCurrentController:(NSNotification *)notification
{
    [self updateProNumData:nil];
    if (self.segmentedControl.selectedSegmentIndex==0)
    {
        [self.firstController.tableView.mj_header beginRefreshing];
    }
    else if (self.segmentedControl.selectedSegmentIndex==1)
    {
        [self.secondController.tableView.mj_header beginRefreshing];
    }
    else if (self.segmentedControl.selectedSegmentIndex ==2)
    {
        [self.thirdController.tableView.mj_header beginRefreshing];
    }
}

// 发送通知，更新选中index索引；从item1及页面离开，返回来的时候展示item2及页面
- (void)updateSelectIndex:(NSNotification *)notification
{
    [self updateProNumData:nil];
    NSDictionary *dic = notification.userInfo;
    if ([dic objectForKey:@"selectIndex"])
    {
        NSNumber *selectIndex = [dic objectForKey:@"selectIndex"];
        if (self.segmentedControl.selectedSegmentIndex !=[selectIndex integerValue])
        {
            self.segmentedControl.selectedSegmentIndex = [selectIndex integerValue];
            [self segmentChangeAction:self.segmentedControl];
        }
        if ([selectIndex integerValue]==0)
        {
            [self.firstController.tableView.mj_header beginRefreshing];
        }
        else if ([selectIndex integerValue]==1)
        {
            [self.secondController.tableView.mj_header beginRefreshing];
        }
        else if ([selectIndex integerValue]==2)
        {
            [self.thirdController.tableView.mj_header beginRefreshing];
        }
    }
}



//segmentedControl切换逻辑
- (IBAction)segmentChangeAction:(UISegmentedControl *)sender {
    
    NSInteger index = sender.selectedSegmentIndex;
    self.numSegmentedControl.selectedSegmentIndex = index;
    
    if ((self.currentController == self.firstController && index ==0)
        ||(self.currentController == self.secondController && index ==1)
        ||(self.currentController == self.thirdController && index ==2)
        )
    {
        return;
    }
    else
    {
        [UIView animateWithDuration:0.4 animations:^{
            
            self.indicateImageView.frame = [self getIndicateImageViewFrameWithIndex:index];

        } completion:^(BOOL finished) {
            
        }];
        switch (index) {
            case 0:
                [self replaceController:self.currentController newController:self.firstController];
                
                break;
            case 1:
                [self replaceController:self.currentController newController:self.secondController];
            case 2:
                   [self replaceController:self.currentController newController:self.thirdController];
            default:
                break;
        }
        
    }
}


- (void)replaceController:(UIViewController *)oldController newController:(UIViewController *)newController
{
    
    [self addChildViewController:newController];
    
    UIViewAnimationOptions  animationOption = UIViewAnimationOptionTransitionCrossDissolve;
    
    [self transitionFromViewController:oldController toViewController:newController duration:0.2f options:animationOption animations:nil completion:^(BOOL finished) {
        
        [newController didMoveToParentViewController:self];
        [oldController willMoveToParentViewController:nil];
        [oldController removeFromParentViewController];
        self.currentController = newController;
        
        //更新公用一个筛选组件的状态
        if (newController == self.firstController) {
            self.screenView.timeBtn.selected = self.firstController.direction;
            self.screenView.mainSelBtn.selected = self.firstController.onlyMain;
            self.screenView.mainSelBtn.hidden = NO;
        }
        if (newController == self.secondController) {
            self.screenView.timeBtn.selected = self.secondController.direction;
            self.screenView.mainSelBtn.hidden = YES;
        }
        if (newController == self.thirdController) {
            self.screenView.timeBtn.selected = self.thirdController.direction;
            self.screenView.mainSelBtn.hidden = YES;
        }
        
    }];
    
   
}



#pragma mark - Navigation

//- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(nullable id)sender
//{
//    if ([identifier isEqualToString:segue_FansViewController] || [identifier isEqualToString:segue_VisitorViewController])
//    {
//
//    }
//    return NO;
//}

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    UIViewController *viewController= segue.destinationViewController;
    
    if ([viewController isKindOfClass:[AddProductController class]])
    {
        if ([viewController respondsToSelector:@selector(setAddProductPushType:)])
        {
            [MobClick event:kUM_b_PMaddproduct];
            
            [viewController setValue:@(AddProudctPushType_goBackProductManager) forKey:@"addProductPushType"];
        }

    }
    

}
#pragma mark 电脑上传
-(IBAction)pcUploadAction:(UIBarButtonItem *)sender
{
    [MobClick event:kUM_b_productcontrol_upload];
    
    LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
    NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.pcUploadIntro;
    [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_pcUploadIntro withSoureController:self];
}

#pragma mark 搜索
- (IBAction)searchAction:(UIBarButtonItem *)sender {
    
    [MobClick event:kUM_b_pd_search];
  ProductSearchController *vc = (ProductSearchController *)[self zx_getControllerWithStoryboardName:storyboard_ShopStore controllerWithIdentifier:SBID_ProductSearchController];
    
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [nav zx_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
  [nav zx_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
  [self presentViewController:nav animated:YES completion:nil];

}
#pragma mark 是否允许改变按钮状态(eg:当前正在刷新时)
-(BOOL)wy_proMScreeningView:(ProMScreeningView *)view shouldChangeSelected:(UIButton *)sender
{
    if (self.currentController == self.firstController)
    {
       return ![self.firstController.tableView.mj_header isRefreshing];
    }
    if(self.currentController == self.secondController)
    {
        return ![self.secondController.tableView.mj_header isRefreshing];
    }
    if(self.currentController == self.thirdController)
    {
        return ![self.thirdController.tableView.mj_header isRefreshing];
    }
    return NO;
}
#pragma mark 筛选-按时间、只看主营
-(void)wy_proMScreeningView:(ProMScreeningView *)view didChangeTimeBtnSelected:(BOOL)time mainSelBtnSelected:(BOOL)mainSel changeTime:(BOOL)ischangeTime
{
    if (ischangeTime) {
        [MobClick event:kUM_b_productcontrol_switchover];
    }else{
        [MobClick event:kUM_b_productcontrol_major];
    }

    if (self.currentController == self.firstController)
    {
        self.firstController.direction = time; //重写Set方法下啦刷新
        self.firstController.onlyMain = mainSel;
    }
    if(self.currentController == self.secondController)
    {
        self.secondController.direction = time;
    }
    if(self.currentController == self.thirdController)
    {
        self.thirdController.direction = time;
    }
}



//- (void)checkPrintWithShowUI:(id)sender
//{
//    if (![UIPrintInteractionController isPrintingAvailable])
//    {
//        if ([sender isKindOfClass:[UIView class]])
//        {
//            [sender removeFromSuperview];
//        }
//        else if ([sender isKindOfClass:[UIBarButtonItem class]])
//        {
//            UIBarButtonItem *item = (UIBarButtonItem *)sender;
//            item.enabled = NO;
//        }
//    }
//}
//
//- (void)printContent
//{
//
//    UIImage *printImage = [UIImage imageNamed:@"11.jpg"];
//    NSString *path = [[NSBundle mainBundle]pathForResource:@"11" ofType:@"jpg"];
//    //    NSURL *url = [NSURL fileURLWithPath:path];
//    NSData *data = [NSData dataWithContentsOfFile:path];
//
//    UIPrintInteractionController *printController = [UIPrintInteractionController sharedPrintController];
//    if (!printController && ![UIPrintInteractionController canPrintData:data])
//    {
//        return;
//    }
//    printController.delegate = self;
//    printController.showsNumberOfCopies = YES;
//    printController.showsPaperSelectionForLoadedPapers = YES;
//
//    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
//    printInfo.outputType  = UIPrintInfoOutputGeneral;
//    printInfo.orientation = UIPrintInfoOrientationPortrait;
//    printInfo.jobName = @"打印测试";
//    printInfo.duplex = UIPrintInfoDuplexLongEdge;
//
//    printController.printInfo = printInfo;
//
//    printController.printingItem = printImage;
//    //    UIViewPrintFormatter *viewPrintFormatter = [self.firstController.view viewPrintFormatter];
//    //    viewPrintFormatter.startPage = 0;
//    //    printController.printFormatter = viewPrintFormatter;
//    //
//    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) = ^(UIPrintInteractionController *printController, BOOL completed, NSError *error) {
//        if (!completed && error)
//        {
//            NSLog(@"%@",[error localizedDescription]);
//        }
//    };
//    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//    {
//        //iPad
//        [printController presentFromRect:self.view.frame inView:self.view animated:YES completionHandler:completionHandler];
//    }
//    else
//    {
//        [printController presentAnimated:YES completionHandler:completionHandler];
//    }
//}


@end
