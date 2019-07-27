//
//  CCVideoPlayerViewController.h
//  SortOut
//
//  Created by light on 2017/11/15.
//  Copyright © 2017年 light. All rights reserved.
//

#import <UIKit/UIKit.h>
//@class CCVideoPlayerView;
#import "CCVideoPlayerView.h"

@interface CCVideoPlayerViewController : UIViewController

@property (nonatomic, strong) CCVideoPlayerView *videoPlayerView;

@property (nonatomic ,weak) id delegate;

- (void)updatePlayerWithURL:(NSString *)url;

@end

/*
 *
 CCVideoPlayerViewController *playerViewVC = [[CCVideoPlayerViewController alloc]init];
 [playerViewVC updatePlayerWithURL:@"file:///var/mobile/Media/DCIM/100APPLE/IMG_0515.MOV"];
 [self presentViewController:playerViewVC animated:YES completion:nil];
 
 */
