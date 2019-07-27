//
//  RefundingOrderProCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundingOrderProCell.h"

@implementation RefundingOrderProCell

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
    [self.containerView setCornerRadius:2.f borderWidth:0.5f borderColor:nil];
    [self.picImageView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    [self sendSubviewToBack:self.contentView];
}

- (void)setData:(id)data
{
    BaseOrderModelSub *model = (BaseOrderModelSub *)data;
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.prodPic] placeholderImage:AppPlaceholderImage];
    
    self.productNameLab.text = model.prodName;
    self.skuInfoLab.text = model.skuInfo;
 
}

@end
