//
//  PurRefundDetailViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurRefundDetailViewController.h"

#import "RefundDetailWaitTableViewCell.h"
#import "RefundDetailSuccessTableViewCell.h"
#import "RefundDetailProductsTableViewCell.h"

#import "OrderManagementDetailModel.h"

@interface PurRefundDetailViewController ()<UITableViewDelegate,UITableViewDataSource,SODProductsViewDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)RefundDetailWaitTableViewCell* refunddetailWaitCell;
@property(nonatomic,strong)RefundDetailProductsTableViewCell* ProductsCell;

@property(nonatomic,strong)OMRefundDetailInfoModel* omrefundDetailInfoModel;

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@end

static NSString* const RefundDetailWaitTableViewCell_Resign = @"RefundDetailWaitTableViewCell_Resign";
static NSString* const RefundDetailSuccessTableViewCell_Resign = @"RefundDetailSuccessTableViewCell_Resign";
static NSString* const RefundDetailProductsTableViewCell_Resign = @"RefundDetailProductsTableViewCell_Resign";
@implementation PurRefundDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorF3F3F3];
    self.title = @"退款详情";
    
    [self buildUI];
    [self requestRefundInfo];

}
#pragma mark - 获取退款详情信息（买家）
-(void)requestRefundInfo
{
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] getCommonRefundInfoWithRoleType:[WYUserDefaultManager getUserTargetRoleType] bizOrderId:_bizOrderId success:^(id data) {
        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];

       _omrefundDetailInfoModel =  (OMRefundDetailInfoModel*)data; //.status;//状态 0-申请,1-撤销,2-拒绝,3-同意,4-完成,非正常状态以错误返回
        [self.tableView reloadData];

    } failure:^(NSError *error) {
        if (![self is_order_status_had_changed_Error:error]) {
            [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:YES];
            [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        }
    }];
}
-(BOOL)is_order_status_had_changed_Error:(NSError*)error
{
    NSString *code = [error.userInfo objectForKey:@"code"];
    if ([code isEqualToString:@"order_status_had_changed"])
    {
        UIAlertController* alertView= [UIAlertController alertControllerWithTitle:@"该订单信息已发生改变，无法进行当前操作，请在刷新订单后重新操作。" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction* _Nonnull action){
            [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }];
        [alertView addAction:alertAction];
        [self presentViewController:alertView animated:YES completion:nil];
        return YES;
    }else{
        return NO;
    }
}
#pragma mark - 退款操作（买家）
-(void)requestRefundOperation
{
    _refunddetailWaitCell.revocationBtn.enabled = NO; // 关闭撤销
     [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostCommonRefundOperationWithBizOrderId:_bizOrderId operationType:@"C" reason:nil success:^(id data) {
         [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];

         [self.navigationController popViewControllerAnimated:YES];
         [MBProgressHUD zx_showSuccess:@"撤销成功" toView:nil];
         
     } failure:^(NSError *error) {
         _refunddetailWaitCell.revocationBtn.enabled = YES;
         if (![self is_order_status_had_changed_Error:error]) {
             [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
         }
     }];
}
-(void)buildUI
{
    
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.backgroundColor = [WYUISTYLE colorF3F3F3];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView = [UIView new];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    [self.view addSubview:_tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.view);
    }];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"RefundDetailWaitTableViewCell" bundle:nil] forCellReuseIdentifier:RefundDetailWaitTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"RefundDetailSuccessTableViewCell" bundle:nil] forCellReuseIdentifier:RefundDetailSuccessTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"RefundDetailProductsTableViewCell" bundle:nil] forCellReuseIdentifier:RefundDetailProductsTableViewCell_Resign];
    
    _refunddetailWaitCell = [self.tableView dequeueReusableCellWithIdentifier:RefundDetailWaitTableViewCell_Resign];
    _ProductsCell = [self.tableView dequeueReusableCellWithIdentifier:RefundDetailProductsTableViewCell_Resign];

    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    self.emptyViewController = emptyVC;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([_omrefundDetailInfoModel.status isEqual:@0] || [_omrefundDetailInfoModel.status isEqual:@3]|| [_omrefundDetailInfoModel.status isEqual:@4]) {
        return 1;  //只展示0-申请,3-同意,4-完成 状态
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_omrefundDetailInfoModel.status isEqual:@0]) {
            return 190; //退款等待中
        }else{
            return 145; //退款成功
        }
    }else{
        return [_ProductsCell getCellHeightWithContentData:_omrefundDetailInfoModel];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if ([_omrefundDetailInfoModel.status isEqual:@0]) {
           
            [_refunddetailWaitCell.revocationBtn addTarget:self action:@selector(ClickRevocationBtn:) forControlEvents:UIControlEventTouchUpInside];
           
            [_refunddetailWaitCell setCellData:_omrefundDetailInfoModel];
            _refunddetailWaitCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return _refunddetailWaitCell;
        }else{
            RefundDetailSuccessTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:RefundDetailSuccessTableViewCell_Resign];
            [cell setCellData:_omrefundDetailInfoModel];

            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
           
        }
    }else{
        _ProductsCell = [tableView dequeueReusableCellWithIdentifier:RefundDetailProductsTableViewCell_Resign];
        [_ProductsCell setCellData:_omrefundDetailInfoModel];
        
        [_ProductsCell.productsview setArray: _omrefundDetailInfoModel.subBizOrders];
        _ProductsCell.productsview.delegate = self;
        
        _ProductsCell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _ProductsCell;
        
    }
}
#pragma mark - 产品点击Delegeta
-(void)jl_SODProductsView:(SODProductsView *)sodProductsView sourceArray:(NSArray *)array integer:(NSInteger)integer
{
    
}
#pragma mark - 撤销退款
-(void)ClickRevocationBtn:(UIButton*)sender
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"您确定要撤销本次退款申请吗" message:nil cancelButtonTitle:@"否" cancleHandler:^(UIAlertAction * _Nonnull action) {
    } doButtonTitle:@"是" doHandler:^(UIAlertAction * _Nonnull action) {
        [self requestRefundOperation];
    } ];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
