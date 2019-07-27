//
//  CCVideoCollectionViewCell.h
//  SortOut
//
//  Created by light on 2017/11/24.
//  Copyright © 2017年 light. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

@interface CCVideoModel : NSObject
@property (nonatomic ,strong) PHAsset *phAsset;
@property (nonatomic ,strong) AVURLAsset *urlAsset;
@property (nonatomic ,strong) UIImage *image;
@property (nonatomic ,strong) NSString *time;

@end

extern NSString * const CCVideoCollectionViewCellID;

@interface CCVideoCollectionViewCell : UICollectionViewCell

@property (nonatomic ,strong) AVURLAsset *urlAsset;
@property (nonatomic ,strong) NSData *imageData;

- (instancetype)initWithFrame:(CGRect)frame;
- (void)updateData:(id)model;

@end
