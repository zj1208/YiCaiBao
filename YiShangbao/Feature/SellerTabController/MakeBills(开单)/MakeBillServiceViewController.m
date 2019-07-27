//
//  MakeBillServiceViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillServiceViewController.h"
#import "MakeBillServiceTableViewCell.h"
#import "WYPublicModel.h"
#import "YYText.h"
#import "WYTimeManager.h"

#import "WYPayDepositViewController.h"

@interface MakeBillServiceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UIView *popServiceView;
@property (weak, nonatomic) IBOutlet UIButton *rightOrderButton;
@property (weak, nonatomic) IBOutlet UIButton *continueUsingButton;
@property (weak, nonatomic) IBOutlet UIButton *feeUsingButton;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tableViewHeightConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeightConstraint;


@property (nonatomic, strong)WYServicePlaceOrderModel *model;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic) BOOL isPaySuccess;
@property (nonatomic) BOOL isClose;

@end

@implementation MakeBillServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.isClose) {
        [self closeButtonAction:nil];
    }
    if (self.isPaySuccess) {
        self.isClose = YES;
    }
    [self.navigationController setNavigationBarHidden:YES animated:animated];//侧滑过渡动画
}

- (void)viewWillDisappear:(BOOL)animated{
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
    [MobClick event:kUM_kdb_firstpopup_close];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_WYMakeBillHomeViewController object:nil];
    [[WYTimeManager shareTimeManager] isShowPopMakeBillServiceIsNeedSave:YES];
}

- (IBAction)rightOrderButtonAction:(id)sender {
    [MobClick event:kUM_kdb_firstpopup_order];
    [self requestServiceCreatOrder];
}

- (IBAction)continueUsingButtonAction:(id)sender {
    [MobClick event:kUM_kdb_firstpopup_continuetotry];
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_WYMakeBillHomeViewController object:nil];
    [[WYTimeManager shareTimeManager] isShowPopMakeBillServiceIsNeedSave:YES];
}

- (IBAction)feeUsingButtonAction:(id)sender {
    [MobClick event:kUM_kdb_firstpopup_extend];
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
        [weakSelf.navigationController pushViewController:vc animated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.funcItemInfoList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MakeBillServiceTableViewCell *cell = (MakeBillServiceTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillServiceTableViewCellID forIndexPath:indexPath];
    [cell updateData:self.model.funcItemInfoList[indexPath.row]];
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 49.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark- Private
- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
//    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.separatorColor = [UIColor clearColor];
    _tableView.scrollEnabled = NO;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, 215 , 38);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [_rightOrderButton.layer insertSublayer:gradientLayer atIndex:0];
    _rightOrderButton.layer.cornerRadius = 19.0;
    _rightOrderButton.layer.masksToBounds = YES;
    
    _continueUsingButton.layer.borderWidth = 0.5;
    _continueUsingButton.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    _continueUsingButton.layer.cornerRadius = 19.0;
    _continueUsingButton.layer.masksToBounds = YES;
    
    _popServiceView.layer.cornerRadius = 5.0;
    
    
    _priceLabel = [[UILabel alloc]init];
    [self.popServiceView addSubview:_priceLabel];
    [_priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.popServiceView).offset(15);
        make.right.equalTo(self.popServiceView).offset(-15);
        make.bottom.equalTo(self.rightOrderButton.mas_top).offset(-15);
    }];
    
    [self initData];
}

- (void)initData{
    if (self.model.extMap.enableGoOnButton) {
        _continueUsingButton.userInteractionEnabled = YES;
    }else{
        _continueUsingButton.userInteractionEnabled = NO;
    }
    [_continueUsingButton setTitle:self.model.extMap.goOnButtonText forState:UIControlStateNormal];
    
    if (self.model.extMap.openBillFreeTrialJumpUrl.length > 0) {
        self.feeUsingButton.hidden = NO;
        self.bottomHeightConstraint.constant = 35;
    }else{
        self.feeUsingButton.hidden = YES;
        self.bottomHeightConstraint.constant = 20;
    }
    
    self.tableViewHeightConstraint.constant = 49.0 * self.model.funcItemInfoList.count + 10;
    
    [self showPriceLabelInfo];
}

- (void)showPriceLabelInfo{
    _priceLabel.textColor = [UIColor colorWithHex:0x868686];
    _priceLabel.font = [UIFont systemFontOfSize:15.0];
    _priceLabel.textAlignment = NSTextAlignmentCenter;
    _priceLabel.numberOfLines = 2;
    _priceLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30; //设置最大的宽度
    
    if (self.model.comboItemList.count > 0) {
        WYServicePackagesModel *packagesModel = self.model.comboItemList[0];
        
        NSString *tipString = [NSString stringWithFormat:@"原价：%@/年",packagesModel.fee];
        
        NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:tipString];
        resultAttr.yy_font = [UIFont systemFontOfSize:14.0];
        resultAttr.yy_color = [UIColor colorWithHex:0xB1B1B1];
        [resultAttr addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, resultAttr.length)];
        
        NSString *tipString2 = [NSString stringWithFormat:@"\n%@",packagesModel.desc];
        NSMutableAttributedString * resultAttr2 = [[NSMutableAttributedString alloc] initWithString:tipString2];
        resultAttr2.yy_font = [UIFont systemFontOfSize:20.0];
        resultAttr2.yy_color = [UIColor colorWithHex:0xFF5434];
        
        [resultAttr appendAttributedString:resultAttr2];
        _priceLabel.attributedText = resultAttr;
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
