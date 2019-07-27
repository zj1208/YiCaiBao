//
//  CCVideoPlayerView.m
//  SortOut
//
//  Created by light on 2017/11/16.
//  Copyright © 2017年 light. All rights reserved.
//

#import "CCVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>

#import <Masonry/Masonry.h>

#define CCScreenWidth   [UIScreen mainScreen].bounds.size.width
#define CCScreenHeight  [UIScreen mainScreen].bounds.size.height
#define CCStatusBarHeight [UIApplication sharedApplication].statusBarFrame.size.height
static const CGFloat CCPlayerToolBarHeight = 30;

@interface CCVideoPlayerView(){
    TouchPlayerViewMode _touchMode;
    BOOL _isIntoBackground; // 是否在后台
    BOOL _isSliding; // 是否正在滑动
    id _playTimeObserver; // 观察者
    BOOL _isPlaying;
    BOOL _isAllScreen;//全屏
    CGSize _playerViewSize;
    CGSize _superViewSize;
}

// 是否横屏
@property (nonatomic, assign) BOOL isLandscape;
// 是否锁屏
@property (nonatomic, assign) BOOL isLock;


@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) UIView *playerView;

@property (nonatomic, strong) UIView *toolBarView;
@property (nonatomic, strong) UIProgressView *bufferProgressView;
@property (nonatomic, strong) UISlider *playerProgressSlider;
@property (nonatomic, strong) UILabel *currentTimeLabel;
@property (nonatomic, strong) UILabel *totalTimeLabel;

@property (nonatomic, strong) UIButton *playerButton;

@end

@implementation CCVideoPlayerView

#pragma mark -lifeCircle

+ (instancetype)shareInstance {
    static CCVideoPlayerView *videoPlayView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        videoPlayView = [[self alloc] init];
    });
    return videoPlayView;
}

- (instancetype)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    [self creatUI];
    [self hidePlayerToolView];
    return self;
}

- (void)dealloc {
    [self removeObserve];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeObserve {
    [self.player replaceCurrentItemWithPlayerItem:nil];
    @try {
        [self.playerItem removeObserver:self forKeyPath:@"status" context:@"status"];
        [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:@"loadedTimeRanges"];
        [self.playerItem removeObserver:self forKeyPath:@"playbackBufferEmpty" context:nil];
        [self.playerItem removeObserver:self forKeyPath:@"playbackLikelyToKeepUp" context:nil];
    }
    @catch (NSException *exception) {
        //用于拦截多次注销监听
        NSLog(@"多次删除了");
    }
    [self.player removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    [super willMoveToSuperview:newSuperview];
    [self.playerView.layer addSublayer:self.playerLayer];
    
//    if (_playerViewSize.width > 0) {
//        self.frame = CGRectMake(0, CCStatusBarHeight, newSuperview.frame.size.width, _playerViewSize.height/_playerViewSize.width*newSuperview.frame.size.width);
//    }else{
        self.frame = newSuperview.bounds;
//    }
}

- (void)freePlayer{
    [self.player pause];
    [self.playerItem cancelPendingSeeks];
    [self.playerItem.asset cancelLoading];

    [self removeObserve];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.player replaceCurrentItemWithPlayerItem:nil];
    [self.playerLayer removeFromSuperlayer];
    self.playerLayer = nil;
    self.player = nil;
    self.playerItem = nil;
    _playerViewSize = CGSizeZero;
    
    //数据重置
    [self.bufferProgressView setProgress:0 animated:YES];
    self.playerProgressSlider.value = 0;
    self.currentTimeLabel.text = [self convertTime:0];
    self.totalTimeLabel.text = [self convertTime:0];
}

#pragma mark -Player功能行为
// 传入视频地址
- (void)updatePlayerWithURL:(NSURL *)url{
    [self freePlayer];
//    url = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
    self.player = [[AVPlayer alloc] init];
    self.playerItem = [AVPlayerItem playerItemWithURL:url];
    [self.player replaceCurrentItemWithPlayerItem:self.playerItem];
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    //设置模式
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    self.playerLayer.contentsScale = [UIScreen mainScreen].scale;
    self.playerLayer.frame = self.playerView.frame;
    [self.playerView.layer addSublayer:self.playerLayer];

    [self addObserverAndNotification];
    
}

- (void)updatePlayerSize:(CGSize)size{
    _superViewSize = size;
}

- (void)playOrStopAction:(id)sender {
    if (_isPlaying) {
        [self pause];
    } else {
        [self play];
    }
    [self inspectorViewShow];
}

- (void)enterForegroundNotification{
    [self play];
}

- (void)enterBackgroundNotification{
    [self pause];
}

// 播放
- (void)play{
    _isPlaying = YES;
    [_player play];
    [self.playerButton setTitle:@"暂停" forState:UIControlStateNormal];
}

// 暂停
- (void)pause{
    _isPlaying = NO;
    [_player pause];
}

- (void)inspectorViewShow {
    if (_isPlaying) {
        [self.playerButton setTitle:@"暂停" forState:UIControlStateNormal];
    } else {
        [self.playerButton setTitle:@"播放" forState:UIControlStateNormal];
    }
}

#pragma mark- playerToolView 动画
- (void)showPlayerToolView {
    [UIView animateWithDuration:2.0 animations:^{
        self.toolBarView.hidden = NO;
    } completion:^(BOOL finished) {
        [self performSelector:@selector(hidePlayerToolView) withObject:nil afterDelay:5];
    }];
}

- (void)hidePlayerToolView {
//    [self.toolBarView.layer removeAllAnimations];
//    [UIView animateWithDuration:2.0 animations:^{
//        self.toolBarView.hidden = YES;
//    } completion:^(BOOL finished) {
//
//    }];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.playerLayer.frame = self.bounds;
}

#pragma mark- 添加观察者 、通知 、监听播放进度

- (void)addObserverAndNotification {
    [MBProgressHUD zx_showLoadingWithStatus:@"加载中" toView:self];
    [_playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:@"status"]; // 观察status属性
    [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:@"loadedTimeRanges"]; // 观察缓冲进度
    [_playerItem addObserver:self forKeyPath:@"playbackBufferEmpty" options:NSKeyValueObservingOptionNew context:nil];//监听播放的区域缓存是否为空
    [_playerItem addObserver:self forKeyPath:@"playbackLikelyToKeepUp" options:NSKeyValueObservingOptionNew context:nil];//缓存可以播放的时候调用
    [self monitoringPlayback:_playerItem]; // 监听播放
    [self addNotification]; // 添加通知
}

// 观察播放进度
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self)WeakSelf = self;
    
    // 播放进度, 每秒执行30次， CMTime 为30分之一秒
    _playTimeObserver = [_player addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        if (_touchMode != TouchPlayerViewModeHorizontal) {
            float currentPlayTime = (double)time.value*1.0/time.timescale;
            if (currentPlayTime > WeakSelf.bufferProgressView.progress * CMTimeGetSeconds(_playerItem.duration)){
                currentPlayTime = WeakSelf.bufferProgressView.progress * CMTimeGetSeconds(_playerItem.duration);
            }
//            float currentPlayTime = (double)item.currentTime.value/ item.currentTime.timescale;
            // 更新slider, 如果正在滑动则不更新
            if (_isSliding == NO) {
                [WeakSelf updateVideoSlider:currentPlayTime];
            }
        } else {
            return;
        }
    }];
}

// 更新滑动条
- (void)updateVideoSlider:(float)currentTime {
    [self.playerProgressSlider setValue:currentTime animated:YES];
    self.currentTimeLabel.text = [self convertTime:currentTime];
}

- (void)addNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
    // 前台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterForegroundNotification) name:UIApplicationWillEnterForegroundNotification object:nil];
    // 后台通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(enterBackgroundNotification) name:UIApplicationDidEnterBackgroundNotification object:nil];
}

- (void)playbackFinished:(NSNotification *)notification {
    NSLog(@"视频播放完成通知");
    _playerItem = [notification object];
    [_playerItem seekToTime:kCMTimeZero completionHandler:^(BOOL finished) {
        
    }];
    [self.playerButton setTitle:@"播放" forState:UIControlStateNormal];
    //播放完后关闭
    if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayingAllScreen:)]){
        [self.delegate isPlayingAllScreen:NO];
    }
}

- (void)playerVideSize:(AVAsset *)asset{
    NSArray *array = asset.tracks;
    CGSize videoSize = CGSizeZero;
    for (AVAssetTrack *track in array) {
        if ([track.mediaType isEqualToString:AVMediaTypeVideo]) {
            videoSize = track.naturalSize;
        }
    }
    _playerViewSize = videoSize;
}

#pragma mark- KVO PlayerStatus
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        if (_isIntoBackground) {
            return;
        } else { // 判断status 的 状态
            AVPlayerStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
            if (status == AVPlayerStatusReadyToPlay) {
                CMTime duration = item.duration; // 获取视频长度
                [self setMaxDuration:CMTimeGetSeconds(duration)];
                
                //获取视频尺寸
                [self playerVideSize:item.asset];
                [self play];
                
            } else if (status == AVPlayerStatusFailed) {
                NSLog(@"AVPlayerStatusFailed");
            } else {
                NSLog(@"AVPlayerStatusUnknown");
            }
        }
        
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        // 缓冲
        NSTimeInterval timeInterval = [self availableDurationRanges];
        NSLog(@"---------%f",timeInterval);
        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration);
        [self.bufferProgressView setProgress:timeInterval / totalDuration animated:YES];
        [MBProgressHUD zx_hideHUDForView:self];
        [self play];
    }else if ([keyPath isEqualToString:@"playbackBufferEmpty"]){
        NSLog(@"playbackBufferEmpty");
    }else if ([keyPath isEqualToString:@"playbackLikelyToKeepUp"]){
        NSLog(@"playbackLikelyToKeepUp");
    }else{
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

// 设置视频最大时间
- (void)setMaxDuration:(CGFloat)duration {
    if (!isnan(duration)) {
        self.playerProgressSlider.maximumValue = duration; // maxValue = CMGetSecond(item.duration)
        self.totalTimeLabel.text = [self convertTime:duration];
    }
}

// 已缓冲进度
- (NSTimeInterval)availableDurationRanges {
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges]; // 获取item的缓冲数组
    // discussion Returns an NSArray of NSValues containing CMTimeRanges
    
    // CMTimeRange 结构体 start duration 表示起始位置 和 持续时间
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 计算总缓冲时间 = start + duration
    return result;
}

#pragma mark- 处理点击事件
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayingAllScreen:)]){
        [self.delegate isPlayingAllScreen:NO];
    }
    _touchMode = TouchPlayerViewModeNone;
//    [self showPlayerToolView];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (_touchMode == TouchPlayerViewModeNone) {
        if (_isLandscape) { // 横屏
        } else { // 竖屏
        }
    }
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
}


#pragma mark- 进度条滑块事件

- (void)playerSliderTouchDown:(id)sender {
    [self pause];
}

// 滑动结束
- (void)playerSliderTouchUpInside:(id)sender {
    _isSliding = NO;
    [self play];
}

// 不要拖拽的时候改变， 手指抬起来后缓冲完成再改变
- (void)playerSliderValueChanged:(id)sender {
    _isSliding = YES;
    [self pause];
    
    CMTime changedTime = CMTimeMakeWithSeconds(self.playerProgressSlider.value, 30);
    NSLog(@"%.2f", self.playerProgressSlider.value);
//    [_playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
//        // 跳转完成后做某事
//    }];
    
    [_playerItem seekToTime:changedTime toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero];
}

#pragma mark- PrivateUI
- (void)creatUI{
    self.playerView = [[UIView alloc]init];
    [self addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.playerView.backgroundColor = [UIColor blackColor];
    
    self.toolBarView = [[UIView alloc]init];
    [self addSubview:self.toolBarView];
    [self.toolBarView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(CCPlayerToolBarHeight));
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self);
        }
    }];
    [self.toolBarView setBackgroundColor:[UIColor colorWithWhite:0.7 alpha:0.3]];
    
    self.playerButton = [[UIButton alloc]init];
    [self.toolBarView addSubview:self.playerButton];
    [self.playerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolBarView);
        make.centerY.equalTo(self.toolBarView);
    }];
    [self.playerButton setTitle:@"播放" forState:UIControlStateNormal];
    [self.playerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.playerButton addTarget:self action:@selector(playOrStopAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.currentTimeLabel = [[UILabel alloc]init];
    [self.toolBarView addSubview:self.currentTimeLabel];
    [self.currentTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerButton.mas_right).offset(5);
        make.centerY.equalTo(self.toolBarView);
    }];
    self.currentTimeLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    self.currentTimeLabel.text = @"0:00";
    
    UIButton *allScreenButton = [[UIButton alloc]init];
    [self.toolBarView addSubview:allScreenButton];
    [allScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.toolBarView);
        make.centerY.equalTo(self.toolBarView);
    }];
    [allScreenButton setTitle:@"关闭" forState:UIControlStateNormal];
    [allScreenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [allScreenButton addTarget:self action:@selector(rotationAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.totalTimeLabel = [[UILabel alloc]init];
    [self.toolBarView addSubview:self.totalTimeLabel];
    [self.totalTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(allScreenButton.mas_left).offset(-5);
        make.centerY.equalTo(self.toolBarView);
    }];
    self.totalTimeLabel.textColor = [UIColor colorWithWhite:0.7 alpha:0.5];
    self.totalTimeLabel.text = @"0:00";
    
    //缓冲播放条
    self.bufferProgressView = [[UIProgressView alloc]init];
    [self.toolBarView addSubview:self.bufferProgressView];
    
    self.playerProgressSlider = [[UISlider alloc] init];
    [self.toolBarView addSubview:self.playerProgressSlider];
    [self.playerProgressSlider mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(self.playerButton.mas_right).offset(60);
//        make.right.equalTo(allScreenButton.mas_left).offset(-60);
        make.left.equalTo(self.toolBarView).offset(0);
        make.right.equalTo(self.toolBarView).offset(0);
        make.centerY.equalTo(self.toolBarView);
        make.height.equalTo(@30);
    }];
    [self.playerProgressSlider addTarget:self action:@selector(playerSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.playerProgressSlider addTarget:self action:@selector(playerSliderTouchDown:) forControlEvents:UIControlEventTouchDown];
    [self.playerProgressSlider addTarget:self action:@selector(playerSliderTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.playerProgressSlider.maximumTrackTintColor = [UIColor clearColor];
    self.playerProgressSlider.minimumTrackTintColor = [UIColor clearColor];
    
    [self.bufferProgressView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.playerProgressSlider.mas_left);
        make.right.equalTo(self.playerProgressSlider.mas_right);
        make.centerY.equalTo(self.playerProgressSlider);
        make.height.equalTo(@2);
    }];
//    self.bufferProgressView.alpha = 0.5;
    self.bufferProgressView.progressTintColor = [UIColor blueColor];
    
    
    //只显示进度条
    self.playerButton.hidden = YES;
    self.currentTimeLabel.hidden = YES;
    self.totalTimeLabel.hidden = YES;
    allScreenButton.hidden = YES;
    [self.playerProgressSlider mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.toolBarView).offset(0);
        make.right.equalTo(self.toolBarView).offset(0);
        make.centerY.equalTo(self.toolBarView);
        make.height.equalTo(@30);
    }];
}

- (NSString *)convertTime:(CGFloat)second {
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    if (second / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showTimeNew = [formatter stringFromDate:date];
    return showTimeNew;
}

#pragma mark- sizeClass 横竖屏
// sizeClass 横竖屏切换时，执行
//- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
//    [super traitCollectionDidChange:previousTraitCollection];
//    // 横竖屏切换时重新添加约束
//    CGRect bounds = [UIScreen mainScreen].bounds;
//
//    if ([self isOrientationLandscape]){
//        self.frame = bounds;
//    }else{
//        self.frame = CGRectMake(0, 0, 300, 500);
//    }
//    [self setNeedsLayout];
////    [_mainView mas_remakeConstraints:^(MASConstraintMaker *make) {
////        make.top.left.equalTo(@(0));
////        make.width.equalTo(@(bounds.size.width));
////        make.height.equalTo(@(bounds.size.height));
////    }];
//    // 横竖屏判断
////    if (self.traitCollection.verticalSizeClass != UIUserInterfaceSizeClassCompact) { // 竖屏
////        self.downView.backgroundColor = self.topView.backgroundColor = [UIColor clearColor];
////        [self.rotationButton setImage:[UIImage imageNamed:@"player_fullScreen_iphone"] forState:(UIControlStateNormal)];
////    } else { // 横屏
////        self.downView.backgroundColor = self.topView.backgroundColor = RGBColor(89, 87, 90);
////        [self.rotationButton setImage:[UIImage imageNamed:@"player_window_iphone"] forState:(UIControlStateNormal)];
////
////    }
//
//    // iPhone 6s 6                      6sP  6p
//    // 竖屏情况下 compact * regular     compact * regular
//    // 横屏情况下 compact * compact     regular * compact
//    // 以 verticalClass 来判断横竖屏
//    //    NSLog(@"horizontal %ld", (long)self.traitCollection.horizontalSizeClass);
//    //    NSLog(@"vertical %ld", (long)self.traitCollection.verticalSizeClass); //
//}

#pragma mark- 横屏竖屏切换
- (void)rotationAction:(UIButton *)sender {
    _isAllScreen = !_isAllScreen;
    if (self.delegate && [self.delegate respondsToSelector:@selector(isPlayingAllScreen:)]){
        [self.delegate isPlayingAllScreen:NO];
    }
    
//    if (_isAllScreen){
//        [sender setTitle:@"小屏" forState:UIControlStateNormal];
//    }else{
//        [sender setTitle:@"全屏" forState:UIControlStateNormal];
//    }
    
//    if ([self isOrientationLandscape]) { // 如果是横屏，
//        [self forceOrientation:(UIInterfaceOrientationPortrait)]; // 切换为竖屏
//        //        [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait];
//    } else {
//        [self forceOrientation:(UIInterfaceOrientationLandscapeRight)]; // 否则，切换为横屏
//        //        [UIApplication sharedApplication] setStatusBarOrientation
//    }
//    [self availableDurationRanges];
}

- (void)forceOrientation:(UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


- (BOOL)isOrientationLandscape {
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        return YES;
    } else {
        return NO;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
