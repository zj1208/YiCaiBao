//
//  ZXNoGapCellFlowLayout.m
//  YiShangbao
//
//  Created by simon on 2017/8/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ZXNoGapCellFlowLayout.h"

static NSInteger const ZXColumnsCount = 4;


@implementation ZXNoGapCellFlowLayout


//- (instancetype)init
//{
//    self = [super init];
//    if (self)
//    {
//        [self setInit];
//    }
//    return self;
//}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self setInit];
    }
    return self;
}

- (void)setInit
{
    self.columnsCount = ZXColumnsCount;
}


- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 根据rect可见区域，如果超过一个屏幕，则分批次返回 需要显示的属性数组的；
    NSArray *attributesArray = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"attributesArray=%@",attributesArray);
    __weak __typeof(self)weakSelf = self;

    [attributesArray enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([self.delegate respondsToSelector:@selector(ZXNoGapCellFlowLayout:shouldNoGapAtIndexPath:)] && obj.representedElementCategory == UICollectionElementCategoryCell)
        {
            if ([self.delegate ZXNoGapCellFlowLayout:self shouldNoGapAtIndexPath:obj.indexPath])
            {
                [weakSelf resetCellLayoutAttributes:obj index:idx layoutAttributesArray:attributesArray];
            }
        }
//        NSLog(@"obj = %@",obj);
       }];
    return attributesArray;
}


- (void)resetCellLayoutAttributes:(UICollectionViewLayoutAttributes *)attributes index:(NSUInteger)index  layoutAttributesArray:(NSArray *)mlayoutAttributes
{
 
    UICollectionViewLayoutAttributes *currentLayoutAttributes = attributes;
    if (index >0)
    {
//        NSLog(@"index = %ld",index);
        UICollectionViewLayoutAttributes *preLayoutAtrributes = [mlayoutAttributes objectAtIndex:index-1];
        NSInteger maximumSpacing = 0;
        NSInteger preX = CGRectGetMaxX(preLayoutAtrributes.frame);
        NSInteger col_idx = currentLayoutAttributes.indexPath.item%self.columnsCount;
        CGFloat itemWidth = CGRectGetWidth(self.collectionView.bounds)/self.columnsCount;
        //如果当前一个cell的最右边加上我们想要的间距加上当前cell的宽度依然在contentSize中，我们改变当前cell的原点位置
        if(preX + maximumSpacing + currentLayoutAttributes.frame.size.width <= self.collectionViewContentSize.width)
        {
            CGRect frame = currentLayoutAttributes.frame;
            frame.origin.x = col_idx * itemWidth;
            currentLayoutAttributes.frame = frame;
        }
    }
 
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    CGRect oldBounds = self.collectionView.bounds;
    if (!CGRectEqualToRect(oldBounds, newBounds))
    {
        return YES;
    }
    return NO;
}

@end
