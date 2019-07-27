//
//  TradeOrderedPersonalCell.m
//  YiShangbao
//
//  Created by simon on 17/1/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeOrderedPersonalCell.h"

@interface TradeOrderedPersonalCell ()

@property (nonatomic,strong)TradeDetailModel *detailModel;

@end

@implementation TradeOrderedPersonalCell




- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

    self.progressView.progressHeight = 6.f;
    self.progressView.cornerRaidius = YES;
   
    UIImage *gradientImage = [UIImage zh_getGradientImageFromHorizontalTowColorWithSize:CGSizeMake(10, 6) startColor:UIColorFromRGB(250.f, 124.f, 47.f) endColor:UIColorFromRGB(241.f, 62.f, 62.f)];
    self.progressView.zxTrackImage = gradientImage;
    
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    
//    NSLog(@"width =%@",@(LCDW-36*2));
  //定义一行只显示10个item
    self.flowLayout.minimumInteritemSpacing = -7.0;
    CGFloat collectionViewWidth = LCDW-23*2;
    CGFloat common = (collectionViewWidth-12.f*ABS(self.flowLayout.minimumInteritemSpacing))/11;
    CGFloat itemWidth = common +ABS(self.flowLayout.minimumInteritemSpacing)*2;
    self.flowLayout.itemSize = CGSizeMake(itemWidth, itemWidth);
    self.flowLayout.minimumLineSpacing = 5.f;
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
   
}

- (void)setData:(id)data
{
    TradeDetailModel *model = (TradeDetailModel *)data;
    self.detailModel = model;
    
    self.numPersonalLab.text = [NSString stringWithFormat:@"%@",model.qouterAmout];
    self.progressLab.text = [NSString stringWithFormat:@"%d%%",(int)(model.ratio*100)];
    CGFloat progress = [model.qouterAmout floatValue]<10?0.3:model.ratio;
    [self.progressView setProgress:progress animated:YES];
    [self.collectionView reloadData];
}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    TradeDetailModel *model = (TradeDetailModel *)data;
    if ([model.qouterAmout isEqualToNumber:@(0)])
    {
        return 0;
    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:([model.qouterAmout integerValue] -1) inSection:0];
    [self setData:data];
    UICollectionViewLayoutAttributes *attributes = [self.collectionView layoutAttributesForItemAtIndexPath:indexPath];
//    NSLog(@"%@",NSStringFromCGRect(attributes.frame));

    return 119+CGRectGetMaxY(attributes.frame)+20;
}

//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
//{
//    return 0;
//}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.detailModel.qouterAmout integerValue];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

    static NSString *cellIdentifier = @"Cell";
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor orangeColor];

    if (![cell.contentView viewWithTag:200])
    {
        UIImageView *label = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.flowLayout.itemSize.height, self.flowLayout.itemSize.height)];
        label.tag =200;
        [cell.contentView addSubview:label];
    }
    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:200];
    imageView.contentMode = UIViewContentModeScaleAspectFill;

    if ([self.detailModel.qouterAmout integerValue]>0)
    {
        if (self.detailModel.sellerIcons.count<[self.detailModel.qouterAmout integerValue] && self.detailModel.sellerIcons.count<=indexPath.item)
        {
             [imageView sd_setImageWithURL:nil placeholderImage:AppPlaceholderHeadImage];
        }
        else
        {
            NSURL *url = [NSURL URLWithString:[self.detailModel.sellerIcons objectAtIndex:indexPath.item]];
            [imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderHeadImage];
        }
       
    }
    [cell setCornerRadius:self.flowLayout.itemSize.height/2 borderWidth:1 borderColor:[UIColor whiteColor]];
    return cell;
}



@end
