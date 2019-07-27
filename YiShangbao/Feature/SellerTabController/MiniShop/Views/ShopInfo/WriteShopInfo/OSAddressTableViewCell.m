//
//  OSAddressTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OSAddressTableViewCell.h"

NSString *const OSAddressTableViewCellID = @"OSAddressTableViewCellID";

@implementation OSAddressTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.addressTextField.delegate = self;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//#pragma mark - 输入字符长度判断
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range 
//    return YES;
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (self.delegate && [self.delegate respondsToSelector:@selector(addressDetail:)]) {
        [self.delegate addressDetail:self.addressTextField.text];
    }
}

@end
