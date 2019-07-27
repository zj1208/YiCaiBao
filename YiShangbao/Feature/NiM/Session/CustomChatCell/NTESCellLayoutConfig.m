//
//  NTESCellLayoutConfig.m
//  YiShangbao
//
//  Created by simon on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "NTESCellLayoutConfig.h"

static  CGFloat titleTextFont = 14.f;
static  CGFloat recommandTextFont = 13.f;

@interface NTESCellLayoutConfig()

@property (nonatomic, strong) NSArray *types;

@end

@implementation NTESCellLayoutConfig
- (instancetype)init
{
    if (self = [super init])
    {
        _types =  @[
                    @"NTESJanKenPonAttachment",
                    @"NTESSnapchatAttachment",
                    @"NTESChartletAttachment",
                    @"NTESWhiteboardAttachment",
                    @"NTESRedPacketAttachment",
                    @"NTESRedPacketTipAttachment",
                    @"NTESLinkAttachment"
                    ];
    }
    return self;
}

/**
 *  是否显示头像(有一些自定义消息可能不显示头像，重载次方法可以自由操作)
 */
- (BOOL)shouldShowAvatar:(NIMMessageModel *)model{
    if ([self isProductMessage:model]) {
        return NO;
    }
    return YES;
}

- (CGSize)contentSize:(NIMMessageModel *)model cellWidth:(CGFloat)width
{
    if ([self isProductMessage:model]){
        return CGSizeMake(width, 115);
    }
    if ([self canLayout:model])
    {
        CGFloat w = LCDScale_iPhone6_Width(250.f);
        CGFloat picWidth = 67.f;
        CGFloat padding = 12.f;
        CGFloat topBottomPadding = 10.f;
        CGFloat height = 0.f;

        NIMCustomObject *object = model.message.messageObject;
        id attachment = object.attachment;
        if([attachment isKindOfClass:[NTESAttachment class]])
        {
            NTESAttachment *attach = (NTESAttachment *)attachment;
            NTESCustomProductLinkModel *model = attach.model;
        
            if([NSString zhIsBlankString:model.imageUrl])
            {
              
                CGFloat titleHeight = [NSString zhGetBoundingSizeOfString:model.title WithSize:CGSizeMake(w-2*padding, [UIFont systemFontOfSize:titleTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:titleTextFont]].height;
                height = topBottomPadding + titleHeight;
                
                if (![NSString zhIsBlankString:model.recommendation])
                {
                    CGFloat describeHeight = [NSString zhGetBoundingSizeOfString:model.recommendation WithSize:CGSizeMake(w-2*padding, [UIFont systemFontOfSize:recommandTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:recommandTextFont]].height;
                    height = height + 5+describeHeight;
                }
                height = height+10+0.5 +10 +[UIFont systemFontOfSize:14].lineHeight;
                return CGSizeMake(LCDScale_iPhone6_Width(250.f), height);
            }
            else
            {
                
                CGFloat titleHeight = [NSString zhGetBoundingSizeOfString:model.title WithSize:CGSizeMake(w-2*padding-picWidth-8, [UIFont systemFontOfSize:titleTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:titleTextFont]].height;
                height = titleHeight +topBottomPadding;
                if (![NSString zhIsBlankString:model.recommendation])
                {
                    CGFloat describeHeight = [NSString zhGetBoundingSizeOfString:model.title WithSize:CGSizeMake(w-2*padding-picWidth-8, [UIFont systemFontOfSize:recommandTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:recommandTextFont]].height;
                    height = height + 5+describeHeight;
                }
                if (height>topBottomPadding+picWidth)
                {
                    height = height +10+0.5 +10 +[UIFont systemFontOfSize:14].lineHeight;
                }
                else
                {
                    height = topBottomPadding + picWidth +10+0.5 +10 +[UIFont systemFontOfSize:14].lineHeight;
                }
                return CGSizeMake(LCDScale_iPhone6_Width(250.f), height);
            }
        }
        else if ([attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment *attach = (NTESSendProductLinkAttachment *)attachment;
            NTESSendProductLinkModel *model = attach.model;
            CGFloat titleHeight = [NSString zhGetBoundingSizeOfString:model.name WithSize:CGSizeMake(w-2*padding-picWidth-8, [UIFont systemFontOfSize:titleTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:titleTextFont]].height;
            height = titleHeight +topBottomPadding;
            if (![NSString zhIsBlankString:model.pic])
            {
                CGFloat describeHeight = [NSString zhGetBoundingSizeOfString:model.name WithSize:CGSizeMake(w-2*padding-picWidth-8, [UIFont systemFontOfSize:recommandTextFont].lineHeight*2+3) font:[UIFont systemFontOfSize:recommandTextFont]].height;
                height = height + 5+describeHeight;
            }
            if (height>topBottomPadding+picWidth)
            {
                height = height +10+0.5 +10 +[UIFont systemFontOfSize:14].lineHeight;
            }
            else
            {
                height = topBottomPadding + picWidth +10+0.5 +10 +[UIFont systemFontOfSize:14].lineHeight;
            }
            return CGSizeMake(LCDScale_iPhone6_Width(250.f), height);
        }
    }
    return [super contentSize:model cellWidth:width];
}

- (BOOL)isProductMessage:(NIMMessageModel *)model
{
    if (model.message.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object  = model.message.messageObject;
        if ([object.attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment *attachment = (NTESSendProductLinkAttachment *)object.attachment;
            if ([attachment.type isEqualToNumber:@(CustomMessageTypeSendProductLocal)])
            {
                return YES;
            }
        }
    }
    return NO;
}

- (BOOL)canLayout:(NIMMessageModel *)model
{
    return model.message.messageType == NIMMessageTypeCustom;
}


- (NSString *)cellContent:(NIMMessageModel *)model
{
    if ([self isProductMessage:model]) {
        return @"NTESProductMessageView";
    }
    if (model.message.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object  = model.message.messageObject;
        if ([object.attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment *attachment = (NTESSendProductLinkAttachment *)object.attachment;
            if ([attachment.type integerValue] ==CustomMessageTypeSendProductLink)
            {
                return @"NTESProductPriceContentView";
            }
        }
    }
    if ([self canLayout:model])
    {
        return @"NTESContentView";
    }
    return [super cellContent:model];
}

//- (UIEdgeInsets)cellInsets:(NIMMessageModel *)model
//{
//    if ([self canLayout:model])
//    {
//        return UIEdgeInsetsMake(5, 5, 5, 5);
//    }
//    return [super cellInsets:model];
//}

- (UIEdgeInsets)contentViewInsets:(NIMMessageModel *)model{
    if ([self isProductMessage:model]) {
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }
    if ([self canLayout:model]) {
        //填入内容距气泡的边距,选填
        return UIEdgeInsetsMake(5, 5, 5, 5);
    }
    NSLog(@"%@",NSStringFromUIEdgeInsets([super contentViewInsets:model]));
    return [super contentViewInsets:model];
    
}

#pragma mark - 公用

- (BOOL)isSupportedCustomMessage:(NIMMessage *)message
{
    NIMCustomObject *object = message.messageObject;
    return [object isKindOfClass:[NIMCustomObject class]] && [_types indexOfObject:NSStringFromClass([object.attachment class])] != NSNotFound;
}

@end
