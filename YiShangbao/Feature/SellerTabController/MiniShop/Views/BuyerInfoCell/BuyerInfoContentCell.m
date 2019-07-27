//
//  BuyerInfoContentCell.m
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BuyerInfoContentCell.h"

@implementation BuyerInfoContentCell

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
    self.productNameLab.text = @"未知";

}

- (void)setData:(id)data
{
    ShopPurchaserInfoModel *model = (ShopPurchaserInfoModel *)data;

    self.cityLab.text = ![NSString zhIsBlankString:[data locationName]]?[data locationName]:@"未知";
    if (model.buyProducts.count>0)
    {
        NSString * productStr = [model.buyProducts componentsJoinedByString:@","];
        self.productNameLab.text = productStr;
    }
    //
    self.sourceLab.text =![NSString zhIsBlankString:[data source]]?[data source]:nil;
    self.sourceContainerView.hidden = !self.sourceLab.text;

    self.briefLab.text = ![NSString zhIsBlankString:[data intro]]?[data intro]:@"未知";
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    

}

- (void)updateConstraints
{
    [super updateConstraints];
    //即使改变了容器高度，如果有显示文字的，你还要隐藏容器才行；
    if ([NSString zhIsBlankString:self.sourceLab.text])
    {
        [self.sourceContainerView  mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(@0);
            
        }];
    }
    else
    {
        
    }

}
@end
