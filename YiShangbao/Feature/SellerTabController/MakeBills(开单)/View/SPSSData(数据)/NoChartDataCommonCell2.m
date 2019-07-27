//
//  NoChartDataCommonCell2.m
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NoChartDataCommonCell2.h"

@implementation NoChartDataCommonCell2

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    PNPieChartDataItem *item1 = [PNPieChartDataItem dataItemWithValue:100 color:UIColorFromRGB_HexValue(0xff5434)];
    NSArray *items = @[item1];
    PNPieChart *pieChart = [[PNPieChart alloc] initWithFrame:CGRectMake(LCDW/2-60, 178/2-60, 120, 120) items:items];
    pieChart.hideValues = YES;
    pieChart.shouldHighlightSectorOnTouch = NO;
    [pieChart strokeChart];
    [self.contentView addSubview:pieChart];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
