//
//  UIView+ZJExtension.h
//  MobileApplicationPlatform
//
//  Created by administrator on 16-7-3.
//  Copyright (c) 2016年 HCMAP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZJExtension)

/** X坐标 */
@property(assign,nonatomic)CGFloat x;
/** Y坐标 */
@property(assign,nonatomic)CGFloat y;
/** 宽度 */
@property(assign,nonatomic)CGFloat width;
/** 高度 */
@property(assign,nonatomic)CGFloat height;
//完善  两个属性  centerX  centerY
/** 中心 */
@property(assign,nonatomic)CGFloat centerX;
@property(assign,nonatomic)CGFloat centerY;
@end
