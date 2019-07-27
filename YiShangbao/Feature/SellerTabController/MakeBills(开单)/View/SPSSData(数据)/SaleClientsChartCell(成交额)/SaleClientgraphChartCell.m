//
//  SaleClientgraphChartCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleClientgraphChartCell.h"


@implementation SaleClientgraphChartCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(LCDScale_iPhone6_Width(46), 43, 120, 120) items:nil];
    pieChart.hideValues = YES;
    //   选中高亮
    pieChart.labelPercentageCutoff = 0.001;
    pieChart.shouldHighlightSectorOnTouch = NO;
    [self.contentView addSubview:pieChart];
    self.pieChart = pieChart;
    
    
    [self.customCellCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([ClientLegendCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:NSStringFromClass([ClientLegendCollectionCell class])];
    
    self.customCellCollectionView.sectionInset = UIEdgeInsetsMake(10, 15, 10, 15);
    self.customCellCollectionView.itemSize = CGSizeMake(LCDW/2-2*15, (215-10-10-3*10)/4);
}



- (NSArray *)colorArray
{
    if (!_colorArray)
    {
        NSArray *array = @[UIColorFromRGB_HexValue(0xFFAB00),UIColorFromRGB_HexValue(0xff5434),UIColorFromRGB_HexValue(0x45A4E8),UIColorFromRGB_HexValue(0xB1B1B1)];
        _colorArray = array;
    }
    return _colorArray;
}
- (void)setData:(id)data
{
    NSArray *saleGoodgraphs = (NSArray *)data;
    NSMutableArray *items = [NSMutableArray array];
    [saleGoodgraphs enumerateObjectsUsingBlock:^(BillDataSaleClientgraphModelSub*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        PNPieChartDataItem *item = [PNPieChartDataItem dataItemWithValue:[obj.percentage floatValue]*100 color:[self.colorArray objectAtIndex:idx] description:nil];
        [items addObject:item];
    }];
    
    [self.pieChart updateChartData:items];
    [self.pieChart strokeChart];
    
    [self.customCellCollectionView setData:saleGoodgraphs];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}



@end
