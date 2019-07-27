//
//  UIView+ZJExtension.m
//  MobileApplicationPlatform
//
//  Created by administrator on 16-7-3.
//  Copyright (c) 2016年 HCMAP. All rights reserved.
//

#import "UIView+ZJExtension.h"

@implementation UIView (ZJExtension)

//X
-(CGFloat)x
{
    return self.frame.origin.x;
}
-(void)setX:(CGFloat)x
{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


//Y
-(CGFloat)y
{
    return self.frame.origin.y;
}
-(void)setY:(CGFloat)y
{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

//宽度
-(CGFloat)width
{
    return  self.frame.size.width;
}

-(void)setWidth:(CGFloat)width
{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


//高度
-(CGFloat)height
{
    return  self.frame.size.height;
}

-(void)setHeight:(CGFloat)height
{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

//中心X
-(CGFloat)centerX
{
    return  self.center.x;
}

-(void)setCenterX:(CGFloat)centerX
{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

//中心点Y
-(CGFloat)centerY
{
    return  self.center.y;
}

-(void)setCenterY:(CGFloat)centerY
{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}
@end
