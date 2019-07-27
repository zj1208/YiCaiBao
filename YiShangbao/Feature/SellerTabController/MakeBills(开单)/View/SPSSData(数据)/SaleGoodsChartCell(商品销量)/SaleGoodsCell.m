//
//  SaleGoodsCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleGoodsCell.h"

@implementation SaleGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data withIndexPath:(NSIndexPath *)indexPath
{
    BillDataSaleGoodsModelWithGoodsSub *model = (BillDataSaleGoodsModelWithGoodsSub *)data;
    self.productNameLab.text = model.goodName;
    self.quantityLab.text = [NSString stringWithFormat:@"数量:%@",model.unit];
    self.priceLab.text = [NSString stringWithFormat:@"金额:¥%@",model.totalFee];
    switch (indexPath.row)
    {
        case 0:
            [self.leftRankingBtn setImage:[UIImage imageNamed:@"ranking1"] forState:UIControlStateNormal];
            break;
        case 1:
            [self.leftRankingBtn setImage:[UIImage imageNamed:@"ranking2"] forState:UIControlStateNormal];
            break;
        case 2:
            [self.leftRankingBtn setImage:[UIImage imageNamed:@"ranking3"] forState:UIControlStateNormal];
            break;
        default:   [self.leftRankingBtn setImage:nil forState:UIControlStateNormal];
            [self.leftRankingBtn setTitle:[@(indexPath.row+1) stringValue] forState:UIControlStateNormal];
            break;
    }
}
@end
