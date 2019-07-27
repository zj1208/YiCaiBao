//
//  PurApplyRefundsViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurApplyRefundsViewController.h"

#import "ApplyRefundsProductsTableViewCell.h"
#import "ApplyRefundsOtherInfoTableViewCell.h"

#import "PurRefundReasonViewController.h"
#import "PurRefundDetailViewController.h"

#import "OrderManagementDetailModel.h"

@interface PurApplyRefundsViewController ()<UITableViewDelegate,UITableViewDataSource,PurRefundReasonViewControllerDelegate,UITextFieldDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)UITableView* tableView;
@property(nonatomic,strong)UIView* bottonContentView;
@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;

@property(nonatomic,strong)ApplyRefundsOtherInfoTableViewCell* AppOtherInfocell;

@property(nonatomic,strong)OMRefundInitModel *omrefundInitModel;

@property(nonatomic,strong)PurRefundReasonViewController* resonVC; //退款原因弹窗控制器
@property(nonatomic,strong)NSString* resonString; //退款原因

@property(nonatomic,assign)BOOL tagsRemoved; //申请退款成功跳转详情页返回跳过这个页面
@end

static NSString* const ApplyRefundsProductsTableViewCell_Resign = @"ApplyRefundsProductsTableViewCell_Resign";
static NSString* const ApplyRefundsOtherInfoTableViewCell_Resign = @"ApplyRefundsOtherInfoTableViewCell_Resign";

@implementation PurApplyRefundsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorWithHexString:@"#f3f3f3"];

    self.title = @"申请退款";
    
    [self requestRefundInit];
    
    [self buildUI];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    if (self.tagsRemoved) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [arrayM removeObject:self];
        [self.navigationController setViewControllers:arrayM animated:NO];
    }
}
#pragma mark - 退款初始化
-(void)requestRefundInit
{
    [[[AppAPIHelper shareInstance] gethsOrderManagementApi] getBuyerRefundInitWithBizOrderId:_bizOrderId success:^(id data) {
        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];

        _omrefundInitModel = data;
        if (_omrefundInitModel) {
            _bottonContentView.hidden = NO;
            [self.tableView reloadData];
        }

    } failure:^(NSError *error) {
        if (![self is_order_status_had_changed_Error:error]) {
            [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }
    }];
}
#pragma mark - 提交退款
-(void)reauestAddRefund
{
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    
    NSString * append = _AppOtherInfocell.textfild.text;
    
     [[[AppAPIHelper shareInstance] gethsOrderManagementApi] PostBuyerAddRefundWithBizOrderId:_bizOrderId reason:_resonString append:append success:^(id data) {
         [MBProgressHUD zx_hideHUDForView:self.view];
         [[NSNotificationCenter defaultCenter] postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];

         self.tagsRemoved = YES;
         PurRefundDetailViewController* VC = [[PurRefundDetailViewController alloc] init];
         VC.bizOrderId = _omrefundInitModel.bizOrderId;
         [self.navigationController pushViewController:VC animated:YES];

     } failure:^(NSError *error) {
         [MBProgressHUD zx_hideHUDForView:self.view];
         if (![self is_order_status_had_changed_Error:error]) {
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
#pragma mark - 初始化UI设置
-(void)buildUI
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = [WYUISTYLE colorWithHexString:@"#f3f3f3"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    self.tableView.tableFooterView=[[UIView alloc]init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.showsVerticalScrollIndicator = NO;
    [self.view addSubview:_tableView];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyRefundsProductsTableViewCell" bundle:nil] forCellReuseIdentifier:ApplyRefundsProductsTableViewCell_Resign];
    [self.tableView registerNib:[UINib nibWithNibName:@"ApplyRefundsOtherInfoTableViewCell" bundle:nil] forCellReuseIdentifier:ApplyRefundsOtherInfoTableViewCell_Resign];
  
    _AppOtherInfocell = [self.tableView dequeueReusableCellWithIdentifier:ApplyRefundsOtherInfoTableViewCell_Resign];
    _AppOtherInfocell.textfild.delegate = self;

    
    _bottonContentView = [[UIView alloc] init];
    _bottonContentView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_bottonContentView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(self.bottonContentView.mas_top);
    }];
    [self.bottonContentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.tableView.mas_bottom);
        make.left.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(60.f+HEIGHT_TABBAR_SAFE);
        make.bottom.mas_equalTo(self.view);
    }];
    UIView* alpV = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LCDW, 60+HEIGHT_TABBAR_SAFE)];
    alpV.backgroundColor = [UIColor blackColor];
    alpV.alpha = 0.3;
    [_bottonContentView addSubview:alpV];
    
    UIButton* tijiaoBtn = [[UIButton alloc] initWithFrame:CGRectMake(15,7.5, LCDW-30, 45)];
    tijiaoBtn.layer.masksToBounds = YES;
    tijiaoBtn.layer.cornerRadius = 22.5;
    [tijiaoBtn setTitle:@"提交" forState:UIControlStateNormal];
    UIImage* img  = [WYUISTYLE imageWithStartColorHexString:@"FFBA49" EndColorHexString:@"FF8D32" WithSize:CGSizeMake(LCDW, 60)];
    [tijiaoBtn setBackgroundImage:img forState:UIControlStateNormal];
    [tijiaoBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [_bottonContentView addSubview:tijiaoBtn];
    
    
    _bottonContentView.hidden = YES;
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}
#pragma mark - 氛围图
-(void)zxEmptyViewUpdateAction
{
    [self requestRefundInit];
}
//提交
-(void)commit:(UIButton*)sender
{
    if ([NSString zhIsBlankString:_resonString]) {
        [MBProgressHUD zx_showError:@"请选择退款理由" toView:self.view];
        return;
    }
    [self reauestAddRefund];
    
}
//退款原因
-(void)clickRefundResonBtn:(UIButton*)sender
{
    [self.view endEditing:NO];
    if (!self.resonVC) {
        self.resonVC = [[PurRefundReasonViewController alloc] init];
        self.resonVC.delegate = self;
    }
    if (IOS_VERSION>=9.0) {
        [self.resonVC showToViewController:self  WithAnimated:YES];
    }else{
        [self.resonVC showToViewController:self  WithAnimated:NO];
    }
}
-(void)jl_PurRefundReasonViewController:(PurRefundReasonViewController *)purRefundReasonViewController viewWillRemoveWithSelString:(NSString *)str didSelectedInteger:(NSInteger)integer
{
    self.resonString = [NSString stringWithFormat:@"%@",str];
    [self.tableView reloadData];
}
#pragma mark - tableView Delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _omrefundInitModel.subBizOrders.count;
    }else{
        if (_omrefundInitModel) {
            return 1;
        }
        return 0;
    }
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 80;
    }else{
        return 196;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        ApplyRefundsProductsTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:ApplyRefundsProductsTableViewCell_Resign];
        [cell setCellData:_omrefundInitModel.subBizOrders[indexPath.row]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        
        if (!self.resonString) {
            _AppOtherInfocell.resonLabel.text = @"请选择退款原因";
            _AppOtherInfocell.resonLabel.textColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
        }else{
            _AppOtherInfocell.resonLabel.text = self.resonString;
            _AppOtherInfocell.resonLabel.textColor = [WYUISTYLE colorWithHexString:@"#2F2F2F"];
        }
        [_AppOtherInfocell.resonBtn addTarget:self action:@selector(clickRefundResonBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _AppOtherInfocell.priceLabel.text = _omrefundInitModel.finalPrice;
        _AppOtherInfocell.zuiduoLabel.text = [NSString stringWithFormat:@"最多%@ （包含运费%@）",_omrefundInitModel.finalPrice,_omrefundInitModel.transFee];

        _AppOtherInfocell.selectionStyle = UITableViewCellSelectionStyleNone;
        return _AppOtherInfocell;
    }
}
#pragma mark - 退款原因50个字
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [UITextField xm_limitRemainText:_AppOtherInfocell.textfild shouldChangeCharactersInRange:range replacementString:string maxLength:50 remainTextNum:^(NSInteger remainLength) {
        
    }];
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
