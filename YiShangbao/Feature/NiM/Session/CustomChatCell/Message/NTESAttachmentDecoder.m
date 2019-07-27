//
//  NTESAttachmentDecoder.m
//  YiShangbao
//
//  Created by simon on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESAttachmentDecoder.h"
#import "NTESAttachment.h"
#import "NTESCustomAttachmentDefines.h"
#import "NTESSendProductLinkAttachment.h"

@implementation NTESAttachmentDecoder

- (id<NIMCustomAttachment>)decodeAttachment:(NSString *)content
{
    id<NIMCustomAttachment> attachment;
    NSData *data = [content dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if ([dict isKindOfClass:[NSDictionary class]])
        {
            NSInteger type     = [[dict objectForKey:CMType]integerValue];
            NSDictionary *data = [dict objectForKey:CMData];
            switch (type)
            {
                case CustomMessageTypePicTextLink:
                {
                    NTESAttachment *atttach = [[NTESAttachment alloc] init];
                    
                    NTESCustomProductLinkModel *model = [[NTESCustomProductLinkModel alloc] init];
                    model.title = data[@"title"];;
                    model.recommendation = data[@"recommendation"];
                    model.imageUrl = [data objectForKey:@"picUrl"];
                    model.linkUrl = [data objectForKey:@"linkUrl"];
                    atttach.model = model;
                    attachment = atttach;
                    
                }
                    break;
                case CustomMessageTypeSendProductLink:
                {
                    NTESSendProductLinkAttachment *atttach = [[NTESSendProductLinkAttachment alloc] init];
                    atttach.type = @(CustomMessageTypeSendProductLink);
                    NTESSendProductLinkModel *model = [[NTESSendProductLinkModel alloc] init];
                    model.name = data[@"name"];;
                    model.url = data[@"url"];
                    model.pic = [data objectForKey:@"pic"];
                    model.price = [data objectForKey:@"price"];
                    atttach.model = model;
                    attachment = atttach;
                }
                    break;
                case CustomMessageTypeSendProductLocal:
                {
                    NTESSendProductLinkAttachment *atttach = [[NTESSendProductLinkAttachment alloc] init];
                    atttach.type = @(CustomMessageTypeSendProductLocal);
                    NTESSendProductLinkModel *model = [[NTESSendProductLinkModel alloc] init];
                    model.name = data[@"name"];;
                    model.url = data[@"url"];
                    model.pic = [data objectForKey:@"pic"];
                    model.price = [data objectForKey:@"price"];
                    atttach.model = model;
                    attachment = atttach;
                }
                    break;
                default:
                    break;
            }
       
       
        }
    }
    return attachment;
}

@end
