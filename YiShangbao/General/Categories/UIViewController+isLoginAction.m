//
//  UIViewController+isLoginAction.m
//  YiShangbao
//
//  Created by simon on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIViewController+isLoginAction.h"

@implementation UIViewController (isLoginAction)


- (BOOL)zx_performIsLoginActionWithPopAlertView:(BOOL)flag
{
    return [self zx_performActionWithIsLogin:ISLOGIN withPopAlertView:flag];
}

@end
