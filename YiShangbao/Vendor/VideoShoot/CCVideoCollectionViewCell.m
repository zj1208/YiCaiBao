//
//  CCVideoCollectionViewCell.m
//  SortOut
//
//  Created by light on 2017/11/24.
//  Copyright © 2017年 light. All rights reserved.
//

#import "CCVideoCollectionViewCell.h"
#import <Masonry/Masonry.h>
#import <Photos/Photos.h>

NSString * const CCVideoCollectionViewCellID = @"CCVideoCollectionViewCellID";

@implementation CCVideoModel

@end

@interface CCVideoCollectionViewCell ()

@property (nonatomic ,strong) UIImageView *imageView;
@property (nonatomic ,strong) UIView *bottomBackView;
@property (nonatomic ,strong) UILabel *timeLabel;

@property (nonatomic ,strong) CCVideoModel *assetModel;

@end

@implementation CCVideoCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    self.imageView = [[UIImageView alloc]init];
    [self.contentView addSubview:self.imageView];
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.clipsToBounds = YES;
    
    self.bottomBackView = [[UIView alloc]init];
    [self.contentView addSubview:self.bottomBackView];
    [self.bottomBackView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@20);
    }];
    
    self.timeLabel = [[UILabel alloc]init];
    [self.bottomBackView addSubview:self.timeLabel];
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.bottomBackView).offset(-5);
        make.centerY.equalTo(self.bottomBackView);
    }];
    self.timeLabel.font = [UIFont systemFontOfSize:13.0];
    self.timeLabel.textColor = [UIColor whiteColor];
    
    [self graduallyColor];
    return self;
}

//- (void)updateData:(CCVideoModel *)model{
//    if (!model) {
//        self.bottomBackView.hidden = YES;
//
//        return;
//    }
//    self.bottomBackView.hidden = NO;
//    AVURLAsset *urlAsset = (AVURLAsset *)model.urlAsset;
//    CMTime duration = urlAsset.duration;
//    self.timeLabel.text = [self convertTime:CMTimeGetSeconds(duration)];
//    if (!model.image){
//        model.image = [self creatImageByUrl:model.urlAsset.URL];
//    }
//    [self.imageView setImage:model.image];
//}

- (void)updateData:(CCVideoModel *)model{
    if (!model) {
        self.bottomBackView.hidden = YES;
        [self.imageView setImage:[UIImage imageNamed:@"CCVideo.bundle/CCPlayVideo"]];
        return;
    }
    //默认
    [self.imageView setImage:[UIImage imageNamed:@"CCVideo.bundle/CCDefaultVideo"]];
    self.timeLabel.text = @"00:00";
    
    self.assetModel = model;
    self.bottomBackView.hidden = NO;
    if (model.image && model.time && model.urlAsset) {
        [self.imageView setImage:model.image];
        self.timeLabel.text = model.time;
        self.urlAsset = model.urlAsset;
    }else{
        PHVideoRequestOptions *videoOptions = [[PHVideoRequestOptions alloc] init];
        videoOptions.version = PHVideoRequestOptionsVersionOriginal;
        videoOptions.deliveryMode = PHVideoRequestOptionsDeliveryModeAutomatic;
        videoOptions.networkAccessAllowed = YES;
        [[PHImageManager defaultManager]requestAVAssetForVideo:model.phAsset options:videoOptions resultHandler:^(AVAsset * _Nullable asset, AVAudioMix * _Nullable audioMix, NSDictionary * _Nullable info) {
            AVURLAsset *urlAsset = (AVURLAsset *)asset;
            self.urlAsset = urlAsset;
            [self creatImageAndTimeByAsset:urlAsset];
            
        }];
    }
    
//    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
//    imageOptions.version = PHImageRequestOptionsVersionCurrent;
//    imageOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
//    imageOptions.synchronous = YES;
//    [[PHImageManager defaultManager] requestImageDataForAsset:model options:imageOptions resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
//        self.imageData = imageData;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [self.imageView setImage:[UIImage imageWithData:imageData]];
//        });
//    }];
    
    
    
}

- (void)creatImageAndTimeByAsset:(AVURLAsset *)urlAsset{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIImage *image = [self creatImageByUrl:urlAsset.URL];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.imageView setImage:image];
            CMTime duration = urlAsset.duration;
            self.timeLabel.text = [self convertTime:CMTimeGetSeconds(duration)];
            self.assetModel.image = image;
            self.assetModel.time = self.timeLabel.text;
            self.assetModel.urlAsset = urlAsset;
        });
        
    });
}

- (void)graduallyColor{
    UIColor *colorOne = [UIColor colorWithWhite:0.0 alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithWhite:0.0 alpha:1.0];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = CGRectMake(0, 0, self.bounds.size.width, 20.0);
    
    [self.bottomBackView.layer insertSublayer:headerLayer atIndex:0];
}

- (NSString *)convertTime:(CGFloat)second {
    int secondInt = round(second);
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:secondInt];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (secondInt / 3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    
    NSString *showTimeNew = [formatter stringFromDate:date];
    return showTimeNew;
}

- (UIImage *)creatImageByUrl:(NSURL *)url{
    UIImage *shotImage;
    NSURL *fileURL = url;
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
    AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    gen.appliesPreferredTrackTransform = YES;
    CMTime time = CMTimeMakeWithSeconds(0.0, 30);
    gen.maximumSize = CGSizeMake(400, 400);
    NSError *error = nil;
    CMTime actualTime;
    CGImageRef cgImage = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
    shotImage = [[UIImage alloc] initWithCGImage:cgImage];
    CGImageRelease(cgImage);
    return shotImage;
}

@end
