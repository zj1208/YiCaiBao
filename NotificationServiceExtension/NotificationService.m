//
//  NotificationService.m
//  NotificationServiceExtension
//
//  Created by simon on 2017/8/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NotificationService.h"
#import <GTExtensionSDK/GeTuiExtSdk.h>

@interface NotificationService ()

@property (nonatomic, strong) void (^contentHandler)(UNNotificationContent *contentToDeliver);
@property (nonatomic, strong) UNMutableNotificationContent *bestAttemptContent;

@end

@implementation NotificationService

// 我们可以在这个方法中处理我们的 APNs 通知，并个性化展示给用户。APNs 推送的消息送达时会调用这个方法，此时你可以对推送的内容进行处理，然后使用contentHandler方法结束这次处理。但是如果处理时间过长，将会进入serviceExtensionTimeWillExpire方法进行最后的紧急处理。
- (void)didReceiveNotificationRequest:(UNNotificationRequest *)request withContentHandler:(void (^)(UNNotificationContent * _Nonnull))contentHandler {
    self.contentHandler = contentHandler;
    self.bestAttemptContent = [request.content mutableCopy];
    
//  使用 handelNotificationServiceRequest 上报推送送达数据。
    [GeTuiExtSdk handelNotificationServiceRequest:request withAttachmentsComplete:^(NSArray *attachments, NSArray *errors) {
        
        //注意：是否修改下发后的title内容以项目实际需求而定
//        self.bestAttemptContent.title = [NSString stringWithFormat:@"%@ [需求而定]", self.bestAttemptContent.title];
        self.bestAttemptContent.attachments = attachments; //设置通知中的多媒体附件
        // 待展示推送的回调处理需要放到回执完成的回调中;
        self.contentHandler(self.bestAttemptContent);

    }];    
}

//如果didReceiveNotificationRequest方法在限定时间内没有调用 contentHandler方法结束处理，则会在过期之前进行回调本方法。此时你可以对你的 APNs 消息进行紧急处理后展示，如果没有处理，则显示原始 APNs 推送。
- (void)serviceExtensionTimeWillExpire {
    // Called just before the extension will be terminated by the system.
    // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
    
    [GeTuiExtSdk destory];
    self.contentHandler(self.bestAttemptContent);
    
    
}


@end
