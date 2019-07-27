//
//  WYMakeBillPreviewSetController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYMakeBillPreviewSetController.h"
#import "ContactViewController.h"
#import "WYPerfectShopInfoViewController.h"
#import "MakeBillModel.h"

#import "IQKeyboardManager.h"
@interface WYMakeBillPreviewSetController ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLayoutConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textView_bottomLayoutconstraint;

@end

@implementation WYMakeBillPreviewSetController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"设置";

    [self buildUI];
    [self requestDisplayClause];
    
    [self addNotificationCenters];
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
    
    if ([self.textView isFirstResponder]) {
        self.topLayoutConstraint.constant = -(37+108+45)-5;
        self.textView_bottomLayoutconstraint.constant = rect.size.height+5;
        [UIView animateWithDuration:duration animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    
}
- (void)keyboardWillHide:(NSNotification *)noti
{
    self.topLayoutConstraint.constant = 0;
    self.textView_bottomLayoutconstraint.constant = 95;
    [self.view setNeedsLayout];
}
-(void)addNotificationCenters
{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showAlert) name:Noti_showAlert_WYMakeBillPreviewSetController object:nil];
}
-(void)showAlert
{
    [self showAlertTitle:@"联系信息修改成功，请重新预览"];
}
-(void)showAlertTitle:(NSString *)title
{
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:title message:nil cancelButtonTitle:@"取消" cancleHandler:nil doButtonTitle:@"重新预览" doHandler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}
-(void)requestDisplayClause
{
    [[[AppAPIHelper shareInstance] getMakeBillAPI] getBillDisplayClauseSuccess:^(id data) {
       
        MBDisplayClauseModel *model = data;
        self.termsSwitch.on = model.display;
        
        NSString *contentStr = [NSString zhIsBlankString:model.content]?@"":model.content;
        self.textView.text = contentStr;
        NSString *bankStr = [NSString zhIsBlankString:model.bankCard]?@"":model.bankCard;
        self.bankTextFild.text = bankStr;

        [self setTextViewAttributedText];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
    }];
}
-(void)buildUI
{
    self.shopDescLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.5f)];
    self.shopGoDescLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.5f)];
    self.termsSaveBtn.backgroundColor = [UIColor clearColor];
    self.termsSaveBtn.layer.masksToBounds = YES;
    self.termsSaveBtn.layer.cornerRadius = 22.5;
    [self.termsSaveBtn setBackgroundImage:[WYUIStyle imageFD7953_FE5147:CGSizeMake(1, 1)] forState:UIControlStateNormal];
    
    self.textView.text = @"";
    self.textView.placeholder = @"请输入条款";
    self.textView.layer.masksToBounds = YES;
    self.textView.layer.borderWidth = 0.5;
    self.textView.layer.borderColor = [WYUISTYLE colorWithHexString:@"e0e0e0"].CGColor;
    self.textView.layer.cornerRadius = 4.f;
    
    self.bankTextFild.delegate = self;
}
-(void)setTextViewAttributedText
{
    if (self.termsSwitch.on) {
         self.textView.textColor = [WYUISTYLE colorWithHexString:@"2F2F2F"];
    }else{
        self.textView.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark - 商铺设置
- (IBAction)goShopBtn:(id)sender {
    [MobClick event:kUM_kdb_openbill_preview_fix];
   
    if ([UserInfoUDManager isOpenShop]) {  //登陆开店了
        ContactViewController *vc = [[ContactViewController alloc] init];
        [self.navigationController pushViewController:vc animated:YES];
    }else{ //登陆未开店
        WYPerfectShopInfoViewController *fastOpenShop = [[WYPerfectShopInfoViewController alloc] init];
        fastOpenShop.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:fastOpenShop animated:YES];
    }
}
#pragma mark - 保存条款设置
- (IBAction)termsSaveBtn:(id)sender {
    [self saveClause];
}
#pragma mark - 显示条款开关
- (IBAction)termSwitch:(UISwitch *)sender {
    [self setTextViewAttributedText];
}
-(void)saveClause
{
    [self.bankTextFild resignFirstResponder];
    [self.textView resignFirstResponder];
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    NSString *display = self.termsSwitch.on?@"on":@"off";
    NSString *content = self.textView.text;
    NSString *bankCard = self.bankTextFild.text;
    
    [[[AppAPIHelper shareInstance] getMakeBillAPI] postBillSaveClauseDisplay:display content:content bankCard:bankCard success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:self.view];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_updatePDF_WYMakeBillPreviewViewController object:nil];
        [self showAlertTitle:@"设置已成功保存，请重新预览"];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:self.view];
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
