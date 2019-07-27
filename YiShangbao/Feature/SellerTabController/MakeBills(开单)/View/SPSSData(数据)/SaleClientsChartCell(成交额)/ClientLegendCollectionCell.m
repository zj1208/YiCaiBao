//
//  ClientSaleGoodsLegendCollectionCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ClientLegendCollectionCell.h"

@implementation ClientLegendCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath
{
    BillDataSaleClientgraphModelSub *model = (BillDataSaleClientgraphModelSub *)data;

    switch (indexPath.item) {
        case 0:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xFFAB00);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 1:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xff5434);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 2:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0x45A4E8);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        case 3:
            self.colorLab.backgroundColor = UIColorFromRGB_HexValue(0xB1B1B1);
            self.productName.textColor = self.colorLab.backgroundColor;
            self.priceLab.textColor = self.colorLab.backgroundColor;
            break;
        default:
            break;
    }
    self.productName.text = model.clientName;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",model.totalFee];
}
@end
