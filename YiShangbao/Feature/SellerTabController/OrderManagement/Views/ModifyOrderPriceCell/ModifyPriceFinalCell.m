//
//  ModifyPriceFinalCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ModifyPriceFinalCell.h"

@implementation ModifyPriceFinalCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (void)setData:(id)data
{
    GetConfirmOrderModel *model = (GetConfirmOrderModel *)data;
    
    self.prodsPriceLab.text = [NSString stringWithFormat:@"原价:¥%@",model.prodsPrice];
    self.transFeeLab.text = [NSString stringWithFormat:@"运费:¥%@",model.transFee];

    __block CGFloat discount = 0.f;
    [model.subBizOrders enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GetConfirmOrderModelSub *modelSub = (GetConfirmOrderModelSub *)obj;
        discount = discount + modelSub.ndiscount*[modelSub.quantity integerValue];
    }];
    
    if (discount<=0)
    {
        self.discountLab.text = [NSString stringWithFormat:@"折扣：-¥%.2f",ABS(discount)];
    }
    else
    {
        self.discountLab.text = [NSString stringWithFormat:@"折扣：+¥%.2f",ABS(discount)];
    }
    CGFloat finalPrice = [model.prodsPrice doubleValue] + [model.transFee doubleValue] + discount;
    self.finalPriceLab.text = [NSString stringWithFormat:@"¥%.2f",finalPrice];
    model.finalPrice = self.finalPriceLab.text;
}
@end
