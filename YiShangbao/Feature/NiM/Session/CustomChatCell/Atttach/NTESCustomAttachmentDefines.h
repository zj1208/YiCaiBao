//
//  NTESCustomAttachmentDefines.h
//  NIM
//
//  Created by amao on 7/2/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#ifndef NIM_NTESCustomAttachmentTypes_h
#define NIM_NTESCustomAttachmentTypes_h
#import <NIMSDK/NIMSDK.h>
@class NIMKitBubbleStyleObject;

typedef NS_ENUM(NSInteger,NTESCustomMessageType){
 
    CustomMessageTypePicTextLink = 1, //产品图文
    CustomMessageTypeSendProductLink = 2, // 产品详情 发送产品
    CustomMessageTypeSendProductLocal = 100, // 产品详情 本地展示

//    // 没用到
    CustomMessageTypeSnapchat   = 6, //阅后即焚
    CustomMessageTypeChartlet   = 3, //贴图表情
    CustomMessageTypeWhiteboard = 4,  //白板会话
    CustomMessageTypeJanKenPon  = 5, //剪子石头布

};


#define CMType          @"type"
#define CMData          @"data"
#define CMValue         @"value"
#define CMFlag          @"flag"
#define CMURL           @"url"
#define CMMD5           @"md5"
#define CMFIRE          @"fired"    //阅后即焚消息是否被焚毁
#define CMCatalog       @"catalog"  //贴图类别
#define CMChartlet      @"chartlet" //贴图表情ID
#endif


@protocol NTESCustomAttachmentInfo <NSObject>

@optional

- (NSString *)cellContent:(NIMMessage *)message;

- (CGSize)contentSize:(NIMMessage *)message cellWidth:(CGFloat)width;

- (UIEdgeInsets)contentViewInsets:(NIMMessage *)message;

- (NSString *)formatedMessage;

- (UIImage *)showCoverImage;

- (BOOL)shouldShowAvatar;

- (void)setShowCoverImage:(UIImage *)image;

@end
