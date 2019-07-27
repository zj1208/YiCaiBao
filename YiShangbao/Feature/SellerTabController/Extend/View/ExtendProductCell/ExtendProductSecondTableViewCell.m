//
//  ExtendProductSecondTableViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendProductSecondTableViewCell.h"
#import "CustomAddPicLayoutConfig.h"

@implementation ExtendProductSecondTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    ZXAddPicCollectionView *picView = [[ZXAddPicCollectionView alloc] init];
    picView.maxItemCount = 9;
    picView.minimumInteritemSpacing = 2.f;
    picView.photosState = ZXPhotosViewStateDidCompose;//
    picView.sectionInset = UIEdgeInsetsMake(5, 12, 5, 12);
    picView.picItemWidth = [picView getItemAverageWidthInTotalWidth:LCDW columnsCount:4 sectionInset:picView.sectionInset minimumInteritemSpacing:picView.minimumInteritemSpacing];
    picView.picItemHeight = picView.picItemWidth;
    picView.addButtonPlaceholderImage = [UIImage imageNamed:@"addImgPro"];

//    picView.showAddPicCoverView = NO;
    picView.addPicCoverView.titleLabel.text = @"";// [NSString stringWithFormat:@"添加图片或视频\n(最多9个，视频时长不能超过10秒)"];
//    picView.addPicCoverView.titleLabel.textColor = [UIColor colorWithHexString:@"9D9D9D"];

    self.picsCollectionView = picView;
    [self.containerView addSubview:picView];
    self.containerView.clipsToBounds = YES;//self.picsCollectionView中collectionview.frame设置有问题
    
    [self.picsCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(picView.superview.mas_top).offset(0);
        make.bottom.mas_equalTo(picView.superview.mas_bottom).offset(0);
        make.left.mas_equalTo(picView.superview.mas_left).offset(0);
        make.right.mas_equalTo(picView.superview.mas_right).offset(0);
    }];
    [[ZXAddPicViewKit sharedKit]registerLayoutConfig:[CustomAddPicLayoutConfig new]];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
