//
//  SendProductCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SendProductCell.h"

@implementation SendProductCell

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
    [self.picBtn zh_setButtonImageViewScaleAspectFill];
    [self.picBtn zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];

}

- (void)setData:(id)data
{
    GetOrderDeliveryModel *model = (GetOrderDeliveryModel *)data;
    self.picImageView.backgroundColor = [UIColor redColor];
//    bug
//    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:AppPlaceholderImage];
    [self.picBtn sd_setImageWithURL:[NSURL URLWithString:model.orderPic] forState:UIControlStateNormal placeholderImage:AppPlaceholderImage];
    self.numProLab.text = [NSString stringWithFormat:@"产品数量:%@件",model.productCount];
    self.orderNumLab.text = [NSString stringWithFormat:@"订单号:%@",model.bizOrderId];
    
}
@end
