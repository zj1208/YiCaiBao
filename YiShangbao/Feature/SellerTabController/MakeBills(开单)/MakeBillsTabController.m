//
//  MakeBillsTabController.m
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillsTabController.h"
#import "WYPublicModel.h"
#import "MakeBillServiceExpireViewController.h"
#import "WYPayDepositViewController.h"
#import "WYTimeManager.h"

@interface MakeBillsTabController ()<UITabBarControllerDelegate>
@property(nonatomic, assign) BOOL checkServiceSafe;
@end

@implementation MakeBillsTabController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.delegate = self;

    [self initTabBar];
    [self setApperanceForSigleNavController];
    [self setApperanceForAllController];
    
    [self checkOpenBillTimeIsExpireView:OBShowType_buyNow checkService:OBServiceType_newBill succes:nil];
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc
{
    
}

#pragma mark-
//设置基本数据
- (void)setApperanceForSigleNavController
{
    [self.viewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [obj xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
        [obj xm_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];

    }];
}


//设置基本数据
- (void)setApperanceForAllController
{
    [UIViewController xm_navigationBar_appearance_backgroundImageName:nil ShadowImageName:nil orBackgroundColor:[UIColor whiteColor] titleColor:UIColorFromRGB_HexValue(0x222222) titleFont:[UIFont boldSystemFontOfSize:17.f]];
    
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];
    [[UIBarButtonItem appearance]setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateHighlighted];
    
    
    [UIViewController xm_navigationBar_UIBarButtonItem_appearance_systemBack_noTitle];
    
    [[UIButton appearance]setExclusiveTouch:YES];
    
    //    UIImage *backImage = [UIImage zh_imageWithColor:[UIColor orangeColor] andSize:CGSizeMake(10, 10)];
    //    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)initTabBar
{
    NSArray *imgSelectArray = @[@"ic_kaidan",@"ic_shuju",@"ic_kehu"];
    NSArray *imgArray = @[@"ic_kaidan2",@"ic_shuju2",@"ic_kehu2"];
    
    [self xm_tabBarController_tabBarItem_ImageArray:imgArray selectImages:imgSelectArray slectedItemTintColor:nil unselectedItemTintColor:nil];
    self.tabBar.translucent = NO;
    UIImage *tabImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xFAFAFA) andSize:self.tabBar.frame.size];
    self.tabBar.backgroundImage = tabImage;
    UIImage *shadowImage = [UIImage zh_imageWithColor:UIColorFromRGB_HexValue(0xD8D8D8) andSize:CGSizeMake(self.tabBar.frame.size.width, 0.5)];
    self.tabBar.shadowImage = shadowImage;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    UINavigationController *dataVC = [tabBarController.viewControllers objectAtIndex:1];
    if ([dataVC isEqual:viewController])
    {
        if (_checkServiceSafe) {
            return NO;
        }else{
            _checkServiceSafe = YES;
            [self checkOpenBillTimeIsExpireView:OBShowType_renewal checkService:OBServiceType_chart succes:^(CheckBlockType isOk) {
                _checkServiceSafe = NO;
                if (isOk == CheckBlockType_oK) {
                    self.selectedIndex = 1;
                    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_SPSSStatisticsController object:nil];
                }
            }];
            return NO;
        }
    }
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    if (tabBarController.selectedIndex ==1){
        [MobClick event:kUM_kdb_tabbar_data];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_update_SPSSStatisticsController object:nil];
    }else if (tabBarController.selectedIndex == 0){
        [MobClick event:kUM_kdb_tabbar_openbill];
    }else if (tabBarController.selectedIndex == 2){
        [MobClick event:kUM_kdb_tabbar_customer];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

//OBShowType_none        = 0, //检查服务使用权限，没钱或试用过期不弹出《续费弹框》
//OBShowType_renewal     = 1, //检查服务使用权限，没钱或试用过期自动弹出《续费弹框》
//OBShowType_buyNow      = 2, //检查服务使用权限，并弹出《立即订购弹框》营销弹框
//OBShowType_must        = 3, //点击开单弹窗横幅，暂不检查服务使用权限，直接获取立即订购信息，弹《立即订购弹框》营销弹框
-(void)checkOpenBillTimeIsExpireView:(OBShowType)type checkService:(OBServiceType)funcName succes:(Success)succes
{
    if (type == OBShowType_must){ 
        [self requestServiceConfirmOrderIsExpireView:type];
        return;
    }

    NSString *funcNameInfo;
    if (funcName == OBServiceType_enterBill)
    {
        funcNameInfo = @"enterBill";
    }
    else if (funcName == OBServiceType_newBill)
    {
        funcNameInfo = @"newBill";
    }
    else if(funcName == OBServiceType_chart)
    {
        funcNameInfo = @"chart";
    }
    else if(funcName == OBServiceType_customer)
    {
        funcNameInfo = @"customer";
    }
    [self requestStatusInfoShowExpire:type funcName:funcNameInfo succes:^(CheckBlockType isOk) {
        if (succes) {
            succes(isOk);
        }
    }];
}
#pragma mark - 1.校验开单权限是否过期------------------------------
-(void)requestStatusInfoShowExpire:(OBShowType)type funcName:(NSString *)funcName succes:(Success)succes{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillOpenBillStatusInfoWithFuncName:funcName Success:^(id data) {
        BillOpenBillServiceStatusModel *model = data;
        if (model.needBoughtCheck) {
            if ((type == OBShowType_renewal || type == OBShowType_none) && (model.trialLeftDay.integerValue > 0 || model.boughtStatus.integerValue == 1 )) { //已购买、在试用期内允许使用，不需要弹《续费弹框》
                if (succes) {
                    succes(CheckBlockType_oK);
                }
                return;
            }else if (model.boughtStatus.integerValue != 1 && model.trialLeftDay.integerValue == 0) { //服务到期，没有试用天数-弹《续费弹框》
                [weakSelf requestServiceConfirmOrderIsExpireView:type];
            }else if ((model.boughtStatus.integerValue != 1 && model.trialLeftDay.integerValue > 0) && [[WYTimeManager shareTimeManager] isShowPopMakeBillServiceIsNeedSave:NO]){ //每天进来弹一次《立即订购弹框》营销弹框
                [weakSelf requestServiceConfirmOrderIsExpireView:type];
            }else{

            }
            if (succes) {
                succes(CheckBlockType_disable);
            }
        }else{  //不需要校验服务是否开通，直接免费使用
            if (succes) {
                succes(CheckBlockType_oK);
            }
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
        succes(CheckBlockType_noNet);
    }];
}
#pragma mark 2.获取试用、过期后续费的弹框信息
- (void)requestServiceConfirmOrderIsExpireView:(OBShowType)type
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance] publicAPI] getServiceConfirmOrderByFuncType:WYServiceFunctionTypeMakeBill success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:nil];
        WYServicePlaceOrderModel *servicePlaceOrderModel = data;
        [self showMakeBillServiceViewController:servicePlaceOrderModel isExpireView:type];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark 3.展示试用、续费的弹框
-(void)showMakeBillServiceViewController:(WYServicePlaceOrderModel *)model isExpireView:(OBShowType)type
{
    UIViewController *VC;
    if (type == OBShowType_renewal) { //到期续费弹框
        MakeBillServiceExpireViewController *expireVC = (MakeBillServiceExpireViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_MakeBillServiceExpireViewController];
        [expireVC addServiceInfo:model];
        VC = expireVC;
    }else if (type == OBShowType_buyNow || type == OBShowType_must) { //《立即订购弹框》营销弹框
        MakeBillServiceViewController *serviceVC = (MakeBillServiceViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_MakeBillServiceViewController];
        [serviceVC addServiceInfo:model];
        VC = serviceVC;
    }else{
        return;
    }
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:VC];
    [navi xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
    [navi xm_navigationBar_barItemColor:UIColorFromRGB_HexValue(0x222222)];
    [navi setModalPresentationStyle:UIModalPresentationOverCurrentContext];
    
    [self.navigationController presentViewController:navi animated:NO completion:nil];
}
#pragma mark-----------------------------

@end
