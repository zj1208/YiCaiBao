//
//  SJVideoInfoEditingViewController.h
//  SJRecordVideo
//
//  Created by BlueDancer on 2017/8/3.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SJRecordVideoEnumHeader.h"

@class AVAsset;
@interface SJVideoInfoEditingViewController : UIViewController

typedef void (^SelectVideo)(BOOL isSelected);
@property (nonatomic, copy)SelectVideo block;

@property (nonatomic, strong, readwrite) UIImage *coverImage;

- (instancetype)initWithAsset:(AVAsset *)asset direction:(SJScreenOrientation)direction;

@end
