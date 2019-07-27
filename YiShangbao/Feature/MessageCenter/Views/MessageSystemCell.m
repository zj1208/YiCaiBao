//
//  MessageSystemCell.m
//  YiShangbao
//
//  Created by simon on 2017/12/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageSystemCell.h"
#define ContentWidth LCDW-60

@implementation MessageSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    
    self.titleLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(17)];
    self.descLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
    self.topTimeLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(11)];
    [self.topTimeLab setCornerRadius:4.f borderWidth:0.f borderColor:nil];
}

- (void)setData:(id)data
{
    MessageDetailModel *model = (MessageDetailModel *)data;
    self.topTimeLab.text = model.date;
    self.titleLab.text = model.title;
    self.descLab.text =model.abbr ;
}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    MessageDetailModel *model = (MessageDetailModel *)data;

    [self.titleLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.titleLab layoutIfNeeded];
    
    [self.descLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.descLab layoutIfNeeded];

    self.titleLab.text = model.title;
    self.descLab.text = model.abbr;

    [self.contentView layoutIfNeeded];
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = size.height+1.0f;
    return height;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
