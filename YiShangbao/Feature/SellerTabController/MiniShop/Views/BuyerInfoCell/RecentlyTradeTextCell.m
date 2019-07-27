//
//  RecentlyTradeTextCell.m
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RecentlyTradeTextCell.h"

@implementation RecentlyTradeTextCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setData:(id)data
{
    RecentlyBizsModel *model = (RecentlyBizsModel *)data;
    self.titleLab.text = [NSString stringWithFormat:@"求购:%@",[data productName]];
    self.timeLab.text = [model createTime];
}
@end
