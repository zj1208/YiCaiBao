//
//  SaleAmountCell.m
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SaleAmountCell.h"

@implementation SaleAmountCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.maxAmountLab.layer.masksToBounds = YES;
    self.maxAmountLab.layer.borderColor = UIColorFromRGB_HexValue(0xFF5434).CGColor;
    self.maxAmountLab.layer.borderWidth = 0.5;
    [self.maxAmountLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.width.mas_equalTo(CGRectGetWidth(self.maxAmountLab.frame)+4);
        make.height.mas_equalTo(CGRectGetHeight(self.maxAmountLab.frame)+4);

    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    BillDataSaleAmountModelSub *model = (BillDataSaleAmountModelSub *)data;
    self.dateLab.text = model.date1;
    self.totalFeeLab.text = [NSString stringWithFormat:@"¥%@",model.totalFee];
    self.maxAmountLab.hidden = !model.maxDay;
    self.totalFeeLab.textColor = model.maxDay?UIColorFromRGB_HexValue(0xFF5434):UIColorFromRGB_HexValue(0x868686);

}

@end
