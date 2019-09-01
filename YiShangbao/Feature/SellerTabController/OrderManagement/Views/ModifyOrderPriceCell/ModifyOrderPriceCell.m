//
//  ModifyOrderPriceCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ModifyOrderPriceCell.h"

@implementation ModifyOrderPriceCell

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
    [self.transFeeTextField zx_setCornerRadius:CGRectGetHeight(self.transFeeTextField.frame)/2 borderWidth:0.5 borderColor:UIColorFromRGB(225.f, 225.f, 225.f)];
}


- (void)setData:(id)data withTransFee:(NSString *)transFee
{
    GetConfirmOrderModel *model = (GetConfirmOrderModel *)data;
    self.priceLab.text = [NSString stringWithFormat:@"¥%.2f",model.nProdsPrice];
    
    self.transFeeTextField.text = transFee;
}
@end
