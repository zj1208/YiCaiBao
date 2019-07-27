//
//  TradeDetailSecondCell.m
//  YiShangbao
//
//  Created by simon on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeDetailSecondCell.h"

@implementation TradeDetailSecondCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.backgroundColor = [UIColor clearColor];
    }];
    self.lineView.backgroundColor =UIColorFromRGB(238.f, 238.f, 238.f);
    
}

- (void)setData:(id)data
{
    TradeDetailModel *model = (TradeDetailModel *)data;
    self.deliveryTimeLab.text = model.deliveryTime;
    self.needCountLab.text = model.needCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
