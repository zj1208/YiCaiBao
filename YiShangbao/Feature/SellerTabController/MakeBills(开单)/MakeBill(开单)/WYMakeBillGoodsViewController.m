//
//  WYMakeBillGoodsViewController.m
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillGoodsViewController.h"
#import "MakeBillInputsTableViewCell.h"
#import "MakeBillModel.h"

#import "NSString+ccTool.h"

#import "IQKeyboardManager.h"
#import "MakeBillGoodNameView.h"

@interface WYMakeBillGoodsViewController ()<UITableViewDelegate,UITableViewDataSource,MakeBillInputsTableViewCellDelegate,MakeBillGoodNameViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UIButton *addNewButton;
@property (weak, nonatomic) IBOutlet UIButton *editConfirmButton;

@property (nonatomic, strong) MakeBillGoodNameView *nameView;

@property (nonatomic, strong) MakeBillGoodsModel *goodsModel;
@property (nonatomic, strong) NSMutableArray *goodsArray;
@property (nonatomic, strong) NSArray *goodsNameHistoryList;

@property (nonatomic) BOOL isAdd;
@property (nonatomic) NSInteger index;
@property (nonatomic, copy) MakeBillGoodsListBlock block;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewBottomLayoutConstraint;

@end

@implementation WYMakeBillGoodsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (self.isAdd){
//        self.title = @"添加产品";
//        self.goodsModel = [[MakeBillGoodsModel alloc]init];
//    }else{
//        self.title = @"编辑产品";
//        self.goodsModel = [[MakeBillGoodsModel alloc]init];
//    }
    self.goodsArray = [NSMutableArray array];
    
    [self setUI];
    
    [self reloadGoodsNameHistory];
    
    self.editConfirmButton.hidden = self.isAdd;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager]setEnable:NO] ;
//    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [IQKeyboardManager sharedManager].enable = YES;
//    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
}

- (void)updataGoodsModel:(MakeBillGoodsModel *)goodsModel isAdd:(BOOL)isAdd index:(NSInteger)index block:(MakeBillGoodsListBlock)block{
    self.block = block;
    self.isAdd = isAdd;
    self.index = index;
    self.goodsModel = [[MakeBillGoodsModel alloc]init];
    if (isAdd) {
        self.title = @"添加产品";
    }else{
        self.title = @"编辑产品";
        
        self.goodsModel.goodsId = goodsModel.goodsId;
        self.goodsModel.goodsNo = goodsModel.goodsNo;
        self.goodsModel.goodsName = goodsModel.goodsName;
        self.goodsModel.totalNumStr = goodsModel.totalNumStr;
        self.goodsModel.boxNumStr = goodsModel.boxNumStr;
        self.goodsModel.boxPerNumStr = goodsModel.boxPerNumStr;
//        self.goodsModel.boxNum = goodsModel.boxNum;
//        self.goodsModel.boxPerNum = goodsModel.boxPerNum;
        self.goodsModel.minUnit = goodsModel.minUnit;
        self.goodsModel.minPriceDisplay = goodsModel.minPriceDisplay;
        self.goodsModel.boxSize = goodsModel.boxSize;
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

#pragma mark- Request
- (void)reloadAddNewGoodsIsBack:(BOOL)isback{
    [self.view endEditing:YES];
    if (!self.goodsModel.goodsName || self.goodsModel.goodsName.length == 0) {
        [MBProgressHUD zx_showError:@"请填写品名" toView:self.view];
        return;
    }
    if (self.goodsModel.minPriceDisplay.length == 0) {
        [MBProgressHUD zx_showError:@"请填写单价" toView:self.view];
        return;
    }
    if (self.goodsModel.totalNumStr.length == 0) {
        [MBProgressHUD zx_showError:@"请填写总数量" toView:self.view];
        return;
    }
    
//    [self addNewGoodsIsBack:isback];
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postBillConfirmAddGoodsWithModel:self.goodsModel success:^(id data) {
        if (!isback){
            [weakSelf reloadGoodsNameHistory];
        }
        [weakSelf addNewGoodsIsBack:isback];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)reloadGoodsNameHistory{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getkBillHistoryGoodsNameListWithSuccess:^(id data) {
        self.goodsNameHistoryList = [data objectForKey:@"historyGoodsNameList"];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
    
}

- (void)reloadGoodsNameByName:(NSString *)name{
    WS(weakSelf)
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getkBillHistoryGoodsNameInfoByGoodsname:name success:^(id data) {
        MakeBillGoodsModel *model = data;
        weakSelf.goodsModel.goodsName = [name copy];
        weakSelf.goodsModel.goodsNo = model.goodsNo;
        weakSelf.goodsModel.minUnit = model.minUnit;
        weakSelf.goodsModel.boxPerNumStr = model.boxPerNumStr;
        weakSelf.goodsModel.boxSize = model.boxSize;
        [weakSelf.tableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark- ButtonAction

- (IBAction)confirmButtonAction:(id)sender {
    if (self.isEditBill) {
        [MobClick event:kUM_kdb_openbill_old_product_confirm];
    }else{
        [MobClick event:kUM_kdb_openbill_new_product_confirm];
    }
    [self reloadAddNewGoodsIsBack:YES];
}

- (IBAction)addNewButtonAction:(id)sender {
    
    if (self.isEditBill) {
        [MobClick event:kUM_kdb_openbill_old_product_next];
    }else{
        [MobClick event:kUM_kdb_openbill_new_product_next];
    }
    [self reloadAddNewGoodsIsBack:NO];
}

- (void)addNewGoodsIsBack:(BOOL)isBack{
    [self.goodsArray addObject:self.goodsModel];
    
    MakeBillGoodsModel *goodsModel = [[MakeBillGoodsModel alloc]init];
    goodsModel.goodsId = self.goodsModel.goodsId;
    goodsModel.goodsNo = self.goodsModel.goodsNo;
    goodsModel.goodsName = self.goodsModel.goodsName;
    goodsModel.totalNumStr = self.goodsModel.totalNumStr;
    goodsModel.boxNumStr = self.goodsModel.boxNumStr;
    goodsModel.boxPerNumStr = self.goodsModel.boxPerNumStr;
    goodsModel.minUnit = self.goodsModel.minUnit;
    goodsModel.minPriceDisplay = self.goodsModel.minPriceDisplay;
    goodsModel.boxSize = self.goodsModel.boxSize;
    
    self.goodsModel = [[MakeBillGoodsModel alloc]init];
    [self.tableView reloadData];
    if (self.block){
        self.block(goodsModel,self.index);
    }
    if (isBack) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    self.goodsModel = [[MakeBillGoodsModel alloc]init];
}

#pragma mark- MakeBillGoodNameViewDelegate
- (void)selectedGoodsName:(NSString *)goodsName{
    [self reloadGoodsNameByName:goodsName];
    [self.view endEditing:YES];
}

#pragma mark- MakeBillInputsTableViewCellDelegate
- (void)inputString:(NSString *)string goodsInfoType:(MakeBillGoodsInfo)goodsInfoType{
    switch (goodsInfoType) {
        case MakeBillGoodsProductName:
            self.goodsModel.goodsName = string;
            break;
        case MakeBillGoodsUnitPrice:
            self.goodsModel.minPriceDisplay = string;
            break;
        case MakeBillGoodsTotalNumber:
            self.goodsModel.totalNumStr = string;
            break;
        case MakeBillGoodsNo:
            self.goodsModel.goodsNo = string;
            break;
        case MakeBillGoodsUnit:
            self.goodsModel.minUnit = string;
            break;
        case MakeBillGoodsBoxNumber:
            self.goodsModel.boxNumStr = string;
            break;
        case MakeBillGoodsPerBoxNumber:
            self.goodsModel.boxPerNumStr = string;
            break;
        case MakeBillGoodsVolume:
            self.goodsModel.boxSize = string;
            break;
        default:
            break;
    }
    if (goodsInfoType == MakeBillGoodsBoxNumber || goodsInfoType == MakeBillGoodsPerBoxNumber ){
        [self calculationTotalQuantityByModel:self.goodsModel];
        //刷新总数量
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:4 inSection:0];
        [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    }
    //刷新总价
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:3 inSection:1];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)changeString:(NSString *)string{
    NSArray *screeningArray = [self screeningByString:string];
    if (screeningArray.count){
        [self.nameView updateData:screeningArray];
        self.nameView.hidden = NO;
    }else{
        self.nameView.hidden = YES;
    }
}

- (void)hiddenHistoryView{
    self.nameView.hidden = YES;
}

#pragma mark -UIKeyboardNotification
- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    float safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = self.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    
    [UIView animateWithDuration:duration animations:^{
        self.viewBottomLayoutConstraint.constant = keyboardRect.size.height - safeBottom;
        [self.view layoutIfNeeded];
        [self.tableView needsUpdateConstraints];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    NSTimeInterval duration = [[userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    [UIView animateWithDuration:duration animations:^{
        self.viewBottomLayoutConstraint.constant = 0;
        [self.view layoutIfNeeded];
        [self.tableView needsUpdateConstraints];
    }];
}

#pragma mark- UITableviewDatasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 5;
    }
    return 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MakeBillInputsTableViewCell *cell = (MakeBillInputsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:MakeBillInputsTableViewCellID forIndexPath:indexPath];
    cell.delegate = self;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            [cell updateInputText:self.goodsModel.goodsName index:indexPath];
        }else if (indexPath.row == 1){
            [cell updateInputText:self.goodsModel.minPriceDisplay index:indexPath];
        }else if (indexPath.row == 2){
            [cell updateInputText:self.goodsModel.boxNumStr index:indexPath];
        }else if (indexPath.row == 3){
            [cell updateInputText:self.goodsModel.boxPerNumStr index:indexPath];
        }else if (indexPath.row == 4){
            [cell updateInputText:self.goodsModel.totalNumStr index:indexPath];
        }
    }else{
        if (indexPath.row == 0) {
            [cell updateInputText:self.goodsModel.goodsNo index:indexPath];
        }else if (indexPath.row == 1){
            [cell updateInputText:self.goodsModel.minUnit index:indexPath];
        }else if (indexPath.row == 2){
            [cell updateInputText:self.goodsModel.boxSize index:indexPath];
        }else if (indexPath.row == 3){
            [cell updateInputText:[self calculationTotalPriceByModel:self.goodsModel] index:indexPath];
        }
    }
    
    
    
//    if (indexPath.row == 0) {
//        [cell updateInputWithFirst:self.goodsModel.goodsName second:@"" index:indexPath.row];
//    }else if (indexPath.row == 1){
//        [cell updateInputWithFirst:self.goodsModel.goodsNo second:@"" index:indexPath.row];
//    }else if (indexPath.row == 2){
//        [cell updateInputWithFirst:self.goodsModel.boxNum.stringValue second:@"" index:indexPath.row];
//    }else if (indexPath.row == 3){
//        [cell updateInputWithFirst:self.goodsModel.boxPerNum.stringValue second:self.goodsModel.minUnit index:indexPath.row];
//    }else if (indexPath.row == 4){
//        [cell updateInputWithFirst:self.goodsModel.minPriceDisplay second:@"" index:indexPath.row];
//    }else if (indexPath.row == 5){
//        [cell updateInputWithFirst:[self calculationTotalPriceByModel:self.goodsModel] second:@"" index:indexPath.row];
//    }else if (indexPath.row == 6){
//        [cell updateInputWithFirst:self.goodsModel.boxSize second:@"m³" index:indexPath.row];
//    }
    return cell;
}

#pragma mark- UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc]initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self.view endEditing:YES];
}

#pragma mark- Private

- (void)setUI{
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithHex:0xE5E5E5];
    _tableView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    
    self.nameView = [[MakeBillGoodNameView alloc]init];
    self.nameView.delegate = self;
    self.nameView.hidden = YES;
    [self.view addSubview:self.nameView];
    [self.nameView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(30);
        make.left.equalTo(self.view).offset(150);
        make.right.equalTo(self.view).offset(-25);
        make.bottom.equalTo(self.tableView.mas_bottom).offset(0);
    }];
    
    //按钮背景渐变色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH / 375 * 110, 45);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFDAB53].CGColor,(id)[UIColor colorWithHex:0xFD7953].CGColor, nil];
    [self.confirmButton.layer insertSublayer:gradientLayer atIndex:0];
    self.confirmButton.layer.cornerRadius = 22.5;
    self.confirmButton.layer.masksToBounds = YES;
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 50)/265*375 , 45);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    [self.addNewButton.layer insertSublayer:gradientLayer2 atIndex:0];
    self.addNewButton.layer.cornerRadius = 22.5;
    self.addNewButton.layer.masksToBounds = YES;
    
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(1, 0);
    gradientLayer3.frame = CGRectMake(0, 0, (SCREEN_WIDTH - 30) , 45);
    gradientLayer3.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFD7953].CGColor,(id)[UIColor colorWithHex:0xFE5247].CGColor, nil];
    [self.editConfirmButton.layer insertSublayer:gradientLayer3 atIndex:0];
    self.editConfirmButton.layer.cornerRadius = 22.5;
    self.editConfirmButton.layer.masksToBounds = YES;
}

//计算总数量
- (void) calculationTotalQuantityByModel:(MakeBillGoodsModel *)model{
    if (model.boxNumStr.length && model.boxPerNumStr.length) {
        NSDecimalNumber *boxNumber = [NSDecimalNumber decimalNumberWithString:model.boxNumStr];
        NSDecimalNumber *boxPerNumber = [NSDecimalNumber decimalNumberWithString:model.boxPerNumStr];
        NSDecimalNumber *countNumber = [boxNumber decimalNumberByMultiplyingBy:boxPerNumber];
        model.totalNumStr = [NSString stringWithFormat:@"%@",countNumber];
        [self calculationTotalPriceByModel:model];
    }
}

//计算总价
- (NSString *)calculationTotalPriceByModel:(MakeBillGoodsModel *)model{
    NSString *countPrice = @"";
    if (model.totalNumStr.length == 0 || model.minPriceDisplay.length == 0) {
        return countPrice;
    }
    
    NSDecimalNumber *minPriceDisplayNumber = [NSDecimalNumber decimalNumberWithString:model.minPriceDisplay];
    NSDecimalNumber *countNumber = [NSDecimalNumber decimalNumberWithString:model.totalNumStr];
    
    NSDecimalNumber *money = [countNumber decimalNumberByMultiplyingBy:minPriceDisplayNumber];
    countPrice = [NSString stringWithFormat:@"%@",money];
    countPrice = [countPrice cc_stringKeepTwoDecimal];
    return countPrice;
}

- (NSArray *)screeningByString:(NSString *)name{
    if ([name isEqualToString:@""]){
        return self.goodsNameHistoryList;
    }
    NSMutableArray *array = [NSMutableArray array];
    for (NSString *string in self.goodsNameHistoryList) {
        if ([string rangeOfString:name].location != NSNotFound) {
            [array addObject:string];
        }
    }
    return array;
}

- (MakeBillGoodsModel *)goodsModel{
    if (!_goodsModel) {
        _goodsModel = [[MakeBillGoodsModel alloc]init];
    }
    return _goodsModel;
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
