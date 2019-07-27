//
//  AdvMustReadCell.m
//  YiShangbao
//
//  Created by simon on 2017/12/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "AdvMustReadCell.h"
#import "AdvMustReadSubCell.h"
#import "AdvMustReadSubCell2.h"

@implementation AdvMustReadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor whiteColor];
    self.briefLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];

//    self.cycleTitleView.backgroundColor = [UIColor colorWithRandomColor];
    [self.cycleTitleView setCustomCell:[[AdvMustReadSubCell2 alloc]init] isXibBuild:YES];
    self.cycleTitleView.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.cycleTitleView.scrollEnabled = NO;
    self.cycleTitleView.timeDuration = 3;
    self.cycleTitleView.pageControlNeed = NO;
    
    self.dotImageView.hidden = YES;
}

- (void)setData:(id)data
{
    ShopMustReadAdvFatherModel *model = (ShopMustReadAdvFatherModel *)data;
    self.dotImageView.hidden = !model.redDot;
}
@end
