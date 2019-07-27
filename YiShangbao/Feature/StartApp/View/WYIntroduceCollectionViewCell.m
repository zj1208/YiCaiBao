//
//  WYIntroduceCollectionViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYIntroduceCollectionViewCell.h"

@implementation WYIntroduceCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imageView];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return self;
}

@end
