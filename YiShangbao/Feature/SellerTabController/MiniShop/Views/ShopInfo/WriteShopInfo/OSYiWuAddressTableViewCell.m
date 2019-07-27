//
//  OSYiWuAddressTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OSYiWuAddressTableViewCell.h"

NSString *const OSYiWuAddressTableViewCellID = @"OSYiWuAddressTableViewCellID";

@implementation OSYiWuAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.menTextField.delegate = self;
    self.louTextField.delegate = self;
    self.jieTextField.delegate = self;
    self.shopNumberTextField.delegate = self;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateMen:(NSString *)men lou:(NSString *)lou jie:(NSString *)jie shopNumber:(NSString *)shopNumber{
    self.menTextField.text = men;
    self.louTextField.text = lou;
    self.jieTextField.text = jie;
    self.shopNumberTextField.text = shopNumber;
}

#pragma mark - 输入字符长度判断
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (textField == self.shopNumberTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 30) {
            return NO;
        }
    }
    if (textField == self.menTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    if (textField == self.louTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 2) {
            return NO;
        }
    }
    if (textField == self.jieTextField) {
        if (string.length == 0) return YES;
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 6) {
            return NO;
        }
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressMenString:louString:jieString:shopNumberString:)]) {
        [self.delegate addressMenString:self.menTextField.text louString:self.louTextField.text jieString:self.jieTextField.text shopNumberString:self.shopNumberTextField.text];
    }
}

@end
