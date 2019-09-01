//
//  AppHeader.h
//  
//
//  Created by simon on 15/6/17.
//  Copyright (c) 2015年 simon. All rights reserved.
//

#ifndef douniwan_AppHeader_h
#define douniwan_AppHeader_h
#import "StoryboardHeader.h"
#import "NotificationMarco.h"
#import "UMAnalyticsViewMarco.h"


#pragma mark - 美颜拼图AppleID
#define kAPPID  @"1180821282" //义采宝
//#define kAPPID  @"1177018574"


#pragma mark - JPush

static NSString *const kJPushAppKey = @"87245d848bf02bbd239b59af";
static NSInteger const kHTTP_minPageSize = 5;

#pragma mark- 比盟

//思春堂
//static NSString *const kBMOB_APPID =  @"85f8f27eba2da26d5076df7114dae422"

//美颜拼图

static NSString *const kBMOB_APPID =  @"69c52eeb7424886debae08af8dad3e2f";


#pragma mark - 占位图以及头像头

//义采宝
#define AppPlaceholderImage [UIImage imageNamed:@"默认图正方形"]
//#define AppPlaceholderImage [UIImage zx_imageWithColor:UIColorFromRGB(229., 229., 229.) andSize:CGSizeMake(200, 200)]
//人头像
#define AppPlaceholderHeadImage [UIImage imageNamed:@"ic_empty_person"]
//商铺空头像
#define AppPlaceholderShopImage [UIImage imageNamed:@"ic_empty_shop"]
#define AppPlaceholderMainWidthImage [UIImage imageNamed:@"yicaibao.jpg"]
//采购商首页轮播占位图
#define AppPlaceholderLunboImage [UIImage imageNamed:@"pic_morentu_caigouduan"]
//分类轮播占位图
#define AppPlaceholderFenLeiImage [UIImage imageNamed:@"search_fenleiplo"]

//是否是iphoneX
#ifndef  IS_IPHONE_X
#define  IS_IPHONE_X        (LCDW == 375.f && LCDH == 812.f ? YES : NO)
#endif

//是否是刘海屏X系列
#ifndef  IS_IPHONE_XXX
#define  IS_IPHONE_XXX      ([WYUtility is_Iphone_XX])
#endif

//状态栏高度（若状态栏隐藏则高度为0）
#ifndef  HEIGHT_STATEBAR
#define  HEIGHT_STATEBAR     ([[UIApplication sharedApplication] statusBarFrame].size.height)
#endif

#ifndef  HEIGHT_NAVBAR
#define  HEIGHT_NAVBAR       (44.f+HEIGHT_STATEBAR)
#endif

#ifndef  HEIGHT_TABBAR_SAFE
#define  HEIGHT_TABBAR_SAFE  ([WYUtility safeAreaInsets_Bottom])
#endif

#ifndef  HEIGHT_TABBAR
#define  HEIGHT_TABBAR       (49.f+HEIGHT_TABBAR_SAFE)
#endif





/*
 
#pragma mark -QiniuImageView2

//限定缩略图的长边最多为<750>，进行等比缩放，不裁剪；主要用于宽度等于整个屏幕宽度的图片
static NSString *const kQINIU_IMAGEPATH_500_X = @"?imageView2/0/w/750/q/75";

//限定缩略图的宽最少为<200>，高最少为<200>，进行等比缩放，居中裁剪 正方形缩略小图；
static NSString *const kQINIU_IMAGEPATH_200_200 = @"?imageView2/1/w/200/h/200";

//限定缩略图的长边最多为<1000>，短边自适应，进行等比缩放，不裁剪。用于显示整个屏幕大小的大图，显示图片原图等；
static NSString *const kQINIU_IMAGEPATH_1000_X =@"?imageView2/0/w/1000/q/75";

//限定缩略图的长边最多为<400>，短边最多300，进行等比缩放，不裁剪。用于瀑布流列表显示1/2屏幕宽度的图片；
static NSString *const kQINIU_IMAGEPATH_W400_H300 =@"?imageView2/0/w/400/h/300";
*/



#endif
