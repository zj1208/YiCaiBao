//
//  MineMainViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MineMainViewController.h"

#import "WYPurchaserViewController.h"

#import "WYSellerMineHeadTableViewCell.h"
//#import "WYSellerMineStatusTableViewCell.h"
#import "WYSellerMineBaseTableViewCell.h"
#import "WYSellerServiceTableViewCell.h"

#import "WYMessageListViewController.h"
#import "ZXWebViewController.h"
#import "PersonalInfoViewController.h"
#import "SettingViewController.h"
#import "WYTabBarViewController.h"

#import "WYIntegralButton.h"
#import "JLDragImageView.h"
#import "MessageModel.h"
//#import "GuideMineController.h"
//#import "ZXBadgeIconButton.h"
//急速开店页面
//#import "FastOpenShopViewController.h"


@interface MineMainViewController ()<UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate,JLDragImageViewDelegate,ZXHorizontalPageCollectionViewDelegate>

//CustomNav
@property(nonatomic, strong) WYIntegralButton* integralBtn;
@property(nonatomic, strong) UIButton* settingBtn;

//tableView
@property (nonatomic, strong) UITableView * mainTableView;
@property (nonatomic, strong) JLDragImageView *tradeMoveView;

//data
@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) NSString *serviceManagerUrl;
//分享有礼
@property (nonatomic, strong) advArrModel *advItemModel;

@property (nonatomic, strong) ShopHomeInfoModel *serviceModel;

@end


@implementation MineMainViewController

#pragma mark - life cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人中心";
    [self creatUI];
    
//    [self serviceManagerUrlRequest];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    [self requestServerInfo];
    
//    [self.navigationController.navigationBar  setShadowImage:[[UIImage alloc] init]];
//    [self.navigationController.navigationBar  setBackgroundImage:[self creatImage] forBarMetrics:UIBarMetricsDefault];
//    self.navigationController.navigationBar.translucent = NO;
    
}

- (void)viewWillDisappear:(BOOL)animated{
     [super viewWillDisappear:animated];
//    if (!self.presentedViewController){
//        [self.navigationController.navigationBar  setShadowImage:nil];
//        [self.navigationController.navigationBar  setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//        self.navigationController.navigationBar.translucent = YES;
//    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}


#pragma mark -Request

-(void)initData{
    //提示
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@1004 success:^(id data) {
        
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0)
        {
            self.advItemModel = [model.advArr firstObject];
            //拖动按钮
            if (!self.tradeMoveView) {
                self.tradeMoveView = [[JLDragImageView alloc] init];
                self.tradeMoveView.delegate = self;
            }
            [self.tradeMoveView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:self.advItemModel.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.tradeMoveView showSuperview:self.view frameOffsetX:0 offsetY:50 Width:70 Height:70];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
    
    
    if (![UserInfoUDManager isLogin])
    {
        self.userModel = nil;
        [self.mainTableView reloadData];
//        [self.integralBtn setTitle:@"未登录" forState:UIControlStateNormal];
        return;
    }
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMyInfomationWithSuccess:^(id data) {
        weakSelf.userModel = data;
        [_mainTableView reloadData];
//        [weakSelf.integralBtn setTitle:[NSString stringWithFormat:@"%@", weakSelf.userModel.score] forState:UIControlStateNormal];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestServerInfo{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]getShopAPI]getShopHomeInfoWithFactor:@(4) Success:^(id data) {
        weakSelf.serviceModel = [[ShopHomeInfoModel alloc] init];
        weakSelf.serviceModel = data;
        [weakSelf.mainTableView reloadData];
        
    } failure:^(NSError *error) {
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

//- (void)switchIdentityRequest{
//    [MBProgressHUD zx_showLoadingWithStatus:@"身份切换中" toView:self.view];
//    WS(weakSelf);
//    NSString *clientId = [UserInfoUDManager getClientId];
//    [[[AppAPIHelper shareInstance]userModelAPI]postChangeUserRoleWithClientId:clientId source:WYTargetRoleSource_userChange targetRole:WYTargetRoleType_buyer success:^(id data) {
//
//        [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_buyer];
//        [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_userChange];
//
//        WYPurchaserViewController *vc = [[WYPurchaserViewController alloc] init];
//        APP_MainWindow.rootViewController = vc;
//        [MBProgressHUD zx_showText:nil customIcon:@"pic_change_caigoushang" view:nil];
//
//    } failure:^(NSError *error) {
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//    }];
//
//}

- (void)myMarketAuthenticationRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] getUserModelAPI] getMarketQualiInfoWithSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        if ([[data allKeys] containsObject:@"url"]) {
            [weakSelf goWebViewWithUrl:[data objectForKey:@"url"]];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)integralMallRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:nil];
    [[[AppAPIHelper shareInstance] publicAPI] getDuibaLoginUrlSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:nil];
        if (data) {
            [weakSelf goWebViewWithUrl:data];
            
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}

- (void)serviceManagerUrlRequest{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] publicAPI] getServiceManagerUrlSuccess:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        if (data) {
//            weakSelf.serviceManagerUrl = data;
            [self goWebViewWithUrl:data];
        }
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

// 服务item点击去角标
- (void)requestClickRefreshSubscribeWithName:(NSString *)name{
    [[[AppAPIHelper shareInstance] getShopAPI] postShopStoreFlushClickWithName:name success:^(id data) {
        
    } failure:^(NSError *error) {
    }];
}

#pragma mark -Action
- (void)imageTap:(id)sender{
    if ([self zx_performIsLoginActionWithPopAlertView:NO])
    {
        PersonalInfoViewController *vc = [[PersonalInfoViewController alloc] init];
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

//- (void)pushProductTap:(id)sender{
//    [MobClick event:kUM_b_Mypushproduct];
//
//    //我推的产品
//    if ([self zx_performIsLoginActionWithPopAlertView:NO]) {
//        NSString *url = [NSString stringWithFormat:@"%@/yicaibao/myRecommend?shopId=%@",[WYUserDefaultManager getkAPP_H5URL],[UserInfoUDManager getShopId]];
//        [self goWebViewWithUrl:url];
//    }
//}
//
//-(void)clearInventoryTap:(id)sender{
//
//    [MobClick event:kUM_b_Mypushinventory];
//
//    //    我推的库存
//    if ([self zx_performIsLoginActionWithPopAlertView:NO]) {
//        NSString *url = [NSString stringWithFormat:@"%@/yicaibao/myStock?shopId=%@",[WYUserDefaultManager getkAPP_H5URL],[UserInfoUDManager getShopId]];
//        [self goWebViewWithUrl:url];
//    }
//
//}
//
//-(void)acceptBusinessTap:(id)sender{
//
//    [MobClick event:kUM_b_Myyijie];
//    if ([self zx_performIsLoginActionWithPopAlertView:NO]) {
//        [self zx_pushStoryboardViewControllerWithStoryboardName:storyboard_Trade identifier:SBID_MyTradesController withData:nil];
//    }
//}
//
//-(void)wantBuyTap:(id)sender{
//
//    [MobClick event:kUM_b_Mytobuy];
//
//    //    我的求购
//    if ([self zx_performIsLoginActionWithPopAlertView:NO]){
//        NSString *url = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseOrder.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [self goWebViewWithUrl:url];
//    }
//}

//我的市场认证
- (void)myMarketAuthentication{
    if ([self zx_performIsLoginActionWithPopAlertView:NO]){
        if ([UserInfoUDManager isOpenShop])
        {
            [self myMarketAuthenticationRequest];
        }
        else
        {
            [[WYUtility dataUtil] routerWithName:@"microants://makeShopQuick" withSoureController:self];
        }
    }
}

//我的积分
- (void)integralAction{
    [MobClick event:kUM_b_myintegral];
    if ([self zx_performIsLoginActionWithPopAlertView:NO]){
        [self goWebViewWithUrl:self.userModel.scoreUrl];
    }
}

//我订购的服务
- (void)orderService{
    [MobClick event:kUM_b_my_service];
    if ([self zx_performIsLoginActionWithPopAlertView:NO]) {
//        NSString *url = [NSString stringWithFormat:@"%@/ycb/page/myOrderedService.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [self goWebViewWithUrl:url];
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.myOrderedService;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_myOrderedService withSoureController:self];
    }
}

//积分商城
- (void)integralMall{
    [MobClick event:kUM_b_Integralmall];
    [self integralMallRequest];
}

//设置
- (void)settingBtnAction{
    [MobClick event:kUM_b_Set];
    
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//身份切换
//- (void)switchIdentity{
//
////    [MobClick event:kUM_b_identity];
//    [self switchIdentityRequest];
//}

- (void)serviceQQ{
    [MobClick event:kUM_b_ServiceQQ];
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"1839153907"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else{
        [MBProgressHUD zx_showError:@"请先安装手机QQ哦～" toView:self.view];
    }
}

//服务经理
- (void)serviceManager{
    [MobClick event:kUM_b_servicemanager];
//    if (self.serviceManagerUrl){
//        [self goWebViewWithUrl:self.serviceManagerUrl];
//    }else{
        [self serviceManagerUrlRequest];
//    }
}

- (void)goWebViewWithUrl:(NSString *)url{
    

    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
    
}

#pragma mark- ZXHorizontalPageCollectionViewDelegate

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView willDisplayCell:(ZXBadgeCollectionCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    cell.imgViewLayoutWidth.constant = LCDScale_iPhone6_Width(40);
}

- (void)zx_horizontalPageCollectionView:(ZXHorizontalPageCollectionView *)pageView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    BadgeItemCommonModel *model = self.serviceModel.perfectService[indexPath.item];
    [MobClick event:model.name];
    if ([self getIsRouteWithModel:model]){
        if (ISLOGIN && [model.name isEqualToString:@"bidbar"]){
            [self requestClickRefreshSubscribeWithName:model.name];
        }else if (model.sideMarkType ==SideMarkType_image){
            [self requestClickRefreshSubscribeWithName:model.name];
        }
        [[WYUtility dataUtil]routerWithName:model.url withSoureController:self];
    }
}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.mainTableView.contentOffset;
    if (offset.y < -(20 + SCREEN_STATUSHEIGHT)) {
        offset.y = -20 - SCREEN_STATUSHEIGHT;
    }
    self.mainTableView.contentOffset = offset;
}

#pragma mark -UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 2 || section == 3){
        return 3;
    }
    return 1;
}

#pragma mark -UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 1 && self.serviceModel.perfectService.count == 0) {
        return 0;
    }
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
//        return 174 + SCREEN_STATUSHEIGHT;
//        return 84 + 194;
        return 90.0;
    }else if (indexPath.section == 1){
        WYSellerServiceTableViewCell *cell = [[WYSellerServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSellerServiceTableViewCellID];
        CGFloat height =  [cell getCellHeightWithContentData:self.serviceModel.perfectService];
        return height;
//        return 60.0;
    }else return 45;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        WYSellerMineHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYSellerMineHeadTableViewCellID];
        if (!cell) {
            cell = [[WYSellerMineHeadTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSellerMineHeadTableViewCellID];
        }
        
        [cell.headButton addTarget:self action:@selector(imageTap:) forControlEvents:UIControlEventTouchUpInside];
        [cell.integralButton addTarget:self action:@selector(integralAction) forControlEvents:UIControlEventTouchUpInside];
        [cell updateData:self.userModel];
        return cell;
    }else if (indexPath.section == 1){
        WYSellerServiceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:WYSellerServiceTableViewCellID];
        if (!cell) {
            cell = [[WYSellerServiceTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSellerServiceTableViewCellID];
        }
        cell.itemPageView.delegate = self;
        [cell setData:self.serviceModel.perfectService];
        return cell;
    }else{
        WYSellerMineBaseTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:WYSellerMineBaseTableViewCellID];
        if (!cell) {
            cell = [[WYSellerMineBaseTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WYSellerMineBaseTableViewCellID];
        }
        if (indexPath.section == 2 && indexPath.row == 0) {
            if (self.userModel.authStatus.integerValue) {
                [cell updateImageName:@"shop_id" name:@"我的市场认证" content:@" 已认证" showArrow:YES contentLeftImageName:@"pic_v"];
            }else{
                [cell updateImageName:@"shop_id" name:@"我的市场认证" content:@"未认证" showArrow:YES];
            }
        }else if (indexPath.section == 2 && indexPath.row == 1) {
            [cell updateImageName:@"shop_dinggou" name:@"我订购的服务" content:@"" showArrow:YES];
        }else if (indexPath.section == 2 && indexPath.row == 2) {
            [cell updateImageName:@"shop_jifen" name:@"积分商城" content:@"积分换好礼 " showArrow:YES contentRightImageName:@"pic_gift"];
        }else if (indexPath.section == 3 && indexPath.row == 0) {
            [cell updateImageName:@"shop_service" name:@"客服电话" content:@"400-666-0998" showArrow:NO];
        }else if (indexPath.section == 3 && indexPath.row == 1) {
            [cell updateImageName:@"shop_qq" name:@"客服QQ" content:@"1839153907" showArrow:NO];
        }else if(indexPath.section == 3 && indexPath.row == 2) {
            [cell updateImageName:@"shop_servicemanager" name:@"义采宝服务经理" content:@"" showArrow:YES];
        }
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1){
//        [self switchIdentity];
    }else if (indexPath.section == 2 && indexPath.row == 0){
        [self myMarketAuthentication];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        [self orderService];
    }else if (indexPath.section == 2 && indexPath.row == 2){
        [self integralMall];
    }else if (indexPath.section == 3 && indexPath.row == 0){
        [MobClick event:kUM_b_Servicetel];
        //客服电话
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006660998"]];
    }else if (indexPath.section == 3 && indexPath.row == 1){
        [self serviceQQ];
    }else if (indexPath.section == 3 && indexPath.row == 2){
        [self serviceManager];
    }
}

#pragma mark - private function
- (void)creatUI{
    
    //tableview
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [self.view addSubview:self.mainTableView];
    [self.mainTableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.bottom.equalTo(self.view);
    }];
    
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    self.mainTableView.backgroundColor = WYUISTYLE.colorBGgrey;
    [self.mainTableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
    
    [self.mainTableView registerClass:[WYSellerMineHeadTableViewCell class] forCellReuseIdentifier:WYSellerMineHeadTableViewCellID];
    [self.mainTableView registerClass:[WYSellerServiceTableViewCell class] forCellReuseIdentifier:WYSellerServiceTableViewCellID];
    
    [self.mainTableView registerClass:[WYSellerMineBaseTableViewCell class] forCellReuseIdentifier:WYSellerMineBaseTableViewCellID];
    
//    //nav custom
//    self.integralBtn = [[WYIntegralButton alloc] init];
//    UIBarButtonItem * leftButton = [[UIBarButtonItem alloc]initWithCustomView:self.integralBtn];
////    self.navigationItem.leftBarButtonItem = leftButton;
//
//    [self.integralBtn setTitle:@"0" forState:UIControlStateNormal];
//    [self.integralBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
//    [self.integralBtn setImage:[UIImage imageNamed:@"pic_jifen_shanghu"] forState:UIControlStateNormal];
//    [self.integralBtn setArrowImage:@"ic_arrow2"];
//    [self.integralBtn setTitleColor:[UIColor colorWithHex:0xFF6935] forState:UIControlStateNormal];
//    self.integralBtn.isMoreClickZone = YES;
//    [self.integralBtn addTarget:self action:@selector(integralAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.settingBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 50)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.settingBtn];
    self.navigationItem.rightBarButtonItem = rightButton;

    [self.settingBtn addTarget:self action:@selector(settingBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.settingBtn setTitleColor:[UIColor colorWithHex:0x222222] forState:UIControlStateNormal];
    [self.settingBtn.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [self.settingBtn setTitle:@"设置" forState:UIControlStateNormal];
//    [self.settingBtn setImage:[UIImage imageNamed:@"ic_shezhi"] forState:UIControlStateNormal];
    
//    [self.settingBtn sizeToFit];
    
    //初始化数据
    self.userModel = [[UserModel alloc] init];
    
//    [self lauchFirstNewFunction];
//
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(remotePush:) name:Noti_RemoveView_GuideController object:nil];
    
}

////导航栏颜色
//- (UIImage *)creatImage{
//    NSArray *ar = @[(__bridge id) [UIColor colorWithHex:0xFFB45E].CGColor, (__bridge id) [UIColor colorWithHex:0xFF6950].CGColor];
//    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, 1), YES, 1);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSaveGState(context);
//    CGColorSpaceRef rgbSapceRef = CGColorSpaceCreateDeviceRGB();
//    CGGradientRef gradient = CGGradientCreateWithColors(rgbSapceRef, (CFArrayRef)ar, NULL);
//    CGPoint start = CGPointMake(0.0, 0.0);
//    CGPoint end = CGPointMake(SCREEN_WIDTH, 0.0);
//
//    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
//    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
//    CGGradientRelease(gradient);
//    CGContextRestoreGState(context);
//    UIGraphicsEndImageContext();
//    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    return image;
//}

//- (void)lauchFirstNewFunction{
//    if (![WYUserDefaultManager getNewNewFunctionGuide_MineV1]){
//        GuideMineController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"GuideMineControllerID"];
//        [self.tabBarController addChildViewController:vc];
//        [self.tabBarController.view addSubview:vc.view];
//
//    }
//}

//- (void)remotePush:(id)notification{
//    //跳转时移除功能引导
//    for (UIViewController*v  in self.tabBarController.childViewControllers) {
//        if ([v isKindOfClass:[GuideMineController class]]) {
//            [v.view removeFromSuperview];
//            [v removeFromParentViewController];
//        }
//    }
//
//}

//优选服务判断能否跳转
- (BOOL)getIsRouteWithModel:(BadgeItemCommonModel *)model{
    if (model.needLogin && ![self zx_performActionWithIsLogin:ISLOGIN withPopAlertView:NO]){
        return NO;
    }
    if (model.needOpenShop && ![UserInfoUDManager isOpenShop]) {
        [self addShopAlert];
        return NO;
    }
    return YES;
}

- (void)addShopAlert{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"完善商铺资料后就能管理您的商铺啦～" message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"立即完善资料" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [[WYUtility dataUtil]routerWithName:@"microants://makeShopQuick" withSoureController:self];
    }];
}

#pragma mark - 发求购 JLDragImageViewDelegate
-(void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer *)tapGes
{
    [self requestClickAdvWithAreaId:@1004 advId:[NSString stringWithFormat:@"%@",self.advItemModel.iid]];
    [self goWebViewWithUrl:self.advItemModel.url];
}
#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

@end
