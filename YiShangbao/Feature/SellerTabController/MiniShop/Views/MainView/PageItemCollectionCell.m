//
//  PageItemCollectionCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/30.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PageItemCollectionCell.h"
#import "BadgeMarkItemModel.h"

@implementation PageItemCollectionCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self setUI];

    }
    return self;
}

- (ZXHorizontalPageCollectionView *)itemPageView
{
    if (!_itemPageView)
    {
        ZXHorizontalPageCollectionView *page = [[ZXHorizontalPageCollectionView alloc] init];
        page.maxRowCount = 2;
        page.columnsCount = 4;
        page.sectionInset = UIEdgeInsetsMake(0, 2, 12, 2);
        page.lineSpacing = 1.f;
        page.interitemSpacing = 4.f;
        CGFloat width = [page getItemAverageWidthInTotalWidth:LCDW columnsCount:page.columnsCount sectionInset:page.sectionInset minimumInteritemSpacing:page.interitemSpacing];
        page.itemSize = CGSizeMake(width, width-LCDScale_iPhone6_Width(12));
        _itemPageView = page;
    }
    return _itemPageView;
}

- (void)setUI
{
    [self.contentView addSubview:self.itemPageView];
     
     [self.itemPageView mas_makeConstraints:^(MASConstraintMaker *make) {
         
         make.edges.mas_equalTo(self.contentView);
     }];
}

- (void)setData:(id)data
{
    NSArray *dataArray = (NSArray *)data;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [data enumerateObjectsUsingBlock:^(BadgeItemCommonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BadgeMarkItemModel *model = [[BadgeMarkItemModel alloc] init];
        model.icon = obj.icon;
        model.desc = obj.desc;
        model.sideMarkType = obj.sideMarkType;
        model.sideMarkValue = obj.sideMarkValue;
        model.vbrands = obj.vbrands;
        [mArray addObject:model];
    }];
    [self.itemPageView setData:mArray];
    [self.itemPageView scrollToPageAtIndex:0 animated:NO];
}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    return [self.itemPageView getCellHeightWithContentData:data];
}
@end
