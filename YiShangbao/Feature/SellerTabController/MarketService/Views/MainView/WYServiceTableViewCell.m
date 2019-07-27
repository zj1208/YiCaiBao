
//
//  WYServiceTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYServiceTableViewCell.h"

#import "SurveyModel.h"

NSString *const WYServiceTableViewCellID = @"WYServiceTableViewCellID";

@interface WYServiceTableViewCell ()

@end
@implementation WYServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //
    ZXHorizontalPageCollectionView *page = [[ZXHorizontalPageCollectionView alloc] init];
    page.maxRowCount = 2;
    page.columnsCount = 4;
    page.sectionInset = UIEdgeInsetsMake(12, 2, 12, 2);
    page.lineSpacing = 11.f;
    page.interitemSpacing = 4.f;
    
    CGFloat width = [page getItemAverageWidthInTotalWidth:LCDW columnsCount:page.columnsCount sectionInset:page.sectionInset minimumInteritemSpacing:page.interitemSpacing];
    page.itemSize = CGSizeMake(width, width-LCDScale_iPhone6_Width(12));
   
    [self.menuView addSubview:page];
    
    [page mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.menuView);
    }];
    self.itemPageView = page;
    
    self.searchButton.imageEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.searchButton.titleEdgeInsets = UIEdgeInsetsMake(0, 15, 0, 0);
    self.searchButton.layer.borderColor = [UIColor colorWithHex:0x48B1F9].CGColor;
    self.searchButton.layer.borderWidth = 0.5;
    self.searchButton.layer.cornerRadius = 16.f;
}

- (void)setMenuDic:(ServiceMenuModel*)menuModel notiArray:(NSArray *)notiArray{
    [self setZXHorizontalPageCollectionViewData:menuModel.menuList];
}

- (void)setZXHorizontalPageCollectionViewData:(id)data{
    NSArray *dataArray = (NSArray *)data;
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:dataArray.count];
    [data enumerateObjectsUsingBlock:^(MenuListModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        BadgeMarkItemModel *model = [[BadgeMarkItemModel alloc] init];
        model.icon = obj.icon;
        model.desc = obj.name;
        if (obj.sideOfPic) {
            model.sideMarkType = SideMarkType_image;
        }else{
            model.sideMarkType = SideMarkType_none;
        }
        model.sideMarkValue = obj.sideOfPic;
        [mArray addObject:model];
    }];
    [self.itemPageView setData:mArray];
    [self.itemPageView scrollToPageAtIndex:0 animated:NO];
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
