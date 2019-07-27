//
//  PurchaserMineTableViewController.m
//  YiShangbao
//
//  Created by light on 2017/8/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserMineTableViewController.h"

#import "ZXBadgeIconButton.h"
#import "WYIntegralButton.h"

#import "PurchaserModel.h"
#import "BuyerPageMenuController.h"
#import "SettingViewController.h"
#import "WYMessageListViewController.h"
#import "ZXImgIconsCollectionView.h"
#import "ZXWebViewController.h"

@interface PurchaserMineTableViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) BuyerUserModel *userModel;

@property (nonatomic, strong) WYIntegralButton *integralBtn;
@property (nonatomic, strong) ZXBadgeIconButton* messageBadgeButton;
@property (nonatomic, strong) UIBarButtonItem * messageButton;
@property (nonatomic, strong) UIBarButtonItem * leftButton;
@property (nonatomic, strong) UIBarButtonItem *settingButton;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;//认证图标控件

@property (weak, nonatomic) IBOutlet UIView *headBackgroundView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *certificationIconsView;

@property (weak, nonatomic) IBOutlet UIImageView *personalCertificationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *companyCertificationImageView;
@property (weak, nonatomic) IBOutlet UIImageView *inviteImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *editContentImageView;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;//资料完成程度
@property (weak, nonatomic) IBOutlet UILabel *certificationStatusLabel;//认证状态



@property (weak, nonatomic) IBOutlet UILabel *wantToBuyCountLabel;//求购
@property (weak, nonatomic) IBOutlet UILabel *collectShopCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *collectGoodsCountLabel;

@property (weak, nonatomic) IBOutlet UIImageView *waitConfirmedOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitConfirmedOrderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitPayOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitPayOrderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitConsignmentOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitConsignmentOrderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitReceiveOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitReceiveOrderLabel;
@property (weak, nonatomic) IBOutlet UIImageView *waitEvaluateOrderImageView;
@property (weak, nonatomic) IBOutlet UILabel *waitEvaluateOrderLabel;
@property (weak, nonatomic) IBOutlet UIButton *usingTranslateButton;//翻译立即使用


@end

@implementation PurchaserMineTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor colorWithHex:0xF5F5F5];
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self setUI];
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self requestInfo];
    if (self.parentViewController){
        self.parentViewController.navigationItem.leftBarButtonItem = self.leftButton;
//        self.parentViewController.navigationItem.rightBarButtonItem = self.messageButton;
        self.parentViewController.navigationItem.rightBarButtonItems = @[self.settingButton,self.messageButton];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Request PersonInfo
- (void)requestInfo{
    [self requestBuyerInfo];
    [self requestMessageInfo];
}

- (void)requestBuyerInfo{
    WS(weakSelf);
    if (![UserInfoUDManager isLogin]){
        self.userModel = nil;
        [self reloadInfo];
        [self.integralBtn setTitle:@"未登录" forState:UIControlStateNormal];
        return;
    }
    [[[AppAPIHelper shareInstance] getPurchaserAPI] getBuyerInfoWithsuccess:^(id data) {
        weakSelf.userModel = data;
        [weakSelf reloadInfo];
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

- (void)requestMessageInfo
{
    if (![UserInfoUDManager isLogin])
    {
        [_messageBadgeButton setBadgeValue:0];
        return;
    }
    [[[AppAPIHelper shareInstance] messageAPI] getshowMsgCountWithsuccess:^(id data) {
        
        NSNumber *system = [data objectForKey:@"system"];
        NSNumber *market =  [data objectForKey:@"buyernews"];
        NSNumber *trade = [data objectForKey:@"trade"];
        NSNumber *todo = [data objectForKey:@"todo"];
        NSNumber *antsteam =  [data objectForKey:@"antsteam"];

        NSInteger total =[system integerValue]+[market integerValue]+[trade integerValue]+[todo integerValue] +antsteam.integerValue;
        NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
        NSInteger badgeValue = nimValue +total;
        [_messageBadgeButton setBadgeValue:(badgeValue)];
    } failure:^(NSError *error) {
        
        if ([[[NIMSDK sharedSDK]conversationManager]allUnreadCount]>0)
        {
            NSInteger nimValue = [[[NIMSDK sharedSDK]conversationManager]allUnreadCount];
            [_messageBadgeButton setBadgeValue:nimValue];
        }
    }];
}


#pragma mark -Action
//切换身份
//- (void)switchIdentity{
//    [MobClick event:kUM_c_identity];
//    [MBProgressHUD zx_showLoadingWithStatus:@"身份切换中" toView:nil];
////    WS(weakSelf);
//    NSString *clientId = [UserInfoUDManager getClientId];
//    [[[AppAPIHelper shareInstance] userModelAPI]postChangeUserRoleWithClientId:clientId source:WYTargetRoleSource_userChange targetRole:WYTargetRoleType_seller success:^(id data) {
////        [MBProgressHUD zx_showSuccess:nil toView:self.view];
//        [WYUserDefaultManager setUserTargetRoleType:WYTargetRoleType_seller];
//        [WYUserDefaultManager setChangeUserTargetRoleSource:WYTargetRoleSource_userChange];
//
//        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        APP_MainWindow.rootViewController = story.instantiateInitialViewController;
//        [MBProgressHUD zx_hideHUDForView:nil];
//        [MBProgressHUD zx_showText:nil customIcon:@"pic_change_gongyingshang" view:nil];
//
//    } failure:^(NSError *error) {
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
//    }];
//}

//我的积分
- (void)integralAction{
    [MobClick event:kUM_c_myintegral];
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        [self goWebViewWithUrl:self.userModel.scoreUrl];
    }
}

-(void)messageBadgeButtonAction:(id)sender{
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        [MobClick event:kUM_message];
        
        WYMessageListViewController * messageList =[[WYMessageListViewController alloc]init];
        messageList.hidesBottomBarWhenPushed= YES;
        [self.navigationController pushViewController:messageList animated:YES];
    }
}

- (void)settingButtonAction:(id)sender{
    [self goSettingViewController];
}

//积分商城
- (void)integralMall{
    [MobClick event:kUM_c_Integralmall];
    [self integralMallRequest];
}

//个人信息
- (IBAction)personInfoAction:(id)sender {
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        if (self.userModel.link.length){
            [self goWebViewWithUrl:self.userModel.link];
        }
    }
}

//我的求购
- (IBAction)myPurchaseAction:(id)sender {
    [MobClick event:kUM_c_mypurchase];
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
//        NSString * url = [NSString stringWithFormat:@"%@/ycb/page/ycbPurchaseOrder.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [self goWebViewWithUrl:url];
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPurchaseOrder;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPurchaseOrder withSoureController:self];
    }
}
//我关注的商铺
- (IBAction)myAttentionAction:(id)sender {
    [MobClick event:kUM_c_collectshop];
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
//        NSString * url = [NSString stringWithFormat:@"%@/ycbx/page/ycbPersonalConcernedShop.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [self goWebViewWithUrl:url];
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPersonalConcernedShop;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPersonalConcernedShop withSoureController:self];
    }
}
//收藏的产品
- (IBAction)myCollectAction:(id)sender {
    [MobClick event:kUM_c_collectproduct];
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
//        NSString * url = [NSString stringWithFormat:@"%@/ycbx/page/ycbPersonalConcernedGoods.html",[WYUserDefaultManager getkAPP_H5URL]];
//        [self goWebViewWithUrl:url];
        LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
        NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPersonalConcernedGoods;
        [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPersonalConcernedGoods withSoureController:self];
    }
}

//我的订单
- (void)myOrder{
    [MobClick event:kUM_c_moreorder];
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_All];
    }
    
}

//待确认订单
- (IBAction)toConfirmedOrder:(id)sender {
    [MobClick event:kUM_c_tobeconfirmed];
    [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_ToBeConfirmed];
}

//待支付订单
- (IBAction)toPayOrder:(id)sender {
    [MobClick event:kUM_c_tobepay];
    [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_Obligation];

}

//待发货订单
- (IBAction)toConsignmentOrder:(id)sender {
    [MobClick event:kUM_c_tobedeliver];
    [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_WaitForDelivery];

}

//待收货订单
- (IBAction)toReceiveOrder:(id)sender {
    [MobClick event:kUM_c_tobereceive];
    [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_ToBeReceive];

}

//待评价订单
- (IBAction)toEvaluateOrder:(id)sender {
    [MobClick event:kUM_c_tobeevaluate];
    [self pushBuyserPageMenuControllerWithStatus:OrderListStatus_ToBeCommit];

}

//语音翻译
- (void)translateVoice{
    [MobClick event:kUM_c_mine_ranslate];
    [[WYUtility dataUtil]routerWithName:@"microants://translate" withSoureController:self];
}

- (void)pushBuyserPageMenuControllerWithStatus:(PurchaserOrderListStatus)status
{
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        BuyerPageMenuController *pageVC = [[BuyerPageMenuController alloc] init];
        pageVC.hidesBottomBarWhenPushed = YES;
        [pageVC setSelectedPageIndexWithOrderListStatus:status];
        [self.navigationController pushViewController:pageVC animated:YES];
    }

}

#pragma mark - UIScrollView delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y < -(20 + SCREEN_STATUSHEIGHT)) {
        offset.y = -20 - SCREEN_STATUSHEIGHT;
    }
    self.tableView.contentOffset = offset;
}

#pragma mark - Tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 3 || section == 4 || section == 5){
//        return 2;
//    }
//    return 1;
//}

#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0) {
        return 0.1;
    }
    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 185.0;
    }else if(indexPath.section == 1){
        return 85.0;
    }else if(indexPath.section == 2 && indexPath.row == 1){
        return 100.0;
    }else{
        return 44.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self myOrder];
    }else if (indexPath.section == 3) {
        [self translateVoice];
    }else if (indexPath.section == 4 && indexPath.row == 0) {
        [self authenticationStatus];
    }else if (indexPath.section == 4 && indexPath.row == 1){
        [self integralMall];
    }else if (indexPath.section == 5){
        if (indexPath.row == 0) {
            //客服电话
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006660998"]];
        }else if (indexPath.row == 1){
            [self customerServiceWithQQ];
        }
    }else if (indexPath.section == 6){
        [self goSettingViewController];
    }
}

#pragma mark - Private function
- (void)setUI{
    
    //我的积分按钮
    self.integralBtn = [[WYIntegralButton alloc]init];
    [self.integralBtn setTitle:@"0" forState:UIControlStateNormal];
    [self.integralBtn.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.integralBtn setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
    [self.integralBtn setImage:[UIImage imageNamed:@"pic_jifen_caigou"] forState:UIControlStateNormal];
    [self.integralBtn setArrowImage:@"ic_arrow1"];
    self.integralBtn.isMoreClickZone = YES;
    [self.integralBtn addTarget:self action:@selector(integralAction) forControlEvents:UIControlEventTouchUpInside];
    
    //messageBtn
    self.messageBadgeButton = [[ZXBadgeIconButton alloc] initWithFrame:CGRectMake(20, 0, 30, 50)];
    [self.messageBadgeButton addTarget:self action:@selector(messageBadgeButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [_messageBadgeButton setImage:[UIImage imageNamed:@"ic_message_normal"]];
    [_messageBadgeButton setBadgeContentInsetY:2.f badgeFont:[UIFont systemFontOfSize:11]];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFC14B].CGColor,(id)[UIColor colorWithHex:0xFF8D42].CGColor, nil];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 194);
    [self.headBackgroundView.layer insertSublayer:gradientLayer atIndex:0];
    
    
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.layer.cornerRadius = 29;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
//    self.headImageView.image = [UIImage imageNamed:@"ic_empty_person"];
    self.headImageView.layer.borderWidth = 1.5;
    self.headImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.waitConfirmedOrderImageView.image = [self.waitConfirmedOrderImageView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.waitPayOrderImageView.image = [self.waitPayOrderImageView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.waitConsignmentOrderImageView.image = [self.waitConsignmentOrderImageView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.waitReceiveOrderImageView.image = [self.waitReceiveOrderImageView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    self.waitEvaluateOrderImageView.image = [self.waitEvaluateOrderImageView.image stretchableImageWithLeftCapWidth:10 topCapHeight:10];
    
    self.waitConfirmedOrderLabel.hidden = YES;
    self.waitConfirmedOrderImageView.hidden = YES;
    self.waitPayOrderLabel.hidden = YES;
    self.waitPayOrderImageView.hidden = YES;
    self.waitConsignmentOrderLabel.hidden = YES;
    self.waitConsignmentOrderImageView.hidden = YES;
    self.waitReceiveOrderLabel.hidden = YES;
    self.waitReceiveOrderImageView.hidden = YES;
    self.waitEvaluateOrderLabel.hidden = YES;
    self.waitEvaluateOrderImageView.hidden = YES;
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    iconsView.iconHeight = 20.0;
    iconsView.minimumInteritemSpacing = 7.0;
    self.iconsView = iconsView;
    [self.certificationIconsView addSubview:iconsView];
    self.certificationIconsView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.certificationIconsView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
    
    [self.usingTranslateButton addTarget:self action:@selector(translateVoice) forControlEvents:UIControlEventTouchUpInside];
    self.usingTranslateButton.layer.cornerRadius = 12.5;
    self.usingTranslateButton.layer.masksToBounds = YES;
    self.usingTranslateButton.layer.borderWidth = 0.5;
    self.usingTranslateButton.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
}

- (void)reloadInfo{
    
    [self.integralBtn setTitle:[NSString stringWithFormat:@"%@", self.userModel.score] forState:UIControlStateNormal];
    
    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:self.userModel.headIcon];
    [self.headImageView sd_setImageWithURL:headUrl placeholderImage:[UIImage imageNamed:@"pic_weidenglu"] options:SDWebImageRetryFailed|SDWebImageRefreshCached];
    if ([UserInfoUDManager isLogin]) {
        self.nameLabel.text = self.userModel.nickname;
        
        if (self.userModel.describe.length) {
            self.contentLabel.text = self.userModel.describe;
            self.editContentImageView.hidden = YES;
        }else{
            self.contentLabel.text = [NSString stringWithFormat:@"资料完整度%@%%，立即完善资料",self.userModel.percent];
            self.editContentImageView.hidden = NO;
        }
        
        //
        //认证图标
        if (self.userModel.showAuthPerson.integerValue) {
            self.personalCertificationImageView.image = [UIImage imageNamed:@"ic_name_normal"];
        }else{
            self.personalCertificationImageView.image = [UIImage imageNamed:@"ic_name_disabled"];
        }
        if (self.userModel.showAuthCompany.integerValue) {
            self.companyCertificationImageView.image = [UIImage imageNamed:@"ic_company_normal"];
        }else{
            self.companyCertificationImageView.image = [UIImage imageNamed:@"ic_company_disabled"];
        }
        if (self.userModel.showAuthGuest.integerValue) {
            self.inviteImageView.image = [UIImage imageNamed:@"ic_invite_normal"];
        }
        
        self.wantToBuyCountLabel.text = [NSString stringWithFormat:@"%@",self.userModel.like.subjectCount];
        self.collectShopCountLabel.text = [NSString stringWithFormat:@"%@",self.userModel.like.favorShopCount];
        self.collectGoodsCountLabel.text = [NSString stringWithFormat:@"%@",self.userModel.like.favorProdCount];
        
    }else{
        self.nameLabel.text = @"点击登录";
        self.contentLabel.text = @"完善个人资料，让供应商更信任你～";
        
        self.wantToBuyCountLabel.text = @"0";
        self.collectShopCountLabel.text = @"0";
        self.collectGoodsCountLabel.text = @"0";
        
        
        self.personalCertificationImageView.image = [UIImage imageNamed:@"ic_name_disabled"];
        self.companyCertificationImageView.image = [UIImage imageNamed:@"ic_company_disabled"];
        self.inviteImageView.image = nil;
        
       
    }
    
    NSMutableArray *imgIcons = [NSMutableArray array];
    [self.userModel.buyerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {

        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    
    //订单数
    [self orderCountLabel:self.waitConfirmedOrderLabel imageView:self.waitConfirmedOrderImageView orderNumber:self.userModel.order.waitConfirmCount.integerValue];
    [self orderCountLabel:self.waitPayOrderLabel imageView:self.waitPayOrderImageView orderNumber:self.userModel.order.waitPayCount.integerValue];
    [self orderCountLabel:self.waitConsignmentOrderLabel imageView:self.waitConsignmentOrderImageView orderNumber:self.userModel.order.waitTranCount.integerValue];
    [self orderCountLabel:self.waitReceiveOrderLabel imageView:self.waitReceiveOrderImageView orderNumber:self.userModel.order.waitReceiveCount.integerValue];
    [self orderCountLabel:self.waitEvaluateOrderLabel imageView:self.waitEvaluateOrderImageView orderNumber:self.userModel.order.waitEvalCount.integerValue];
    
    self.certificationStatusLabel.text = [self certificationStatusString];

}

- (NSString *)certificationStatusString{
    NSString *str;
    switch (self.userModel.authStatus.integerValue) {
        case 101:
            str =  @"身份认证审核中";
            break;
        case 102:
            str = @"身份认证审核中";
            break;
        case 103:
            str = @"身份认证审核中";
            break;
        case 2:
            str = @"已通过个人认证";
            break;
        case 3:
            str = @"已通过企业认证";
            break;
        default:
            str = @"认证后权益更多";
            break;
    }
    return str;
}

//认证状态
- (void)authenticationStatus{
    if ([self xm_performIsLoginActionWithPopAlertView:NO]){
        switch (self.userModel.authStatus.integerValue) {
            case 101:
            case 102:
            case 103:
                [self AlertUnverify];
                break;
            case 2:{
//                NSString *url = [NSString stringWithFormat:@"%@/ycb/page/ycbPersonalRealAuthenticationSuccess.html",[WYUserDefaultManager getkAPP_H5URL]];
//                [self goWebViewWithUrl:url];
                LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbPersonalRealAuthenticationSuccess;
                [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbPersonalRealAuthenticationSuccess withSoureController:self];
            }
                break;
            case 3:{
//                NSString *url = [NSString stringWithFormat:@"%@/ycb/page/ycbCompanyAuthenticationSuccess.html",[WYUserDefaultManager getkAPP_H5URL]];
//                [self goWebViewWithUrl:url];
                LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbCompanyAuthenticationSuccess;
                [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbCompanyAuthenticationSuccess withSoureController:self];
            }
                break;
            default:{
//                NSString *url = [NSString stringWithFormat:@"%@/ycb/page/ycbIdentityVerify.html",[WYUserDefaultManager getkAPP_H5URL]];
//                [self goWebViewWithUrl:url];
                LocalHtmlStringManager *localHtmlManager = [LocalHtmlStringManager shareInstance];
                NSString *htmlUrl = localHtmlManager.LocalHtmlStringManagerModel.ycbIdentityVerify;
                [localHtmlManager loadHtml:htmlUrl forKey:HTMLKey_ycbIdentityVerify withSoureController:self];
            }
                break;
        }
    }
}

-(void)AlertUnverify{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"身份认证即将审核通过，请耐心等待~", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)customerServiceWithQQ{
    WS(weakSelf)
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]]) {
        UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
        NSURL * url=[NSURL URLWithString:[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"1839153907"]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        webView.delegate = self;
        [webView loadRequest:request];
        [self.view addSubview:webView];
    }else{
        [MBProgressHUD zx_showError:@"请先安装手机QQ哦～" toView:weakSelf.view];
    }
}

- (void)goWebViewWithUrl:(NSString *)url{
    
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];

}

- (void)goSettingViewController{
    SettingViewController *vc = [[SettingViewController alloc] init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

//订单数角标控制
- (void)orderCountLabel:(UILabel *)label imageView:(UIImageView *)imageView orderNumber:(NSInteger)count{
    if (count) {
        label.text = [NSString stringWithFormat:@"%ld",count];
        label.hidden = NO;
        imageView.hidden = NO;
    }else{
        label.hidden = YES;
        imageView.hidden = YES;
    }
}

#pragma mark -GetterAndSetter
- (UIBarButtonItem *)leftButton{
    if (!_leftButton) {
        _leftButton = [[UIBarButtonItem alloc]initWithCustomView:self.integralBtn];
    }
    return _leftButton;
}

- (UIBarButtonItem *)messageButton{
    if (!_messageButton) {
        _messageButton = [[UIBarButtonItem alloc]initWithCustomView:_messageBadgeButton];
    }
    return _messageButton;
}

- (UIBarButtonItem *)settingButton{
    if (!_settingButton) {
        UIButton *setting = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 40)];
        [setting addTarget:self action:@selector(settingButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [setting setImage:[UIImage imageNamed:@"ic_setting"] forState:UIControlStateNormal];
        _settingButton = [[UIBarButtonItem alloc]initWithCustomView:setting];
    }
    return _settingButton;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
