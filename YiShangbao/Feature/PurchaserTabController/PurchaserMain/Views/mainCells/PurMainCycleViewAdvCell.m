//
//  PurMainCycleViewAdvCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurMainCycleViewAdvCell.h"

@implementation PurMainCycleViewAdvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
   
    self.lunboView.pageControl_botton = 7;
    self.lunboView.timeDuration = 3;
    
    self.lunboView.pageControl.currentPageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"F58F23"];
    self.lunboView.pageControl.pageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
    self.lunboView.pageControl.pageIndicatorSize = CGSizeMake(15, 3);
    self.lunboView.pageControl.currentPageIndicatorSize = CGSizeMake(15, 3);
    self.lunboView.pageControl.pageIndicatorRadius = 1.5;
    self.lunboView.pageControl.currentPageIndicatorRadius = 1.5;
    self.lunboView.pageControl.pageIndicatorSpacing = 3.f;
    self.lunboView.pageControl.currentPageIndicatorSpacing = 3.f;
    self.lunboView.pageControl.allowUpdatePageIndicator = YES;
}

@end
