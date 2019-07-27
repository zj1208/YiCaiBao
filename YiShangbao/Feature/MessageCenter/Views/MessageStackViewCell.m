//
//  MessageStackViewCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageStackViewCell.h"

@implementation MessageStackViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.menuIconCollectionView.columnsCount = 4;
    self.menuIconCollectionView.minimumInteritemSpacing = 15.f;

    CGFloat width = [self.menuIconCollectionView getItemAverageWidthInTotalWidth:LCDW columnsCount:self.menuIconCollectionView.columnsCount sectionInset:self.menuIconCollectionView.sectionInset minimumInteritemSpacing:self.menuIconCollectionView.minimumInteritemSpacing];
    self.menuIconCollectionView.itemSize = CGSizeMake(width,width+10);

    self.menuIconCollectionView.placeholderImage = AppPlaceholderImage;
}

- (void)setData:(id)data
{
    NSArray *dataArray = (NSArray *)data;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [data enumerateObjectsUsingBlock:^(MessageModelSub *  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXMenuIconModel *model = [[ZXMenuIconModel alloc] init];
        model.icon = obj.typeIcon;
        model.title = obj.typeName;
        if (obj.num>0) {
            model.sideMarkType = SideMarkType_number;
        }else{
            model.sideMarkType = SideMarkType_none;
        }
        model.sideMarkValue = [NSString stringWithFormat:@"%@",@(obj.num)];
        [mArray addObject:model];
    }];
     [self.menuIconCollectionView setData:mArray];
}

- (CGFloat)getCellHeightWithContentIndexPath:(NSIndexPath *)indexPath data:(id)data
{

    return [self.menuIconCollectionView getCellHeightWithContentData:data];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
