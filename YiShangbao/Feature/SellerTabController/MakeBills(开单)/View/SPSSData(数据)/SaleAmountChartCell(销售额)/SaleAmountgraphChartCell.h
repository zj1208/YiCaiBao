//
//  SaleAmountgraphChartCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "PNChart.h"

@interface SaleAmountgraphChartCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *saleAmountLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (nonatomic, strong) PNLineChart *lineChart;
@end
