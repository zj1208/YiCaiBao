//
//  JLDynamicMenuCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "JLDynamicMenuCollectionViewCell.h"

@implementation JLDynamicMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.rightIconHeightContraint.constant = LCDScale_iPhone6_Width(15.f);
    self.rightIconWidthContraint.constant = LCDScale_iPhone6_Width(15.f);
    self.titleLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.5f)];

}

@end
