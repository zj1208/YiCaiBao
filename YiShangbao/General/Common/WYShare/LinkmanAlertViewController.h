//
//  LinkmanAlertViewController.h
//  YiShangbao
//
//  Created by light on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LinkmanAlertViewController;

typedef void (^SendSuccessBlock)(void);

@interface LinkmanAlertViewController : UIViewController

@property (nonatomic, copy) SendSuccessBlock sendSuccessBlock;

- (void)showIn:(UIViewController *)viewController;

/**
 
 分享
 
 @param imageStr 图片
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
-(void)shareToUsers:(NSArray *)users image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url;

- (void)close;

@end
