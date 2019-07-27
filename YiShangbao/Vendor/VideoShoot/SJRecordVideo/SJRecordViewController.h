//
//  SJRecordViewController.h
//  SJRecordVideo
//
//  Created by BlueDancer on 2017/8/3.
//  Copyright © 2017年 SanJiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface SJRecordViewController : UIViewController

typedef void (^RecordVideo)(AVAsset *asset);

@property (nonatomic, copy)RecordVideo recordVideoBlock;

@end
