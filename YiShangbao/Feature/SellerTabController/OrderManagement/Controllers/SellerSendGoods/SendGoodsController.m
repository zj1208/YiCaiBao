//
//  SendGoodsController.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SendGoodsController.h"
#import "ZXCenterBottomToolView.h"

#import "SendProductCell.h"
#import "SendShippingAddressCell.h"
#import "SendContentCell.h"
#import "SendContentDetailCell.h"
#import "AlertChoseController.h"

static NSString *reuse_productCell  = @"productCell";
static NSString *reuse_shippingAddressCell = @"shippingAddressCell";
static NSString *reuse_contentCell = @"contentCell";
static NSString *reuse_contentDetailCell = @"contentDetailCell";


@interface SendGoodsController ()<ZXEmptyViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,ZXAlertChoseControllerDelegate>

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) GetOrderDeliveryModel *orderModel;

@property (nonatomic, strong)ZXModalTransitionDelegate *transitonModelDelegate;

//发货方式
@property (nonatomic, strong) NSNumber *sendType;
@property (nonatomic, copy) NSString *logisticsCompanay;
@property (nonatomic, copy) NSString *trackingNumber;
@end


@implementation SendGoodsController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setUI];
    
    [self setData];
}

- (void)setUI
{
    self.tableView.estimatedRowHeight = 70;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];

    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
    [self addBottomView];
    
}

- (void)addBottomView
{
    
    self.bottomContainerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    
    ZXCenterBottomToolView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterBottomToolView owner:self options:nil] lastObject];
    view.backgroundColor = [UIColor clearColor];
    [self.bottomContainerView addSubview:view];
    [view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.bottomContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0, 0));
        
    }];
    view.centerBtnLeadingLayout.constant = LCDScale_5Equal6_To6plus(15.f);
    view.centerBtnTopLayout.constant = LCDScale_5Equal6_To6plus(8.f);
    UIImage *backgroundImage2 = [WYUTILITY getCommonVersion2RedGradientImageWithSize:view.onlyCenterBtn.frame.size];
    [view.onlyCenterBtn setBackgroundImage:backgroundImage2 forState:UIControlStateNormal];
    [view.onlyCenterBtn setTitle:@"立即发货" forState:UIControlStateNormal];
//    [view.onlyCenterBtn setImage:[UIImage imageNamed:@"im"] forState:UIControlStateNormal];
//    [view.onlyCenterBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [view.onlyCenterBtn addTarget:self action:@selector(bottomCenterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomContainerView.hidden = YES;
    
}


- (void)layoutBottomContainerView
{
    self.bottomContainerView.hidden = NO;
    
    UIEdgeInsets inset = self.tableView.contentInset;
    inset.bottom = 60.f;
    self.tableView.contentInset = inset;
    
    UIEdgeInsets indicatorInset = self.tableView.scrollIndicatorInsets;
    indicatorInset.bottom = 60.f;
    self.tableView.scrollIndicatorInsets =indicatorInset;
    
}



- (void)setData
{
    [self headerRefresh];
    
    self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(210));
}


- (void)headerRefresh
{
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);
    
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getOrderDeliveryWithBizOrderId:self.bizOrderId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.orderModel = nil;
        GetOrderDeliveryModel *model = [[GetOrderDeliveryModel alloc] init];
        weakSelf.orderModel = model;
        weakSelf.orderModel = data;
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.orderModel?YES:NO];
        
        [weakSelf layoutBottomContainerView];
        
        [weakSelf.tableView reloadData];
        
    } failure:^(NSError *error) {
        
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.orderModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}



- (void)zxEmptyViewUpdateAction
{
    [self headerRefresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_orderModel)
    {
        return 0;
    }
    //无需物流
    if ([self.sendType isEqualToNumber:@(1)])
    {
        return 3;
    }
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==1)
    {
        SendShippingAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_shippingAddressCell forIndexPath:indexPath];
        [cell setData:_orderModel];
        return cell;
    }
    else if (indexPath.section ==2)
    {
        SendContentCell *contentCell = [tableView dequeueReusableCellWithIdentifier:reuse_contentCell forIndexPath:indexPath];
        [contentCell.sendGoodTypeBtn addTarget:self action:@selector(choseSendGoodType) forControlEvents:UIControlEventTouchUpInside];
        if (_sendType)
        {
            [contentCell setSendGoodType:_sendType];
        }
        return contentCell;
    }
    else if (indexPath.section ==3)
    {
        SendContentDetailCell *contentCell = [tableView dequeueReusableCellWithIdentifier:reuse_contentDetailCell forIndexPath:indexPath];
        [contentCell setLogisticsCompanay:_logisticsCompanay trackingNumber:_trackingNumber];
        return contentCell;

    }
    SendProductCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_productCell forIndexPath:indexPath];
    [cell setData:_orderModel];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
        case 3:return 0.1;break;
        default:return 12.f;
            break;
    }
    return 0.1;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        return 80.f;
    }
    return tableView.rowHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{

    return 0.1f;
}

- (void)choseSendGoodType
{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];

    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
    SendContentDetailCell *contentCell  = [self.tableView cellForRowAtIndexPath:indexPath];
    
    _trackingNumber = contentCell.trackingNumberTextField.text;
    _logisticsCompanay = contentCell.logisticsCompanyTextField.text;
    
    AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
    vc.addTextField = NO;
    vc.btnActionDelegate = self;
    vc.alertTitle = @"请选择发货方式";
    vc.titles = @[@"物流",@"无需物流"];
    vc.userInfo = @{@"bizOrderId":@""};
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.transitioningDelegate = self.transitonModelDelegate;
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
}


- (void)bottomCenterBtnAction:(id)sender
{
    
    if ([_sendType isEqualToNumber:@(1)])
    {
        
    }
    else if ([_sendType isEqualToNumber:@(2)])
    {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:0 inSection:3];
        SendContentDetailCell *contentCell  = [self.tableView cellForRowAtIndexPath:indexPath];
        _trackingNumber = contentCell.trackingNumberTextField.text;
        _logisticsCompanay = contentCell.logisticsCompanyTextField.text;

        if ([NSString zhIsBlankString:_logisticsCompanay])
        {
            [MBProgressHUD zx_showError:@"请填写物流公司名称" toView:nil];
            return;
        }
        if ([NSString zhIsBlankString:_trackingNumber])
        {
            [MBProgressHUD zx_showError:@"请填写运单号码" toView:nil];
            return;
        }
    }
    else
    {
        [MBProgressHUD zx_showError:@"请选择发货方式" toView:nil];
        return;
    }
    
    
    PostOrderDeliveryModel * model = [[PostOrderDeliveryModel alloc] init];
    model.bizOrderId = _orderModel.bizOrderId;
    model.deliveryType = _sendType;
    model.companyName = _logisticsCompanay;
    model.logisticsNum = _trackingNumber;
    
    [MBProgressHUD zx_showLoadingWithStatus:@"正在提交..." toView:nil];
    WS(weakSelf);
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]postOrderDeliveryWithDictonary:model success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:@"发货成功" toView:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
        NSLog(@"成功之后跳转哪里");
        
    } failure:^(NSError *error) {
        
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];

    }];
}


- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{    
    if (buttonIndex ==0)
    {
        _sendType = @(2);
    }
    if (buttonIndex ==1)
    {
        _sendType = @(1);
    }
    [self.tableView reloadData];
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
