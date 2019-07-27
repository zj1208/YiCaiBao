//
//  PurchasrBestProductsAdvCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchasrBestProductsAdvCell.h"
@implementation PurchasrBestProductsAdvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
        
    self.menuView.jl_minimumInteritemSpacing = 0;
    self.menuView.jl_minimumLineSpacing = LCDScale_iPhone6_Width(15.f);
    self.menuView.jl_sectionInset = UIEdgeInsetsMake(4, LCDScale_iPhone6_Width(15.f), 15, LCDScale_iPhone6_Width(15.f));
    self.menuView.jl_IconSize = CGSizeMake(LCDScale_iPhone6_Width(85.f), LCDScale_iPhone6_Width(85.f));
    self.menuView.jl_TitleHeight = 16.f;
    self.menuView.jl_maxCount = 1;
    self.menuView.scrollEnabled = YES;
    self.menuView.scrollDirection = UICollectionViewScrollDirectionHorizontal;

}

@end
