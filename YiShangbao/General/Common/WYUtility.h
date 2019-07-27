//
//  WYUtility.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/27.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#define WYUTILITY [WYUtility dataUtil]



#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

@interface WYUtility : NSObject

+ (WYUtility *)dataUtil;

/**
 WY背景渐变的图片获取

 @param size 图片大小
 @return image
 */
- (UIImage *)getCommonRedGradientImageWithSize:(CGSize)size;

//接生意
- (UIImage *)getCommonVersion2RedGradientImageWithSize:(CGSize)size;
- (UIImage *)getCommonVersion2GreenGradientImageWithSize:(CGSize)size;
//接生意导航栏
- (UIImage *)getCommonNavigationBarRedGradientImageWithSize:(CGSize)size;
//市场服务导航栏
- (UIImage*)getCommonNavigationBarMarketServiceImageWithSize:(CGSize)size;
//推广导航栏自定义分段控件背景图
- (UIImage *)getTitleViewRedGradientImageWithSize:(CGSize)size;

//采购段首页导航渐变图
- (UIImage *)getPurBarImageWithSize:(CGSize)size;


- (nullable UIViewController *)previewingNewControllerViewWithRouteUrl:(NSString *)url;

//跳转(V2.0.1开始弃用)
//- (BOOL)cheackAdvURLToControllerWithSoureController:(UINavigationController *)nav advUrlString:(NSString *)url;

//路由跳转；name：路由地址（原生定义的路由字符串或h5地址）；
- (BOOL)routerWithName:(NSString *)name withSoureController:(UIViewController *)viewController;

/**
 判断屏幕

 @return 6p
 */
- (NSString *)getMainScreen;

/**
 图片压缩

 @param image 图片
 @param asize 压缩尺寸
 @return <#return value description#>
 */
+ (UIImage *)thumbnailWithImageWithoutScale:(UIImage *)image size:(CGSize)asize;


/**
 播放自定义声音
 */
+(void)AudioCustomSoundName:(NSString *)name;

/**
 播放系统声音
 */
+(void)AudioSystemSound;

-(NSString *)iphoneType;






/**
 图片处理

 @param sourceImage 需要处理的图片
 @return 图片流
 */
+(NSData *)zipNSDataWithImage:(UIImage *)sourceImage;



/**
 判断是否是刘海屏X系列
 */
+(BOOL)is_Iphone_XX;
/**
 获取安全区底部高度(iOS11一下返回0.0)
 */
+(CGFloat)safeAreaInsets_Bottom;

@end
