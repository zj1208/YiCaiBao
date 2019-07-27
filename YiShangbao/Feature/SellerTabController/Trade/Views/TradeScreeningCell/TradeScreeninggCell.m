//
//  TradeScreeninggCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/10/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeScreeninggCell.h"

@implementation TradeScreeninggCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCurryStyle:(TopSelTypeTableViewCellType)curryStyle
{
    _curryStyle = curryStyle;
    if (self.curryStyle == 0) {
        self.selLabel.hidden = YES;
        self.noLabel.hidden = NO;
        self.imV.hidden = YES;
    }else if (self.curryStyle == 1){
        self.selLabel.hidden = NO;
        self.noLabel.hidden = YES;
        self.imV.hidden = NO;
    }
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
