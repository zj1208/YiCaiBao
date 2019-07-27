//
//  RecentlyFindLabCell.m
//  YiShangbao
//
//  Created by simon on 17/2/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RecentlyFindLabCell.h"

@implementation RecentlyFindLabCell

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

    self.labelsTagsView.maxItemCount = 100;
    self.labelsTagsView.delegate = self;
    self.labelsTagsView.apportionsItemWidthsByContent = YES;
    [self.labelsTagsView setCollectionViewLayoutWithEqualSpaceAlign:AlignWithLeft withItemEqualSpace:15.f animated:NO];
}

- (void)setData:(id)data
{
    [self.labelsTagsView setData:data];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{
    return [self.labelsTagsView getCellHeightWithContentData:data];
}

- (void)zx_labelsTagsView:(ZXLabelsTagsView *)labelsTagView willDisplayCell:(LabelCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    //默认设置
    cell.titleLab.textColor = UIColorFromRGB(47.f, 47.f, 47.f);
    cell.titleLab.backgroundColor = UIColorFromRGB(255.f, 245.f, 241.f);
    cell.titleLab.layer.borderColor = cell.titleLab.backgroundColor.CGColor;


}
@end


