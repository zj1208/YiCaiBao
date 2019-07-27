//
//  WYShareLinkmanViewController.h
//  YiShangbao
//
//  Created by light on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYShareLinkmanViewController : UIViewController

/**

 分享
 
 @param imageStr 图片
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
-(void)shareWithImage:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url;

@end
