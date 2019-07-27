//
//  SODProductsView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SODProductsView.h"
#import "SODProductsCollectionViewCell.h"
#import "SODProductsRefundDetailCollectionViewCell.h"

@interface SODProductsView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,weak)UICollectionView* collectionview;
@property(nonatomic,weak)UICollectionViewFlowLayout* flowlayout;
@property(nonatomic,strong)NSArray* arrayCollectionData;

@end

static NSString* const SODProductsCollectionViewCell_resign = @"SODProductsCollectionViewCell_resign";
static NSString* const SODProductsRefundDetailCollectionViewCell_resign = @"SODProductsRefundDetailCollectionViewCell_resign";

@implementation SODProductsView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self addCollectionView];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addCollectionView];
    }
    return self;
}
-(void)setArray:(NSArray *)array
{
    self.arrayCollectionData = [NSArray arrayWithArray:array];
    [self.collectionview reloadData];
    
}
- (CGFloat)getCellHeightWithContentData:(NSArray*)array
{
    if (array.count == 0) {
        return 0.f;
    }
    self.arrayCollectionData = [NSArray arrayWithArray:array];
    [self.collectionview reloadData];

    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:0 inSection:array.count-1];
    UICollectionViewLayoutAttributes *attributes = [self.collectionview layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.flowlayout.sectionInset.bottom;
    return ceilf(height);
}

-(void)addCollectionView
{
    self.arrayCollectionData = [NSArray array];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 2;
    flowLayout.minimumInteritemSpacing = 2.f ;
    flowLayout.sectionInset = UIEdgeInsetsMake(2,4,2,4);
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    self.flowlayout = flowLayout;
    
    UICollectionView*collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width,self.frame.size.height) collectionViewLayout:flowLayout];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.scrollEnabled = NO;
    collectionView.backgroundColor = self.backgroundColor;
    collectionView.delegate = self;
    collectionView.dataSource = self;
    [self addSubview:collectionView];
    self.collectionview = collectionView;
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    
    [self.collectionview registerNib:[UINib nibWithNibName:@"SODProductsCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:SODProductsCollectionViewCell_resign];
    [self.collectionview registerNib:[UINib nibWithNibName:@"SODProductsRefundDetailCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:SODProductsRefundDetailCollectionViewCell_resign];

    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.arrayCollectionData.count;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 1;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    return CGSizeMake(LCDW-8, 110.f);
    
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_cellType == SOD_ProductsRefundDetailCollectionViewCell)
    { //退款详情Cell
        SODProductsRefundDetailCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SODProductsRefundDetailCollectionViewCell_resign forIndexPath:indexPath];
        [cell setData:self.arrayCollectionData[indexPath.section]];
        return cell;
    }else
    { //订单详情Cell
        SODProductsCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:SODProductsCollectionViewCell_resign forIndexPath:indexPath];
        [cell setData:self.arrayCollectionData[indexPath.section]];
        return cell;
    }
   
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_SODProductsView:sourceArray:integer:)]) {
        [self.delegate jl_SODProductsView:self sourceArray:self.arrayCollectionData integer:indexPath.section];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
