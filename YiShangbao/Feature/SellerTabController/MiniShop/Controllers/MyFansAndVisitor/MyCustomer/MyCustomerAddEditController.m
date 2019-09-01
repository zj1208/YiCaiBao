//
//  MyCustomerAddEditController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MyCustomerAddEditController.h"

#import "LookMyCustomerController.h"
#import "IQKeyboardManager.h"

@interface MyCustomerAddEditController ()<UITextFieldDelegate,UITextViewDelegate,ZXEmptyViewControllerDelegate>
@property(nonatomic,strong)CustomerInfoModel *customerInfoModel;
@property(nonatomic,strong)CustomerInfoModel *compareModel;

@property (nonatomic, strong) ZXEmptyViewController *emptyViewController;

@property (nonatomic, assign) CGFloat minYBottonBtn;
@property (nonatomic, strong) UIButton *addCustomerBtn;
@end

@implementation MyCustomerAddEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.isEditCustomer? NSLocalizedString(@"编辑客户信息",nil):NSLocalizedString(@"客户信息",nil);
    
    [self buildUI];
  
    [self requestCustomerOnlineInfo];

}
-(void)buildUI
{
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 20.5;
    
    self.mobieTextFild.keyboardType = UIKeyboardTypePhonePad ;
    self.mobieTextFild.textColor = [WYUISTYLE colorWithHexString:@"#333333"] ;
    self.nameTextFild.textColor = [WYUISTYLE colorWithHexString:@"#333333"] ;

    self.addressTextView.placeholder = NSLocalizedString(@"请输入地址",nil);
    [self.addressTextView setTypingAttributesWithLineHeight:20.f lineSpacing:0 textFont:[UIFont systemFontOfSize:14] textColor:[WYUISTYLE colorWithHexString:@"#333333"]];
    self.addressTextView.maxLength = 50;
    self.addressTextView.sizeToFitHight = YES;
    
    self.descTextView.placeholder = NSLocalizedString(@"请输入更多备注",nil);
    [self.descTextView setTypingAttributesWithLineHeight:20.f lineSpacing:0 textFont:[UIFont systemFontOfSize:14] textColor:[WYUISTYLE colorWithHexString:@"#333333"]];
    self.descTextView.maxLength = 100;
    self.descTextView.sizeToFitHight = YES;

    [self.addressTextView addTextHeightDidChangeHandler:^(JLTextView *view, CGFloat textHeight) {
        self.addressHeightLayout.constant = textHeight;
    }];
    
    [self.descTextView addTextHeightDidChangeHandler:^(JLTextView *view, CGFloat textHeight) {
        self.descHeightLayout.constant = textHeight;
    }];
    self.nameTextFild.delegate = self;
    self.mobieTextFild.delegate = self;
    self.addressTextView.delegate = self;
    self.descTextView.delegate = self;

    
    if (self.isEditCustomer){
        self.headHeightLayout.constant = 0.f;
        [self addRightBarButton];
        _minYBottonBtn = 0.f;
    }else{
        _minYBottonBtn = LCDH-CGRectGetMinY(self.addCustomerBtn.frame);

        UIEdgeInsets edge = self.scrollerView.contentInset;
        edge.bottom = _minYBottonBtn;
        self.scrollerView.contentInset = edge;
    }
    
    [self hiddenContentView:YES];
}
-(void)hiddenContentView:(BOOL)hidden
{
    self.scrollerView.hidden = hidden;
    _addCustomerBtn.hidden = hidden;
}
-(UIButton *)addCustomerBtn
{
    if (!_addCustomerBtn) {
        UIButton *bottonBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, LCDH-45-HEIGHT_TABBAR_SAFE-50, LCDW-30, 45)];
        [bottonBtn setBackgroundImage:[WYUISTYLE imageWithStartColorHexString:@"#FD7953" EndColorHexString:@"#FE5147"  WithSize:CGSizeMake(1, 1)] forState:UIControlStateNormal];
        bottonBtn.titleLabel.font = [UIFont systemFontOfSize:20];
        bottonBtn.layer.masksToBounds = YES;
        bottonBtn.layer.cornerRadius = 22.5;
        [bottonBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [bottonBtn setTitle:NSLocalizedString(@"添加为我的客户",nil) forState:UIControlStateNormal];
        [self.view addSubview:bottonBtn];
        [bottonBtn addTarget:self action:@selector(clickAddCustomerBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        _addCustomerBtn = bottonBtn;
    }return _addCustomerBtn;
}
-(void)addRightBarButton
{
    UIButton *saveBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, 22)];
    [saveBtn setImage:[UIImage imageNamed:@"btn_save"] forState:UIControlStateNormal];
    [saveBtn setAdjustsImageWhenHighlighted:NO];
    [saveBtn addTarget:self action:@selector(clickSaveUpdateCustomerBtn:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem* rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:saveBtn];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
}
-(ZXEmptyViewController *)emptyViewController
{
    if (!_emptyViewController) {
        ZXEmptyViewController *emptyVC =[[ZXEmptyViewController alloc] init];
        emptyVC.delegate = self;
        _emptyViewController = emptyVC;
    }return _emptyViewController;
    
}
#pragma mark - 提交新增客户
-(void)requestAddOnlineCustomer
{
    [[[AppAPIHelper shareInstance] getUserModelExtendAPI]postAddOnlineCustomerWithBuyerBizId:_buyerBizId source:_source remark:_customerInfoModel.remark mobile:_customerInfoModel.mobile address:_customerInfoModel.address describe:_customerInfoModel.describe success:^(id data) {
        
        //刷新采购商信息
        [[NSNotificationCenter defaultCenter] postNotificationName:Noti_update_BuyerInfoController object:nil];
        
        [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"添加成功，是否跳转到客户列表查看详情？" ,nil) message:nil cancelButtonTitle:NSLocalizedString(@"取消",nil) cancleHandler:^(UIAlertAction * _Nonnull action) {
            
            [self.navigationController popViewControllerAnimated:YES];
            
        } doButtonTitle:NSLocalizedString(@"查看客户列表",nil) doHandler:^(UIAlertAction * _Nonnull action) {
            [[WYUtility dataUtil] routerWithName:@"microants://myCustomer" withSoureController:self];
        }];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
#pragma mark - 编辑客户
-(void)requestUpdateCustomerOnlineInfo
{
    [[[AppAPIHelper shareInstance] getUserModelExtendAPI] postUpdateCustomerOnlineInfoWithBuyerBizId:_buyerBizId remark:_customerInfoModel.remark mobile:_customerInfoModel.mobile address:_customerInfoModel.address describe:_customerInfoModel.describe success:^(id data) {
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
        
    }];
}
#pragma mark - 新增、编辑接口初始化
-(void)requestCustomerOnlineInfo
{
    GetCustomerOnlineInfoType type = _isEditCustomer?customerOnlineInfo_Update:customerOnlineInfo_Add;
    [[[AppAPIHelper shareInstance] getUserModelExtendAPI] getCustomerOnlineInfoWithBuyerBizId:_buyerBizId type:type success:^(id data) {
        [self hiddenContentView:NO];

        self.customerInfoModel = (CustomerInfoModel *)data;
        self.compareModel = [(CustomerInfoModel *)data copy];
        
        [self.emptyViewController hideEmptyViewInController:self hasLocalData:self.customerInfoModel?YES:NO];
        
        if (!self.isEditCustomer) {
            self.customerInfoModel.remark = @"";
            self.customerInfoModel.mobile = @"";
            self.customerInfoModel.address = @"";
            self.customerInfoModel.describe = @"";
        }
        [self setUIData];
        
    } failure:^(NSError *error) {
        NSString *code = [error.userInfo objectForKey:@"code"];
        if ([code isEqualToString:@"guest_not_customer"] || [code isEqualToString:@"wechatuser_not_customer"])
        {
            [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:nil emptyImage:ZXEmptyRequestFaileImage emptyTitle:[error localizedDescription] updateBtnHide:YES];
        }
        else{
            [self.emptyViewController addEmptyViewInController:self hasLocalData:NO error:error emptyImage:ZXEmptyRequestFaileImage emptyTitle:ZXEmptyRequestFaileTitle updateBtnHide:NO];
        }
    }];
}
-(void)setUIData
{
    if (!self.isEditCustomer) {
        NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:self.customerInfoModel.icon];
        [self.iconImageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
        self.nameLabel.text = _customerInfoModel.nickName?_customerInfoModel.nickName:@"";
        self.companyLabel.text = _customerInfoModel.companyName?_customerInfoModel.companyName:@"";
    }
    
    self.nameTextFild.text = self.customerInfoModel.remark;
    self.mobieTextFild.text = self.customerInfoModel.mobile;
    self.addressTextView.text = self.customerInfoModel.address;
    self.descTextView.text = self.customerInfoModel.describe;
}
-(void)zxEmptyViewUpdateAction
{
    [self requestCustomerOnlineInfo];
    
}
#pragma mark 系统按钮返回事件
- (BOOL)navigationShouldPopOnBackButton
{
    if (self.isEditCustomer) {
        
        [self.view endEditing:YES];
        BOOL remark = [self.customerInfoModel.remark isEqualToString:self.compareModel.remark ];
        BOOL mobile = [self.customerInfoModel.mobile isEqualToString:self.compareModel.mobile ];
        BOOL address = [self.customerInfoModel.address isEqualToString:self.compareModel.address ];
        BOOL describe = [self.customerInfoModel.describe isEqualToString:self.compareModel.describe ];
        if (remark && mobile && address && describe) {
            
        }else{
            [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:NSLocalizedString(@"是否保存本次更改",nil) cancelButtonTitle:NSLocalizedString(@"取消",nil) cancleHandler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
            } doButtonTitle:NSLocalizedString(@"保存",nil) doHandler:^(UIAlertAction * _Nonnull action) {
                [self clickSaveUpdateCustomerBtn:nil];
            }];
            return NO;
        }
    }
    return YES;
}
#pragma mark - Delegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (textField == self.nameTextFild) {
        BOOL should = [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:15 remainTextNum:^(NSInteger remainLength) {
        }];
        return should;
    }
    if (textField == self.mobieTextFild) {
        BOOL should = [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:20 remainTextNum:^(NSInteger remainLength) {
        }];
        return should;
    }
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.nameTextFild) {
        _customerInfoModel.remark = textField.text;
    }
    if (textField == self.mobieTextFild) {
        _customerInfoModel.mobile = textField.text;
    }
}
-(void)textViewDidEndEditing:(UITextView *)textView
{
    if (textView == self.addressTextView) {
        _customerInfoModel.address = textView.text;
    }
    if (textView == self.descTextView) {
        _customerInfoModel.describe = textView.text;
    }
}
#pragma mark - 编辑保存
-(void)clickSaveUpdateCustomerBtn:(UIButton*)sender
{
    [self.view endEditing:YES];
    if (self.customerInfoModel) {
        [self requestUpdateCustomerOnlineInfo];
    }
}
#pragma mark - 新增
-(void)clickAddCustomerBtn:(UIButton*)sender
{
    [MobClick event: kUM_b_customerinfo_creat];
    [self.view endEditing:YES];
    if (self.customerInfoModel) {
        [self requestAddOnlineCustomer];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    if (!self.isEditCustomer) {
        NSMutableArray *arrayM = [NSMutableArray arrayWithArray:self.navigationController.childViewControllers];
        [arrayM removeObject:self];
        [self.navigationController setViewControllers:arrayM animated:NO];
    }
    
}
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
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)removeObserverForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}
- (void)keyboardWillShow:(NSNotification *)noti
{
    CGRect rect = [noti.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSTimeInterval duration = [[noti.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    
    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom).offset(-rect.size.height+_minYBottonBtn);
    }];
    [UIView animateWithDuration:duration animations:^{
        [self.view setNeedsLayout];
    } completion:^(BOOL finished) {
    }];
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    [self.scrollerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view.mas_bottom);
    }];
    [self.view setNeedsLayout];
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
