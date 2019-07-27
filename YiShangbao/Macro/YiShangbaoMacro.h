//
//  YiShangbaoMacro.h
//  YiShangbao
//
//  Created by Lance on 16/12/3.
//  Copyright © 2016年 Lance. All rights reserved.
//

#ifndef YiShangbaoMacro_h
#define YiShangbaoMacro_h
#import "AppMarco.h"
//#ifndef DEBUG
//# define NSLog(format, ...) NSLog((@"[文件名:%s]\n" "[函数名:%s]" "[行号:%d]" format), __FILE__, __FUNCTION__, __LINE__, ##__VA_ARGS__);
//#else
//# define NSLog(...);
//#endif

//#if DEBUG
//#define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, ［NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
//
//#else
//#define NSLog(FORMAT, ...) nil
//#endif

//-------------------获取设备大小-------------------------

//获取屏幕 宽度、高度
#define SCREEN_STATUSHEIGHT ([UIApplication sharedApplication].statusBarFrame.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define MAINTOPHEIGHT 64//导航栏+状态栏高度

//-------------------获取设备大小-------------------------

//----------------------系统----------------------------
//开屏活动图片缓存地址
#define kImageBusinessPath [NSHomeDirectory() stringByAppendingString:@"/Documents/imageBusiness.jpg"]
#define kImageBuyerPath [NSHomeDirectory() stringByAppendingString:@"/Documents/imageBuyer.jpg"]
#define kImageBusinessUrl @"kimageBusinessUrl"
#define kImageBusinessUrl_ID @"kimageBusinessUrl_id" //广告id
#define kImageBuyerUrl @"kimageBuyerUrl"
#define kImageBuyerUrl_ID @"kimageBuyerUrl_id"


#define kMSCTranslationDataPath [NSHomeDirectory() stringByAppendingString:@"/Documents/translationData.txt"]

//推送声音
#define EnableSubject @"enableSubject"
#define EnableFan @"enableFan"
#define EnableVisitor @"enableVisitor"

#define kApplication        [UIApplication sharedApplication]

#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#define kAppDelegate        [UIApplication sharedApplication].delegate

#define kUserDefaults      [NSUserDefaults standardUserDefaults]

#define kNotificationCenter [NSNotificationCenter defaultCenter]
//获取系统版本
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define CurrentSystemVersion [[UIDevice currentDevice] systemVersion]
#define isiOS7 ([[UIDevice currentDevice] systemVersion].floatValue >= 7.0 ? YES : NO)

#define SYSTEM_VERSION_EQUAL_TO(v)                  (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)    (［[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//获取当前语言
#define CurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])

//APP版本号
 #define kAppVersion [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]

//当前语言
#define kCurrentLanguage ([[NSLocale preferredLanguages] objectAtIndex:0])
//文件路径
 #define kDocumentPath [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject]//沙盒Document路径
 #define kTempPath NSTemporaryDirectory()  //temp
 #define kCachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] //沙盒Cache路径

/*------是否为空-----------------*/
 #define kStringIsEmpty(str) ([str isKindOfClass:[NSNull class]] || str == nil || [str length] < 1 ? YES : NO )
 #define kArrayIsEmpty(array) (array == nil || [array isKindOfClass:[NSNull class]] || array.count == 0)
 #define kDictIsEmpty(dic) (dic == nil || [dic isKindOfClass:[NSNull class]] || dic.allKeys == 0)

 #define kObjectIsEmpty(_object) (_object == nil \|| [_object isKindOfClass:[NSNull class]] \|| ([_object respondsToSelector:@selector(length)] && [(NSData *)_object length] == 0) \|| ([_object respondsToSelector:@selector(count)] && [(NSArray *)_object count] == 0))

//颜色
#define kRGBColor(r, g, b)    [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a]
#define kRandomColor    KRGBColor(arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0,arc4random_uniform(256)/255.0)        //随机色生成
#define kColorWithHex(rgbValue) \[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]
//单例
#define SINGLETON(_type_, _class_, _name_) \
+ (_type_)_name_ { \
static id o = nil; \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
o = [[_class_ alloc] init]; \
}); \
return o; \
}


//NSLog 根据url和dictionary 参数 打印httpURL请求地址
#ifndef ZX_NSLog_HTTPURL
#define ZX_NSLog_HTTPURL(hostURL,path, parameterDic) \
NSString *string = [NSString stringWithFormat:@"%@%@?", hostURL, path];\
NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameterDic];\
NSMutableArray *array = [NSMutableArray array];\
[dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) { \
NSString *para = [NSString stringWithFormat:@"%@=%@",key,[dic objectForKey:key]];\
[array addObject:para];\
}];\
NSString *p = [array componentsJoinedByString:@"&"];\
NSString *urlString = [string stringByAppendingString:p];\
NSLog(@"%@",urlString);
#endif

//定义block使用的weak引用
#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;

//弱引用/强引用   __weak __typeof(&*self)weakSelf = self;
 #define kWeakSelf(type)  __weak typeof(type) weak##type = type;
 #define kStrongSelf(type) __strong typeof(type) type = weak##type;
//角度
  #define kDegreesToRadian(x)      (M_PI * (x) / 180.0) //角度转换弧度
  #define kRadianToDegrees(radian) (radian * 180.0) / (M_PI) //弧度转换角度
//时间间隔
#define kStartTime CFAbsoluteTime start = CFAbsoluteTimeGetCurrent();
#define kEndTime  NSLog(@"Time: %f", CFAbsoluteTimeGetCurrent() - start)




#endif /* YiShangbaoMacro_h */
