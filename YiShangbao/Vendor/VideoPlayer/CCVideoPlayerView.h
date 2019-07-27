//
//  CCVideoPlayerView.h
//  SortOut
//
//  Created by light on 2017/11/16.
//  Copyright © 2017年 light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
typedef NS_ENUM(NSInteger, TouchPlayerViewMode) {
    TouchPlayerViewModeNone, // 轻触
    TouchPlayerViewModeHorizontal, // 水平滑动
    TouchPlayerViewModeUnknow, // 未知
};

@protocol CCVideoPlayerViewDelegate <NSObject>
@optional
//全屏切换
- (void)isPlayingAllScreen:(BOOL)isAllScreen;

@end

@interface CCVideoPlayerView : UIView

@property (nonatomic ,weak) id<CCVideoPlayerViewDelegate> delegate;

+ (instancetype)shareInstance;
// 传入视频地址
- (void)updatePlayerWithURL:(NSURL *)url;
//不传size将按屏幕尺寸适配
- (void)updatePlayerSize:(CGSize)size;
//清理缓存
- (void)freePlayer;
@end
