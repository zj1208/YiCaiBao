//
//  PurScrollHorizontallyCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurScrollHorizontallyCell.h"

@implementation PurScrollHorizontallyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.menuView.jl_minimumInteritemSpacing = 0;
    self.menuView.jl_minimumLineSpacing = 8.f;
    self.menuView.jl_sectionInset = UIEdgeInsetsMake(8.f, 8.f, 8.f, 8.f);
    self.menuView.jl_IconSize = CGSizeMake(LCDScale_iPhone6_Width(140)-16.f,10);//并未使用iconIMV，用于计算宽度
    self.menuView.jl_maxCount = 1;
    self.menuView.scrollEnabled = YES;
    self.menuView.scrollDirection = UICollectionViewScrollDirectionHorizontal;
}

@end
