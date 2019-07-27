//
//  NTESProductPriceContentView.h
//  YiShangbao
//
//  Created by simon on 2018/5/18.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <NIMKit/NIMKit.h>
#import "NIMKitEvent.h"

@interface NTESProductPriceContentView : NIMSessionMessageContentView

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel *describeLab;

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *lineView;

//点击查看详情
@property (nonatomic, strong) UILabel *detailLab;

@property (nonatomic, strong) UIImageView *rowImgView;


@end
