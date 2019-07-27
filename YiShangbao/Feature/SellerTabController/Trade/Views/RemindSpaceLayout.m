//
//  RemindSpaceLayout.m
//  YiShangbao
//
//  Created by simon on 17/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RemindSpaceLayout.h"



//吸顶效果
@implementation RemindSpaceLayout

- (nullable NSArray<__kindof UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *oldItems = [super layoutAttributesForElementsInRect:rect];
//    NSLog(@"%@",oldItems);
    WS(weakSelf);
    [oldItems enumerateObjectsUsingBlock:^(UICollectionViewLayoutAttributes*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [weakSelf recomputeCellAttributesFrame:obj];
    }];
    return oldItems;
}
//由于cell在滑动过程中会不断修改cell的位置，所以需要不断重新计算所有布局属性的信息
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}

- (void)recomputeCellAttributesFrame:(UICollectionViewLayoutAttributes *)attributes
{
//   {{0, -64}, {375, 667}}, {{0, 0}, {375, 667}}
//    NSLog(@"%@,%@",NSStringFromCGRect(self.collectionView.bounds) ,NSStringFromCGRect(self.collectionView.frame));
    if ((attributes.frame.origin.x+attributes.frame.size.width)>self.collectionView.bounds.size.width+1)
    {
        CGPoint origin = attributes.frame.origin;
        origin.x = 0;
        if (attributes.indexPath.item %11 ==0)
        {
            origin.y = (attributes.frame.size.height+self.minimumLineSpacing)*(attributes.indexPath.item/11);
        }
        attributes.frame = (CGRect){origin,attributes.frame.size};

    }
}

@end
