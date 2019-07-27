//
//  WYNIMAccoutManager.m
//  YiShangbao
//
//  Created by simon on 17/5/18.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYNIMAccoutManager.h"

NSString *const kNotificationAccountBlock = @"kNotificationAccountBlock";

@interface WYNIMAccoutManager ()

@property (nonatomic, assign)NIMRemoteErrorCode errorCode;

@end

@implementation WYNIMAccoutManager


+ (instancetype)shareInstance
{
    static id sharedHelper = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate, ^{
        sharedHelper = [[self alloc] init];
    });
    return sharedHelper;
}

- (void)resetCurrentNIMAccoutNormal
{
    //重置为正常
    self.errorCode =0;
}

- (void)setupCurrentNIMAccoutLoginFailedErrorCode:(NIMRemoteErrorCode)code
{
    self.errorCode = code;
}


- (BOOL)cheackAccoutEnable:(UIViewController *)sourceController
{
    switch (self.errorCode)
    {
        case NIMRemoteErrorCodeUserNotExist:
            
            [self doNIMRemoteErrorCodeUserNotExistAction:sourceController];
            return NO;
            break;
            
        case NIMRemoteErrorAccountBlock:
            [self doNIMRemoteErrorAccountBlockAction:sourceController];
            return NO;
            break;
        default: return YES;
            break;
    }

}
- (void)doNIMRemoteErrorCodeUserNotExistAction:(UIViewController *)sourceController
{
    [UIAlertController zx_presentGeneralAlertInViewController:sourceController withTitle:@"您的聊天功能无法使用，请联系客服"  message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"联系客服" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [sourceController.view zx_performCallPhoneApplication:@"400-666-0998"];
    }];

    [[NSNotificationCenter defaultCenter]postNotificationName:Noti_tryAgainGetNimAccout object:nil];

}

- (void)doNIMRemoteErrorAccountBlockAction:(UIViewController *)sourceController
{
    [UIAlertController zx_presentGeneralAlertInViewController:sourceController withTitle:@"您已被禁言，如有疑问请联系客服"  message:nil cancelButtonTitle:@"关闭" cancleHandler:nil doButtonTitle:@"联系客服" doHandler:^(UIAlertAction * _Nonnull action) {
        
        [sourceController.view zx_performCallPhoneApplication:@"400-666-0998"];
    }];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
