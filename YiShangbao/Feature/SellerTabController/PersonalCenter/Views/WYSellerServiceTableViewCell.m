//
//  WYSellerServiceTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYSellerServiceTableViewCell.h"
#import "BadgeMarkItemModel.h"

NSString * const WYSellerServiceTableViewCellID = @"WYSellerServiceTableViewCellID";

@interface WYSellerServiceTableViewCell ()

@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation WYSellerServiceTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    ZXHorizontalPageCollectionView *page = [[ZXHorizontalPageCollectionView alloc] init];
    page.maxRowCount = 2;
    page.columnsCount = 4;
    page.sectionInset = UIEdgeInsetsMake(0, 2, 12, 2);
    page.lineSpacing = 1.f;
    page.interitemSpacing = 4.f;
    
    CGFloat width = [page getItemAverageWidthInTotalWidth:LCDW columnsCount:page.columnsCount sectionInset:page.sectionInset minimumInteritemSpacing:page.interitemSpacing];
    page.itemSize = CGSizeMake(width, width-LCDScale_iPhone6_Width(12));
    [self.contentView addSubview:page];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(30);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
//        make.edges.mas_equalTo(self.contentView);
    }];
    
    self.itemPageView = page;
    
    return self;
}


- (void)setData:(id)data{
    NSArray *dataArray = (NSArray *)data;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [data enumerateObjectsUsingBlock:^(BadgeItemCommonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BadgeMarkItemModel *model = [[BadgeMarkItemModel alloc] init];
        model.icon = obj.icon;
        model.desc = obj.desc;
        model.sideMarkType = obj.sideMarkType;
        model.sideMarkValue = obj.sideMarkValue;
        [mArray addObject:model];
    }];
    [self.itemPageView setData:mArray];
    [self.itemPageView scrollToPageAtIndex:0 animated:NO];
    if (mArray.count > 0){
        self.titleLabel.hidden = NO;
    }else{
        self.titleLabel.hidden = YES;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
//    self.itemPageView.frame = CGRectMake(0, 30, self.contentView.frame.size.width, self.contentView.frame.size.height-30);
}

- (CGFloat)getCellHeightWithContentData:(id)data{
    CGFloat height = [self.itemPageView getCellHeightWithContentData:data];
    if (height) {
        height += 30;
    }
    return height;
}

- (UILabel *)titleLabel{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]init];//WithFrame:CGRectMake(15, 0, 100, 30)];
        [self.contentView addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).offset(12);
            make.left.equalTo(self.contentView).offset(15);
            make.width.equalTo(@100);
//            make.height.equalTo(@30);
        }];
        _titleLabel.text = @"优选服务";
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        _titleLabel.textColor = [UIColor colorWithHex:0x535353];
    }
    return _titleLabel;
}

@end
