//
//  RefundingDetailController.m
//  YiShangbao
//
//  Created by simon on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  退款详情

#import "RefundingDetailController.h"
#import "ZXTitleView.h"
#import "RefundingContentCell.h"
#import "RefundingOrderProCell.h"
#import "RefundingOrderPriceCell2.h"
#import "RefundingOrderPriceCell.h"
#import "NTESSessionViewController.h"
#import "WYNIMAccoutManager.h"
#import "AlertChoseController.h"

@interface RefundingDetailController ()<UITableViewDelegate,UITableViewDataSource,ZXEmptyViewControllerDelegate,ZXLabelsTagsViewDelegate,ZXAlertChoseControllerDelegate>

@property (nonatomic, strong) NSMutableArray *dataMArray;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) OMRefundDetailInfoModel *orderModel;

@property (nonatomic, copy) NSString *coloseReason;

@property (nonatomic, strong)ZXModalTransitionDelegate *transitonModelDelegate;

@end


static NSString * const reuse_HeadCell  = @"HeadCell";

static NSString * const reuse_Cell  = @"Cell";
static NSString * const reuse_CellNum1  = @"CellNum1";
static NSString * const reuse_CellNum2  = @"CellNum2";



@implementation RefundingDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"退款详情", nil);
    [self setUI];
    
    [self setData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setUI
{
    self.tableView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.estimatedRowHeight = 70;
    self.tableView.estimatedSectionHeaderHeight = 10.f;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    
    [self.tableView registerNib:[UINib nibWithNibName:nibName_RefundingOrderProCell bundle:nil] forCellReuseIdentifier:reuse_Cell];
    
    //最底部 cell样式2
    [self.tableView registerNib:[UINib nibWithNibName:nibName_RefundingOrderPriceCell2 bundle:nil] forCellReuseIdentifier:reuse_CellNum2];
    //最底部 cell样式1
    [self.tableView registerNib:[UINib nibWithNibName:nibName_RefundingOrderPriceCell bundle:nil] forCellReuseIdentifier:reuse_CellNum1];

    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
    
}

- (void)setData
{
    [self headerRefresh];
    
    self.transitonModelDelegate = [[ZXModalTransitionDelegate alloc] init];
    self.transitonModelDelegate.contentSize = CGSizeMake(LCDScale_iPhone6_Width(295), LCDScale_iPhone6_Width(327));
}


- (void)headerRefresh
{
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);

    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getCommonRefundInfoWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:self.bizOrderId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];

        weakSelf.orderModel = nil;
        weakSelf.orderModel = [[OMRefundDetailInfoModel alloc] init];
        weakSelf.orderModel = data;
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:_orderModel?YES:NO];
        [weakSelf.tableView reloadData];
        
        
    } failure:^(NSError *error) {
        
        if ([[error.userInfo objectForKey:@"code"]isEqualToString:@"order_status_had_changed"])
        {
            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:nil message:@"该订单信息已发生改变，无法进行当前操作，请在刷新订单后重新操作" cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:^(UIAlertAction * _Nonnull action) {
                
                [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
                [weakSelf.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        else
        {
            [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.orderModel error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }
    }];
}

- (void)zxEmptyViewUpdateAction
{
    [self headerRefresh];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!self.orderModel)
    {
        return 0;
    }
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==1&&_orderModel)
    {
        return _orderModel.subBizOrders.count;
    }
    return 1;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0)
    {
        RefundingContentCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_HeadCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.labelsTagsView.delegate = self;
        [cell setData:self.orderModel];
        return cell;
    }
    
    if (indexPath.section ==2)
    {
        //申请
        if ([_orderModel.status isEqualToNumber:@(0)])
        {
            RefundingOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_CellNum1 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setData:self.orderModel];
            [cell.callPhoneBtn addTarget:self action:@selector(callPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.imBtn addTarget:self action:@selector(imBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }
        //同意退款-退款中
        else
        {
            RefundingOrderPriceCell2 *cell = [tableView dequeueReusableCellWithIdentifier:reuse_CellNum2 forIndexPath:indexPath];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell setData:self.orderModel];
            [cell.callPhoneBtn addTarget:self action:@selector(callPhoneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.imBtn addTarget:self action:@selector(imBtnAction:) forControlEvents:UIControlEventTouchUpInside];
            return cell;

        }

    }
    
    RefundingOrderProCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_Cell forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:[_orderModel.subBizOrders objectAtIndex:indexPath.item]];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section ==1)
    {
        return 44.f;
    }
    return 0.1;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section ==0)
    {
        static RefundingContentCell *cell = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            
            cell = (RefundingContentCell *)[tableView dequeueReusableCellWithIdentifier:reuse_HeadCell];
        });
        CGFloat height = [cell getCellHeightWithContentData:_orderModel];
        return height;
    }
    return UITableViewAutomaticDimension;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section ==1)
    {
        ZXActionTitleView * titleView = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXActionTitleView owner:self options:nil] firstObject];
        [titleView.btn setTitle:@"退款信息" forState:UIControlStateNormal];
        titleView.backgroundColor =[UIColor whiteColor];
        [titleView.btn setTitleColor:UIColorFromRGB(47.f, 47.f, 47.f) forState:UIControlStateNormal];
        titleView.btn.userInteractionEnabled = NO;
        return titleView;
    }
    
    return [[UIView alloc] init];
//    UIView *view =[[UIView alloc] init];
//    view.backgroundColor = [UIColor orangeColor];
//    return view;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==0)
    {
        return 10.f;
    }
    else if (section ==2)
    {
        return 56.f;
    }
    return 0.1f;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section ==2)
    {
        ZXCenterTitleView * view = [[[NSBundle mainBundle] loadNibNamed:nibName_ZXCenterTitleView owner:self options:nil] firstObject];
        NSString *phone = [NSString stringWithFormat:@"投诉电话：%@",_orderModel.buttonComplaint];
        [view.centerBtn setTitle:phone forState:UIControlStateNormal];
        [view.centerBtn setTitleColor:UIColorFromRGB(134.f, 134.f, 134.f) forState:UIControlStateNormal];
        [view.centerBtn addTarget:self action:@selector(callComplaintsPhone:) forControlEvents:UIControlEventTouchUpInside];
        view.centerBtnWidthLayout.constant = 200.f;
        view.centerBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        view.hideLineView = YES;
        view.backgroundColor =WYUISTYLE.colorBGgrey;
        return view;

    }
    return nil;
}


- (void)callPhoneBtnAction:(id)sender
{
    [self.view zx_performCallPhone:_orderModel.buttonCall];
}

- (void)imBtnAction:(id)sender
{
    if ([[WYNIMAccoutManager shareInstance]cheackAccoutEnable:self])
    {
        WS(weakSelf);
        [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_Buyer thisId:_orderModel.bizOrderId success:^(id data) {
            
            NSString *accid = [data objectForKey:@"accid"];
            NSString *hisUrl = [data objectForKey:@"url"];
            NIMSession *session = [NIMSession session:accid type:NIMSessionTypeP2P];
            NTESSessionViewController *vc = [[NTESSessionViewController alloc] initWithSession:session];
            vc.hisUrl = hisUrl;
            NSString *shopUrl = [data objectForKey:@"shopUrl"];
            vc.shopUrl = shopUrl;
            vc.hideUnreadCountView = YES;
            [weakSelf.navigationController pushViewController:vc animated:YES];
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
    }
    
}

- (void)callComplaintsPhone:(id)sender
{
    [self.view zx_performCallPhone:_orderModel.buttonComplaint];
}




- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{

    OrderButtonModel *buttonModel = [_orderModel.buttons objectAtIndex:indexPath.item];
    if ([buttonModel.style isEqualToNumber:@(1)])
    {
        //默认设置
        cell.titleLab.textColor = UIColorFromRGB(83.f, 83.f, 83.f);
        cell.titleLab.backgroundColor = [UIColor whiteColor];
        cell.titleLab.layer.borderColor = UIColorFromRGB(177.f, 177.f, 177.f).CGColor;
    }
    else
    {
        //默认设置
        cell.titleLab.textColor = [UIColor whiteColor];
        UIImage *backgroundImage = [WYUTILITY getCommonVersion2RedGradientImageWithSize:cell.frame.size];
        cell.titleLab.backgroundColor = [UIColor colorWithPatternImage:backgroundImage];
        cell.titleLab.layer.borderColor = [UIColor clearColor].CGColor;
    }
}

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    OMDRefundDetailButtonModel *buttonModel = [_orderModel.buttons objectAtIndex:indexPath.item];
    if ([buttonModel.code isEqualToString:@"agreeRefund1"])
    {
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"同意退款后，货款将自动退还给买家，若您已发货，请拒绝退款后及时填写物流信息" message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"同意退款" doHandler:^(UIAlertAction * _Nonnull action) {
            
            [self requestRefundOperation:@"A" reason:@""];
        }];
    }
    else if ([buttonModel.code isEqualToString:@"refuseRefund1"])
    {
        
        AlertChoseController *vc = [[AlertChoseController alloc] initWithNibName:@"AlertChoseController" bundle:nil];
        vc.addTextField = YES;
        vc.btnActionDelegate = self;
        vc.titles = @[@"已发货",@"定做产品，不支持退款"];
        vc.alertTitle = @"请选择拒绝原因";
        vc.textViewPlaceholder = @"请输入其它原因";
        vc.userInfo = @{@"bizOrderId":@""};
//         message:@"拒绝后可继续填写物流信息，请尽量和买家协商一致"
        vc.modalPresentationStyle = UIModalPresentationCustom;
        vc.transitioningDelegate = self.transitonModelDelegate;
        
        [self presentViewController:vc animated:YES completion:nil];
    }
}


- (void)zx_alertChoseController:(AlertChoseController *)controller clickedButtonAtIndex:(NSInteger)buttonIndex content:(NSString *)content userInfo:(nullable NSDictionary *)userInfo
{
     [self requestRefundOperation:@"R" reason:content];
}



#pragma mark - 退款
-(void)requestRefundOperation:(NSString *)operationType reason:(NSString *)reason
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostCommonRefundOperationWithBizOrderId:_orderModel.bizOrderId operationType:operationType reason:reason success:^(id data) {
        
        if ([operationType isEqualToString:@"R"])
        {
            [self.navigationController popViewControllerAnimated:YES];
            [MBProgressHUD zx_showSuccess:@"已成功拒绝退款" toView:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
            
        }
        else
        {
            [MBProgressHUD zx_hideHUDForView:nil];
            RefundingDetailController *vc = (RefundingDetailController *)[self zx_getControllerWithStoryboardName:sb_SellerOrder controllerWithIdentifier:SBID_RefundingDetailController];
            vc.hidesBottomBarWhenPushed = YES;
            vc.bizOrderId = _orderModel.bizOrderId;
            [self.navigationController pushViewController:vc animated:YES];
            [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
            
        }
        
    } failure:^(NSError *error) {

        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
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
