//
//  NTESProductMessageView.h
//  YiShangbao
//
//  Created by light on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <NIMKit/NIMKit.h>

@interface NTESProductMessageView : NIMSessionMessageContentView

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *priceLabel;

@property (nonatomic, strong) UIButton *button;

@end
