//
//  FenLeiLunBoCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "FenLeiLunBoCell.h"

@implementation FenLeiLunBoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.lunboView.pageControl.pageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(6), LCDScale_iPhone6_Width(6));
    self.lunboView.pageControl.currentPageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(8), LCDScale_iPhone6_Width(8));
    self.lunboView.pageControl.pageIndicatorRadius = LCDScale_iPhone6_Width(3);
    self.lunboView.pageControl.currentPageIndicatorRadius = LCDScale_iPhone6_Width(4);
    self.lunboView.pageControl.currentPageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"F58F23"];
    self.lunboView.pageControl.pageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
    self.lunboView.pageControl_botton = LCDScale_iPhone6_Width(6);
    self.lunboView.pageControl.allowUpdatePageIndicator = YES;

}

@end
