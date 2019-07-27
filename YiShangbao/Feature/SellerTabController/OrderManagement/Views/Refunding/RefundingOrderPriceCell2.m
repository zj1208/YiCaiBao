//
//  RefundingCellFooterView.m
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundingOrderPriceCell2.h"

@implementation RefundingOrderPriceCell2

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
    self.bizOrderIdLab.text = [NSString stringWithFormat:@"订单编号:%@",model.bizOrderId];
    self.refundingOrderIdLab.text = [NSString stringWithFormat:@"退款编号:%@",model.iid];
    
    self.refundFinalPriceLab.text = [NSString stringWithFormat:@"退款金额:%@",model.finalPrice];
    
    self.applyTimeLab.text = [NSString stringWithFormat:@"申请退款时间:%@",model.applyTime];

    self.agreeRefundingTimeLab.text = [NSString stringWithFormat:@"同意退款时间:%@",model.agreeTime];
    if (![NSString zhIsBlankString:model.finishTime])
    {
        self.refundingFinishedTimeLab.text = [NSString stringWithFormat:@"退款完成时间:%@",model.finishTime];
    }
    else
    {
        self.refundingFinishedTimeLab.text = nil;
    }
    self.applyReasonLab.text = [NSString stringWithFormat:@"退款原因:%@",model.applyReason];
    self.refundingDesLab.text = [NSString stringWithFormat:@"退款说明:%@",model.explain?model.explain:@"无"];
}
@end
