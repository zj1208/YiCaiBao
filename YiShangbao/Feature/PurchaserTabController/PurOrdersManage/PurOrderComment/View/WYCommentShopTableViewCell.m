//
//  WYCommentShopTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYCommentShopTableViewCell.h"

@interface WYCommentShopTableViewCell ()<JLStartViewDelegate>

@end
@implementation WYCommentShopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _servicestartView.isCanZero = NO;
    _servicestartView.delegate = self;
    _servicestartView.tag = 3000;

    _velocityStartView.isCanZero = NO;
    _velocityStartView.delegate = self;
    _velocityStartView.tag = 4000;

}
-(void)jl_JLStartView:(JLStartView *)JLStartView didClcikWithScore:(NSInteger)score
{
    if (self.startTitleList.count>4) {
        if (JLStartView.tag == 3000) {
            self.startServiceDescLabel.text = self.startTitleList[score-1];
        }
        if (JLStartView.tag == 4000) {
            self.startVelocDescLabel.text = self.startTitleList[score-1];
        }
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_WYCommentShopTableViewCell:serviceStart:velocityStart:)]) {
        
        [self.delegate jl_WYCommentShopTableViewCell:self serviceStart:[NSString stringWithFormat:@"%ld",(NSInteger)_servicestartView.curryScore]  velocityStart:[NSString stringWithFormat:@"%ld",(NSInteger)_velocityStartView.curryScore] ];
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
