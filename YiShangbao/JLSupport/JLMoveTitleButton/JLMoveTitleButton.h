//
//  JLMoveTitleButton.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//>>>>走马灯

#import <UIKit/UIKit.h>

@interface JLMoveTitleButton : UIButton

@property(nonatomic,strong)NSString* moveString;
@property (nonatomic, strong) UIColor *labelColor;
/**当title长度超过JLMoveTitleButton宽度时，两个label之间的间隙*/
@property(nonatomic,assign)CGFloat twoTitleLabelClearance;
/**多少秒后启动，eg:viewWillapper调用*/
-(void)resumeJLMoveTitleButtonTimerAfterDuration:(NSTimeInterval)duration;
/**暂停,eg:viewwilldisapper调用*/
-(void)pauseJLMoveTitleButtonTimer;
@end
