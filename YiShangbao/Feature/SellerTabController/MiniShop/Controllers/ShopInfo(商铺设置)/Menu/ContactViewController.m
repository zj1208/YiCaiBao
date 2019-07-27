//
//  ContactViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ContactViewController.h"
#import "ContactView.h"

#import "ShopModel.h"

@interface ContactViewController ()<UITextFieldDelegate>
@property(nonatomic, strong)ShopContactModel *model;
@end

@implementation ContactViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.model = [[ShopContactModel alloc] init];
    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


-(void)creatUI{
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn addTarget:self action:@selector(rightBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [rightBtn setTitle:@"保 存" forState:UIControlStateNormal];
    [rightBtn setTitleColor:WYUISTYLE.colorMTblack forState:UIControlStateNormal];
    rightBtn.titleLabel.font = WYUISTYLE.fontWith28;
    [rightBtn sizeToFit];
    rightBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, -15);
    UIBarButtonItem *BtnItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem  = BtnItem;
    
    self.title = @"联系方式";
    ContactView *view = [[ContactView alloc] init];
    view.frame = self.view.bounds;
    self.view = view;
    view.cell_name.input.delegate = self;
    
}
-(void)initData{
    [[[AppAPIHelper shareInstance] shopAPI] getShopContactWithsuccess:^(id data) {
        self.model = data;
        ContactView *view = (ContactView *)self.view;
        [view setData:self.model];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
    
}

-(void)rightBtnAction{
    
    ContactView *view = (ContactView *)self.view;
    self.model.sellerName = view.cell_name.input.text;
     self.model.sellerPhone = view.cell_phone.input.text;
     self.model.tel = view.cell_tel.input.text;
     self.model.fax = view.cell_fax.input.text;
     self.model.email = view.cell_email.input.text;
     self.model.qq = view.cell_qq.input.text;
     self.model.wechat = view.cell_wechat.input.text;
    
    [[[AppAPIHelper shareInstance] shopAPI] modifyShopContactWithParameters:self.model success:^(id data) {
        [self.navigationController popViewControllerAnimated:YES];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_updatePDF_WYMakeBillPreviewViewController object:nil];
        [[NSNotificationCenter defaultCenter]postNotificationName:Noti_showAlert_WYMakeBillPreviewSetController object:nil];
    } failure:^(NSError *error) {
        [self zhHUD_showErrorWithStatus:[error localizedDescription]];
    }];
}


#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    ContactView *view = (ContactView *)self.view;
    if (textField == view.cell_name.input) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 12) {
            return NO;
        }
    }
    if (textField == view.cell_phone.input) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 11) {
            return NO;
        }
    }
    return YES;
}
@end
