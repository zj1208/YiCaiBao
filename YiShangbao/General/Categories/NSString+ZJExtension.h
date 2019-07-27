//
//  NSString+ZJExtension.h
//  WisdomPlatform
//
//  Created by zhdooo on 16/11/27.
//  Copyright © 2016年 zjhcsoft. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (ZJExtension)
// md5加密
+ (NSString *)md5:(NSString *)str;
// 获取设备uuid
+ (NSString*) uuid;
@end
