//
//  HeaderPicsViewCell.m
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "HeaderPicsViewCell.h"
#import "CustomAddPicLayoutConfig.h"

#define PhotoMargin 10*LCDW/375  //间距
#define ContentWidth LCDW-57

@interface HeaderPicsViewCell ()

@end

@implementation HeaderPicsViewCell

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

    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 12.f;
    picView.photosState = ZXPhotosViewStateDidCompose;
    picView.sectionInset = UIEdgeInsetsMake(5, 15, 10, 15);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:4 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.addButtonPlaceholderImage = [UIImage imageNamed:ZXAddAssetImageName];

    picView.addPicCoverView.titleLabel.text = [NSString stringWithFormat:@"添加图片或视频\n(最多9个，视频时长不能超过10秒)"];
    picView.addPicCoverView.titleLabLeading.constant = 23.f;
    picView.canMoveItem = YES;
    self.picsCollectionView = picView;
    [self.contentView addSubview:picView];

    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    [[ZXAddPicViewKit sharedKit]registerLayoutConfig:[CustomAddPicLayoutConfig new]];
    
//    已经不用了，隐藏就行
    self.containerView.hidden = YES;

}


- (void)setData:(id)data
{
//    动态设置占位符按钮的图标
    if ([self.picsCollectionView containsVideoObject:data])
    {
        [self.picsCollectionView updatePlaceholderButtonImage:[UIImage imageNamed:ZXAddPhotoImageName]];
    }
    else
    {
        [self.picsCollectionView updatePlaceholderButtonImage:[UIImage imageNamed:ZXAddAssetImageName]];
    }
    [self.picsCollectionView setData:data];
}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
//{
//    return self.dataMArray.count;
//}
//
//- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
//    
//    UIImageView *imageView = (UIImageView *)[cell.contentView viewWithTag:100];
//    imageView.contentMode = UIViewContentModeScaleAspectFill;
//    if (self.dataMArray.count >0)
//    {
//        AliOSSPicUploadModel *model = (AliOSSPicUploadModel *)[self.dataMArray objectAtIndex:indexPath.item];
//        NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.p];
//        [imageView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderImage];
//        
//        [cell setCornerRadius:5.f borderWidth:1.f borderColor:nil];
//    }
//    return cell;
//}
//
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    CGFloat width = LCDScale_5Equal6_To6plus(60.f);
//    return CGSizeMake(width, width);
//}
//
//- (void)layoutSubviews
//{
//    [super layoutSubviews];
//}
//
////为何在这个cell写了，其他cell都受干扰了
//- (UIView*)hitTest:(CGPoint)point withEvent:(UIEvent*)event
//{
//    UIView*view = [super hitTest:point withEvent:event];
//    NSLog(@"view = %@",view);
//    if (view ==self||view ==self.contentView)
//    {
//        return self;
//    }
//    else if (view ==self.containerView)
//    {
//        return self;
//    }
//    else if (view ==self.collectionView)
//    {
//        return self;
//    }
//    return nil;
//}
//
//- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event
//{
//    return CGRectContainsPoint(self.bounds, point);
//}
@end
