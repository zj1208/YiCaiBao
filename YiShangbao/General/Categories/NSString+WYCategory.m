//
//  NSString+WYCategory.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/29.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "NSString+WYCategory.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@implementation NSString (WYCategory)
+(NSString*)stringWithDict:(NSDictionary*)dict{
    NSString*str =@"";
    for(NSString* categoryId in dict) {
        id value = [dict objectForKey:categoryId];
        if([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
    }
    return str;
}

//字典转字符串MD5
+(NSString*)MD5stringWithDict:(NSDictionary*)dict{
    NSString*str =@"";
    for(NSString* categoryId in dict) {
        id value = [dict objectForKey:categoryId];
        if([str length] !=0) {
            str = [str stringByAppendingString:@"&"];
        }
        str = [str stringByAppendingFormat:@"%@=%@",categoryId,value];
    }
    str = [str md5String];
    return str;
}

// md5加密
- (NSString *)md5String
{
    const char *string = self.UTF8String;
    int length = (int)strlen(string);
    unsigned char bytes[CC_MD5_DIGEST_LENGTH];
    CC_MD5(string, length, bytes);
    return [self stringFromBytes:bytes length:CC_MD5_DIGEST_LENGTH];
}

#pragma mark - Helpers
- (NSString *)stringFromBytes:(unsigned char *)bytes length:(int)length
{
    NSMutableString *mutableString = @"".mutableCopy;
    for (int i = 0; i < length; i++)
        [mutableString appendFormat:@"%02x", bytes[i]];
    return [NSString stringWithString:mutableString];
}
@end
