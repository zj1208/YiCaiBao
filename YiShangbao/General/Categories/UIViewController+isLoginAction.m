//
//  UIViewController+isLoginAction.m
//  YiShangbao
//
//  Created by simon on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "UIViewController+isLoginAction.h"

@implementation UIViewController (isLoginAction)


- (BOOL)xm_performIsLoginActionWithPopAlertView:(BOOL)flag
{
    return [self xm_performActionWithIsLogin:ISLOGIN withPopAlertView:flag];
}

@end
