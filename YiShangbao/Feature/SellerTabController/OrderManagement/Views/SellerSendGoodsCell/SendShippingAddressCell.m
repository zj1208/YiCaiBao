//
//  SendShippingAddressCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SendShippingAddressCell.h"

@implementation SendShippingAddressCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setData:(id)data
{
    GetOrderDeliveryModel *model = (GetOrderDeliveryModel *)data;
    self.receiverNameLab.text =[NSString stringWithFormat:@"收货人：%@",model.consignee];
    self.phoneNumLab.text = model.consigneePhone;
    self.receiverAddressLab.text =[NSString stringWithFormat:@"收货地址：%@",model.address];
}
@end
