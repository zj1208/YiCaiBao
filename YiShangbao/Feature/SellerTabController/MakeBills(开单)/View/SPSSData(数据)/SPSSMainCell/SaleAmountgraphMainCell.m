//
//  SaleAmountgraphMainCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleAmountgraphMainCell.h"

@implementation SaleAmountgraphMainCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.saleAmountLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(15.f)];
    self.dateLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(15.f)];
    
    PNLineChart *lineChart = [[PNLineChart alloc] initWithFrame:CGRectMake(10,LCDScale_5Equal6_To6plus(35), SCREEN_WIDTH-20, LCDScale_5Equal6_To6plus(165))];
    
    // 设置X轴的label的颜色，字体；一定要写在setXLabels之前才有效
    lineChart.xLabelColor = UIColorFromRGB_HexValue(0xC2C2C2);
    lineChart.xLabelFont = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(10)];
    
    // 设置Y轴的label的颜色，字体；
    lineChart.yLabelColor = UIColorFromRGB_HexValue(0xC2C2C2);
    // 设置Y轴4等份；默认5份；
    lineChart.yLabelNum = 5;
    
    // 设置是否显示X轴和Y轴的label显示； 默认YES
    lineChart.showLabel = YES;
    //    设置画布的宽度，高度（从曲线最低点到最高点之间的高度）；
    //    lineChart.chartCavanWidth
    lineChart.yValueMin = 0;
    
    
    //设置是否显示曲线，默认折线
    lineChart.showSmoothLines = YES;
    //设置是否显示坐标轴
    lineChart.showCoordinateAxis = YES;
    //设置坐标轴颜色
    lineChart.axisColor = UIColorFromRGB_HexValue(0xCCCCCC);
    
    [self.contentView addSubview:lineChart];
    
    self.lineChart = lineChart;

}

- (void)setData:(id)data
{
    BillDataSaleAmountModel *model = (BillDataSaleAmountModel *)data;
    self.saleAmountLab.text = [NSString stringWithFormat:@"销售额: ¥%@",model.saleFee];
    self.dateLab.text = model.saleDate;
    
    
    NSArray *saleAmount = model.saleAmount;
    
    
    NSMutableArray *dateArray = [NSMutableArray array];
    NSMutableArray *totalFeeArray = [NSMutableArray array];
    if (saleAmount.count ==0)
    {
        self.lineChart.yLabels = @[@"0",@"200",@"400",@"600",@"800"];
    }
    //    月初第一天
    else if (saleAmount.count ==1)
    {
      
        [saleAmount enumerateObjectsUsingBlock:^(BillDataSaleAmountModelSub *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [dateArray addObject:obj.date2];
            [totalFeeArray addObject:obj.totalFee];
            
        }];
        NSString *date = (NSString *)[dateArray firstObject];
        NSString *month = [[date componentsSeparatedByString:@"."]firstObject];
        for (int i=0; i<4; i++)
        {
            NSString *dateString = [NSString stringWithFormat:@"%@.%d",month,2+i];
            [dateArray addObject:dateString];
        }
    }
    //如果小于等于10个日期，则10个展示
    else if (saleAmount.count<=10 && saleAmount.count>1)
    {
        [saleAmount enumerateObjectsUsingBlock:^(BillDataSaleAmountModelSub *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            [dateArray addObject:obj.date2];
            [totalFeeArray addObject:obj.totalFee];
            
        }];
    }
    else
    {
        NSInteger colum = saleAmount.count%5;
        if (colum<=2)
        {
            [saleAmount enumerateObjectsUsingBlock:^(BillDataSaleAmountModelSub *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [totalFeeArray addObject:obj.totalFee];
                if ( idx ==0||(idx+1)%(5) == 0)
                {
                    [dateArray addObject:obj.date2];
                }
                if (idx == saleAmount.count-1)
                {
                    [dateArray removeLastObject];
                    [dateArray addObject:obj.date2];
                }
                
            }];
        }
        else
        {
            [saleAmount enumerateObjectsUsingBlock:^(BillDataSaleAmountModelSub *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                [totalFeeArray addObject:obj.totalFee];
                if (idx ==0|| (idx+1)%5 == 0 || idx == saleAmount.count-1)
                {
                    [dateArray addObject:obj.date2];
                }
                
            }];
        }
    }
    
    
    
    [self.lineChart setXLabels:dateArray];
    
    NSArray *data01Array = totalFeeArray;
    PNLineChartData *data01 = [PNLineChartData new];
    data01.color = UIColorFromRGB_HexValue(0xFD4D37);
    data01.itemCount = data01Array.count;
    
    if (data01Array.count ==1)
    {
        //设置拐点样式；默认无；
        data01.inflexionPointStyle = PNLineChartPointStyleCircle;
        //设置拐点颜色；默认红色；
        data01.inflexionPointColor = UIColorFromRGB_HexValue(0xFF5434);
        //设置拐点宽度；小于等于2是实心点，大于2是圆弧；
        data01.inflexionPointWidth = 2.f;
    }
    else
    {
        data01.inflexionPointStyle = PNLineChartPointStyleNone;
    }
  
    
    data01.getData = ^PNLineChartDataItem *(NSUInteger item) {
        
        CGFloat yValue = [[data01Array objectAtIndex:item]floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    
    self.lineChart.chartData = @[data01];
    
    [self.lineChart strokeChart];
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
