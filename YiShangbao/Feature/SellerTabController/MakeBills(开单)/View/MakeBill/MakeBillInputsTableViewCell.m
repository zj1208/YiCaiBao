//
//  MakeBillInputsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillInputsTableViewCell.h"

NSString *const MakeBillInputsTableViewCellID = @"MakeBillInputsTableViewCellID";

@interface MakeBillInputsTableViewCell ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UITextField *firstTextField;
//@property (weak, nonatomic) IBOutlet UITextField *secondTextField;
@property (weak, nonatomic) IBOutlet UITextField *oneTextField;//只有一个输入框
@property (weak, nonatomic) IBOutlet UIView *textFieldsView;

//@property (nonatomic) NSInteger index;

//@property (nonatomic, copy) NSIndexPath *indexPath;
@property (nonatomic) MakeBillGoodsInfo goodsInfoType;

@end

@implementation MakeBillInputsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.firstTextField.delegate = self;
//    self.secondTextField.delegate = self;
    self.oneTextField.delegate = self;
    
    [self.oneTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
//    [self.secondTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark -ButtonAction
- (IBAction)tapAction:(id)sender {
    [self.firstTextField becomeFirstResponder];
}

- (void)updateInputText:(NSString *)name index:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            self.goodsInfoType = MakeBillGoodsProductName;
        }else if (indexPath.row == 1){
            self.goodsInfoType = MakeBillGoodsUnitPrice;
        }else if (indexPath.row == 2){
            self.goodsInfoType = MakeBillGoodsBoxNumber;
        }else if (indexPath.row == 3){
            self.goodsInfoType = MakeBillGoodsPerBoxNumber;
        }else if (indexPath.row == 4){
            self.goodsInfoType = MakeBillGoodsTotalNumber;
        }
    }else{
        if (indexPath.row == 0) {
            self.goodsInfoType = MakeBillGoodsNo;
        }else if (indexPath.row == 1){
            self.goodsInfoType = MakeBillGoodsUnit;
        }else if (indexPath.row == 2){
            self.goodsInfoType = MakeBillGoodsVolume;
        }else if (indexPath.row == 3){
            self.goodsInfoType = MakeBillGoodsTotalPrice;
        }
    }
    self.oneTextField.keyboardType = UIKeyboardTypeDefault;
    self.nameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    if (self.goodsInfoType == MakeBillGoodsProductName) {
        self.nameLabel.text = @"*品名";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入品名";
        [self redStar:self.nameLabel];
    }else if (self.goodsInfoType == MakeBillGoodsUnitPrice){
        self.nameLabel.text = @"*单价";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入单价";
        self.oneTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self redStar:self.nameLabel];
    }else if (self.goodsInfoType == MakeBillGoodsTotalNumber){
        self.nameLabel.text = @"*总数量";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入总数量";
        self.oneTextField.keyboardType = UIKeyboardTypeDecimalPad;
        [self redStar:self.nameLabel];
    }else if (self.goodsInfoType == MakeBillGoodsNo) {
        self.nameLabel.text = @"货号";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入货号";
    }else if (self.goodsInfoType == MakeBillGoodsUnit){
        self.nameLabel.text = @"单位";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入单位";
    }else if (self.goodsInfoType == MakeBillGoodsBoxNumber){
        self.nameLabel.text = @"箱数";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入箱数";
        self.oneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }else if (self.goodsInfoType == MakeBillGoodsPerBoxNumber){
        self.nameLabel.text = @"每箱数量";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"请输入每箱数量";
        self.oneTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }else if (self.goodsInfoType == MakeBillGoodsVolume){
        self.nameLabel.text = @"外箱体积";
        self.firstTextField.text = name;
        self.firstTextField.placeholder = @"请输入单个箱子体积";
        self.firstTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }else if (self.goodsInfoType == MakeBillGoodsTotalPrice){
        self.nameLabel.text = @"总价";
        self.oneTextField.text = name;
        self.oneTextField.placeholder = @"无需填写，自动计算";
    }
    
    if (self.goodsInfoType == MakeBillGoodsVolume){
        self.textFieldsView.hidden = NO;
        self.oneTextField.hidden = YES;
    }else{
        self.textFieldsView.hidden = YES;
        self.oneTextField.hidden = NO;
    }
}

#pragma mark- UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length <= 0) {
        return YES;
    }
    NSMutableString *textFieldString = [NSMutableString stringWithString:textField.text];
    [textFieldString replaceCharactersInRange:range withString:string];
    NSString *str = [NSString stringWithFormat:@"%@",textFieldString];
    if (_goodsInfoType == MakeBillGoodsUnitPrice) {//单价
        NSString *regex = @"^[0-9]+(|(\\.[0-9]{0,2}))";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isCan = [pre evaluateWithObject:str];
        if (!isCan) {
            return NO;
        }
        if ([str isEqualToString:@"0.00"] || str.doubleValue > pow(10,7)){//10000000){
            return NO;
        }
    }else if (_goodsInfoType == MakeBillGoodsTotalNumber){//总数量
        if (str.integerValue < 1 || str.integerValue > pow(10,7)){
            return NO;
        }
        NSString *regex = @"^[0-9]+";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pre evaluateWithObject:str];
    }else if (_goodsInfoType == MakeBillGoodsUnit) {//单位
        UITextRange *selectedRange = [textField markedTextRange];
        NSString * newText = [textField textInRange:selectedRange];
        if (str.length < 1 || str.length > 4 + newText.length){
            return NO;
        }
    }else if (_goodsInfoType == MakeBillGoodsBoxNumber) {//箱数
        if (str.integerValue < 1 || str.integerValue > pow(10,7)){
            return NO;
        }
        NSString *regex = @"^[0-9]+";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pre evaluateWithObject:str];
    }else if (_goodsInfoType == MakeBillGoodsPerBoxNumber) {//每箱数量
        if (str.integerValue < 1 || str.integerValue > pow(10,7)){
            return NO;
        }
        NSString *regex = @"^[0-9]+";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        return [pre evaluateWithObject:str];
    }else if (_goodsInfoType == MakeBillGoodsVolume) {//外箱体积
        NSString *regex = @"^[0-9]+(|(\\.[0-9]{0,3}))";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isCan = [pre evaluateWithObject:str];
        if (!isCan) {
            return NO;
        }
        if ([str isEqualToString:@"0.000"] || str.doubleValue > pow(10,7)){
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidChange:(UITextField *)textField{
    if (textField.text.length > 4 && textField.markedTextRange == nil){
        NSString *string = textField.text;
        textField.text = [string substringToIndex:4];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (_goodsInfoType == MakeBillGoodsProductName) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(hiddenHistoryView)]) {
            [self.delegate hiddenHistoryView];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputString:goodsInfoType:)]) {
        [self.delegate inputString:textField.text goodsInfoType:self.goodsInfoType];
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_goodsInfoType == MakeBillGoodsProductName) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeString:)]) {
            [self.delegate changeString:textField.text];
        }
    }
}

- (void)textFieldChanged:(UITextField *)textField{
    if (_goodsInfoType == MakeBillGoodsProductName && textField.markedTextRange == nil) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(changeString:)]) {
            [self.delegate changeString:textField.text];
        }
    }
    if (_goodsInfoType == MakeBillGoodsUnit && textField.markedTextRange == nil) {
        if (textField.text.length > 4){
            textField.text = [textField.text substringToIndex:4];
        }
    }
    if (_goodsInfoType == MakeBillGoodsUnitPrice || _goodsInfoType == MakeBillGoodsBoxNumber || _goodsInfoType == MakeBillGoodsPerBoxNumber || _goodsInfoType == MakeBillGoodsTotalNumber) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(inputString:goodsInfoType:)]) {
            [self.delegate inputString:textField.text goodsInfoType:self.goodsInfoType];
        }
    }
}

- (void)redStar:(UILabel *)label{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSForegroundColorAttributeName:label.textColor,
                                                                                                                                NSFontAttributeName:label.font
                                                         }];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF5434],
                                          NSFontAttributeName:label.font
                                          } range:NSMakeRange(0,1)];
        label.attributedText = attributedString;
    }
}

@end
