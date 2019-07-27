//
//  CCChooseVideoViewController.h
//  SortOut
//
//  Created by light on 2017/11/23.
//  Copyright © 2017年 light. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedVideo)(NSData * videoData,NSURL *playURL);

@interface CCChooseVideoViewController : UIViewController

@property (nonatomic) CGFloat maximumDuration;//秒

@property (nonatomic, copy) SelectedVideo block;

- (void)returnVideoInfo:(SelectedVideo)block;

@end

/*
 *
 CCChooseVideoViewController *chooseVideoVC = [[CCChooseVideoViewController alloc]init];
 chooseVideoVC.hidesBottomBarWhenPushed = YES;
 chooseVideoVC.maximumDuration = 20.0;
 [chooseVideoVC returnVideoInfo:^(NSData *videoData, NSURL *playURL) {}];
 [self.navigationController pushViewController:chooseVideoVC animated:YES];
 */
