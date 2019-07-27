//
//  NTESAttachment.m
//  YiShangbao
//
//  Created by simon on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESAttachment.h"
#import "NSDictionary+NTESJson.h"



@implementation NTESAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *modelDic = @{@"title":self.model.title,@"recommendation":self.model.recommendation,@"linkUrl":self.model.linkUrl,@"picUrl":self.model.imageUrl};
    NSDictionary *dict = @{CMType : @(CustomMessageTypePicTextLink),
                           CMData :modelDic};
    NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:0 error:nil];
    NSString *encodeString = nil;
    if (data)
    {
        encodeString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    }
    return encodeString;
}

@end
