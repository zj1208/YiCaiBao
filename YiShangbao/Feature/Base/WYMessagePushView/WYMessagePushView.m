//
//  WYMessagePushView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/11/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//-----changed----2018.1.18----------

#import "WYMessagePushView.h"

#import "NIMKitUtil.h"
#import "NIMKitInfoFetchOption.h"

#import "EventViewController.h"
#import "WYIntroduceViewController.h"
#import "HKVersionAlertView.h"
#import "WYMessageListViewController.h"
#import "NIMSessionViewController.h"
#import "ExtendSuccessViewController.h"
#import "WYVerificationCodeViewController.h"
#import "NTESCellLayoutConfig.h"

@interface WYMessagePushView ()

@property(nonatomic, assign) CGFloat height;
@end
@implementation WYMessagePushView
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithData:(id)data
{
    WYMessagePushView* messageView = [[[NSBundle mainBundle] loadNibNamed:@"WYMessagePushView" owner:self options:nil] firstObject];
    [messageView addRecognizersss];
//    if (0) { //无回复
//        messageView.huifuHeight.constant = 0;
//        messageView.height = 105.f;
//    }
//    else{ //有回复
        messageView.stateTop.constant = HEIGHT_STATEBAR;
        messageView.height = 155.f+HEIGHT_STATEBAR;
        [messageView setdata:data];
//    }

    messageView.iocnImageView.layer.masksToBounds = YES;
    messageView.iocnImageView.layer.cornerRadius = 10;
    messageView.xiayuanjiaoContentView.layer.masksToBounds = YES;
    messageView.xiayuanjiaoContentView.layer.cornerRadius = 10;
    
    return messageView;
}
-(void)setdata:(id)data
{
    NIMMessage *recent = (NIMMessage *)data;
    self.nameLabel.text = [self nameForRecentSession:recent.session];
    [self.iocnImageView sd_setImageWithURL:[self setAvatarBySession:recent.session] placeholderImage:AppPlaceholderHeadImage];
    self.mesLabel.attributedText  = [self contentForRecentSession:recent];
}

//转换消息的显示昵称
- (NSString *)nameForRecentSession:(NIMSession *)session{
    if (session.sessionType == NIMSessionTypeP2P) {
        return [NIMKitUtil showNick:session.sessionId inSession:session];
    }else{
        NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:session.sessionId];
        return team.teamName;
    }
}
//转换最近的message对象的显示内容
- (NSAttributedString *)contentForRecentSession:(NIMMessage *)lastMessage{
    
    NSString *content = nil;
    if (lastMessage.messageType == NIMMessageTypeCustom)
    {
        NIMCustomObject *object = lastMessage.messageObject;
        id attachment = object.attachment;
        if([attachment isKindOfClass:[NTESAttachment class]])
        {
            NTESAttachment *attach = (NTESAttachment *)attachment;
            NTESCustomProductLinkModel *model = attach.model;
            content = [NSString stringWithFormat:@"[链接]%@",model.title];
        }
        return [[NSAttributedString alloc] initWithString:content ?: @""];
    }
    content = [self messageContent:lastMessage];
    return [[NSAttributedString alloc] initWithString:content ?: @""];
}
//
////显示时间
//- (NSString *)timestampDescriptionForRecentSession:(NIMRecentSession *)recent{
//    return [NIMKitUtil showTime:recent.lastMessage.timestamp showDetail:NO];
//}
//
#pragma mark - Private
- (NSString *)messageContent:(NIMMessage*)lastMessage{
    NSString *text = @"";
    switch (lastMessage.messageType) {
            //包括表情
        case NIMMessageTypeText:
            text = lastMessage.text;
            break;
        case NIMMessageTypeAudio:
            text = @"[语音]";
            break;
        case NIMMessageTypeImage:
            text = @"[图片]";
            break;
        case NIMMessageTypeVideo:
            text = @"[视频]";
            break;
        case NIMMessageTypeLocation:
            text = @"[位置]";
            break;
//        case NIMMessageTypeNotification:{
//            return [self notificationMessageContent:lastMessage];
//        }
        case NIMMessageTypeFile:
            text = @"[文件]";
            break;
        case NIMMessageTypeTip:
            text = lastMessage.text;
            break;
//        case NIMMessageTypeRobot:
//            text = [self robotMessageContent:lastMessage];
//            break;
        default:
            text = @"[未知消息]";
    }
    if (lastMessage.session.sessionType == NIMSessionTypeP2P || lastMessage.messageType == NIMMessageTypeTip)
    {
        return text;
    }
    else
    {
        NSString *from = lastMessage.from;
        if (lastMessage.messageType == NIMMessageTypeRobot)
        {
            NIMRobotObject *object = (NIMRobotObject *)lastMessage.messageObject;
            if (object.isFromRobot)
            {
                from = object.robotId;
            }
        }
        NSString *nickName = [NIMKitUtil showNick:from inSession:lastMessage.session];
        return nickName.length ? [nickName stringByAppendingFormat:@" : %@",text] : @"";
    }
}

- (NSURL *)setAvatarBySession:(NIMSession *)session
{
    NIMKitInfo *info = nil;
    if (session.sessionType == NIMSessionTypeTeam)
    {
        info = [[NIMKit sharedKit] infoByTeam:session.sessionId option:nil];
    }
    else
    {
        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
        option.session = session;
        info = [[NIMKit sharedKit] infoByUser:session.sessionId option:option];
    }
    NSURL *url = info.avatarUrlString ? [NSURL URLWithString:info.avatarUrlString] : nil;
    return url;
}



-(void)showToWindowAfterCompletion:(Completion)completion
{
    if (![self isNeedShow]) { //当前控制器是否需要展示
        return;
    }
    if (!self.superview) {
        self.frame =  CGRectMake(0,-self.mHeight, LCDW, self.mHeight);
        UIWindow *window = [UIApplication sharedApplication].delegate.window;
        [window addSubview:self];

        window.windowLevel = UIWindowLevelStatusBar+10;

        [UIView animateWithDuration:0.25 animations:^{
            CGRect frame = self.frame;
            frame.origin.y = 0;
            self.frame = frame;
            
        } completion:^(BOOL finished) {
            
            if (completion) {
                completion();
            }
            
            [self performSelector:@selector(autoRemove) withObject:nil afterDelay:4];
        }];
        
    }
   
}
-(void)addRecognizersss
{
//    UISwipeGestureRecognizer *swipeGes = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(autoRemove)];
//    swipeGes.direction = UISwipeGestureRecognizerDirectionUp ;
//    [self.btn addGestureRecognizer:swipeGes];
    
    UIPanGestureRecognizer *panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(messagePanGes:)];
    [self.btn addGestureRecognizer:panGes];
}
- (void)messagePanGes:(UIPanGestureRecognizer *)sender
{
    CGPoint point = [sender translationInView:sender.view];
    if (sender.state == UIGestureRecognizerStateChanged) {
       
//        NSLog(@"ppp====%@",NSStringFromCGPoint(point));
        if (point.y<0) {
            //superview
            [sender.view.superview setTransform:CGAffineTransformTranslate(sender.view.superview.transform, 0, point.y)];
        }
       
        [sender setTranslation:CGPointZero inView:sender.view];
    }else if (sender.state == UIGestureRecognizerStateEnded){

        if (point.y<=0) {
            [self dismissWithAnimated:YES completion:nil];
        }
    }
    
}
-(void)autoRemove
{
    [self dismissWithAnimated:YES completion:nil];
}
-(void)dismissWithAnimated:(BOOL)animated completion:(Completion)completion
{
    if (animated) {
        if (self.superview) {
            [UIView animateWithDuration:0.2 animations:^{
                CGRect frame = self.frame;
                frame.origin.y = -self.mHeight;
                self.frame = frame;
                
                
            } completion:^(BOOL finished) {
                
                [self removeFromSuperview];
                if (completion) {
                    completion();
                }
                
                if (!self.isIgnoreSetWindowLevelNormal) {
                    UIWindow *window = [UIApplication sharedApplication].delegate.window;
                    window.windowLevel = UIWindowLevelNormal; //修改优先级使弹框覆盖状态栏(移除时需要把优先级在设置默认UIWindowLevelNormal)
                }
//                NSArray *arr = [UIApplication sharedApplication].windows;
//                NSLog(@"%@",arr);
            }];
        }
    }else{
        if (self.superview) {
            
            [self removeFromSuperview];
            if (completion) {
                completion();
            }
            
            if (!self.isIgnoreSetWindowLevelNormal) {
                UIWindow *window = [UIApplication sharedApplication].delegate.window;
                window.windowLevel = UIWindowLevelNormal; //修改优先级使弹框覆盖状态栏(移除时需要把优先级在设置默认UIWindowLevelNormal)
            }
        }
    }
}

-(CGFloat)mHeight
{
    return self.height;
}
#pragma mark - 判断是否展示
//待优化，消息弹出机制，路由调转
-(BOOL)isNeedShow
{
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window]; //当前window
    for (UIView *v in window.subviews) {
        if ([v isKindOfClass:[HKVersionAlertView class]]) {
            return NO; //检查更新时不弹出
        }
    }
    
    UIViewController* tab = window.rootViewController;
    if ([tab isKindOfClass:[UITabBarController class]]) {
        //UITabBarController.view addsubView
        for (UIViewController* vc in tab.childViewControllers) {
            if ([vc isKindOfClass:[EventViewController class]]) {
                return NO; //开屏广告不弹出
            }
            if ([vc isKindOfClass:[WYVerificationCodeViewController class]]) {
                return NO; //验证码弹框不弹出
            }
        }
        UITabBarController* tabB = (UITabBarController*)window.rootViewController;
        UINavigationController* navi = tabB.selectedViewController;
        UIViewController* vc = navi.topViewController;
        
        if (vc) {
            if ([vc isKindOfClass:[WYMessageListViewController class]]) {
                return NO; //已经在消息列表不弹出
            }
            if ([vc isKindOfClass:[NIMSessionViewController class]]) {
                return NO; //已经在消息详情页不弹出
            }
            if (vc.presentedViewController) {//presented了控制器
                if ([vc.presentedViewController isKindOfClass:[UITabBarController class]]) {
                    UITabBarController* tabVC = (UITabBarController*)vc.presentedViewController;
                    UINavigationController* navi = tabVC.selectedViewController;
                    if ([navi isKindOfClass:[UINavigationController class]]) {
                        return YES; //暂无此设计需求
                    }
                }
                if ([vc.presentedViewController isKindOfClass:[UINavigationController class]]) {
                    return YES; //开单
                }
                return NO; //presented了UIViewController控制器不弹出（搜索不弹出）
            }
        }else{
            return NO; //无topViewController不弹出
        }
    }else{
        return NO; //非UITabBarController不弹出
    }
        
    return YES;
}

#pragma mark - 点击跳转
- (IBAction)clickBtn:(UIButton *)sender {
    [self dismissWithAnimated:YES completion:^{

        UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
        UITabBarController* tab = (UITabBarController*)window.rootViewController;
        UINavigationController *na = tab.selectedViewController;
        UIViewController *VC = na.visibleViewController;//可能存在多个堆栈,取实际展示VC《eg：开单续费弹框》
        if (VC) {
            [WYUTILITY routerWithName:@"microants://messageCategory" withSoureController:VC];
        }
    }];
}
//- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController
//{
//    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
//        UITabBarController* tabBarController = (UITabBarController*)rootViewController;
//        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
//    } else if (rootViewController.presentedViewController) {
//        UIViewController* presentedViewController = rootViewController.presentedViewController;
//        return [self topViewControllerWithRootViewController:presentedViewController];
//    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
//
//        UINavigationController* navigationController = (UINavigationController*)rootViewController;
//        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];//实际展示VC
//    } else {
//        return rootViewController;
//    }
//}

// UIWindow *window = [UIApplication sharedApplication].keyWindow;
//优先级UIWindowLevelNormal == 0.0; UIWindowLevelAlert=2000.0; UIWindowLevelStatusBar=1000.0
//    window.windowLevel = UIWindowLevelAlert; //修改优先级使弹框覆盖状态栏(移除时需要把优先级在设置默认UIWindowLevelNormal)
@end
