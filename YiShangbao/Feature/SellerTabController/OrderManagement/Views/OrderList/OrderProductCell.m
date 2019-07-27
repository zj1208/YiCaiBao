//
//  OrderProductCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OrderProductCell.h"

@implementation OrderProductCell

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
    [self.containerView setCornerRadius:2.f borderWidth:1.f borderColor:nil];
    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_buyer)
    {
        self.refundingLab.textColor =UIColorFromRGB(245.f, 143.f, 35.f);
    }
    else
    {
        self.refundingLab.textColor = UIColorFromRGB(255.f, 84.f, 52.f);
    }
    
    [self.picImageView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    
    [self sendSubviewToBack:self.contentView];

}

- (void)setData:(id)data
{
    BaseOrderModelSub *model = (BaseOrderModelSub *)data;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.prodPic] placeholderImage:AppPlaceholderImage];
    
    self.productNameLab.text = model.prodName;
    self.skuInfoLab.text = model.skuInfo;
    self.priceLab.text = model.price;
    [self.priceLab jl_addMediumLineWithText:nil lineColor:[UIColor colorWithHexString:@"B1B1B1"]];

    self.finalPriceLab.text = model.finalPrice;
    self.priceLab.hidden =[model.price isEqualToString:model.finalPrice];
    self.quantityLab.text = [NSString stringWithFormat:@"×%@",model.quantity];
    
    self.refundingLab.text = [model.storage objectForKey:@"status"];
}
@end
