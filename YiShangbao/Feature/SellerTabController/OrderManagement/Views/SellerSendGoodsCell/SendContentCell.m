//
//  SendContentCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SendContentCell.h"

@implementation SendContentCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];

    [self.sendGoodTypeBtn setTitle:@"选择您的发货方式" forState:UIControlStateNormal];
    [self.sendGoodTypeBtn setTitleColor:UIColorFromRGB(142.f, 142.f, 142.f) forState:UIControlStateNormal];
//    self.sendGoodTypeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"选择您的发货方式" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(142.f, 142.f, 142.f)}];
    
 }

- (void)setSendGoodType:(NSNumber *)sendType
{
    NSString *text = nil;
    if ([sendType isEqualToNumber:@(1)])
    {
        text = @"无需物流";
    }
    if ([sendType isEqualToNumber:@(2)])
    {
        text = @"物流";
    }
    [self.sendGoodTypeBtn setTitle:text forState:UIControlStateNormal];
    [self.sendGoodTypeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
}
@end
