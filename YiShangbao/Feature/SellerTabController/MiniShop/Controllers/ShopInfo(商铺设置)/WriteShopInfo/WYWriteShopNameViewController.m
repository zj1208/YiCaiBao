//
//  WYWriteShopNameViewController.m
//  YiShangbao
//
//  Created by light on 2017/11/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYWriteShopNameViewController.h"
#import "YYText.h"

@interface WYWriteShopNameViewController ()

@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UILabel *errorLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation WYWriteShopNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithHex:0xF3F3F3];
    [self creatUI];
    
    
    self.title = @"商铺名称";
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -Action
- (void)confirmButtonAction{
    //第一次修改时
    if (self.isChangeShopName){
        [self updateShopName];
        return;
    }
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:nil toView:self.view];
    [[[AppAPIHelper shareInstance] shopAPI] getShopStoreCheckShopName:self.textField.text success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        if (weakSelf.delegate && [weakSelf.delegate respondsToSelector:@selector(confirmShopName:)]){
            [weakSelf.delegate confirmShopName:self.textField.text];
            [weakSelf.navigationController popViewControllerAnimated:YES];
        }
    } failure:^(NSError *error) {
        self.errorLabel.text = [error localizedDescription];
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
    }];
}

- (void)updateShopName{
    WS(weakSelf)
    [MBProgressHUD zx_showLoadingWithStatus:@"" toView:self.view];
    [[[AppAPIHelper shareInstance] getShopAPI] postShopStoreModifyShopName:self.textField.text success:^(id data) {
        [MBProgressHUD zx_hideHUDForView:weakSelf.view];
        [weakSelf.navigationController popViewControllerAnimated:YES];
    } failure:^(NSError *error) {
        [MBProgressHUD zx_showError:[error localizedDescription] toView:weakSelf.view];
    }];
}

#pragma mark -Private
- (void)creatUI{
    self.confirmButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 52, 28)];
    UIBarButtonItem * rightButton = [[UIBarButtonItem alloc]initWithCustomView:self.confirmButton];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    [self.confirmButton setTitle:@"确定" forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:13.0]];
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0xFF6935] forState:UIControlStateNormal];
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.confirmButton.layer.borderColor = [UIColor colorWithHex:0xFF5434].CGColor;
    self.confirmButton.layer.borderWidth = 0.5;
    self.confirmButton.layer.cornerRadius = 14.0;
    self.confirmButton.layer.masksToBounds= YES;
    
    UIView *textFieldView = [[UIView alloc]init];
    [self.view addSubview:textFieldView];
    [textFieldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(10);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@45);
    }];
    textFieldView.backgroundColor = [UIColor whiteColor];
    
    self.textField = [[UITextField alloc]init];
    [textFieldView addSubview:self.textField];
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textFieldView);
        make.left.equalTo(textFieldView).offset(15);
        make.right.equalTo(textFieldView).offset(-15);
        make.bottom.equalTo(textFieldView);
    }];
    self.textField.font = [UIFont systemFontOfSize:13.0];
    self.textField.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.textField.placeholder = @"请输入4-18个字的商铺名称";
    self.textField.text = self.shopName;
    
    UILabel *label = [[UILabel alloc]init];
    [self.view addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.top.equalTo(textFieldView.mas_bottom).offset(10);
    }];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textColor = [UIColor colorWithHex:0xFF5434];
//    label.text = @"请输入4-18个字的商铺名称";
    self.errorLabel = label;
    
    UILabel *tipTitleLabel  = [[UILabel alloc]init];
    [self.view addSubview:tipTitleLabel];
    [tipTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(label.mas_bottom).offset(20);
    }];
    tipTitleLabel.textColor = [UIColor colorWithHex:0x868686];
    tipTitleLabel.font = [UIFont systemFontOfSize:13.0];
    tipTitleLabel.text = @"*商铺名称规范：";
    
    YYLabel *tipLabel = [[YYLabel alloc]init];
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view).offset(15);
        make.right.equalTo(self.view).offset(-15);
        make.top.equalTo(tipTitleLabel.mas_bottom).offset(10);
    }];
    tipLabel.textColor = [UIColor colorWithHex:0x868686];
    tipLabel.font = [UIFont systemFontOfSize:13.0];
    tipLabel.numberOfLines = 0;
    tipLabel.preferredMaxLayoutWidth = SCREEN_WIDTH - 30; //设置最大的宽度
    NSString *tipString = @"1、商铺名称一经确定后只能修改一次，如需再次修改可联系客服；\n2、建议商铺名称：位置-店名-行业；\n3、商铺名称不能只填写类目词，如：时尚女包；\n4、商铺名称不能出现7位以上的数字；\n5、商铺名称中不能出现以下关键词：义采宝、义乌购、阿里巴巴、诚信通、微信、QQ、扫码、二维码。";
    
    NSMutableAttributedString * resultAttr = [[NSMutableAttributedString alloc] initWithString:tipString];
    resultAttr.yy_lineSpacing = 5;
    resultAttr.yy_font = [UIFont systemFontOfSize:13.0];
    resultAttr.yy_color = [UIColor colorWithHex:0x868686];
    tipLabel.attributedText = resultAttr;
    
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
