//
//  NSString+WYCategory.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/29.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WYCategory)
//字典转字符串 格式：xx=xxx&xx=xxx&xx=
+(NSString*)stringWithDict:(NSDictionary*)dict;
//字典转字符串并md5加密
+(NSString*)MD5stringWithDict:(NSDictionary*)dict;
// md5加密
- (NSString *)md5String;

@end
