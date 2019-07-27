//
//  WYImmediateWithdrawalViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYImmediateWithdrawalViewController.h"
#import "WYSelectBankCardViewController.h"
#import "WYVerificationCodeViewController.h"
#import "WYImmediateSubmitSussessViewController.h"

#import "AccountModel.h"

#import "ShopModel.h"
@interface WYImmediateWithdrawalViewController ()<UITextFieldDelegate,WYVerificationCodeViewControllerDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)AccountModel *accountModel;//提现信息接口model
@property(nonatomic,strong)AcctInfoModel *accountModelSelected; //选择的银行卡model

@property(nonatomic,strong)NSDictionary *bankDictInfo; //提现需要的银行卡信息
@property(nonatomic,strong)NSDecimalNumber *extractMoney; //提现金额，单位为分

@property(nonatomic,strong)WYVerificationCodeViewController* wyverificationcodeViewController; //验证码弹框

@property (nonatomic, strong)ZXEmptyViewController *emptyViewController;
@end

@implementation WYImmediateWithdrawalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [WYUISTYLE colorBGgrey];
    self.title = NSLocalizedString(@"立即提现", nil);

    [self buildUI];
    [self addNotificationCenters];
    
    [self requestAccountInfoData];

}
-(void)addNotificationCenters
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReloadBankInfo:) name:Noti_update_WYImmediateWithdrawalViewController object:nil];
}
-(void)ReloadBankInfo:(NSNotification*)data
{
    _accountModelSelected = (AcctInfoModel*)data.object;

    [self NotiUpdataUIWithAcctInfoModel:_accountModelSelected];
}

-(void)buildUI
{
    self.bankNameLabel.text = @"";
    self.userNameLabel.text = @"";
    self.BankCardNumberLabel.text = @"";
    
    self.containerView.hidden = YES;  //先全部隐藏
    self.chaoguotixianLabel.hidden = YES;
    self.shouxufeiLabel.hidden = YES;

    self.inputPromptLab.text = nil;
    
    self.tijiaoBtn.layer.masksToBounds = YES;
    self.tijiaoBtn.layer.cornerRadius = 22.5;
    self.tijiaoBtn.backgroundColor = [UIColor whiteColor];
    UIImage* image = [WYUISTYLE imageWithStartColorHexString:@"#FD7953" EndColorHexString:@"#FE5147" WithSize:self.tijiaoBtn.frame.size];
    [self.tijiaoBtn setBackgroundImage:image forState:UIControlStateNormal];
    
    self.textfild.delegate = self;
    
    
    ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
    emptyVC.delegate = self;
    self.emptyViewController = emptyVC;
}
#pragma mark - 氛围图
-(void)zxEmptyViewUpdateAction
{
    [self requestAccountInfoData];
}

#pragma mark - 选择银行卡通知刷新
-(void)NotiUpdataUIWithAcctInfoModel:(AcctInfoModel*)model
{
    self.containerView.hidden = NO;
    
    [self.secondContentView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(103.f);
    }];
    
    NSURL* url = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.bankIcon];
    [self.imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_myincome_yinhangka"]];
    
    self.bankNameLabel.text =  model.bankValue;
    self.userNameLabel.text = model.acctName;
    self.BankCardNumberLabel.text = model.bankNo;
    self.bankDictInfo = @{
                          @"userCardId":[NSString stringWithFormat:@"%@",model.shopId],
                          @"bankId":[NSString stringWithFormat:@"%@",model.bankId],
                          @"bankCardNo":model.bankNo,
                          @"bankAcctName":model.acctName,
                          };
}
#pragma mark - 账户信息请求成功刷新
-(void)updataUI
{
    self.containerView.hidden = NO;
    self.shouxufeiLabel.hidden = NO;
    
    self.shouxufeiLabel.text = [NSString stringWithFormat:@"手续费：¥0"];
    self.tijiaoDescLabel.text = [NSString stringWithFormat:@"%@",_accountModel.desc];

    NSDecimalNumber *maxMoney = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",_accountModel.canWithdrawAmount]];
    NSDecimalNumber*discount_100 = [NSDecimalNumber decimalNumberWithString:@"100"];
    NSDecimalNumber *finallyMax_money = [maxMoney decimalNumberByDividingBy:discount_100];
    self.promptWithdrawalAmountLab.text = [NSString stringWithFormat:@"可提现金额¥%@",finallyMax_money];
   
    NSURL* url = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:_accountModel.bankIcon];
    [self.imageview sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"ic_myincome_yinhangka"]];
    
    
    
    if (![NSString zhIsBlankString:_accountModel.bankId]) {
        
        [self.secondContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(103.f);
        }];

        self.bankNameLabel.text =  _accountModel.bankName;
        self.userNameLabel.text = _accountModel.bankAcctName;
        self.BankCardNumberLabel.text = _accountModel.bankCardNo;
        
        self.bankDictInfo = @{
                              @"userCardId":_accountModel.userCardId,
                              @"bankId":_accountModel.bankId,
                              @"bankCardNo":_accountModel.bankCardNo,
                              @"bankAcctName":_accountModel.bankAcctName,
                              };

    }else{

        [self.secondContentView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(55.f);
        }];
        
//        self.imageview.image =  [UIImage imageNamed:@"ic_myincome_yinhangka"];

        self.bankNameLabel.text = @"";
        self.userNameLabel.text = @"";
        self.BankCardNumberLabel.text = @"";   
    }

}


#pragma mark - 110002_获取提现信息-接口
-(void)requestAccountInfoData
{
    [[[AppAPIHelper shareInstance] getAccountAPI] getAccountWithdrawalsInfoSuccess:^(id data) {
        _accountModel = data;
//        self.accountModel.canWithdrawAmount = 15000;//150元
//        self.accountModel.feeRate = @"0.06";
        [self updataUI];
        [_emptyViewController hideEmptyViewInController:self hasLocalData:YES];
        
    } failure:^(NSError *error) {
        [_emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        
    }];
}
#pragma mark - 110003_确认提现申请-接口
-(void)requestAccountConfirmData
{
    self.containerView.userInteractionEnabled = NO; //提交时不允许操作
     [[[AppAPIHelper shareInstance] getAccountAPI] PostAccountConfirmWithBankInfoDict:_bankDictInfo amount:_extractMoney success:^(id data) {
         self.containerView.userInteractionEnabled = YES;

         AccountConfirmPhoneModel*  model = data;
         [self showWYVerificationCodeViewController_AccountConfirmPhoneModel:model];
         
     } failure:^(NSError *error) {
         self.containerView.userInteractionEnabled = YES;
         [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
     }];
    
}
#pragma mark - 验证码弹窗控制器-点击完成Delegate
-(void)jl_WYVerificationCodeViewControllerDidSureBtn:(WYVerificationCodeViewController *)wyverificationCodeViewController verificationCode:(NSString*)verificationCode
{
    [self requestAccountSubmitWithVerificationCode:verificationCode];
}
#pragma mark - 110004_提交提现申请-接口
-(void)requestAccountSubmitWithVerificationCode:(NSString*)verificationCode
{
    [[[AppAPIHelper shareInstance] getAccountAPI] PostAccountSubmitWithBankInfoDict:_bankDictInfo amount:_extractMoney verificationCode:verificationCode success:^(id data) {
        
        AccountSubmitModel* model = data;
        
        if (self.wyverificationcodeViewController.view.superview ) {
            [self.wyverificationcodeViewController.view removeFromSuperview];
            [self.wyverificationcodeViewController removeFromParentViewController];
        }
        [self pushWYImmediateSubmitSussessViewController_AccountSubmitModel:model];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:nil];
    }];
}
#pragma mark - -----------Button Actions---------------
#pragma mark 提现规则说明
- (IBAction)lijitixianRuleBtnClick:(UIButton *)sender {
    
    if (_accountModel.ruleDescUrl) {
        [[WYUtility dataUtil] routerWithName:_accountModel.ruleDescUrl withSoureController:self];
    }
}
#pragma mark 确认提现
//确认提现
- (IBAction)TiJiaoBtnClcik:(UIButton *)sender {
    [self.textfild resignFirstResponder];
    
    if (!_bankDictInfo) {
        [MBProgressHUD zx_showError:@"请选择银行卡" toView:self.view];
        return;
    }
    NSLog(@"%@",_extractMoney);
    if (!_extractMoney) {
        [MBProgressHUD zx_showError:@"请输入提现金额" toView:self.view];
        return;
    }
    
    NSDecimalNumber * MoneyZero = [NSDecimalNumber decimalNumberWithString:@"0"];//0分
    NSComparisonResult result = [_extractMoney compare:MoneyZero];
    if (result == NSOrderedSame){  //_extractMoney=nil也是相等NSOrderedSame
        [MBProgressHUD zx_showError:@"请输入合适的提现金额" toView:self.view];
        return;
    }
    
    [self requestAccountConfirmData];

    
}
#pragma mark 选择银行卡
//选择银行卡
- (IBAction)selBankClcik:(UIButton *)sender {
    WYSelectBankCardViewController * VC = [[WYSelectBankCardViewController alloc] init];
    if (self.accountModelSelected) {
        VC.AcctInfoModelDefaultSelected = self.accountModelSelected;
    }
    VC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark - 添加-验证码-弹框控制器
-(void)showWYVerificationCodeViewController_AccountConfirmPhoneModel:(AccountConfirmPhoneModel*)phoneModel;
{
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"SellerOrder" bundle:[NSBundle mainBundle]];
    self.wyverificationcodeViewController = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_WYVerificationCodeViewController];
    self.wyverificationcodeViewController.delegate = self;
    self.wyverificationcodeViewController.phone = phoneModel.phone;
    self.wyverificationcodeViewController.countryCode = phoneModel.countryCode;
    self.wyverificationcodeViewController.type = 6;
    
    [self.tabBarController addChildViewController:_wyverificationcodeViewController];
    [self.tabBarController.view addSubview:_wyverificationcodeViewController.view];
}
#pragma mark- 跳转提现-提交成功-控制器
-(void)pushWYImmediateSubmitSussessViewController_AccountSubmitModel:(AccountSubmitModel*)accountSubmitModel
{
    UIStoryboard* extendSottrbord = [UIStoryboard storyboardWithName:@"SellerOrder" bundle:[NSBundle mainBundle]];
    WYImmediateSubmitSussessViewController * VC = [extendSottrbord instantiateViewControllerWithIdentifier:SBID_WYImmediateSubmitSussessViewController];
    VC.accountsubmitModel = accountSubmitModel;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 字符串校验，输入控制
//是否纯数字判断
- (BOOL)isPureInt:(NSString*)string{
    
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    BOOL bo= [scan scanInt:&val] && [scan isAtEnd];
    return bo;
}
//浮点形(包括整型)判断
- (BOOL)isPureFloat:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textfild resignFirstResponder];
    return YES;
}
#pragma mark- 小数点前面8位，小数点后面最多2位，一共不能超过10位（包含小数点）
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([string isEqualToString:@""]) { //删除
        NSString* textStr = textField.text;
        NSRange range_dian = [textField.text rangeOfString:@"."];
        if (range_dian.location != NSNotFound) {
            if (range_dian.location == range.location &&textStr.length >9 ) {
                return NO; //如果是是删除“.”,删除后不允许超过8位
            }
        }
        return YES;
    }
    if (([self isPureInt:string]&&string.length ==1) || [string isEqualToString:@"."]) { //只允许单个数字字符／“.”输入
        NSString* textStr = textField.text;
        NSRange range_dian = [textField.text rangeOfString:@"."];
        
        if (range_dian.location == NSNotFound) { //没有“.”
            if ( [string isEqualToString:@"."] ) { //此时输入"."
                if (textStr.length<8) { //已输入小于8位
                    
                    if (textStr.length <=2) { //长度小于2位，“.”任意插入
                        return YES;
                    }else{
                        if (range.location>=textStr.length-2) {//输入“.”的位置后面只能有两位
                            return YES;
                        }else{
                            return NO;
                        }
                    }
                }else{
                    return NO; //输入12345678+“.”
                }
                
            }else{
                if (textStr.length<8) {
                    return YES;
                }else{
                    return NO; //输入12345678+“9”
                }
            }
            
        }else{
            if ([string isEqualToString:@"."]) {
                return NO;
            }else{
            
                NSArray* array = [textStr componentsSeparatedByString:@"."]; //切出来一定是两个字符串，可能为@“”
                if (range.location >range_dian.location) { //插入在小数点后面
                    NSString* lastStr = array.lastObject;
                    if (lastStr.length<2) { //小数点后小于2位
                        return YES;
                    }else{
                        return NO;
                    }
                }else{ //插入在小数点前面
                    NSString* firststr = array.firstObject;
                    if (firststr.length<7) { //小数点前小于7位
                        return YES;
                    }else{
                        return NO;
                    }
                }
                
            }
            
        }
    }else{
        return NO;
    }
    
        
}
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSString* str = [NSString stringWithFormat:@"%@",textField.text];

    if ([str isEqualToString:@""]) {
        _extractMoney = nil;
        self.shouxufeiLabel.text = [NSString stringWithFormat:@"手续费：¥0"];
        self.chaoguotixianLabel.hidden = YES;
        self.tijiaoBtn.enabled = YES;
        self.inputPromptLab.text  =nil;
        return;
    }
    if ([self checkPriceString:str]) {
        
        NSLog(@"%f>>%.2f",str.doubleValue,str.doubleValue);
        
        NSDecimalNumber *discountAmount = [NSDecimalNumber decimalNumberWithString:str];
        NSDecimalNumber*discount = [NSDecimalNumber decimalNumberWithString:@"100"];
        NSDecimalNumber *afterDiscount = [discountAmount decimalNumberByMultiplyingBy:discount];
        _extractMoney = afterDiscount;
        //计算手续费
        [self SetshouxufeiLabelTextAndCalculationCommission];
//        NSDecimalNumber *Max_money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",_accountModel.canWithdrawAmount]];
//
//        NSComparisonResult result = [afterDiscount compare:Max_money];
//        if (result ==NSOrderedDescending) { //大于
//            self.chaoguotixianLabel.hidden = NO;
//            self.tijiaoBtn.enabled = NO;
//        } else {
//            self.chaoguotixianLabel.hidden = YES;
//            self.tijiaoBtn.enabled = YES;
//        }
        
//        [MBProgressHUD zx_showError:[NSString stringWithFormat:@"%@",_extractMoney] toView:self.view];
    }else{  //异常字符处理
        self.chaoguotixianLabel.hidden = YES;
        self.tijiaoBtn.enabled = YES;
        if (![NSString zhIsBlankString:str]) {
            textField.text = @"";
        }
       
    }
}
//从整个字符串考虑进行二次检测金额输入，主要处理可能的未知的第三方键盘乱输入情况
-(BOOL)checkPriceString:(NSString*)priceString
{
    NSRange range_dian = [priceString rangeOfString:@"."];

    if (![self isPureFloat:priceString]) {
        return NO;
    }else{
        if (range_dian.location != NSNotFound) {
            NSArray* array = [priceString componentsSeparatedByString:@"."]; //切出来一定是两个字符串，可能为@“”
            NSString* intStr = array.firstObject;
            NSString* floatStr = array.lastObject;

            if (intStr.length<=7 && floatStr.length<=2) {
                return YES;
            }else{
                return NO;
            }
        }else{
            if (priceString.length<=8 ) {
                return YES;
            }else{
                return NO;
            }
        }
        return YES;
    }
    
}
#pragma mark - 计算并显示-手续费
-(void)SetshouxufeiLabelTextAndCalculationCommission
{

    NSDecimalNumber*freeQuota_A = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",_accountModel.freeQuota]];

    NSDecimalNumber*decimal_100 = [NSDecimalNumber decimalNumberWithString:@"100"];
    //  NSRoundDown 只舍不入,小数点后保留2位的处理器对象
    NSDecimalNumberHandler *RoundDown  = [NSDecimalNumberHandler decimalNumberHandlerWithRoundingMode:NSRoundDown scale:2 raiseOnExactness:NO raiseOnOverflow:NO raiseOnUnderflow:NO raiseOnDivideByZero:YES];

    NSDecimalNumber *finallyFreeQuota = [freeQuota_A decimalNumberByDividingBy:decimal_100 withBehavior:RoundDown];
    
    //  费率
    NSDecimalNumber *feeRate = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%@",_accountModel.feeRate]];
    NSDecimalNumber *feeRate_100 = [feeRate decimalNumberByMultiplyingBy:decimal_100];
    
    //  账户最大可提现金额（分）
    NSDecimalNumber *Max_money = [NSDecimalNumber decimalNumberWithString:[NSString stringWithFormat:@"%ld",_accountModel.canWithdrawAmount]];

    // 提示语 后面一段话的不同展示，先当整体，再按要求插入前面一段话；
    NSMutableString *component = nil;
    NSComparisonResult result = [_extractMoney compare:freeQuota_A];
    //  上升；
    if (result ==NSOrderedAscending || result ==NSOrderedSame)
    {
        NSComparisonResult canWithdrawResult = [_extractMoney compare:Max_money];
        self.shouxufeiLabel.text = [NSString stringWithFormat:@"手续费：¥0"];

        // 下降
        if (canWithdrawResult ==NSOrderedDescending)
        {
            component  = [NSMutableString stringWithFormat:@"本次提现手续费0元（费率%@%%），提现金额及手续费超过可提现金额",feeRate_100];
            self.chaoguotixianLabel.hidden = NO;
            self.tijiaoBtn.enabled = NO;
        }
        else
        {
            component  = [NSMutableString stringWithFormat:@"本次提现手续费0元（费率%@%%）",feeRate_100];
            self.chaoguotixianLabel.hidden = YES;
            self.tijiaoBtn.enabled = YES;
        }
    }
    //  没有免费额度，或比免费额度高
    else
    {
        NSDecimalNumber *Subtracting = [_extractMoney decimalNumberBySubtracting:freeQuota_A];
        NSDecimalNumber *fee = [Subtracting decimalNumberByMultiplyingBy:feeRate];
        NSDecimalNumber *finallyFee = [fee decimalNumberByDividingBy:decimal_100 withBehavior:RoundDown];
        self.shouxufeiLabel.text = [NSString stringWithFormat:@"手续费：¥%@",finallyFee];
        NSDecimalNumber *finallyMoney = [self.extractMoney decimalNumberByAdding:fee];
        //  最终总费用（分）与最大可提现金额（分）比较
        NSComparisonResult canWithdrawResult = [finallyMoney compare:Max_money];
        // 下降
        if (canWithdrawResult ==NSOrderedDescending)
        {
            component = [NSMutableString stringWithFormat:@"本次提现手续费%@元（费率%@%%），提现金额及手续费超过可提现金额",finallyFee,feeRate_100];
            self.chaoguotixianLabel.hidden = NO;
            self.tijiaoBtn.enabled = NO;
        }
        else
        {
            component = [NSMutableString stringWithFormat:@"本次提现手续费%@元（费率%@%%）",finallyFee,feeRate_100];
            self.chaoguotixianLabel.hidden = YES;
            self.tijiaoBtn.enabled = YES;
        }
    }
    //  判断前面一段话@"您的免费提现额度为%@元，”提示语是否拼接展示
    NSString *component_freeQuota =nil;
    if (_accountModel.freeQuota !=0)
    {
        component_freeQuota =[NSString stringWithFormat:@"您的免费提现额度为%@元，",finallyFreeQuota];
        [component insertString:component_freeQuota atIndex:0];
    }
    self.inputPromptLab.text = component;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    if (self.wyverificationcodeViewController && self.wyverificationcodeViewController.view.superview ) {
        [self.wyverificationcodeViewController.view removeFromSuperview];
        [self.wyverificationcodeViewController removeFromParentViewController];
    }
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
