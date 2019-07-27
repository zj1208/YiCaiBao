
//
//  WYStarWithScoreView.m
//  YiShangbao
//
//  Created by Lance on 16/12/14.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYStarWithScoreView.h"

@implementation WYStarWithScoreView

- (instancetype)initWithFrame:(CGRect)frame
                        score:(NSString *)score
                numberOfStars:(NSInteger)numberOfStars
                  isTouchable:(BOOL)isTouchable
                 currentScore:(CGFloat)currentScore
                   totalScore:(NSInteger)totalScore
            isFullStarLimited:(BOOL)isFullStarLimited
                        index:(NSInteger)index
                     delegate:(id)controller {
    if (self = [super initWithFrame:frame]) {
        
        _starView = [[FMLStarView alloc] initWithFrame:CGRectMake(0, 0, 80, 12)
                                         numberOfStars:numberOfStars
                                           isTouchable:isTouchable
                                                 index:index];
        _starView.currentScore = currentScore;
        _starView.totalScore = totalScore;
        _starView.isFullStarLimited = isFullStarLimited;
        _starView.delegate = controller;
        [self addSubview:_starView];
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = [NSString  stringWithFormat:@"%@",score];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = WYUISTYLE.colorBWhite;
        _titleLabel.backgroundColor = WYUISTYLE.colorSorange;
        _titleLabel.font = [UIFont systemFontOfSize:9.0];
        _titleLabel.layer.masksToBounds =YES;
        _titleLabel.layer.cornerRadius =2.0 ;
        [self addSubview:_titleLabel];
        
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self).offset(3);
            make.left.mas_equalTo(self).offset(0);
            make.width.mas_equalTo(80);
            make.height.mas_equalTo(12);
        }];
       
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self);
            make.top.mas_equalTo(self).offset(1);
            make.left.equalTo(self.mas_left).offset(95);
            make.width.mas_equalTo(25);
        }];
        
        
        
    }
    return self;
}

@end
