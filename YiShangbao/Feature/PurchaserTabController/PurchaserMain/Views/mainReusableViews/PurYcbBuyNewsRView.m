//
//  PurYcbBuyNewsRView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurYcbBuyNewsRView.h"
#import "PurchaserLunBoLabellingCollectionViewCell.h"

@implementation PurYcbBuyNewsRView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.cycleTitleView.backgroundColor = [UIColor whiteColor];
    [self.cycleTitleView setCustomCell:[[PurchaserLunBoLabellingCollectionViewCell alloc]init] isXibBuild:YES];
    self.cycleTitleView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cycleTitleView.scrollEnabled = NO;
    self.cycleTitleView.pageControlNeed = NO;
}

@end
