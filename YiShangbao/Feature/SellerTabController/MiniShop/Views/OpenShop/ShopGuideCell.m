//
//  ShopGuideCell.m
//  YiShangbao
//
//  Created by simon on 17/3/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopGuideCell.h"

@implementation ShopGuideCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setTitle:(NSString *)title
{
    if (![NSString zhIsBlankString:title])
    {
        self.label.text = title;

    }
}
@end
