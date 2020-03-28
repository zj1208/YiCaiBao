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
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUI];
        
    }
    return self;
}

- (void)setUI
{
    [self.contentView addSubview:self.menuIconCollectionView];
    [self.menuIconCollectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.contentView);
    }];
}

- (ZXMenuIconCollectionView *)menuIconCollectionView
{
    if (!_menuIconCollectionView) {
        ZXMenuIconCollectionView *view = [[ZXMenuIconCollectionView alloc] init];
        view.columnsCount = 4;
        view.minimumInteritemSpacing = 15.f;
        CGFloat width = [view getItemAverageWidthInTotalWidth:LCDW columnsCount:view.columnsCount sectionInset:view.sectionInset minimumInteritemSpacing:view.minimumInteritemSpacing];
        view.itemSize = CGSizeMake(width,width+10);
        view.placeholderImage = AppPlaceholderImage;
        _menuIconCollectionView = view;
    }
    return _menuIconCollectionView;
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
