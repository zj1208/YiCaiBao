//
//  WYODCheatTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//备忘

#import "WYODCheatTableViewCell.h"

#import "OrderManagementDetailModel.h"
@interface WYODCheatTableViewCell  ()<UITextFieldDelegate>
@property (nonatomic, strong)NSString * SellerCheat; //卖家留言,判断用户是否修改，控制完成按钮hidden

@end
@implementation WYODCheatTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.layerCornView.layer.masksToBounds = YES;
    self.layerCornView.layer.borderWidth = 0.6;
    self.layerCornView.layer.borderColor = [WYUISTYLE colorWithHexString:@"E1E1E1"].CGColor;
    self.layerCornView.layer.cornerRadius = 19;
    
    self.wanchenbtn.hidden = YES;
    [self.wanchenbtn addTarget:self action:@selector(ClickSure:) forControlEvents:UIControlEventTouchUpInside];
    
    self.textfild.delegate = self;
}
-(void)setCellData:(id)data
{
    if (self.wanchenbtn.hidden) {
        OrderManagementDetailModel* model = data;
        self.textfild.text = model.remark;
        _SellerCheat = self.textfild.text;
    }else{ //未点击完成保存
//        self.textfild.text = self.textfild.text ;
    }
    
    
}
-(void)ClickSure:(UIButton*)sender
{
    [self.textfild resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYODCheatTableViewCell:didBtn:text:)]) {
        [self.delegate jl_WYODCheatTableViewCell:self didBtn:sender text:self.textfild.text];
    }
}

#pragma mark 点击return按钮
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.textfild resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYODCheatTableViewCell:didReturnTextField:text:)]) {
        [self.delegate jl_WYODCheatTableViewCell:self didReturnTextField:textField text:textField.text];
    }
    return YES;
}
#pragma mark 用户输入的信息
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    return [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:200 remainTextNum:^(NSInteger remainLength) {
        
    } ];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.wanchenbtn.hidden = NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if ([textField.text isEqualToString:_SellerCheat]) {
        self.wanchenbtn.hidden = YES;
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYODCheatTableViewCell:cellTextFieldChange:text:)]) {
        [self.delegate jl_WYODCheatTableViewCell:self cellTextFieldChange:textField text:textField.text];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
