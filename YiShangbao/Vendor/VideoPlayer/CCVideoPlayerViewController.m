//
//  CCVideoPlayerViewController.m
//  SortOut
//
//  Created by light on 2017/11/15.
//  Copyright © 2017年 light. All rights reserved.
//

#import "CCVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

//#import "CCVideoPlayerView.h"

@interface CCVideoPlayerViewController ()<CCVideoPlayerViewDelegate>

@property (nonatomic, strong) MPMoviePlayerController *moviePlayer;
@property (nonatomic, strong) UIView *playerView1;
@end

@implementation CCVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self updatePlayerWithURL:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
//    [self.videoPlayerView updatePlayerWithURL:[NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"]];
//    [self.view addSubview:self.videoPlayerView];
    
//
//    NSURL* url = [NSURL URLWithString:@"http://bos.nj.bpc.baidu.com/tieba-smallvideo/11772_3c435014fb2dd9a5fd56a57cc369f6a0.mp4"];
//    _moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:url];
//    [self.view addSubview:_moviePlayer.view];
//
//    _moviePlayer.view.frame=CGRectMake(0, 0, self.view.frame.size.width, CGRectGetWidth(self.view.frame)*(9.0/16.0));
//    [_moviePlayer prepareToPlay];
//    [_moviePlayer play];
    
    
    // Do any additional setup after loading the view.
}

- (void)dealloc{
    [self.videoPlayerView freePlayer];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.playerView1 = self.videoPlayerView.superview;
    [self.view addSubview:self.videoPlayerView];
}

- (void)updatePlayerWithURL:(NSString *)url{
//    [self.videoPlayerView updatePlayerWithURL:[NSURL fileURLWithPath:url]];
    [self.videoPlayerView updatePlayerWithURL:[NSURL URLWithString:url]];
}

#pragma mark- CCVideoPlayerViewDelegate
- (void)isPlayingAllScreen:(BOOL)isAllScreen{
    if (isAllScreen) {
        if (_delegate) {
            [_delegate presentViewController:self animated:YES completion:nil];
        }
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
        [self.playerView1 addSubview:self.videoPlayerView];
    }
}

#pragma mark- Getter
- (CCVideoPlayerView *)videoPlayerView{
    if (!_videoPlayerView) {
        _videoPlayerView = [CCVideoPlayerView shareInstance];
        _videoPlayerView.delegate = self;
    }
    return _videoPlayerView;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
