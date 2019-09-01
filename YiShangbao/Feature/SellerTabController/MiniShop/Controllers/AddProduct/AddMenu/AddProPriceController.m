//
//  AddProPriceController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "AddProPriceController.h"
#import "IQKeyboardManager.h"

#import "APPriceSelectCell.h"
#import "APPriceUnitCell.h"
#import "APPriceMinQuantityCell.h"
#import "APPriceIncreaseRangeCell.h"
#import "APPriceSelectFootView.h"
#import "APPriceMinQuantityFootView.h"
#import "APPricePreviewFootView.h"

#import "TMDiskManager.h"
#import "AddProductModel.h"

@interface AddProPriceController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,APPriceSelectCellDelegate>
@property(nonatomic,strong)UITableView *tableView;

@property (nonatomic, strong)TMDiskManager *diskManager;
@property(nonatomic,strong)NSMutableArray<__kindof AddProductSetPriceModel*> *minimumQuantityArrayM;
@property(nonatomic,assign)BOOL priceNegotiable; //no设置价格，yes面议
@property(nonatomic,copy)NSString *priceUnit;//单位
@property(nonatomic,copy)NSString *priceGrads;//阶梯价格拼接字符串

@property(nonatomic,assign)BOOL isShouldShowAlert; //返回时是否提示用户保存数据（默认以点击了价格设置、面议按钮、增加区间、删除区间、编辑输入框就算修改过）

@property(nonatomic,assign)NSInteger lastEndEditSection;//用于同组不同textfild切换(刷新导致收起键盘，光标不能切换)
@property(nonatomic,assign)BOOL signWillRemove; //删除前标记结束编辑时不刷新，不然刷新时删除数组元素越界，删除时刷新


@end

static NSString *const cell_APPriceSelectCell = @"cell_APPriceSelectCell";
static NSString *const cell_APPriceUnitCell = @"cell_APPriceUnitCell";
static NSString *const cell_APPriceMinQuantityCell = @"cell_APPriceMinQuantityCell";
static NSString *const cell_APPriceIncreaseRangeCell = @"cell_APPriceIncreaseRangeCell";
static NSString *const foot_APPriceSelectFootView = @"foot_APPriceSelectFootView";
static NSString *const foot_APPriceMinQuantityFootView = @"foot_APPriceMinQuantityFootView";
static NSString *const foot_APPricePreviewFootView = @"foot_APPricePreviewFootView";
@implementation AddProPriceController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"设置价格";
    
    [self setData];

    [self buildUI];
    
}
//初始化数据
-(void)setData
{
    self.lastEndEditSection = -1;
    
    TMDiskManager *manager = [[TMDiskManager alloc] initWithObjectKey:TMDiskAddProcutKey];
    self.diskManager = manager;
    AddProductModel *model = (AddProductModel *)[self.diskManager getData];
    
    if (model.priceGrads) //冒号分割梯度eg: 1,1:10,5:20,4
    {
        if ([model.priceGrads isEqualToString:@"1,-1"]) {//面议
            self.priceNegotiable = YES;
            self.minimumQuantityArrayM = [NSMutableArray array];
            [self.minimumQuantityArrayM addObject:[[AddProductSetPriceModel alloc]init]];
        }else{
            NSArray *array = [model.priceGrads componentsSeparatedByString:@":"];
            self.minimumQuantityArrayM = [NSMutableArray array];
            for (int i=0; i<array.count; ++i) {
                NSArray *array_m = [array[i] componentsSeparatedByString:@","];
                AddProductSetPriceModel *model = [[AddProductSetPriceModel alloc] init];
                model.minimumQuantity = array_m.firstObject;
                model.price = array_m.lastObject;
                [self.minimumQuantityArrayM  addObject:model];
            }
        }
    }else//新增
    {
        self.priceNegotiable = NO;
        self.minimumQuantityArrayM = [NSMutableArray array];
        [self.minimumQuantityArrayM addObject:[[AddProductSetPriceModel alloc]init]];
    }
    
    self.priceUnit = [NSString stringWithFormat:@""];
    if (model.priceUnit)
    {
        if (![NSString zhIsBlankString:model.priceUnit])
        {
            self.priceUnit = model.priceUnit;
        }
    }
}
-(void)buildUI
{
    UIButton *AddBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 62, 28)];
    [AddBtn setTitle:@"确定" forState:UIControlStateNormal];
    AddBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    [AddBtn setTitleColor:[WYUISTYLE colorWithHexString:@"FF6936"] forState:UIControlStateNormal];
    AddBtn.backgroundColor = [WYUISTYLE colorWithHexString:@"#FFF5F1"];
    AddBtn.layer.masksToBounds = YES;
    AddBtn.layer.cornerRadius = 14;
    AddBtn.layer.borderWidth = 0.5f;
    AddBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"#FE744A"].CGColor;
    [AddBtn addTarget:self action:@selector(clickSaveBtn:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:AddBtn];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.rowHeight = 45.f;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [WYUISTYLE colorF3F3F3];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(self.view);
    }];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.1)];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceSelectCell" bundle:nil] forCellReuseIdentifier:cell_APPriceSelectCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceUnitCell" bundle:nil] forCellReuseIdentifier:cell_APPriceUnitCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceMinQuantityCell" bundle:nil] forCellReuseIdentifier:cell_APPriceMinQuantityCell];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceIncreaseRangeCell" bundle:nil] forCellReuseIdentifier:cell_APPriceIncreaseRangeCell];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceSelectFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:foot_APPriceSelectFootView];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPriceMinQuantityFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:foot_APPriceMinQuantityFootView];
    [self.tableView registerNib:[UINib nibWithNibName:@"APPricePreviewFootView" bundle:nil] forHeaderFooterViewReuseIdentifier:foot_APPricePreviewFootView];
    
}
#pragma mark 拦截系统返回按钮事件
- (BOOL)navigationShouldPopOnBackButton
{
    [self.view endEditing:YES];
    if (self.isShouldShowAlert)
    {
        WS(weakSelf);
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"是否保存更改后的内容" message:nil cancelButtonTitle:@"不保存" cancleHandler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } doButtonTitle:@"保存" doHandler:^(UIAlertAction * _Nonnull action) {
            [self clickSaveBtn:nil];
        }];
        return NO;
    }else
    {
        return YES;
    }
}
#pragma mark 保存
-(void)clickSaveBtn:(UIButton *)sender
{
    [self.view endEditing:YES];
    [self checkPriceRange];
    [self.tableView reloadData];

    if (self.priceNegotiable) {//面议
        [self.diskManager setPropertyImplementationValue:@"1,-1" forKey:@"priceGrads"];
        
        NSString *priceUnit_save = [NSString zhIsBlankString:_priceUnit]?@"个":_priceUnit;
        [self.diskManager setPropertyImplementationValue:priceUnit_save forKey:@"priceUnit"];
        
        [self.navigationController popViewControllerAnimated:NO];
    }else{
        if ([self isShouldPreview]) {
            [self setPriceGradsWithArrayM];
            [self.navigationController popViewControllerAnimated:NO];
        }else{
            [MBProgressHUD zx_showError:@"信息有错误，请修改后再进行下一步操作" toView:self.view];
        }
    }
}
//拼接阶梯字符串、本地存储数据
-(void)setPriceGradsWithArrayM
{
    NSMutableArray *arrayM = [NSMutableArray array];
    for (int i =0; i<self.minimumQuantityArrayM.count; ++i) {
        AddProductSetPriceModel *model = _minimumQuantityArrayM[i];
        if ([self isHaveInput:model.price] && [self isHaveInput:model.minimumQuantity]) {
            NSString *str = [NSString stringWithFormat:@"%@,%@",model.minimumQuantity,model.price];
            [arrayM addObject:str];
        }
    }
    self.priceGrads = [arrayM componentsJoinedByString:@":"];
    
    NSString *priceGrads_save = [NSString zhIsBlankString:_priceGrads]?nil:_priceGrads;
    [self.diskManager setPropertyImplementationValue:priceGrads_save forKey:@"priceGrads"];
    
    NSString *priceUnit_save = [NSString zhIsBlankString:_priceUnit]?@"个":_priceUnit;
    [self.diskManager setPropertyImplementationValue:priceUnit_save forKey:@"priceUnit"];
}
#pragma mark 删除区间
-(void)delPriceIncreaseRangeBtn:(UIButton *)sender
{
    self.signWillRemove = YES;//标记结束编辑时不刷新，不然异步刷新时删除数组元素越界
    [self.view endEditing:YES];
    NSIndexPath *indexPath = [sender jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:self.tableView];
    [self.minimumQuantityArrayM removeObjectAtIndex:indexPath.section-2];
    [self checkPriceRange];
    [self.tableView reloadData];
    self.signWillRemove = NO;
    
    self.isShouldShowAlert = YES;
}
#pragma mark 增加区间
-(void)addPriceIncreaseRangeBtn:(UIButton *)sender
{
    [MobClick event:kUM_b_product_pricerange];
    
    [self.view endEditing:YES];
    if (self.minimumQuantityArrayM.count<3) {
        if ([self isShouldPreview]) {
            [self.minimumQuantityArrayM addObject:[[AddProductSetPriceModel alloc]init]];
        }else{
            [self checkPriceRange];
        }
    }
    [self.tableView reloadData];
    
    self.isShouldShowAlert = YES;
}
#pragma mark 选择阶梯价格、选择面议 cell代理
-(void)jl_APPriceSelectCell:(APPriceSelectCell *)cell setPriceBtnSelectedChanged:(BOOL)selected
{
    self.priceNegotiable = !selected;
    [self.tableView reloadData];
    
    self.isShouldShowAlert = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.priceNegotiable) {
        return 1; //面议情况只有一组
    }
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section==3) {//第二阶梯
        if (self.minimumQuantityArrayM.count>1) {
            return 1;
        }
        return 0;
    }
    if (section==4) {//第三阶梯
        if (self.minimumQuantityArrayM.count>2) {
            return 1;
        }
        return 0;
    }
    if (section==5) { //增加价格区间组
        if (self.minimumQuantityArrayM.count==3) {
            return 0;
        }
    }
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==3) {
        return 0.01;
    }
    if (section==4) {
        return 0.01;
    }
    if (section==5) {
        return 0.01;
    }
    return 10;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section==0) { //选择面议
        if (self.priceNegotiable) {
            return 60; //面议情况只有一组，一定有组尾提示(小屏两行)
        }
    }
    if (section==2) { //第一组区间组尾
        if (self.minimumQuantityArrayM.count>0) {
            AddProductSetPriceModel *model = self.minimumQuantityArrayM[0];
            if (model.markedWords) {
                return 45;
            }
        }
    }
    if (section==3) {//第二组区间组尾
        if (self.minimumQuantityArrayM.count>1) {
            AddProductSetPriceModel *model = self.minimumQuantityArrayM[1];
            if (model.markedWords) {
                return 45;
            }
        }
    }
    if (section==4) {//第三组区间组尾
        if (self.minimumQuantityArrayM.count>2) {
            AddProductSetPriceModel *model = self.minimumQuantityArrayM[2];
            if (model.markedWords) {
                return 45;
            }
        }
    }
    if (section==5) { //预览
        if (!self.priceNegotiable) {
            if ([self isShouldPreview]) {
                return 150;
            }
        }
    }
    return 0.01;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section==0)
    {
        APPriceSelectFootView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foot_APPriceSelectFootView];
        return view;
    }
    else if (section == 2 || section == 3 || section == 4)
    {
        APPriceMinQuantityFootView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foot_APPriceMinQuantityFootView];
        if (self.minimumQuantityArrayM.count>section-2) {
            AddProductSetPriceModel *model = self.minimumQuantityArrayM[section-2];
            view.messageLabel.text = model.markedWords;
        }
        return view;
    }
    else if (section == 5)
    {
        APPricePreviewFootView *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:foot_APPricePreviewFootView];
        NSString *unitStr = [self isHaveInput: self.priceUnit]?self.priceUnit:@"个";
        [view setPriceData:[self arrayRemoveEmpty] unit:unitStr show:[self isShouldPreview]];
        return view;
    }
    return nil;
}
-(NSMutableArray *)arrayRemoveEmpty
{
    NSMutableArray *arrayM = [NSMutableArray arrayWithArray:_minimumQuantityArrayM];
    for (int i = (int)_minimumQuantityArrayM.count-1; i>=0; --i) {
        AddProductSetPriceModel *model = _minimumQuantityArrayM[i];
        if (![self isHaveInput:model.minimumQuantity] && ![self isHaveInput: model.price])
        {
            [arrayM removeObject:model];
        }else{
            return arrayM;
        }
    }
    return arrayM;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        APPriceSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_APPriceSelectCell forIndexPath:indexPath];
        cell.priceBtn.selected  = !self.priceNegotiable;
        cell.negotiableBtn.selected = self.priceNegotiable;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (indexPath.section == 1)
    {
        APPriceUnitCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_APPriceUnitCell forIndexPath:indexPath];
        cell.unitTextFild.delegate = self;
        cell.unitTextFild.tag = 1001;
        cell.unitTextFild.text = self.priceUnit;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
    else if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4)
    {
        APPriceMinQuantityCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_APPriceMinQuantityCell forIndexPath:indexPath];
        cell.numstextFild.delegate = self;
        cell.priceTextfild.delegate = self;
        cell.numstextFild.tag = 201;
        cell.priceTextfild.tag = 202;
        if (indexPath.section == 2) {
            cell.minQuaLabel.text = @"起订量";
        }else{
            cell.minQuaLabel.text = @"购买";
        }
        AddProductSetPriceModel *model = self.minimumQuantityArrayM[indexPath.section-2];
        cell.numstextFild.text = model.minimumQuantity?model.minimumQuantity:@"";
        cell.priceTextfild.text = model.price?model.price:@"";
        NSString *unitStr = [self isHaveInput: self.priceUnit]?self.priceUnit:@"个";
        cell.unitLabel.text = [NSString stringWithFormat:@"元/%@",unitStr];
        cell.numsTextFildRed = model.minQuaTextFildRed;
        cell.priceTextfildRed = model.priceTextFildRed;
        cell.deleBtn.hidden = indexPath.section == 2?YES:NO;
        [cell.deleBtn addTarget:self action:@selector(delPriceIncreaseRangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        APPriceIncreaseRangeCell *cell = [tableView dequeueReusableCellWithIdentifier:cell_APPriceIncreaseRangeCell forIndexPath:indexPath];
        [cell.addpriceBtn addTarget:self action:@selector(addPriceIncreaseRangeBtn:) forControlEvents:UIControlEventTouchUpInside];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
        
    }
}
#pragma mark - UITextField delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField.tag == 1001 ) {
        BOOL should = [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:10 remainTextNum:^(NSInteger remainLength) {
        }];
        return should;
    }else{
        if (textField.tag == 201) {
            BOOL should = [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:9 remainTextNum:^(NSInteger remainLength) {
            }];
            return should;
        }
        else if (textField.tag == 202)
        {
            BOOL should = [UITextField zx_limitPayMoneyDot:textField shouldChangeCharactersInRange:range replacementString:string dotPreBits:9 dotAfterBits:2];//小数点前9位
            return should;
        }
    }
    return YES;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [textField jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:self.tableView];
    if (self.lastEndEditSection!=indexPath.section && self.lastEndEditSection != -1) {
        [self.view endEditing:YES];//结束上一个编辑
        self.lastEndEditSection = indexPath.section;
        return NO;
    }else{
        self.lastEndEditSection = indexPath.section;
        return YES;
    }
}
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor = [[WYUISTYLE colorWithHexString:@"868686"] CGColor];
    textField.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    
    self.isShouldShowAlert = YES;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSIndexPath *indexPath = [textField jl_getIndexPathWithViewInCellFromTableViewOrCollectionView:self.tableView];
    if (indexPath.section == 1) {
        textField.text = textField.text.length>5?[textField.text substringToIndex:5]:textField.text;
        self.priceUnit = textField.text;
//        [self.tableView reloadData];
    }
    if (indexPath.section == 2 || indexPath.section == 3 || indexPath.section == 4) {
        AddProductSetPriceModel *model = self.minimumQuantityArrayM[indexPath.section-2];
        if (textField.tag == 201 ) {
            if ([NSString zhIsIntScan:textField.text])
            {//纯数字
                textField.text = [NSString stringWithFormat:@"%ld",ABS(textField.text.integerValue)]; //去0,负数
            }else{
                textField.text = @"";
            }
            model.minimumQuantity = textField.text;
        }
        if (textField.tag == 202 ) {
            if ([self isHaveInput:textField.text])
            {//非空
                textField.text = [NSString stringWithFormat:@"%.2lf",textField.text.doubleValue]; //保留两位
            }else{
                textField.text = @"";
            }
            model.price = textField.text;
        }
        if (!self.signWillRemove) {
            [self checkPriceRange];
//            [self.tableView reloadData];
        }
    }

}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma mark - 判断非空、非@“”、非@“ ”
- (BOOL)isHaveInput:(NSString *)str
{
    NSString* rule= @"^ *$";
    NSPredicate *numberPre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",rule];
    BOOL empty = [numberPre evaluateWithObject:str];
    return str&&!empty;
}
//对于未输入空阶梯，检查是否是允许为空
-(BOOL)isAllowEmpty:(AddProductSetPriceModel *)model
{
    if (![self isHaveInput:model.minimumQuantity] && ![self isHaveInput: model.price]) {
        if ([model isEqual:_minimumQuantityArrayM.firstObject]) {
            return NO;
        }
        if ([model isEqual:_minimumQuantityArrayM.lastObject]) {
            return YES;
        }else{
            NSInteger index = [self.minimumQuantityArrayM indexOfObject:model];
            for (int i = (int)index+1; i<self.minimumQuantityArrayM.count; ++i) {
                AddProductSetPriceModel *model = _minimumQuantityArrayM[i];
                if (![self isHaveInput:model.minimumQuantity] && ![self isHaveInput: model.price])
                {
                }else{
                    return NO;
                }
            }
            return YES;
        }
    }
    return NO;
}
-(BOOL)isShouldPreview
{
    for (int i =0; i<_minimumQuantityArrayM.count; ++i) {
        AddProductSetPriceModel *model = _minimumQuantityArrayM[i];
        if (![self isHaveInput:model.minimumQuantity] && ![self isHaveInput: model.price]) {
            BOOL show = [self isAllowEmpty:model];
            return show;
        }
        if (model.markedWords) {
            return NO;
        }
    }
    return YES;
}
#pragma mark - 校验阶梯价格区间
-(void)checkPriceRange
{
    for (int i =0; i<self.minimumQuantityArrayM.count; ++i) {
        AddProductSetPriceModel *model = self.minimumQuantityArrayM[i];
        [self checkModelSuccess_markedWords:model];
    }
}
#pragma mark 阶梯校验
-(BOOL)checkModelSuccess_markedWords:(AddProductSetPriceModel *)model
{
    if ([self isHaveInput:model.minimumQuantity] && ![self isHaveInput:model.price])
    {//只填写起订量、未填写价格
        if (model.minimumQuantity.integerValue==0)
        {
            model.markedWords = @"起订量不能为0";
            model.minQuaTextFildRed = YES;
            model.priceTextFildRed = NO;
        }
        else if ([self errorCompareMinimumQuantity:model])//和上阶梯比较数量（若都存在）
        {
            model.markedWords = @"下方阶梯购买数量必须大于上方";
            model.minQuaTextFildRed = YES;
            model.priceTextFildRed = NO;
        }
        else
        {
            model.markedWords = @"请填写该区间价格";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
    }
    else if (![self isHaveInput:model.minimumQuantity] && [self isHaveInput:model.price])
    {//只填写价格、未填写起订量
        if (model.price.doubleValue<=0.0)
        {
            model.markedWords = @"价格必须大于0";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else if (model.price.doubleValue>=1000000000.0)
        {
            model.markedWords = @"价格必须小于10亿";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else if ([self errorComparePrice:model])//和上阶梯比较价格（若都存在）
        {
            model.markedWords = @"下方阶梯购买价格必须小于上方";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else{
            model.markedWords = @"请填写该区间购买量";
            model.minQuaTextFildRed = YES;
            model.priceTextFildRed = NO;
        }
    }
    else if ([self isHaveInput:model.minimumQuantity] && [self isHaveInput:model.price])
    {//已填写起订量、价格
        if (model.minimumQuantity.integerValue==0)
        {
            model.markedWords = @"起订量不能为0";
            model.minQuaTextFildRed = YES;
            model.priceTextFildRed = NO;
        }
        else if ([self errorCompareMinimumQuantity:model])//和上阶梯比较数量（若都存在）
        {
            model.markedWords = @"下方阶梯购买数量必须大于上方";
            model.minQuaTextFildRed = YES;
            model.priceTextFildRed = NO;
        }
        else if (model.price.doubleValue<=0.0)
        {
            model.markedWords = @"价格必须大于0";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else if (model.price.doubleValue>=1000000000.0)
        {
            model.markedWords = @"价格必须小于10亿";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else if ([self errorComparePrice:model])//和上阶梯比较价格（若都存在）
        {
            model.markedWords = @"下方阶梯购买价格必须小于上方";
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = YES;
        }
        else{
            model.markedWords = nil;
            model.minQuaTextFildRed = NO;
            model.priceTextFildRed = NO;
            return YES;//
        }
    }
    else
    {//起订量、价格均为空
        if ([self.minimumQuantityArrayM.firstObject isEqual:model]) {
            model.markedWords = @"请至少设置一组价格区间，信息才能正常保存";
        }else{
            if ([self isAllowEmpty:model]) {
                model.markedWords = nil;
                model.minQuaTextFildRed = NO;
                model.priceTextFildRed = NO;
            }else{
                model.markedWords = @"请填写该区间购买量、价格";
                model.minQuaTextFildRed = YES;
                model.priceTextFildRed = YES;
            }
        }
    }
    return NO;
}
#pragma mark 检查某个阶梯是否存在上一级阶梯，若存在且阶梯数量不是递增返回YES
-(BOOL)errorCompareMinimumQuantity:(AddProductSetPriceModel *)model
{
    NSInteger index = [self.minimumQuantityArrayM indexOfObject:model];
    if (index>0) {
        AddProductSetPriceModel *model_last = self.minimumQuantityArrayM[index-1];
        if ([self isHaveInput:model_last.minimumQuantity]) {
            if (model_last.minimumQuantity.integerValue>=model.minimumQuantity.integerValue)
            {//和上一个阶梯数量（如果存在）相比、数量不是递增
                return YES;
            }
        }
    }
    return NO;
}
-(BOOL)errorComparePrice:(AddProductSetPriceModel *)model
{
    NSInteger index = [self.minimumQuantityArrayM indexOfObject:model];
    if (index>0) {
        AddProductSetPriceModel *model_last = self.minimumQuantityArrayM[index-1];
        if ([self isHaveInput:model_last.price]) {
            if (model_last.price.doubleValue<=model.price.doubleValue)
            {//和上一个阶梯价格（如果存在）相比、价格不是递减
                return YES;
            }
        }
    }
    return NO;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[IQKeyboardManager sharedManager] setEnable:NO] ;
    [self registerForKeyboardNotifications];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[IQKeyboardManager sharedManager] setEnable:YES] ;
    [self removeObserverForKeyboardNotifications];
    
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
}
- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-rect.size.height-40);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
    }];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view setNeedsLayout];
}
//刷新tableview会导致键盘收起，刷新不放在textFild结束编辑代理（因为这样不利于控制切换到另一个输入框）
- (void)keyboardDidHide:(NSNotification *)noti
{
    self.lastEndEditSection = -1;
    [self.tableView reloadData];
}
@end
