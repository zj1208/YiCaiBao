//
//  ModifyOrderPriceController.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  确认订单

#import "ModifyOrderPriceController.h"
#import "ModifyPriceProCell.h"
#import "ModifyOrderPriceCell.h"
#import "ModifyPriceFinalCell.h"
#import "ZXCenterBottomToolView.h"

static NSString *reuse_ModifyOrderPriceCell  = @"ModifyOrderPriceCell";
static NSString *reuse_ModifyPriceFinalCell = @"ModifyPriceFinalCell";
static NSString *reuse_ModifyOrderProCell = @"Cell";
//

@interface ModifyOrderPriceController ()<ZXEmptyViewControllerDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, strong) GetConfirmOrderModel *confirmOrderModel;

@property (nonatomic, strong) PostMdfConfirmOrderModel *postOrderModel;
//运费
@property (nonatomic, copy) NSString *transFee;
////发货方式
//@property (nonatomic, copy) NSString *sendTypeString;
//@property (nonatomic, copy) NSString *logisticsCompanay;
//@property (nonatomic, copy) NSString *trackingNumber;
@end

@implementation ModifyOrderPriceController

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
    self.tableView.separatorColor = WYUISTYLE.colorLineBGgrey;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.tableView registerNib:[UINib nibWithNibName:Xib_ModifyPriceProCell bundle:nil] forCellReuseIdentifier:reuse_ModifyOrderProCell];

    
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
    [view.onlyCenterBtn setTitle:@"确认订单" forState:UIControlStateNormal];
//   [view.onlyCenterBtn setImage:[UIImage imageNamed:@"im"] forState:UIControlStateNormal];
//   [view.onlyCenterBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [view.onlyCenterBtn addTarget:self action:@selector(bottomCenterBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bottomContainerView.hidden = YES;
    self.finalPriceContainerView.hidden = self.bottomContainerView.hidden;
    
}

- (void)layoutBottomContainerView
{
    self.bottomContainerView.hidden = NO;
    self.finalPriceContainerView.hidden = self.bottomContainerView.hidden;
}



- (void)setData
{
    _postOrderModel = [[PostMdfConfirmOrderModel alloc] init];
    [self headerRefresh];
//    [self.tableView.mj_header beginRefreshing];
}


- (void)headerRefresh
{
    
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    WS(weakSelf);

    [[[AppAPIHelper shareInstance]hsOrderManagementApi]getConfirmOrderWithOrderId:self.bizOrderId success:^(id data) {
        
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        weakSelf.confirmOrderModel = nil;
        weakSelf.confirmOrderModel = [[GetConfirmOrderModel alloc] init];
        weakSelf.confirmOrderModel = data;
        [weakSelf.emptyViewController hideEmptyViewInController:weakSelf hasLocalData:weakSelf.confirmOrderModel?YES:NO];
        [weakSelf layoutBottomContainerView];
        [weakSelf setPostModelData];
        
        [weakSelf.tableView reloadData];
        [weakSelf setBottomTotalData:weakSelf.confirmOrderModel];
        
        
    } failure:^(NSError *error) {
        
        [weakSelf.tableView.mj_header endRefreshing];
        [weakSelf.emptyViewController addEmptyViewInController:weakSelf hasLocalData:weakSelf.confirmOrderModel?YES:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
    }];
}


- (void)zxEmptyViewUpdateAction
{
    [self headerRefresh];
}

- (void)setPostModelData
{
 
    if ([self.confirmOrderModel.transFee rangeOfString:@"￥"].location != NSNotFound)
    {
        NSString *transFee = [self.confirmOrderModel.transFee substringFromIndex:1];
        _confirmOrderModel.transFee = transFee;
        _transFee = transFee;
    }
    //产品总额
    if ([self.confirmOrderModel.prodsPrice rangeOfString:@"￥"].location != NSNotFound)
    {
        NSString *prodsPrice = [self.confirmOrderModel.prodsPrice substringFromIndex:1];
        _confirmOrderModel.prodsPrice = prodsPrice;
        _confirmOrderModel.nProdsPrice = [prodsPrice doubleValue];
    }
    else
    {
        _confirmOrderModel.prodsPrice = @"0.00";
        _confirmOrderModel.nProdsPrice = 0.00;
    }
    //原价总和
    if ([self.confirmOrderModel.price rangeOfString:@"￥"].location != NSNotFound)
    {
        NSString *price = [self.confirmOrderModel.price substringFromIndex:1];
        _confirmOrderModel.price = price;
        _confirmOrderModel.nPrice = [price doubleValue];
    }
    else
    {
        _confirmOrderModel.price = @"0.00";
        _confirmOrderModel.nPrice = 0.00;
    }

    //折扣
    if ([self.confirmOrderModel.discount rangeOfString:@"￥"].location != NSNotFound)
    {
        NSString *discount = [self.confirmOrderModel.discount substringFromIndex:1];
        _confirmOrderModel.discount = discount;
    }
    else
    {
        _confirmOrderModel.discount = @"0.00";
    }
    // 子订单数组 数据转换
    [_confirmOrderModel.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        GetConfirmOrderModelSub *modelSub = (GetConfirmOrderModelSub *)obj;
   
        //价格
        if ([modelSub.price rangeOfString:@"面议"].location != NSNotFound)
        {
            modelSub.floatPrice =0.00;
//            modelSub.nPrice = @"0.00";
        }
        else
        {
//            modelSub.nPrice =[modelSub.price substringFromIndex:1];
            modelSub.floatPrice = [[modelSub.price substringFromIndex:1] doubleValue];
        }
        //上次修改的价格
        if ([modelSub.finalPrice rangeOfString:@"面议"].location != NSNotFound)
        {
            modelSub.finalPrice = @"0.00";
        }
        else
        {
            modelSub.finalPrice = [modelSub.finalPrice substringFromIndex:1];
        }
        //折扣
        double dis = [modelSub.finalPrice doubleValue]-modelSub.floatPrice;
        modelSub.ndiscount = dis;
        //总价格
        if ([modelSub.totalPrice rangeOfString:@"面议"].location != NSNotFound)
        {
            modelSub.totalPrice = @"0.00";
        }
        else
        {
            modelSub.totalPrice = [modelSub.totalPrice substringFromIndex:1];
        }

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (!_confirmOrderModel)
    {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section ==1) {
        return _confirmOrderModel.subBizOrders.count;
    }
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==1)
    {
        //子订单数组cell
        ModifyPriceProCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_ModifyOrderProCell forIndexPath:indexPath];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.nPriceTextField.delegate = self;
        [cell.editBtn addTarget:self action:@selector(editBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [cell setData:[_confirmOrderModel.subBizOrders objectAtIndex:indexPath.item]];
        return cell;
    }
   // 运费，产品总额cell
    ModifyOrderPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:reuse_ModifyOrderPriceCell forIndexPath:indexPath];
    cell.transFeeTextField.delegate =self;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    [cell setData:_confirmOrderModel withTransFee:_transFee];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 2:return 20.f;break;
        default:return 0.1f;
            break;
    }
    return 0.1;
}


//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (indexPath.section ==0)
//    {
//        return 80.f;
//    }
//    return UITableViewAutomaticDimension;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section ==1)
    {
        return 20.f;
    }
    return 0.1f;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:textField];
    if (indexPath.section ==0)
    {
        _transFee = textField.text;
        _confirmOrderModel.transFee = _transFee;
        [self setBottomTotalData:_confirmOrderModel];
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:textField];
    if (indexPath.section ==0)
    {
        return [UITextField xm_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:10 dotAfterBits:2];
    }
    if (indexPath.section ==1)
    {
        return [UITextField xm_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:8 dotAfterBits:8];
    }

    return YES;
}


- (void)editBtnAction:(UIButton *)sender
{
    NSIndexPath *indexPath = [self.tableView zh_getIndexPathFromTableViewOrCollectionViewWithConvertView:sender];
    ModifyPriceProCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [_confirmOrderModel.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if (idx == indexPath.item)
        {
            GetConfirmOrderModelSub *modelSub = (GetConfirmOrderModelSub *)obj;
            if (modelSub.isEditing)
            {
                if ([cell.nPriceTextField.text doubleValue]>=100000000)
                {
                    [MBProgressHUD zx_showError:@"产品金额不能大于1亿" toView:nil];
                    *stop = YES;
                    return ;
                }
                else if ([NSString zhIsBlankString:cell.nPriceTextField.text])
                {
                    [MBProgressHUD zx_showError:@"产品金额不能为空" toView:nil];
                    *stop = YES;
                    return ;
                }
                else if ([cell.nPriceTextField.text rangeOfString:@"."].location !=NSNotFound)
                {
                    if ([[[cell.nPriceTextField.text componentsSeparatedByString:@"."] lastObject]length]>2)
                    {
                        [MBProgressHUD zx_showError:@"价格不能超过小数点两位" toView:nil];
                        *stop = YES;
                        return ;
                    }
                }
            }
            modelSub.isEditing = !modelSub.isEditing;
            sender.selected = modelSub.isEditing;
            cell.nPriceTextField.hidden = !sender.selected;
            cell.nPriceLab.hidden = !cell.nPriceTextField.hidden;
            if (sender.selected)
            {
                [cell.nPriceTextField becomeFirstResponder];
            }
            else
            {
                [cell.nPriceTextField resignFirstResponder];

                modelSub.finalPrice= [NSString stringWithFormat:@"%.2f",[cell.nPriceTextField.text doubleValue]];
                double dis = [modelSub.finalPrice doubleValue]-modelSub.floatPrice;
                modelSub.ndiscount = dis;
                double totalPrice = [modelSub.finalPrice doubleValue] *[modelSub.quantity integerValue];
                modelSub.totalPrice = [NSString stringWithFormat:@"%.2f",totalPrice];
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                [self setBottomTotalData:_confirmOrderModel];
            }
        }
    }];

}


#pragma mark- 设置底部价格合计
- (void)setBottomTotalData:(id)data
{
    GetConfirmOrderModel *model = (GetConfirmOrderModel *)data;
    // 原价，运费，折扣，实付总额
    self.prodsPriceLab.text = [NSString stringWithFormat:@"原价:¥%@",model.price];
    self.transFeeLab.text = [NSString stringWithFormat:@"运费:¥%@",model.transFee];
    
    __block double discount = 0.f;
    [model.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GetConfirmOrderModelSub *modelSub = (GetConfirmOrderModelSub *)obj;
        discount = discount + modelSub.ndiscount*[modelSub.quantity integerValue];
    }];
    
    if (discount<=0)
    {
        self.discountLab.text = [NSString stringWithFormat:@"折扣：-¥%.2f",ABS(discount)];
    }
    else
    {
        self.discountLab.text = [NSString stringWithFormat:@"折扣：+¥%.2f",ABS(discount)];
    }
//    实付总额
    double finalPrice = [model.price doubleValue] + [model.transFee doubleValue] + discount;
    self.finalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",finalPrice];
    model.finalPrice = self.finalPriceLab.text;
    model.nProdsPrice = [model.price doubleValue]+ discount;
    
    // 刷新第一组数据：产品总额/实付总额
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationNone];
}


//或添加事件UIControlEventEditingDidBegin业务处理
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    
}

#pragma mark - 确认订单Action
- (void)bottomCenterBtnAction:(id)sender
{
 
    if ([NSString zhIsBlankString:_transFee])
    {
        [MBProgressHUD zx_showError:@"请输入运费" toView:self.view];
        return;
    }
    WS(weakSelf);
    [_confirmOrderModel.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GetConfirmOrderModelSub *model = (GetConfirmOrderModelSub *)obj;
        if (model.isEditing)
        {
            *stop = YES;
            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:@"请保存修改后的价格，再点击确认" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
            return ;
        }
    }];
    //    __block BOOL isMianYiPrice = NO;
    [_confirmOrderModel.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GetConfirmOrderModelSub *model = (GetConfirmOrderModelSub *)obj;
        if ([model.finalPrice floatValue]==0 && [model.price isEqualToString:@"面议"])
        {
            *stop = YES;
//            isMianYiPrice = YES;
            [UIAlertController zx_presentGeneralAlertInViewController:weakSelf withTitle:@"还有面议的产品没有修改价格，请修改面议产品价格后，再确认订单" message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:@"知道了" doHandler:nil];
            return ;
        }
    }];
//    if (isMianYiPrice)
//    {
//        return;
//    }
    NSString *title = [NSString stringWithFormat:@"当前订单总价%@，确认后买家即可付款，是否确认修改",_confirmOrderModel.finalPrice];
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:title message:nil cancelButtonTitle:@"再看看" cancleHandler:nil doButtonTitle:@"确定修改" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf requestPostData];
    }];
}


- (void)requestPostData
{
    _postOrderModel.bizOrderId = _confirmOrderModel.bizOrderId;
    _postOrderModel.transFee = @([_confirmOrderModel.transFee doubleValue] *100);
    
    NSMutableArray *postModelsArray = [NSMutableArray array];
    [_confirmOrderModel.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GetConfirmOrderModelSub *model = (GetConfirmOrderModelSub *)obj;
        PostMdfConfirmOrderModelSub *postModel  = [[PostMdfConfirmOrderModelSub alloc] init];
        postModel.subBizOrderId = model.subBizOrderId;
        postModel.nPrice = @([model.finalPrice doubleValue]*100);
        postModel.quantity = model.quantity;
        [postModelsArray addObject:postModel];
    }];
    _postOrderModel.orderProd = postModelsArray;
    
    WS(weakSelf);
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:nil];
    [[[AppAPIHelper shareInstance]hsOrderManagementApi]postMdfConfirmOrderWithDictonary:_postOrderModel success:^(id data) {
        
        [MBProgressHUD zx_showSuccess:@"您已确认订单，等待买家付款" toView:nil];
        [weakSelf.navigationController popViewControllerAnimated:YES];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_Order_update_OrderListAndDetail object:nil];
        
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
