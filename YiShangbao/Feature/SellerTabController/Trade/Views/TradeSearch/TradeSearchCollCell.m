//
//  TradeSearchCollCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeSearchCollCell.h"

@implementation TradeSearchCollCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"828282"].CGColor;
    
    self.contentView.layer.cornerRadius = LCDScale_5Equal6_To6plus(12.5f);

}

@end
