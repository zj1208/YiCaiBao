//
//  WYMakeBillViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillViewController.h"

#import "MakeBillBaseCell.h"
#import "MakeBillGoodsCell.h"
#import "MakeBillRemarkCell.h"
#import "MakeBillOrderNumberCell.h"
#import "MakeBillPicsTableViewCell.h"
#import "MakeBillGoodsHeaderView.h"
#import "MakeBillGoodsFooterView.h"
//#import "MakeBillButtonTableViewCell.h"
#import "MBDetailInputsTableViewCell.h"

#import "XLPhotoBrowser.h"
#import "TZImagePickerController.h"
#import "AliOSSUploadManager.h"
#import "NSString+ccTool.h"

#import "WYMakeBillGoodsViewController.h"
#import "CustomerMangerController.h"
#import "WYMakeBillPreviewViewController.h"

#import "ZXDatePickerView.h"
#import "MakeBillModel.h"
#import "SMCustomerModel.h"

@interface WYMakeBillViewController () <UITableViewDelegate,UITableViewDataSource,ZXAddPicCollectionViewDelegate,TZImagePickerControllerDelegate,XLPhotoBrowserDatasource,UITextViewDelegate,MakeBillGoodsCellDelegate,MBDetailInputsTableViewCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

//方便区分输入框
@property (nonatomic, weak) UITextView *addressTextView;
@property (nonatomic, weak) UITextView *remarkTextView;

@property (nonatomic, strong) MakeBillUploadModel *uploadModel;
@property (nonatomic, strong) NSMutableArray *picsArray;
@property (nonatomic, strong) MakeBillPicsTableViewCell *picsCell;
@property (nonatomic) BOOL isPreview;

@property (nonatomic) BOOL isHideGoods;

@end

@implementation WYMakeBillViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    [self initData];
    
    self.title = @"开单";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark- ButtonAction
- (BOOL)navigationShouldPopOnBackButton{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:@"您还没有保存，是否退出" cancelButtonTitle:@"退出" cancleHandler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    } doButtonTitle:@"取消" doHandler:^(UIAlertAction * _Nonnull action) {
    }];
    return NO;
}

- (void)isShowGoodsAction{
    self.isHideGoods = !self.isHideGoods;
    [self.tableView reloadData];
}

- (void)addNewGoods{
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_product_create];
    }else{
        [MobClick event:kUM_kdb_openbill_new_product_create];
    }
    
    WS(weakSelf)
    WYMakeBillGoodsViewController *vc = (WYMakeBillGoodsViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillGoodsViewController];
    vc.isEditBill = self.uploadModel.billSale.BillId;
    [vc updataGoodsModel:nil isAdd:YES index:0 block:^(MakeBillGoodsModel *goodsModel,NSInteger index) {
        [weakSelf.uploadModel.billGoods addObject:goodsModel];
        [weakSelf updatetotalOrderPrice];
        [weakSelf.tableView reloadData];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)saveButtonAction:(id)sender {
    [self saveButtonAction];
}

- (void)saveButtonAction{
    [self.view endEditing:YES];
    
    if (!self.isPreview) {
        if (self.uploadModel.billSale.BillId) {
            [MobClick event:kUM_kdb_openbill_old_save];
        }else{
            [MobClick event:kUM_kdb_openbill_new_save];
        }
    }
    
    if(!self.uploadModel.billSale.customerName || self.uploadModel.billSale.customerName.length == 0){
        [MBProgressHUD zx_showError:@"请选择客户" toView:self.view];
        self.isPreview = NO;
        return;
    }
    if(!self.uploadModel.billSale.totalOrderStr || self.uploadModel.billSale.totalOrderStr.length == 0){
        [MBProgressHUD zx_showError:@"请输入订单总额" toView:self.view];
        self.isPreview = NO;
        return;
    }
    
    self.uploadModel.billPics = [NSMutableArray array];
    for (ZXPhoto *photo in _picsArray) {
        MakeBillPicModel *picModel = [[MakeBillPicModel alloc]init];
        picModel.picUrl = photo.original_pic;
        [self.uploadModel.billPics addObject:picModel];
    }
    [self updateBill];
}

- (void)selectedCustomer{
    
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_customername];
    }else{
        [MobClick event:kUM_kdb_openbill_new_customer];
    }
    
    WS(weakSelf)
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    CustomerMangerController *vc = [sb instantiateViewControllerWithIdentifier:@"CustomerMangerControllerID"];
    vc.isSelectCustomer = YES;
    vc.didClcikBlock = ^(SMCustomerSubModel *model) {
        weakSelf.uploadModel.billSale.customerId = [NSString stringWithFormat:@"%@",model.iid];
        weakSelf.uploadModel.billSale.customerName = model.companyName;
        [weakSelf.tableView reloadData];
    };
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)editGoods:(NSInteger)index{
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_product_edit];
    }else{
        [MobClick event:kUM_kdb_openbill_new_product_edit];
    }
    WS(weakSelf)
    WYMakeBillGoodsViewController *vc = (WYMakeBillGoodsViewController *)[self xm_getControllerWithStoryboardName:sb_MakeBills controllerWithIdentifier:SBID_WYMakeBillGoodsViewController];
    vc.isEditBill = self.uploadModel.billSale.BillId;
    [vc updataGoodsModel:self.uploadModel.billGoods[index] isAdd:NO index:index block:^(MakeBillGoodsModel *goodsModel,NSInteger index) {
//        for (int i = 0; i < weakSelf.uploadModel.billGoods.count; i++) {
//            MakeBillGoodsModel *model = weakSelf.uploadModel.billGoods[i];
//            if (model.goodsId.longLongValue == goodsModel.goodsId.longLongValue) {
//                weakSelf.uploadModel.billGoods[i] = goodsModel;
//                break;
//            }
//        }
        if (index < weakSelf.uploadModel.billGoods.count) {
            weakSelf.uploadModel.billGoods[index] = goodsModel;
        }
        [weakSelf updatetotalOrderPrice];
        [weakSelf.tableView reloadData];
    }];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)preview{
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_preview];
    }else{
        [MobClick event:kUM_kdb_openbill_new_preview];
    }
    self.isPreview = YES;
    [self saveButtonAction];
}

#pragma mark- MBDetailInputsTableViewCell
- (void)inputString:(NSString *)string{
    self.uploadModel.billSale.totalOrderStr = string;
}

#pragma mark- MakeBillGoodsCellDelegate
- (void)deleteGoodsIndex:(NSInteger)index{
    
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_product_delete];
    }else{
        [MobClick event:kUM_kdb_openbill_new_product_delete];
    }
    WS(weakSelf)
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"您确定要删除产品吗？" message:nil cancelButtonTitle:@"删除" cancleHandler:^(UIAlertAction * _Nonnull action) {
        MakeBillGoodsModel *model = weakSelf.uploadModel.billGoods[index];
        [weakSelf.uploadModel.billGoods removeObject:model];
        [weakSelf.tableView reloadData];
    } doButtonTitle:@"取消" doHandler:nil];
}

#pragma mark- Request
- (void)updateBill{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postMakeBill:self.uploadModel success:^(id data) {
        NSLog(@"---%@",data);
        NSString *billId = [data objectForKey:@"id"];
        weakSelf.uploadModel.billSale.BillId = @(billId.longLongValue);
        
        if (weakSelf.isPreview) {
            weakSelf.isPreview = NO;
            [weakSelf requestPreviewByBillId:[data objectForKey:@"id"]];
        }else{
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)reloadBillInfo{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillInfoByBillId:self.billId success:^(id data) {
        weakSelf.uploadModel = data;
        [weakSelf reloadPhotoArray];
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)reloadGenerateBillNo{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillGenerateBillNoWithSuccess:^(id data) {
        weakSelf.uploadModel.billSale.billNo = data;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)requestPreviewByBillId:(NSString *)billId{
    
    UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
    WYMakeBillPreviewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYMakeBillPreviewViewController];
    VC.billId = billId;
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    
//    [MBProgressHUD jl_showGifWithGifName:@"load" imagesCount:13 toView:self.view];
//    WS(weakSelf)
//    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillPreviewInfoByBillId:billId success:^(id data) {
//        NSString *picPath = [data objectForKey:@"picPath"];
//        NSString *pdfPath = [data objectForKey:@"pdfPath"];
//
//        UIStoryboard *SB = [UIStoryboard storyboardWithName:@"MakeBills" bundle:nil];
//        WYMakeBillPreviewViewController *VC = [SB instantiateViewControllerWithIdentifier:SBID_WYMakeBillPreviewViewController];
//        VC.picPath = picPath;
//        VC.pdfPath = pdfPath;
//        VC.billId = billId;
//        VC.hidesBottomBarWhenPushed = YES;
//        [weakSelf.navigationController pushViewController:VC animated:YES];
//    } failure:^(NSError *error) {
//        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
//    }];
}
#pragma mark- UITextViewDelegate
- (void)textViewDidBeginEditing:(UITextView *)textView{
    if (self.remarkTextView == textView){
        if (self.uploadModel.billSale.BillId) {
            [MobClick event:kUM_kdb_openbill_old_remarks];
        }else{
            [MobClick event:kUM_kdb_openbill_new_remarks];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView{
    if (self.addressTextView == textView){
        if (textView.text.length > 50 && textView.markedTextRange == nil){
            NSString *string = textView.text;
            textView.text = [string substringToIndex:50];
        }
        self.uploadModel.billSale.deliveryAddress = textView.text;
    }else if (self.remarkTextView == textView){
        if (textView.text.length > 200 && textView.markedTextRange == nil){
            NSString *string = textView.text;
            textView.text = [string substringToIndex:200];
        }
        self.uploadModel.billSale.remark = textView.text;
    }
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 7;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0){
        return 4;
    }else if (section == 1 && !self.isHideGoods){
        return self.uploadModel.billGoods.count;
    }else if (section == 2){
        return 2;
    }else if (section == 3 || section == 4 || section == 5 || section == 6){
        return 1;
    }else{
        return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        MakeBillBaseCell *cell = (MakeBillBaseCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillBaseCellID forIndexPath:indexPath];
        if (indexPath.row == 0){
            [cell updateName:@"*客户名称" value:self.uploadModel.billSale.customerName defaultString:@"请选择客户"];
        }else if (indexPath.row == 1){
            [cell updateName:@"开单日期" value:self.uploadModel.billSale.billTime defaultString:@""];
        }else if (indexPath.row == 2){
            [cell updateName:@"交货日期" value:self.uploadModel.billSale.deliveryTime defaultString:@"请选择交货日期"];
        }else if (indexPath.row == 3){
            [cell updateName:@"计划收款日期" value:self.uploadModel.billSale.planCollectTime defaultString:@"请选择计划收款日期"];
        }
        return cell;
    }else if (indexPath.section == 1){
        MakeBillGoodsCell *cell = (MakeBillGoodsCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillGoodsCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateData:self.uploadModel.billGoods[indexPath.row] index:indexPath.row];
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 0){
        MBDetailInputsTableViewCell *cell = (MBDetailInputsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MBDetailInputsTableViewCellID forIndexPath:indexPath];
        cell.delegate = self;
        [cell updateName:@"*订单总额" value:self.uploadModel.billSale.totalOrderStr];
        return cell;
    }else if (indexPath.section == 2 && indexPath.row == 1){
        MakeBillBaseCell *cell = (MakeBillBaseCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillBaseCellID forIndexPath:indexPath];
        [cell updateName:@"收款状态" value:[self getPayStatusString] defaultString:@""];
        return cell;
    }else if (indexPath.section == 3){
        MakeBillRemarkCell *cell = (MakeBillRemarkCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillRemarkCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"交货地址：";
        cell.remarkTextView.placeholder = @"请输入交货地址";
        cell.remarkTextView.text = self.uploadModel.billSale.deliveryAddress;
        cell.remarkTextView.delegate = self;
        self.addressTextView = cell.remarkTextView;
        return cell;
    }else if (indexPath.section == 4){
        MakeBillRemarkCell *cell = (MakeBillRemarkCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillRemarkCellID forIndexPath:indexPath];
        cell.titleLabel.text = @"备注：";
        cell.remarkTextView.placeholder = @"请输入备注信息";
        cell.remarkTextView.text = self.uploadModel.billSale.remark;
        cell.remarkTextView.delegate = self;
        self.remarkTextView = cell.remarkTextView;
        return cell;
    }else if (indexPath.section == 5){
        [self.picsCell setData:_picsArray];
        return self.picsCell;
//    }else if (indexPath.section == 6){
    }else{
        MakeBillOrderNumberCell *cell = (MakeBillOrderNumberCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillOrderNumberCellID forIndexPath:indexPath];
        [cell updateData:self.uploadModel.billSale.billNo];
        return cell;
    }
    
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return 44.0;
    }else if (indexPath.section == 1){
        return 94.0;
    }else if (indexPath.section == 2){
        return 44.0;
    }else if (indexPath.section == 3){
        return 105.0;
    }else if (indexPath.section == 4){
        return 105.0;
    }else if (indexPath.section == 5){
        return [self.picsCell.picsCollectionView getCellHeightWithContentData:_picsArray];
    }else if (indexPath.section == 6){
        return 44.0;
    }else{
        return 0.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1 || section == 5){
        return 44.0;
    }else{
        return 10.0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 0 || section == 5){
        return 10.0;
    }else if (section == 1){
        return 40.0;
    }else{
        return 0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 1){
        MakeBillGoodsHeaderView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MakeBillGoodsHeaderViewID];
        [view imageIsHideImage:self.isHideGoods];
        [view.tapButton addTarget:self action:@selector(isShowGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [view.addButton addTarget:self action:@selector(addNewGoods) forControlEvents:UIControlEventTouchUpInside];
        return view;
    }else if (section == 5){
        UIView *view = [[UIView alloc]init];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 9, 60, 20)];
        label.text = @"附件";
        label.textColor = [UIColor colorWithHex:0x868686];
        label.font = [UIFont systemFontOfSize:13.0];
        [view addSubview:label];
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if (section == 1){
        MakeBillGoodsFooterView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:MakeBillGoodsFooterViewID];
        [view.tapButton addTarget:self action:@selector(isShowGoodsAction) forControlEvents:UIControlEventTouchUpInside];
        [view updateData:self.uploadModel.billGoods];
        return view;
    }
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 0){
        [self selectedCustomer];
    }else if (indexPath.section == 0 && indexPath.row == 1){
        [self selectedDataIsMakeBill:1];
    }else if (indexPath.section == 0 && indexPath.row == 2){
        [self selectedDataIsMakeBill:2];
    }else if (indexPath.section == 0 && indexPath.row == 3){
        [self selectedDataIsMakeBill:3];
    }else if (indexPath.section == 1){
        [self editGoods:indexPath.row];
    }else if (indexPath.section == 2 && indexPath.row == 1){
        WS(weakSelf)
        [UIAlertController zx_presentActionSheetInViewController:self withTitle:@"收款状态" message:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"未收款",@"部分收款",@"全部收款"] tapBlock:^(UIAlertController * _Nonnull alertController, UIAlertAction * _Nonnull action, NSInteger buttonIndex) {
            if (buttonIndex == 2){
                weakSelf.uploadModel.billSale.payStatus = @"1";
            }else if (buttonIndex == 3){
                weakSelf.uploadModel.billSale.payStatus = @"2";
            }else if (buttonIndex == 4){
                weakSelf.uploadModel.billSale.payStatus = @"3";
            }
            [weakSelf.tableView reloadData];
        }];
    }
}

#pragma mark- Private

- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    [_tableView registerClass:[MakeBillPicsTableViewCell class] forCellReuseIdentifier:MakeBillPicsTableViewCellID];
//    [_tableView registerClass:[MakeBillButtonTableViewCell class] forCellReuseIdentifier:MakeBillButtonTableViewCellID];
    [_tableView registerClass:[MakeBillGoodsHeaderView class] forHeaderFooterViewReuseIdentifier:MakeBillGoodsHeaderViewID];
    [_tableView registerClass:[MakeBillGoodsFooterView class] forHeaderFooterViewReuseIdentifier:MakeBillGoodsFooterViewID];
    
    
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [button setTitle:@"预览" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    [button.titleLabel setFont:[UIFont systemFontOfSize:16.0]];
    [button addTarget:self action:@selector(preview) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBtn;
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 30 , 45);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5147].CGColor, nil];
    [self.saveButton.layer insertSublayer:gradientLayer atIndex:0];
    self.saveButton.layer.cornerRadius = 22.5;
    self.saveButton.layer.masksToBounds = YES;
    
    [self.saveButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.saveButton.titleLabel setFont:[UIFont systemFontOfSize:20.0]];
}

- (void)initData{
    [[AliOSSUploadManager sharedInstance] initAliOSSWithSTSTokenCredential];
    [AliOSSUploadManager sharedInstance].getPicInfo = YES;
    self.picsCell = [[MakeBillPicsTableViewCell alloc]init];
    self.picsCell.picsCollectionView.delegate = self;
    self.picsArray = [NSMutableArray array];
    
    if (self.billId) {
        [self reloadBillInfo];
    }else{
        self.uploadModel = [[MakeBillUploadModel alloc]init];
        [self reloadGenerateBillNo];
    }
    
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"YYYY.MM.dd";
    NSString *currentDateStr = [dateFor stringFromDate:[NSDate date]];
    self.uploadModel.billSale.billTime = currentDateStr;
}

- (void)reloadPhotoArray{
    for (MakeBillPicModel *model in self.uploadModel.billPics) {
        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.picUrl];
        ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:model.picUrl thumbnailUrl:picUrl.absoluteString];
//        photo.width = imageSize.width;
//        photo.height = imageSize.height;
        photo.type = ZXAssetModelMediaTypePhoto;
        [_picsArray addObject:photo];
    }
    
}

//选择时间
- (void)selectedDataIsMakeBill:(NSInteger)dateType{
    
    if (dateType == 1) {
        if (self.uploadModel.billSale.BillId) {
            [MobClick event:kUM_kdb_openbill_old_opendate];
        }else{
            [MobClick event:kUM_kdb_openbill_new_opendate];
        }
    }else if (dateType == 2) {
        if (self.uploadModel.billSale.BillId) {
            [MobClick event:kUM_kdb_openbill_old_deaddate];
        }else{
            [MobClick event:kUM_kdb_openbill_new_deaddate];
        }
    }
    
    
    [self.view endEditing:YES];
    
    ZXDatePickerView *picker = [[ZXDatePickerView alloc] init];//WithFrame:CGRectMake(0, 0, 0, LCDScale_iPhone6_Width(250.f))];
    ZXDatePickerView *datePicker = picker;
    datePicker.returnDateFormat = @"YYYY.MM.dd";
    datePicker.toolBarTintColor = [UIColor colorWithHex:0x45A4E8];
    NSTimeInterval interval = 60 * 60 * 24 * 365 * 10;
    datePicker.datePicker.minuteInterval = 60 * 60 * 24 * 30;
    
    //设置当前选中时间
    NSDateFormatter *selectedDateFormatter = [[NSDateFormatter alloc] init];
    [selectedDateFormatter setDateFormat:@"yyyy.MM.dd"];
    if (dateType == 1) {
        datePicker.toolBarTitleBarItemTitle = @"请选择开单日期";
        NSDate *maxDate = [NSDate date];
        datePicker.datePicker.maximumDate = maxDate;
        datePicker.datePicker.minimumDate = [maxDate initWithTimeInterval:-interval sinceDate:maxDate];
        //设置当前选中时间
        if (self.uploadModel.billSale.billTime.length > 0) {
            datePicker.datePicker.date = [selectedDateFormatter dateFromString:self.uploadModel.billSale.billTime];
        }
    }else if (dateType == 2){
        datePicker.toolBarTitleBarItemTitle = @"请选择交货日期";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"YYYY.MM.dd";
        NSDate *minDate = [dateFormatter dateFromString:self.uploadModel.billSale.billTime];
        datePicker.datePicker.minimumDate = minDate;
        datePicker.datePicker.maximumDate = [minDate initWithTimeInterval:interval sinceDate:minDate];
        //设置当前选中时间
        if (self.uploadModel.billSale.deliveryTime.length > 0) {
            datePicker.datePicker.date = [selectedDateFormatter dateFromString:self.uploadModel.billSale.deliveryTime];
        }
    }else if (dateType == 3){
        datePicker.toolBarTitleBarItemTitle = @"请选择计划收款日期";
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateFormat=@"YYYY.MM.dd";
        NSDate *minDate = [dateFormatter dateFromString:self.uploadModel.billSale.billTime];
        datePicker.datePicker.minimumDate = minDate;
        datePicker.datePicker.maximumDate = [minDate initWithTimeInterval:interval sinceDate:minDate];
        //设置当前选中时间
        if (self.uploadModel.billSale.planCollectTime.length > 0) {
            datePicker.datePicker.date = [selectedDateFormatter dateFromString:self.uploadModel.billSale.planCollectTime];
        }
    }
    WS(weakSelf)
    [datePicker showInView:self.view cancleHander:^{
        
    } doneHander:^(NSDate * _Nonnull date, NSString * _Nonnull dateString) {
        
        NSLog(@"%@",dateString);
        if (dateType == 1){
            weakSelf.uploadModel.billSale.billTime = dateString;
        }else if (dateType == 2) {
            weakSelf.uploadModel.billSale.deliveryTime = dateString;
        }else if (dateType == 3) {
            weakSelf.uploadModel.billSale.planCollectTime = dateString;
        }
        [weakSelf.tableView reloadData];
    }];
}

//将支付状态转为字符串
- (NSString *)getPayStatusString{
    NSString *patStatusString = @"未收款";
    if (self.uploadModel.billSale.payStatus.integerValue == WYBillPayStatusTypeNot){
        patStatusString = @"未收款";
    }else if (self.uploadModel.billSale.payStatus.integerValue == WYBillPayStatusTypePart){
        patStatusString = @"部分收款";
    }else if (self.uploadModel.billSale.payStatus.integerValue == WYBillPayStatusTypeAll){
        patStatusString = @"全部收款";
    }
    return patStatusString;
}

//计算开单产品总价
- (void)updatetotalOrderPrice{
    NSDecimalNumber *allMoney = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (MakeBillGoodsModel *model in self.uploadModel.billGoods) {
        if (model.totalNumStr.length > 0) {
            NSDecimalNumber *countNumber = [NSDecimalNumber decimalNumberWithString:model.totalNumStr];
            
            NSDecimalNumber *minPriceDisplayNumber = [NSDecimalNumber decimalNumberWithString:model.minPriceDisplay];
            NSDecimalNumber *money = [countNumber decimalNumberByMultiplyingBy:minPriceDisplayNumber];
            allMoney = [allMoney decimalNumberByAdding:money];
        }
    }
    NSString *allMoneyString = [NSString stringWithFormat:@"%@",allMoney];
    allMoneyString = [allMoneyString cc_stringKeepTwoDecimal];
    self.uploadModel.billSale.totalOrderStr = allMoneyString;
}

#pragma mark    -   XLPhotoBrowserDatasource
- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    MakeBillPicModel *model = self.uploadModel.billPics[index];
    return [NSURL URLWithString:model.picUrl];
}

#pragma mark - ZXAddPicCollectionViewDelegate

- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)addPicCollectionView commitEditingStyle:(ZXAddPicCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.uploadModel.billSale.BillId) {
        [MobClick event:kUM_kdb_openbill_old_attachment];
    }else{
        [MobClick event:kUM_kdb_openbill_new_attachment];
    }
    if (editingStyle == ZXAddPicCellEditingStyleInsert){
        [self picBtnAction:nil];
    }else{
        [self.picsArray removeObjectAtIndex:indexPath.item];
        [self.tableView reloadData];
    }
}


- (void)zx_addPicCollectionView:(ZXAddPicCollectionView *)tagsView didSelectPicItemAtIndex:(NSInteger)index didAddPics:(NSMutableArray *)picsArray{
    NSMutableArray *array = [NSMutableArray array];
    [self.picsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXPhoto *photo = (ZXPhoto *)obj;
        if (photo.type == ZXAssetModelMediaTypePhoto)
        {
            [array addObject:photo];
        }
    }];
    NSInteger inde = index;
    if (array.count < picsArray.count){
        inde = index-1;
    }
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:inde imageCount:array.count datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
}


#pragma mark - 添加图片

- (void)picBtnAction:(id)sender {
    [self presentImagePickerController];
}


- (void)presentImagePickerController {
    //初始化多选择照片
    TZImagePickerController *imagePicker = [[TZImagePickerController alloc] initWithMaxImagesCount:(9-self.picsArray.count) delegate:self];
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    [imagePicker setSortAscendingByModificationDate:NO];
    //是否有选择原图
    imagePicker.allowPickingOriginalPhoto = NO;
    //    imagePicker.isSelectOriginalPhoto = _isSelectOriginalPhoto;
    //用户选中的图片
    //    imagePicker.selectedAssets = _assestArray;
    //是否允许选择视频
    imagePicker.allowPickingVideo = NO;
    //是否可以拍照
    imagePicker.allowTakePicture = YES;
    [self presentViewController:imagePicker animated:YES completion:nil];
}

#pragma mark- TZImagePickerControllerDelegate

- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray<UIImage *> *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto{
    
    
    
    [MBProgressHUD zx_showLoadingWithStatus:@"正在上传" toView:self.view];
    __block NSInteger currentIndex = 0;
    NSMutableArray *tempMArray = [NSMutableArray array];
    WS(weakSelf);
    [photos enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIImage *image = (UIImage *)obj;
        NSData *imageData = [WYUtility zipNSDataWithImage:image];
        
        [[AliOSSUploadManager sharedInstance]putOSSObjectSTSTokenInPublicBucketWithUserId:USER_TOKEN fileCatalogType:OSSFileCatalog_MakeBill uploadingData:imageData progress:^(int64_t bytesSent, int64_t totalBytesSent, int64_t totalBytesExpectedToSend) {
            
        } singleComplete:^(id imageInfo,NSString*imagePath,CGSize imageSize) {
            
            currentIndex ++;
            //这里处理上传图片
            NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:imagePath];
            ZXPhoto *photo = [ZXPhoto photoWithOriginalUrl:imagePath thumbnailUrl:picUrl.absoluteString];
            photo.width = imageSize.width;
            photo.height = imageSize.height;
            photo.type = ZXAssetModelMediaTypePhoto;
            [tempMArray addObject:photo];
            if (currentIndex == photos.count){
                [weakSelf.picsArray addObjectsFromArray:tempMArray];
                [MBProgressHUD zx_hideHUDForView:weakSelf.view];
                [weakSelf.tableView reloadData];
            }
            
            self.uploadModel.billPics = [NSMutableArray array];
            for (ZXPhoto *photo in weakSelf.picsArray) {
                MakeBillPicModel *picModel = [[MakeBillPicModel alloc]init];
                picModel.picUrl = photo.original_pic;
                [self.uploadModel.billPics addObject:picModel];
            }
            
        } failure:^(NSError *error) {
            
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
        
    }];
    
}

//get 没有时默认创建
- (MakeBillUploadModel *)uploadModel{
    if (!_uploadModel) {
        _uploadModel = [[MakeBillUploadModel alloc]init];
    }
    if (!_uploadModel.billGoods) {
        _uploadModel.billGoods = [NSMutableArray array];
    }
    if (!_uploadModel.billPics) {
        _uploadModel.billPics = [NSMutableArray array];
    }
    if (!_uploadModel.billSale) {
        _uploadModel.billSale = [[MakeBillInfoModel alloc]init];
        _uploadModel.billSale.payStatus = [NSString stringWithFormat:@"%ld" ,(long)WYBillPayStatusTypeNot];
    }
    return _uploadModel;
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
