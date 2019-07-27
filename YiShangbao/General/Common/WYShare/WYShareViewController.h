//
//  WYShareViewController.h
//  YiShangbao
//
//  Created by light on 2018/4/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#define WYShareManager [WYShareViewController shareManeger]

#import <UIKit/UIKit.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

typedef NS_ENUM(NSInteger, WYShareType) {
    WYShareTypeNot                  = 0,//没有分享状态
    WYShareTypeHotProduct           = (1 << 0),//热销产品
    WYShareTypeStock                = (1 << 1),//库存收购
    WYShareTypeCopyLink             = (1 << 2),//复制链接
    WYShareTypeCustomers            = (1 << 3),//义采宝客户
    WYShareTypeWechatSession        = (1 << 4),//微信好友
    WYShareTypeWechatCircle         = (1 << 5),//朋友圈
    WYShareTypeQQ                   = (1 << 6),//QQ
    WYShareTypeQQZone               = (1 << 7),//QQ空间
};

typedef void (^WYShareTypeBlock)(WYShareType type);

@interface WYShareViewController : UIViewController
//可以APP内部分享block回调
- (void)canPushInAPPWithShareType:(WYShareTypeBlock)block;

+ (WYShareViewController *)shareManeger;

- (void)showIn:(UIViewController *)viewController;

/**
 shareSDK分享
 
 @param imageStr 图片url
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
-(void)shareDataWithImage:(NSString *)imageStr withTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)url;

/**
 shareSDK分享
 
 @param viewController 需要展示VC
 @param imageStr 图片url
 @param title 分享标题
 @param content 分享内容
 @param url 分享url
 */
-(void)shareInVC:(UIViewController *)viewController withImage:(NSString *)imageStr withTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)url;

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
-(void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url;
//不编码，目前只用于开单预览的分享微信好友-单独copy不影响其他地方
//encodedUrl 已编码完成不需要对URL再编码的url
- (void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withPercentEncodedUrl:(NSString *)encodedUrl;

/**
 WYShareManager 使用
 
[WYShareManager showIn:self];  //self 为需要展示ViewController
[WYShareManager shareDataWithImage:@"" Title:@"" Content:@"" withUrl:@""]; //分享内容
 
[WYShareManager shareInVC:viewController withImage:imageStr withTitle:title withContent:content withUrl:url];
 
[WYShareManager canPushInAPPWithShareType:^(WYShareType type) {  //分享时热销产品、库存收购回调
    NSLog(@"-----%ld",type);
}];

 
 WYShareTypeHotProduct           = (1 << 0),//热销产品
 WYShareTypeStock                = (1 << 1),//库存收购
 
 
 [WYShareManager shareSDKWithShareType:shareType Image:self.shareimageStr Title:self.sharetitle Content:self.sharecontent withUrl:self.shareUrl];
 //可以直接使用以前分享方法 ,直接分享 不使用UI
 */
@end
