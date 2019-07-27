//
//  TradeDetailRowCell.m
//  YiShangbao
//
//  Created by simon on 17/4/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeDetailRowCell.h"

@implementation TradeDetailRowCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

//- (void)setTextLab:(id)data1 detailLab:(id)data2
//{
//    _textLab.text = data1;
//    _detailLab.text
//}

- (void)awakeFromNib
{
    [super awakeFromNib];

    [self setNeedsLayout];
    
    [self.contentView.subviews enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.backgroundColor = [UIColor clearColor];
    }];
    
    self.lineView.backgroundColor = WYUISTYLE.colorLineBGgrey;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = UIColorFromRGB_HexValue(0xD9D9D9);
    [self.contentView addSubview:line];
    self.lengthLineView = line;
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
       
        make.height.mas_equalTo(0.5);
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(0);
        make.left.mas_equalTo(self.contentView.mas_left).offset(0);
        make.right.mas_equalTo(self.contentView.mas_right).offset(0);
    }];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}
@end
