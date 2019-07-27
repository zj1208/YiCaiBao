//
//  APPriceSelectCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "APPriceSelectCell.h"

@implementation APPriceSelectCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)priceBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.negotiableBtn.selected = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_APPriceSelectCell:setPriceBtnSelectedChanged:)]) {
        [self.delegate jl_APPriceSelectCell:self setPriceBtnSelectedChanged:YES];
    }
}
- (IBAction)negotiableBtnClick:(UIButton *)sender {
    sender.selected = YES;
    self.priceBtn.selected = NO;
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_APPriceSelectCell:setPriceBtnSelectedChanged:)]) {
        [self.delegate jl_APPriceSelectCell:self setPriceBtnSelectedChanged:NO];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
