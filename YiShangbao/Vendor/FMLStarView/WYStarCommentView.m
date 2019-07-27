//
//  WYStarCommentView.m
//  YiShangbao
//
//  Created by Lance on 16/12/14.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYStarCommentView.h"

@implementation WYStarCommentView

- (instancetype)initWithFrame:(CGRect)frame
                        title:(NSString *)title
                numberOfStars:(NSInteger)numberOfStars
                  isTouchable:(BOOL)isTouchable
                 currentScore:(NSInteger)currentScore
                   totalScore:(NSInteger)totalScore
            isFullStarLimited:(BOOL)isFullStarLimited
                        index:(NSInteger)index
                     delegate:(id)controller {
    if (self = [super initWithFrame:frame]) {
        
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.text = title;
        _titleLabel.textColor = WYUISTYLE.colorLTgrey;
        _titleLabel.font = [UIFont systemFontOfSize:14.0];
        [self addSubview:_titleLabel];
        
        _starView = [[FMLStarView alloc] initWithFrame:CGRectMake(0, 0, 150, 25)
                                         numberOfStars:numberOfStars
                                           isTouchable:YES
                                                 index:index];
        _starView.currentScore = currentScore;
        _starView.totalScore = totalScore;
        _starView.isFullStarLimited = isFullStarLimited;
        _starView.delegate = controller;
        [self addSubview:_starView];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.mas_equalTo(self);
            make.right.mas_greaterThanOrEqualTo(_starView).offset(0);
        }];
        
        [_starView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(self.mas_centerY);
            make.right.mas_equalTo(self).offset(0);
            make.width.mas_equalTo(150);
            make.height.mas_equalTo(25);
        }];
        
    }
    return self;
}


@end
