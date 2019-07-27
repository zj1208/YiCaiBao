//
//  MakeBillServiceExpireViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillServiceExpireViewController.h"
#import "WYPublicModel.h"

#import "WYPayDepositViewController.h"

@interface MakeBillServiceExpireViewController ()
@property (weak, nonatomic) IBOutlet UIView *popServiceView;
@property (weak, nonatomic) IBOutlet UIButton *placeOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *invitationFriendsButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewHeightConstraint;
@property (weak, nonatomic) IBOutlet UILabel *priceInfoLabel;

@property (nonatomic, strong)WYServicePlaceOrderModel *model;
@property (nonatomic) BOOL isPaySuccess;
@property (nonatomic) BOOL isClose;
@end

@implementation MakeBillServiceExpireViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    if (self.isClose) {
        [self closeButtonAction:nil];
    }
    if (self.isPaySuccess) {
        self.isClose = YES;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];//侧滑过渡动画
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:animated];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addServiceInfo:(WYServicePlaceOrderModel *)model{
    self.model = model;
    [self initData];
}

#pragma mark- ButtonAction

- (IBAction)closeButtonAction:(id)sender {
    [MobClick event:kUM_kdb_expirepopup_close];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_WYMakeBillHomeViewController object:nil];
    [self.view removeFromSuperview];
}

- (IBAction)placeOrderButtonAction:(id)sender {
    [MobClick event:kUM_kdb_expirepopup_order];
    [self requestServiceCreatOrder];
}

- (IBAction)invitationFriendsButtonAction:(id)sender {
    [MobClick event:kUM_kdb_expirepopup_extend];
    [self goWebViewByUrl:self.model.extMap.openBillFreeTrialJumpUrl];

}

#pragma mark- Request
- (void)requestServiceCreatOrder{
    if (self.model.comboItemList.count <= 0) {
        return;
    }
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    WYServicePackagesModel *packagesModel = self.model.comboItemList[0];
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] publicAPI] postCreatServiceOrderBycomboId:packagesModel.comboId.integerValue type:WYServiceAuthenticationTypeFirst funcType:WYServiceFunctionTypeMakeBill outOrderId:self.model.outOrderId success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:nil];
        WYServiceCreatOrderModel * model = data;
        
        WYPayDepositViewController *vc = [[WYPayDepositViewController alloc] init];
        vc.comboId = model.ssView.comboId.stringValue;
        vc.orderId = model.orderIds;
        vc.paySuccessBlock = ^{
            weakSelf.isPaySuccess = YES;
        };
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- setUI

- (void)setUI{
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, 215 , 38);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [_placeOrderButton.layer insertSublayer:gradientLayer atIndex:0];
    _placeOrderButton.layer.cornerRadius = 19.0;
    _placeOrderButton.layer.masksToBounds = YES;
    
    _invitationFriendsButton.layer.borderWidth = 0.5;
    _invitationFriendsButton.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    _invitationFriendsButton.layer.cornerRadius = 19.0;
    _invitationFriendsButton.layer.masksToBounds = YES;
    
    _popServiceView.layer.cornerRadius = 5.0;
    _popServiceView.layer.masksToBounds = YES;
    
    [self initData];
}

- (void)initData{
    if (self.model.extMap.openBillFreeTrialJumpUrl.length > 0) {
        self.invitationFriendsButton.hidden = NO;
        self.viewHeightConstraint.constant = 253;
    }else{
        self.invitationFriendsButton.hidden = YES;
        self.viewHeightConstraint.constant = 203;
    }
    
    if (self.model.comboItemList.count > 0) {
        WYServicePackagesModel *model = self.model.comboItemList[0];
        self.priceInfoLabel.text = model.desc;
    }
}

- (void)goWebViewByUrl:(NSString *)url{
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
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
