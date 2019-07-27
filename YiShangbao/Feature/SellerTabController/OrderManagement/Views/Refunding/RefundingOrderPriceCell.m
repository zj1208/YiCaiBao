//
//  RefundingOrderPriceCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundingOrderPriceCell.h"

@implementation RefundingOrderPriceCell

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
    [self.callPhoneBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [self.imBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [self sendSubviewToBack:self.contentView];
}

- (void)setData:(id)data
{
    OMRefundDetailInfoModel *model = (OMRefundDetailInfoModel *)data;
        
    self.refundFinalPriceLab.text = model.finalPrice;
    self.applyReasonLab.text = model.applyReason;
    self.explainLab.text = model.explain;

}

@end
