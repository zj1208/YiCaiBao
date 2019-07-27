//
//  WYPurchaserConfirmOrderEditAddressViewController.m
//  YiShangbao
//
//  Created by light on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderEditAddressViewController.h"
#import "WYPublicModel.h"
#import "WYSelectCityView.h"

@interface WYPurchaserConfirmOrderEditAddressViewController ()<UITextFieldDelegate,UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UITextField *addressTextField;

@property (weak, nonatomic) IBOutlet UITextView *detailAddressTextView;
@property (weak, nonatomic) IBOutlet UILabel *detailAddressPlaceholderLabel;

@property (nonatomic ,strong) WYDefaultDeliveryAddressModel *model;

@property (nonatomic ,strong) NSString *provCode;
@property (nonatomic ,strong) NSString *cityCode;
@property (nonatomic ,strong) NSString *townCode;

@end

@implementation WYPurchaserConfirmOrderEditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"编辑地址";
    [self creatRightbutton];
    self.detailAddressTextView.delegate = self;
    self.nameTextField.delegate = self;
    
//    self.automaticallyAdjustsScrollViewInsets = NO;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self reloadAddressRequest];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)navigationShouldPopOnBackButton{
    //判断页面值有没有改过，是否需要保存
    if ([self.nameTextField.text isEqualToString:self.model.deliveryName] && [self.phoneTextField.text isEqualToString:self.model.deliveryPhone] && [self.detailAddressTextView.text isEqualToString:self.model.address] && [self.provCode isEqualToString:self.model.provCode] && [self.cityCode isEqualToString:self.model.cityCode] && [self.townCode isEqualToString:self.model.townCode]){
        return YES;
    }
    
    if (!self.model && (self.nameTextField.text.length == 0) && (self.phoneTextField.text.length == 0) && (self.detailAddressTextView.text.length == 0) && (self.provCode.length == 0)) {
        return YES;
    }
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:nil message:@"您还未保存当前内容，现在离开页面并不会保存修改，是否现在离开页面" cancelButtonTitle:@"否" cancleHandler:^(UIAlertAction * _Nonnull action) {
        
    } doButtonTitle:@"是" doHandler:^(UIAlertAction * _Nonnull action) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
    return NO;
}

#pragma mark - UITextField Delegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length > 0 && textField.text.length >= 20) {
        return NO;
    }
    return YES;
}

#pragma mark - UITextView Delegate
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length > 0) {
        self.detailAddressPlaceholderLabel.hidden = YES;
    }else{
        self.detailAddressPlaceholderLabel.hidden = NO;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (text.length > 0 && textView.text.length >= 40) {
        return NO;
    }
    return YES;
}

#pragma mark -ButtonAction
- (IBAction)selectedAreaAction:(id)sender {
    [self.view endEditing:YES];
    WS(weakSelf);
    WYSelectCityView *city = [[WYSelectCityView alloc] initSelectFrame:[UIApplication sharedApplication].keyWindow.bounds WithTitle:@"所在地区"];
    [city showCityView:^(NSDictionary *provice, NSDictionary *city, NSDictionary *dis) {
        weakSelf.provCode = provice? [provice objectForKey:@"code"] : @"";
        weakSelf.cityCode = city? [city objectForKey:@"code"] : @"";
        weakSelf.townCode = dis? [dis objectForKey:@"code"] : @"";
        weakSelf.addressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",   provice? [provice objectForKey:@"name"] : @"",city? [city objectForKey:@"name"] : @"",dis? [dis objectForKey:@"name"] : @""];
        
    }];
    
}

#pragma mark -Request

- (void)reloadAddressRequest{
    WS(weakSelf);
    [[[AppAPIHelper shareInstance] publicAPI] getBuyerDefaultDeliveryAddressSuccess:^(id data) {
        weakSelf.model = data;
        [weakSelf reloadView];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

- (void)preserveAction{
    WS(weakSelf);
    
    NSString *mystring = self.nameTextField.text;
    NSString *regex = @"(^[a-zA-Z\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", regex];
    
    if (![predicate evaluateWithObject:mystring]) {
        [MBProgressHUD zx_showError:@"请输入正确的姓名" toView:weakSelf.view];
        return;
    }
    if (self.nameTextField.text.length <= 0) {
        [MBProgressHUD zx_showError:@"请填写收货人" toView:weakSelf.view];
        return;
    }
    if (self.phoneTextField.text.length <= 0) {
        [MBProgressHUD zx_showError:@"请填写联系电话" toView:weakSelf.view];
        return;
    }
    if (self.detailAddressTextView.text.length < 5) {
        [MBProgressHUD zx_showError:@"地址不能少于5个字" toView:weakSelf.view];
        return;
    }
    if (self.provCode.length <= 0) {
        [MBProgressHUD zx_showError:@"请选择所在地区" toView:weakSelf.view];
        return;
    }
    
    //是不是添加地址
    if (self.model.addressId) {
        [[[AppAPIHelper shareInstance] publicAPI] postBuyerUpdateAddressId:self.model.addressId deliveryName:self.nameTextField.text deliveryPhone:self.phoneTextField.text provCode:self.provCode cityCode:self.cityCode townCode:self.townCode addressName:self.detailAddressTextView.text success:^(id data) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }else{
        [[[AppAPIHelper shareInstance] publicAPI] postBuyerAddDeliveryName:self.nameTextField.text deliveryPhone:self.phoneTextField.text provCode:self.provCode cityCode:self.cityCode townCode:self.townCode addressName:self.detailAddressTextView.text success:^(id data) {
            [weakSelf.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
        }];
    }
}

#pragma mark -Private Function
- (void)creatRightbutton{
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 52, 22)];
    [btn setTitle:@"保存" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor colorWithHex:0xF58F23] forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:13]];
    btn.backgroundColor = [UIColor colorWithHex:0xF58F23 alpha:0.08];
    btn.layer.borderColor = [UIColor colorWithHex:0xF58F23].CGColor;
    btn.layer.borderWidth = 0.5;
    btn.layer.cornerRadius = SCREEN_STATUSHEIGHT > 20 ? 14.0 : 11.0;
    btn.layer.masksToBounds = YES;
    [btn addTarget:self action:@selector(preserveAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * preserveButton = [[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = preserveButton;
}

- (void)reloadView{
    if (!self.model) {
        return;
    }
    self.nameTextField.text = self.model.deliveryName;
    self.phoneTextField.text = self.model.deliveryPhone;
    self.addressTextField.text = [NSString stringWithFormat:@"%@ %@ %@",self.model.prov,self.model.city,self.model.town];
    self.detailAddressTextView.text = self.model.address;
    self.provCode = self.model.provCode;
    self.cityCode = self.model.cityCode;
    self.townCode = self.model.townCode;
    
    if (self.model.address.length > 0) {
        self.detailAddressPlaceholderLabel.hidden = YES;
    }
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
