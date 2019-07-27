//
//  PurchasrLunboAdvCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchasrLunboAdvCell.h"
#import "JLCycleScrollerView.h"

@implementation PurchasrLunboAdvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lunboView.pageControl.currentPageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"F58F23"];
    self.lunboView.pageControl.pageIndicatorTintColor = [WYUISTYLE colorWithHexString:@"C2C2C2"];
    self.lunboView.pageControl_botton = 7;
    self.lunboView.timeDuration = 3;

    self.lunboView.pageControl.pageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(6.6), LCDScale_iPhone6_Width(7));
    self.lunboView.pageControl.currentPageIndicatorSize = CGSizeMake(LCDScale_iPhone6_Width(8), LCDScale_iPhone6_Width(8));
    self.lunboView.pageControl.pageIndicatorRadius = LCDScale_iPhone6_Width(3.3);
    self.lunboView.pageControl.currentPageIndicatorRadius = LCDScale_iPhone6_Width(4);
    self.lunboView.pageControl.pageIndicatorSpacing = 6.f;
    self.lunboView.pageControl.currentPageIndicatorSpacing = 6.f;
    self.lunboView.pageControl.allowUpdatePageIndicator = YES;
    
}
@end
