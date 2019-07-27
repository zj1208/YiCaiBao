//
//  OrderCellFooterView.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OrderCellFooterView.h"

@interface OrderCellFooterView ()

@property (nonatomic, strong)GetOrderManagerModel *orderModel;

@end

@implementation OrderCellFooterView

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
    self.contentView.backgroundColor = WYUISTYLE.colorBGgrey;
    self.transFeeLab.adjustsFontSizeToFitWidth = YES;
    [self.moreBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    
    self.labelsTagsView.maxItemCount = 3;
    self.labelsTagsView.apportionsItemWidthsByContent = NO;
    self.labelsTagsView.sectionInset = UIEdgeInsetsMake(7.5, 15, 7.5, 15);
    [self.labelsTagsView setCollectionViewLayoutWithEqualSpaceAlign:AlignWithRight withItemEqualSpace:10.f animated:NO];
}

- (void)setData:(id)data
{
    GetOrderManagerModel *model = (GetOrderManagerModel *)data;;
    self.numProDesLab.text = [NSString stringWithFormat:@"共计%@件产品 合计:",model.prodCount];

    self.finalPriceLab.text = model.finalPrice;
    self.transFeeLab.text = [NSString stringWithFormat:@"(含运费%@)",model.transFee];
    
    
    CGFloat moreViewHeight = model.showMore?45.f:0.f;
    [self.moreContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(moreViewHeight);
    }];
    self.moreContainerView.hidden = !model.showMore;
    
    NSMutableArray *titleArray = [NSMutableArray array];
    [model.buttons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArray addObject:obj.name];
    }];
    [self.labelsTagsView setData:titleArray];
}

//获取tableFooterView的高度
- (CGFloat)getCellHeightWithContentData:(id)data
{
    GetOrderManagerModel *model = (GetOrderManagerModel *)data;
    NSMutableArray *titleArray = [NSMutableArray array];
    [model.buttons enumerateObjectsUsingBlock:^(OrderButtonModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [titleArray addObject:obj.name];
    }];
    
    if (!model.showMore)
    {
        return 45*3+10-45;
    }
    return 45*3+10;
}


@end
