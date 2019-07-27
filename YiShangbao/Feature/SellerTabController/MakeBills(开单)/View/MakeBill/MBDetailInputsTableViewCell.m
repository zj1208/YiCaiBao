//
//  MBDetailInputsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/3/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MBDetailInputsTableViewCell.h"

NSString *const MBDetailInputsTableViewCellID = @"MBDetailInputsTableViewCellID";

@implementation MBDetailInputsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    self.textField.delegate = self;
    self.textField.keyboardType = UIKeyboardTypeDecimalPad;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateName:(NSString *)name value:(NSString *)value{
    self.nameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.nameLabel.text = name;
    self.textField.text = value;
    [self redStar:self.nameLabel];
}

#pragma mark- UITexyFieldDelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length <= 0) {
        return YES;
    }
    NSMutableString *textFieldString = [NSMutableString stringWithString:textField.text];
    [textFieldString replaceCharactersInRange:range withString:string];
    NSString *str = [NSString stringWithFormat:@"%@",textFieldString];
    
        NSString *regex = @"^[0-9]+(|(\\.[0-9]{0,2}))";
        NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
        BOOL isCan = [pre evaluateWithObject:str];
        if (!isCan) {
            return NO;
        }
        if ([str isEqualToString:@"0.00"] || str.doubleValue > pow(10,15)){
            return NO;
        }
    
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(inputString:)]) {
        [self.delegate inputString:textField.text];
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
