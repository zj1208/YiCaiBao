//
//  AppDelegate.h
//  YiShangbao
//
//  Created by Lance on 16/12/1.
//  Copyright © 2016年 Lance. All rights reserved.
//

#import <UIKit/UIKit.h>
//微信SDK头文件
#import "WXApi.h"

@protocol WXDelegate <NSObject>
-(void)loginSuccessByCode:(NSString *)code;
@end


@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, weak) id<WXDelegate> wxDelegate;


@end


//1、市场内和市场外商户都存在认证权限限制：
//（1）无论是市场内商户还是市场外商户，如果没有进行认证则都会受到   接生意1条／月，推产品4条／月，清库存4条／月 的限制；
//（2）认证成功之后才可以解除限制

