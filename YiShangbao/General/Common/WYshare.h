//
//  WYshare.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/5.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#define WYSHARE [WYshare wyshare]

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>


@interface WYshare : NSObject

+(WYshare *)wyshare;

/**
 shareSDK分享
 
 @param imageStr 图片
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
//-(void)shareSDKWithImage:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url;


/**
 自定义UI的shareSDK分享
 
 @param shareType 分享枚举
 //    SSDKPlatformSubTypeQQFriend            //qq
 //    SSDKPlatformSubTypeWechatSession       //微信好友
 //    SSDKPlatformSubTypeQZone               //空间
 //    SSDKPlatformSubTypeWechatTimeline      //微信朋友圈
 @param imageStr 图片
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
//-(void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url;
@end
