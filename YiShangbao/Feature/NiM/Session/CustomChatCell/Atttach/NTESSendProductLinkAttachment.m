//
//  NTESSendProductLinkAttachment.m
//  YiShangbao
//
//  Created by simon on 2018/5/17.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESSendProductLinkAttachment.h"
#import "NSDictionary+NTESJson.h"

@implementation NTESSendProductLinkAttachment

- (NSString *)encodeAttachment
{
    NSDictionary *modelDic = @{@"name":self.model.name,@"pic":self.model.pic,@"price":self.model.price,@"url":self.model.url};
    NSDictionary *dict = @{CMType : @(CustomMessageTypeSendProductLink),
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
