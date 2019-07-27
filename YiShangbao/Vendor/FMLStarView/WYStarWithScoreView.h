//
//  WYStarWithScoreView.h
//  YiShangbao
//
//  Created by Lance on 16/12/14.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FMLStarView.h"

@interface WYStarWithScoreView : UIView
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) FMLStarView *starView;

- (instancetype)initWithFrame:(CGRect)frame
                        score:(NSString *)score
                numberOfStars:(NSInteger)numberOfStars
                  isTouchable:(BOOL)isTouchable
                 currentScore:(CGFloat)currentScore
                   totalScore:(NSInteger)totalScore
            isFullStarLimited:(BOOL)isFullStarLimited
                        index:(NSInteger)index
                     delegate:(id)controller;
@end
