//
//  UIButton+Common.m
//  YiShangbao
//
//  Created by 何可 on 2017/3/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIButton+Common.h"

@implementation UIButton (Common)
+ (instancetype)buttonWithBackgrouneColor:(UIColor *)bgcolor AndTintColor:(UIColor *)tintcolor AndTitle:(NSString *)title AndFont:(UIFont *)font{
    UIButton *button = [[self alloc]init];
    button.backgroundColor=bgcolor;
    [button setTintColor:tintcolor];
    [button setTitleColor:tintcolor forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    [button.titleLabel setFont:font];
    return button;
}
@end
