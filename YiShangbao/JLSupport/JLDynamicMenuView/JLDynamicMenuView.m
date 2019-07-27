//
//  JLDynamicMenuView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#define SCR_W [UIScreen mainScreen].bounds.size.width
#define SCR_H [UIScreen mainScreen].bounds.size.height

//#define LCDScale_iPhone6_Width(X)    ((X)*SCR_W/375.f)
#import "JLDynamicMenuView.h"

@interface JLDynamicMenuView ()<UICollectionViewDataSource,UICollectionViewDelegate>
@property(nonatomic,strong)UICollectionView* collectionview;
@property(nonatomic,strong)UICollectionViewFlowLayout* flowlayout;
@property(nonatomic,strong)NSArray* arrayCollectionData;

@property(nonatomic, strong) NSMutableString *reuseIdentifier;
@property(nonatomic, strong) UICollectionViewCell<JLDynamcMenuProtocol>*custonCollectioncell;
@end

static NSString* JLDynamicMenuCollectionViewCellResign = @"JLDynamicMenuCollectionViewCellResign";

@implementation JLDynamicMenuView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addCollectionView];
        [self initData];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addCollectionView];
        [self initData];
    }
    return self;
}
-(void)initData
{
    self.jl_minimumInteritemSpacing = LCDScale_iPhone6_Width(20.f);
    self.jl_minimumLineSpacing = 12.f;
    self.jl_sectionInset = UIEdgeInsetsMake(12.f,LCDScale_iPhone6_Width(20.f),20.f, LCDScale_iPhone6_Width(20.f)); //顶部底部20;
    self.jl_maxCount = 4;
    self.jl_IconSize = CGSizeMake(LCDScale_iPhone6_Width(40.f), LCDScale_iPhone6_Width(40.f));
    self.jl_IconTitleHeight = 8.f;
    self.jl_IconTop = 8.f;
    _jl_TitleHeight = 15.f;
    
}
-(void)layoutSubviews{
    [super layoutSubviews];
    self.collectionview.frame = self.bounds;
}
//计算JLDynamicMenuView（collectionView）的总高度
- (CGFloat)getHeightByLayoutAttributesWithContentData:(NSArray*)array
{
    if (!array || array.count ==0) {
        return 0.f;
    }
    NSIndexPath *itemIndexPath = [NSIndexPath indexPathForItem:array.count-1 inSection:0];
    UICollectionViewLayoutAttributes *attributes = [self.collectionview layoutAttributesForItemAtIndexPath:itemIndexPath];
    CGFloat height = CGRectGetMaxY(attributes.frame)+self.flowlayout.sectionInset.bottom;
    return ceilf(height);
}
-(CGFloat)getHeightByCalculationWithContentData:(NSArray*)array
{
    if (!array || array.count == 0) {
        return 0.f;
    }
    if (_jl_maxCount <= 0) {
        return 0.f;
    }
    NSInteger numLine = array.count/_jl_maxCount;
    NSInteger remainder = array.count%_jl_maxCount;
    if (remainder>0) {
        numLine++;
    }
    CGFloat spaces_H =  self.flowlayout.sectionInset.top + self.flowlayout.sectionInset.bottom+(numLine-1)*self.flowlayout.minimumLineSpacing; //所有间隙高度
    CGFloat cells_H  = (self.jl_IconTop +self.jl_IconSize.height+self.jl_IconTitleHeight+self.jl_TitleHeight)*numLine;
    return  spaces_H+ cells_H;
}
-(void)setArrayData:(NSArray *)arrayData
{
    _arrayData = arrayData;
    self.arrayCollectionData = [NSArray arrayWithArray:arrayData];
    [self layoutSubviews];
    [self.collectionview reloadData];

}
-(void)setJl_minimumInteritemSpacing:(CGFloat)jl_minimumInteritemSpacing
{
    _jl_minimumInteritemSpacing = jl_minimumInteritemSpacing;
    self.flowlayout.minimumInteritemSpacing = _jl_minimumInteritemSpacing;

}
-(void)setJl_minimumLineSpacing:(CGFloat)jl_minimumLineSpacing
{
    _jl_minimumLineSpacing = jl_minimumLineSpacing;
    self.flowlayout.minimumLineSpacing = _jl_minimumLineSpacing;
}
-(void)setJl_sectionInset:(UIEdgeInsets)jl_sectionInset
{
    _jl_sectionInset = jl_sectionInset;
    self.flowlayout.sectionInset = _jl_sectionInset;
}
-(void)setScrollEnabled:(BOOL)scrollEnabled
{
    _scrollEnabled = scrollEnabled;
    self.collectionview.scrollEnabled = _scrollEnabled;
}
-(void)setScrollDirection:(UICollectionViewScrollDirection)scrollDirection
{
    _scrollDirection = scrollDirection;
    self.flowlayout.scrollDirection = _scrollDirection;
}
-(void)setCustomCell:(UICollectionViewCell<JLDynamcMenuProtocol> *)cell isXibBuild:(BOOL)isxib
{
    if (![cell isKindOfClass:[UICollectionViewCell class]]) {
        NSLog(@"\n---------方法:%sCell参数传入错误----------",__FUNCTION__);
        return;
    }
    NSString* ClassCell =  NSStringFromClass([cell class]);
    self.reuseIdentifier = [NSMutableString stringWithFormat:@"%@Resign",ClassCell];
    if (isxib) {
        [self.collectionview registerNib:[UINib nibWithNibName:ClassCell bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:self.reuseIdentifier];
    }else{
        [self.collectionview registerClass:[NSClassFromString(ClassCell) class] forCellWithReuseIdentifier:self.reuseIdentifier];
    }
    if (self.arrayCollectionData.count>0) {
        [self.collectionview reloadData];
    }
}
-(void)addCollectionView
{
    [self.subviews  makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.arrayCollectionData = [NSArray array];
    self.flowlayout = [[UICollectionViewFlowLayout alloc] init];
    self.flowlayout.scrollDirection = UICollectionViewScrollDirectionVertical;

    self.collectionview = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowlayout];
    self.collectionview.showsHorizontalScrollIndicator = NO;
    self.collectionview.showsVerticalScrollIndicator = NO;
    self.collectionview.scrollEnabled = NO;
    self.collectionview.backgroundColor = [UIColor whiteColor];
    self.collectionview.delegate = self;
    self.collectionview.dataSource = self;
    [self addSubview:self.collectionview];
    [self.collectionview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self);
        make.right.mas_equalTo(self);
        make.top.mas_equalTo(self);
        make.bottom.mas_equalTo(self);
    }];
    [self.collectionview registerNib:[UINib nibWithNibName:@"JLDynamicMenuCollectionViewCell" bundle: [NSBundle mainBundle]] forCellWithReuseIdentifier:JLDynamicMenuCollectionViewCellResign];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(nonnull UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.flowlayout.scrollDirection == UICollectionViewScrollDirectionVertical) {
        CGFloat cellwidths = self.collectionview.frame.size.width-self.flowlayout.sectionInset.left-self.flowlayout.sectionInset.right-self.flowlayout.minimumInteritemSpacing*(_jl_maxCount-1.f) ;
        CGFloat W = cellwidths/_jl_maxCount -0.1;
        CGFloat H = self.jl_IconTop +self.jl_IconSize.height+self.jl_IconTitleHeight+self.jl_TitleHeight;
        return CGSizeMake(W, H);
    }else{
        CGFloat cellwidths = self.collectionview.frame.size.height-self.flowlayout.sectionInset.top-self.flowlayout.sectionInset.bottom-self.flowlayout.minimumInteritemSpacing*(_jl_maxCount-1.f) ;
        CGFloat H = cellwidths/_jl_maxCount -0.1;
        CGFloat W = self.jl_IconSize.width;
        return CGSizeMake(W, H);
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayCollectionData.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.reuseIdentifier) {
        self.custonCollectioncell = [collectionView dequeueReusableCellWithReuseIdentifier:self.reuseIdentifier forIndexPath:indexPath];
        [self.custonCollectioncell setJLDynamcMenuCellData:_arrayCollectionData[indexPath.row]];
        return (UICollectionViewCell*)self.custonCollectioncell;
    }
    JLDynamicMenuCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JLDynamicMenuCollectionViewCellResign forIndexPath:indexPath];
    cell.topIconConstraint.constant = self.jl_IconTop;
    cell.iconWidthConstraint.constant = self.jl_IconSize.width;
    cell.iconHeihtConstraint.constant = self.jl_IconSize.height;
    cell.title_height_Contraint.constant = self.jl_TitleHeight;
    if (self.dataSource && [self.dataSource respondsToSelector:@selector(jl_JLDynamicMenuView:cell:cellForItemAtInteger:)]) {
         [self.dataSource jl_JLDynamicMenuView:self cell:cell cellForItemAtInteger:indexPath.row];
    }
//    cell.backgroundColor = [UIColor redColor];
//    cell.titleLabel.backgroundColor = [UIColor purpleColor];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(nonnull UICollectionViewCell *)cell forItemAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_JLDynamicMenuView:willDisplayCell:cellForItemAtInteger:)]) {
        [self.delegate jl_JLDynamicMenuView:self willDisplayCell:(JLDynamicMenuCollectionViewCell*)cell cellForItemAtInteger:indexPath.row];
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(jl_JLDynamicMenuView:didSelectItemAtInteger:)]) {
        [self.delegate jl_JLDynamicMenuView:self didSelectItemAtInteger:indexPath.row];
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
