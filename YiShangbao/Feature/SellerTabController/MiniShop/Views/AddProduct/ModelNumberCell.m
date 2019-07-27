//
//  ModelNumberCell.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ModelNumberCell.h"

@implementation ModelNumberCell

NSInteger const MAXLENGTH = 60;

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.textField.delegate = self;
    self.titleLab.font = [UIFont systemFontOfSize:15];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (IS_IPHONE_6P)
    {
        self.leftMagin.constant =15.f;
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if (range.location>= MAXLENGTH)
    {
        textField.text = [textField.text substringToIndex:MAXLENGTH];
        return NO;
    }
    return YES;
}

@end
