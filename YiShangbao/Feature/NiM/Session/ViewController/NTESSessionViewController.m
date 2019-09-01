//
//  NTESSessionViewController.m
//  NIM
//
//  Created by amao on 8/11/15.
//  Copyright (c) 2015 Netease. All rights reserved.
//

#import "NTESSessionViewController.h"
@import MobileCoreServices;
@import AVFoundation;
#import "UIView+Toast.h"
#import <NIMSDK/NIMSDK.h>
#import "NIMKitTimerHolder.h"
#import "NIMGlobalMacro.h"
#import "NIMKitInfoFetchOption.h"
#import "IQKeyboardManager.h"
#import "NSDictionary+NTESJson.h"
#import "NTESSessionConfig.h"
#import "NTESVideoViewController.h"
#import "NIMKitMediaFetcher.h"
#import "NTESCustomSysNotificationSender.h"

#import "NTESSessionMsgConverter.h"
#import "NTESSessionUtil.h"
#import "WYNIMAccoutManager.h"
#import "XLPhotoBrowser.h"
#import "KxMenu.h"
#import "NTESCellLayoutConfig.h"
#import "SEProductSelectController.h"

@interface NTESSessionViewController ()
<UIImagePickerControllerDelegate,
UINavigationControllerDelegate,NIMSystemNotificationManagerDelegate,NIMKitTimerHolderDelegate,NIMMediaManagerDelegate,XLPhotoBrowserDatasource>

@property (nonatomic,strong)    NIMKitTimerHolder         *titleTimer;
@property (nonatomic,strong)    UIImagePickerController *imagePicker;
@property (nonatomic,strong)    NTESSessionConfig       *sessionConfig;

@property (nonatomic,strong)    NIMKitMediaFetcher *mediaFetcher;
@property (nonatomic,strong)    NTESCustomSysNotificationSender *notificaionSender;

@property (nonatomic, strong)  NIMImageObject *showImageObject;
@end



@implementation NTESSessionViewController


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[IQKeyboardManager sharedManager]setEnable:NO] ;
    [[IQKeyboardManager sharedManager]setEnableAutoToolbar:NO];
 
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NIMSDK sharedSDK].mediaManager stopRecord];
    [[NIMSDK sharedSDK].mediaManager stopPlay];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = YES;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"enter session, id = %@",self.session.sessionId);
    self.tableView.backgroundColor = NIMKit_UIColorFromRGB(0xf3f3f3);
    
    UIImage *img = [UIImage imageNamed:@"ic_geren"];
    UIBarButtonItem *personalInfoItem = [[UIBarButtonItem alloc] initWithImage:img style:UIBarButtonItemStyleDone target:self action:@selector(pushHisCenter:)];
    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_seller ||[NSString zhIsBlankString:_shopUrl])
    {
        self.navigationItem.rightBarButtonItem = personalInfoItem;
    }
    else
    {

        UIBarButtonItem *shopItem = [[UIBarButtonItem alloc] initWithTitle:@"进店" style:UIBarButtonItemStyleDone target:self action:@selector(pushHisShop:)];
        [shopItem setTitleTextAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:16.f]} forState:UIControlStateNormal];

        self.navigationItem.rightBarButtonItems = @[personalInfoItem,shopItem];
    }
    
    
    
    UIBarButtonItem *barButtonItem = [self.navigationItem.leftBarButtonItems objectAtIndex:1];
    barButtonItem.customView.hidden = self.hideUnreadCountView;
//    NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
//    option.session = self.session;
//    NIMKitInfo *info =[[NIMKit sharedKit] infoByUser:self.session.sessionId option:option];
    
    _notificaionSender  = [[NTESCustomSysNotificationSender alloc] init];
    
    BOOL disableCommandTyping = self.disableCommandTyping || (self.session.sessionType == NIMSessionTypeP2P &&[[NIMSDK sharedSDK].userManager isUserInBlackList:self.session.sessionId]);
    if (!disableCommandTyping) {
        _titleTimer = [[NIMKitTimerHolder alloc] init];
        [[NIMSDK sharedSDK].systemNotificationManager addDelegate:self];
    }

//    if ([[NTESBundleSetting sharedConfig] showFps])
//    {
//        self.fpsLabel = [[NTESFPSLabel alloc] initWithFrame:CGRectZero];
//        [self.view addSubview:self.fpsLabel];
//        self.fpsLabel.right = self.view.width;
//        self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
//    }
//    
//    if (self.session.sessionType == NIMSessionTypeP2P && !self.disableOnlineState)
//    {
//        //临时订阅这个人的在线状态
//        [[NTESSubscribeManager sharedInstance] subscribeTempUserOnlineState:self.session.sessionId];
//        [[NIMSDK sharedSDK].subscribeManager addDelegate:self];
//    }
    
//    //删除最近会话列表中有人@你的标记
//    [NTESSessionUtil removeRecentSessionAtMark:self.session];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(accountBlock:) name:kNotificationAccountBlock object:nil];
    
    [self sendLocalLookProductInfo];
}



- (void)sendLocalLookProductInfo
{
    if (self.proModel)
    {
        NTESSendProductLinkModel *model = [[NTESSendProductLinkModel alloc]init];
        model.name = self.proModel.name;
        model.price = self.proModel.price;
        model.pic = self.proModel.pic;
        model.url = self.proModel.url;
        
        
        NTESSendProductLinkAttachment *attachment = [[NTESSendProductLinkAttachment alloc] init];
        attachment.model = model;
        attachment.type = @(CustomMessageTypeSendProductLocal);
        
        NIMCustomObject *object = [[NIMCustomObject alloc] init];
        object.attachment = attachment;
        
        NIMMessage *message = [[NIMMessage alloc] init];
        message.messageObject = object;
        
        [self.tableView reloadData];
        [self uiInsertMessages:@[message]];
        
    }
}

- (void)accountBlock:(id)notification
{
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:NSLocalizedString(@"您已被禁言，如有疑问请联系客服", nil)  message:nil cancelButtonTitle:nil cancleHandler:nil doButtonTitle:NSLocalizedString(@"确定", nil) doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf.navigationController popViewControllerAnimated:YES];
        
    }];

}

- (void)dealloc
{
    [[NIMSDK sharedSDK].systemNotificationManager removeDelegate:self];
    if (self.session.sessionType == NIMSessionTypeP2P && !self.disableOnlineState)
    {
//        [[NIMSDK sharedSDK].subscribeManager removeDelegate:self];
//        [[NTESSubscribeManager sharedInstance] unsubscribeTempUserOnlineState:self.session.sessionId];
    }
//    [_fpsLabel invalidate];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];

//    self.fpsLabel.right = self.view.width;
//    self.fpsLabel.top   = self.tableView.top + self.tableView.contentInset.top;
}


- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
}

- (void)pushHisCenter:(id)sender
{
    [self onTapAvatar:nil];
}

//http://wykj-internal.s-ant.cn/ycb/page/shopDetail.html?id=1061054259944226944&token={token}&ttid={ttid}&channel=112&trackId=112&trackSpm=getChatUserIMInfo
- (void)pushHisShop:(id)sender
{
    [MobClick event:kUM_b_chat_intoshop];
//    NSString *shopUrl = [model.entityUrl stringByReplacingOccurrencesOfString:@"{id}" withString:model.entityId];
    [[WYUtility dataUtil]routerWithName:_shopUrl withSoureController:self];
}

- (BOOL)onTapAvatar:(NIMMessage *)message
{
    NSString *urlStr = nil;
    BOOL isFromMe = [message.from isEqualToString:[[NIMSDK sharedSDK].loginManager currentAccount]];
    if (isFromMe) {
        
        urlStr = [WYUserDefaultManager getNiMMyInfoUrl];
    }
    else
    {
        if (!_hisUrl)
        {
            WS(weakSelf);
            [[[AppAPIHelper shareInstance]getNimAccountAPI]getChatUserIMInfoWithIDType:NIMIDType_NIMAccout thisId:self.session.sessionId success:^(id data) {
                
                
                NSString *hisUrl = [data objectForKey:@"url"];
                
                [[WYUtility dataUtil]routerWithName:hisUrl withSoureController:weakSelf];
                
            } failure:^(NSError *error) {
                
                [weakSelf zhHUD_showErrorWithStatus:[error localizedDescription]];
            }];
            return NO;
            
        }
        else
        {
            urlStr = _hisUrl;
        }
    }
    [[WYUtility dataUtil]routerWithName:urlStr withSoureController:self];
    
    return YES;
}


- (id<NIMSessionConfig>)sessionConfig
{
    if (_sessionConfig == nil) {
        _sessionConfig = [[NTESSessionConfig alloc] init];
        _sessionConfig.session = self.session;
    }
    return _sessionConfig;
}

#pragma mark - NIMEventSubscribeManagerDelegate
//- (void)onRecvSubscribeEvents:(NSArray *)events
//{
//    for (NIMSubscribeEvent *event in events) {
//        if ([event.from isEqualToString:self.session.sessionId]) {
//            [self refreshSessionSubTitle:[NTESSessionUtil onlineState:self.session.sessionId detail:YES]];
//        }
//    }
//}

//正在输入功能
#pragma mark - NIMSystemNotificationManagerDelegate
- (void)onReceiveCustomSystemNotification:(NIMCustomSystemNotification *)notification
{
    if (!notification.sendToOnlineUsersOnly) {
        return;
    }
    NSData *data = [[notification content] dataUsingEncoding:NSUTF8StringEncoding];
    if (data) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                             options:0
                                                               error:nil];
        if ([dict jsonInteger:@"id"] ==1 && self.session.sessionType == NIMSessionTypeP2P && [notification.sender isEqualToString:self.session.sessionId])
        {
            [self refreshSessionTitle:@"正在输入..."];
            [_titleTimer startTimer:5
                           delegate:self
                            repeats:NO];
        }
    }
    
    
}

//定时器
- (void)onNIMKitTimerFired:(NIMKitTimerHolder *)holder
{
    [self refreshSessionTitle:self.sessionTitle];
}


- (NSString *)sessionTitle
{
    if ([self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount]) {
        return  @"我的电脑";
    }
    return [super sessionTitle];
}

- (NSString *)sessionSubTitle
{
//    if (self.session.sessionType == NIMSessionTypeP2P && ![self.session.sessionId isEqualToString:[NIMSDK sharedSDK].loginManager.currentAccount])
//    {
//        return @"在线";
//        return [NTESSessionUtil onlineState:self.session.sessionId detail:YES];
//    }
    return @"";
}


- (void)onTextChanged:(id)sender
{
    [_notificaionSender sendTypingState:self.session];
}


#pragma mark - 发送 产品详情 聊天发送的产品信息
- (void)sendCustomMessageWithProductInfoAttachment:(NTESSendProductLinkAttachment *)attach
{
//    [self send35ProductDetailWithAttachment:attach];
    [self send36ProductDetailWithAttachment:attach];
}

// 3.5版本发送
//- (void)send35ProductDetailWithAttachment:(NTESSendProductLinkAttachment *)attach
//{
//    NTESSendProductLinkModel *sendLookModel  = attach.model;
//    NTESCustomProductLinkModel *model =  [[NTESCustomProductLinkModel alloc] init];
//    model.title = sendLookModel.name;
//    model.recommendation = sendLookModel.price;
//    model.imageUrl = sendLookModel.pic;
//    model.linkUrl = sendLookModel.url;
//    [self sendProductInfoWithModle:model];
//}

// 3.6版本发送
- (void)send36ProductDetailWithAttachment:(NTESSendProductLinkAttachment *)attach
{
    NTESSendProductLinkModel *model = attach.model;

    NTESSendProductLinkAttachment *attachment = [[NTESSendProductLinkAttachment alloc] init];
    attachment.model = model;
    attachment.type = @(CustomMessageTypeSendProductLink);

    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    object.attachment = attachment;

    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;
    message.apnsContent = [NSString stringWithFormat:@"[链接]%@",model.name];;

    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:self.session error:nil];
}

#pragma mark - 发送我的产品
// 我的产品
- (void)onTapMediaItemMyShopProduct:(NIMMediaItem *)item
{
    [MobClick event:kUM_b_chat_ourproduct];
    SEProductSelectController *vc = (SEProductSelectController *)[self zx_getControllerWithStoryboardName:sb_Extend controllerWithIdentifier:SBID_SEProductSelectController];
    vc.maxProsucts = 9;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    WS(weakSelf);
    vc.productDidSelectBlock = ^(NSMutableArray<__kindof ExtendSelectProcuctModel *> *arrayProducts) {
    
        [weakSelf sendProductWithData:arrayProducts];
        
    };
}
- (void)sendProductWithData:(NSMutableArray *)productsArray;
{
    ExtendSelectProcuctModel *model = [productsArray firstObject];
    NSString *title = [NSString stringWithFormat:@"确认发送'%@'等%@件产品吗？",model.name,@(productsArray.count)];
    WS(weakSelf);
    [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:title message:nil cancelButtonTitle:NSLocalizedString(@"取消", nil) cancleHandler:nil doButtonTitle:NSLocalizedString(@"发送", nil) doHandler:^(UIAlertAction * _Nonnull action) {
        
        [weakSelf sendCustomMessage:productsArray];
    }];
}




- (void)sendCustomMessage:(NSMutableArray *)arr
{
    NSMutableArray *tempMArray = [self manyZXPhotoFormSelectProcuctModelArray:arr];
    [tempMArray enumerateObjectsUsingBlock:^(NTESCustomProductLinkModel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [self sendProductInfoWithModle:obj];
    }];
  
}
- (void)sendProductInfoWithModle:(NTESCustomProductLinkModel *)obj
{
    NTESAttachment *attachment = [[NTESAttachment alloc] init];
    attachment.model = obj;
    attachment.type = @(CustomMessageTypePicTextLink);
    
    NIMCustomObject *object = [[NIMCustomObject alloc] init];
    object.attachment = attachment;
    
    NIMMessage *message = [[NIMMessage alloc] init];
    message.messageObject = object;
    message.apnsContent = [NSString stringWithFormat:@"[链接]%@",obj.title];;
    
    [[NIMSDK sharedSDK].chatManager sendMessage:message toSession:self.session error:nil];
}


- (NSMutableArray *)manyZXPhotoFormSelectProcuctModelArray:(NSMutableArray *)modelsArray
{
    NSMutableArray *zxPhotoMArray = [NSMutableArray array];
    [modelsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        if ([obj isKindOfClass:[ExtendSelectProcuctModel class] ]) {
            
            ExtendSelectProcuctModel *productModel = (ExtendSelectProcuctModel *)obj;
            AliOSSPicUploadModel *picModel = productModel.mainPic;
            //构造自定义内容
            NTESCustomProductLinkModel *model =  [[NTESCustomProductLinkModel alloc] init];
            model.title = productModel.name;
            model.recommendation =NSLocalizedString(@"【优质产品推荐】", nil) ;
            model.imageUrl = picModel.p;
            model.linkUrl = productModel.url;
            
            [zxPhotoMArray addObject:model];
        }
        
    }];
    return  zxPhotoMArray;
}

#pragma mark -
//贴图
- (void)onSelectChartlet:(NSString *)chartletId
                 catalog:(NSString *)catalogId
{
//    NTESChartletAttachment *attachment = [[NTESChartletAttachment alloc] init];
//    attachment.chartletId = chartletId;
//    attachment.chartletCatalog = catalogId;
//    [self sendMessage:[NTESSessionMsgConverter msgWithChartletAttachment:attachment]];
}
//
//
//#pragma mark - 石头剪子布
//- (void)onTapMediaItemJanKenPon:(NIMMediaItem *)item
//{
//    NTESJanKenPonAttachment *attachment = [[NTESJanKenPonAttachment alloc] init];
//    attachment.value = arc4random() % 3 + 1;
//    [self sendMessage:[NTESSessionMsgConverter msgWithJenKenPon:attachment]];
//}
//
//#pragma mark - 实时语音
//- (void)onTapMediaItemAudioChat:(NIMMediaItem *)item
//{
//    if ([self checkCondition]) {
//        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
//        NTESAudioChatViewController *vc = [[NTESAudioChatViewController alloc] initWithCallee:self.session.sessionId];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.25;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromTop;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        self.navigationController.navigationBarHidden = YES;
//        [self.navigationController pushViewController:vc animated:NO];
//    }
//}
//
//#pragma mark - 视频聊天
//- (void)onTapMediaItemVideoChat:(NIMMediaItem *)item
//{
//    if ([self checkCondition]) {
//        //由于音视频聊天里头有音频和视频聊天界面的切换，直接用present的话页面过渡会不太自然，这里还是用push，然后做出present的效果
//        NTESVideoChatViewController *vc = [[NTESVideoChatViewController alloc] initWithCallee:self.session.sessionId];
//        CATransition *transition = [CATransition animation];
//        transition.duration = 0.25;
//        transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
//        transition.type = kCATransitionPush;
//        transition.subtype = kCATransitionFromTop;
//        [self.navigationController.view.layer addAnimation:transition forKey:nil];
//        self.navigationController.navigationBarHidden = YES;
//        [self.navigationController pushViewController:vc animated:NO];
//    }
//}
//
//#pragma mark - 文件传输
//- (void)onTapMediaItemFileTrans:(NIMMediaItem *)item
//{
//    NTESFileTransSelectViewController *vc = [[NTESFileTransSelectViewController alloc]
//                                             initWithNibName:nil bundle:nil];
//    __weak typeof(self) wself = self;
//    vc.completionBlock = ^void(id sender,NSString *ext){
//        if ([sender isKindOfClass:[NSString class]]) {
//            [wself sendMessage:[NTESSessionMsgConverter msgWithFilePath:sender]];
//        }else if ([sender isKindOfClass:[NSData class]]){
//            [wself sendMessage:[NTESSessionMsgConverter msgWithFileData:sender extension:ext]];
//        }
//    };
//    [self.navigationController pushViewController:vc animated:YES];
//}
//
//#pragma mark - 阅后即焚
//- (void)onTapMediaItemSnapChat:(NIMMediaItem *)item
//{
//    UIActionSheet *sheet;
//    BOOL isCamraAvailable = [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
//    if (isCamraAvailable) {
//        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",@"拍照",nil];
//    }else{
//        sheet = [[UIActionSheet alloc] initWithTitle:@"请选择" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册中选取",nil];
//    }
//    __weak typeof(self) wself = self;
//    [sheet showInView:self.view completionHandler:^(NSInteger index) {
//        switch (index) {
//            case 0:{
//                //相册
//                [wself.mediaFetcher fetchPhotoFromLibrary:^(NSArray *images, NSString *path, PHAssetMediaType type){
//                    if (images.count) {
//                        [wself sendSnapchatMessage:images.firstObject];
//                    }
//                    if (path) {
//                        [wself sendSnapchatMessagePath:path];
//                    }
//                }];
//                
//            }
//                break;
//            case 1:{
//                //相机
//                [wself.mediaFetcher fetchMediaFromCamera:^(NSString *path, UIImage *image) {
//                    if (image) {
//                        [wself sendSnapchatMessage:image];
//                    }
//                }];
//            }
//                break;
//            default:
//                return;
//        }
//    }];
//}
//
//- (void)sendSnapchatMessagePath:(NSString *)path
//{
//    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
//    [attachment setImageFilePath:path];
//    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
//}
//
//- (void)sendSnapchatMessage:(UIImage *)image
//{
//    NTESSnapchatAttachment *attachment = [[NTESSnapchatAttachment alloc] init];
//    [attachment setImage:image];
//    [self sendMessage:[NTESSessionMsgConverter msgWithSnapchatAttachment:attachment]];
//}
//
//#pragma mark - 白板
//- (void)onTapMediaItemWhiteBoard:(NIMMediaItem *)item
//{
//    NTESWhiteboardViewController *vc = [[NTESWhiteboardViewController alloc] initWithSessionID:nil
//                                                                                        peerID:self.session.sessionId
//                                                                                         types:NIMRTSServiceReliableTransfer | NIMRTSServiceAudio
//                                                                                          info:@"白板演示"];
//    [self presentViewController:vc animated:NO completion:nil];
//}
//
//
//
#pragma mark - 提醒消息
- (void)onTapMediaItemTip:(NIMMediaItem *)item
{
    NSLog(@"输入提醒:onTapMediaItemTip");
//    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:nil message:@"输入提醒" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
//    alert.alertViewStyle = UIAlertViewStylePlainTextInput;
//    [alert showAlertWithCompletionHandler:^(NSInteger index) {
//        switch (index) {
//            case 1:{
//                UITextField *textField = [alert textFieldAtIndex:0];
//                NIMMessage *message = [NTESSessionMsgConverter msgWithTip:textField.text];
//                [self sendMessage:message];
//
//            }
//                break;
//            default:
//                break;
//        }
//    }];
}

#pragma mark - 录音事件
- (void)onRecordFailed:(NSError *)error
{
    [self.view makeToast:@"录音失败" duration:2 position:CSToastPositionCenter];
}

- (BOOL)recordFileCanBeSend:(NSString *)filepath
{
    NSURL    *URL = [NSURL fileURLWithPath:filepath];
    AVURLAsset *urlAsset = [[AVURLAsset alloc]initWithURL:URL options:nil];
    CMTime time = urlAsset.duration;
    CGFloat mediaLength = CMTimeGetSeconds(time);
    return mediaLength > 2;
}

- (void)showRecordFileNotSendReason
{
    [self.view makeToast:@"录音时间太短" duration:0.2f position:CSToastPositionCenter];
}

#pragma mark - Cell事件
- (BOOL)onTapCell:(NIMKitEvent *)event
{
    
    BOOL handled = [super onTapCell:event];
    NSString *eventName = event.eventName;
    if ([eventName isEqualToString:NIMKitEventNameTapContent])
    {
        NIMMessage *message = event.messageModel.message;
        NSDictionary *actions = [self cellActions];
        NSString *value = actions[@(message.messageType)];
        if (value) {
            SEL selector = NSSelectorFromString(value);
            if (selector && [self respondsToSelector:selector]) {
                NIMKit_SuppressPerformSelectorLeakWarning([self performSelector:selector withObject:message]);
                handled = YES;
            }
        }
    }
    else if([eventName isEqualToString:NIMKitEventNameTapLabelLink])
    {
        NSString *link = event.data;
        
        [[WYUtility dataUtil]routerWithName:link withSoureController:self];
//        [self.view makeToast:[NSString stringWithFormat:@"tap link : %@",link]
//                    duration:2
//                    position:CSToastPositionCenter];
        handled = YES;
    }
    else if ([eventName isEqualToString:NIMKitEventNameTapProductPicTextLink])
    {
        NIMCustomObject *object = event.messageModel.message.messageObject;
        if ([object.attachment isKindOfClass:[NTESAttachment class]])
        {
            NTESAttachment * attachment = object.attachment;
            NTESCustomProductLinkModel *model = attachment.model;
            NSString *link = model.linkUrl;
            [self pushProductDetail:link];
        }
        else if ([object.attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment * attachment = object.attachment;
            NTESSendProductLinkModel *model = attachment.model;
            NSString *link = model.url;
            [self pushProductDetail:link];
        }
        handled = YES;
    }else if ([eventName isEqualToString:NIMKitEventNameTapSendProduct])
    {
        [MobClick event:kUM_c_flashscreen];
        NIMMessage *message = event.messageModel.message;
        NIMCustomObject *object = message.messageObject;
        if([object.attachment isKindOfClass:[NTESSendProductLinkAttachment class]])
        {
            NTESSendProductLinkAttachment * attachment = object.attachment;
            [self sendCustomMessageWithProductInfoAttachment:attachment];
        }
        handled = YES;
        
    }
//    else if([eventName isEqualToString:NIMDemoEventNameOpenSnapPicture])
//    {
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
//        if(attachment.isFired){
//            return handled;
//        }
//        UIView *sender = event.data;
//        self.currentSingleSnapView = [NTESGalleryViewController alertSingleSnapViewWithMessage:object.message baseView:sender];
//        handled = YES;
//    }
//    else if([eventName isEqualToString:NIMDemoEventNameCloseSnapPicture])
//    {
//        //点击很快的时候可能会触发两次查看，所以这里不管有没有查看过 先强直销毁掉
//        NIMCustomObject *object = event.messageModel.message.messageObject;
//        UIView *senderView = event.data;
//        [senderView dismissPresentedView:YES complete:nil];
//        
//        NTESSnapchatAttachment *attachment = (NTESSnapchatAttachment *)object.attachment;
//        if(attachment.isFired){
//            return handled;
//        }
//        attachment.isFired  = YES;
//        NIMMessage *message = object.message;
//        if ([NTESBundleSetting sharedConfig].autoRemoveSnapMessage) {
//            [[NIMSDK sharedSDK].conversationManager deleteMessage:message];
//            [self uiDeleteMessage:message];
//            
//        }else{
//            [[NIMSDK sharedSDK].conversationManager updateMessage:message forSession:message.session completion:nil];
//            [self uiUpdateMessage:message];
//        }
//        [[NSFileManager defaultManager] removeItemAtPath:attachment.filepath error:nil];
//        handled = YES;
//        self.currentSingleSnapView = nil;
//    }

    if (!handled) {
        NSAssert(0, @"invalid event");
    }
    return handled;
}

- (void)pushProductDetail:(NSString *)link
{
    [[WYUtility  dataUtil]routerWithName:link withSoureController:self];
}

- (NSDictionary *)cellActions
{
    static NSDictionary *actions = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        actions = @{@(NIMMessageTypeImage) :    @"showImage:",
                    @(NIMMessageTypeVideo) :    @"showVideo:",
                    @(NIMMessageTypeLocation) : @"showLocation:",
                    @(NIMMessageTypeFile)  :    @"showFile:",
                    @(NIMMessageTypeCustom):    @"showCustom:"};
    });
    return actions;
}




#pragma mark - Cell Actions
- (void)showImage:(NIMMessage *)message
{
    NIMImageObject *object = (NIMImageObject *)message.messageObject;
    self.showImageObject = object;
    //大图浏览
    XLPhotoBrowser *browser = [XLPhotoBrowser showPhotoBrowserWithCurrentImageIndex:0 imageCount:1 datasource:self];
    browser.browserStyle = XLPhotoBrowserStyleCustom;
    browser.pageControlStyle = XLPhotoBrowserPageControlStyleClassic;
    
    
//    NTESGalleryItem *item = [[NTESGalleryItem alloc] init];
//    item.thumbPath      = [object thumbPath];
//    item.imageURL       = [object url];
//    item.name           = [object displayName];
//    NTESGalleryViewController *vc = [[NTESGalleryViewController alloc] initWithItem:item];
//    [self.navigationController pushViewController:vc animated:YES];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:object.thumbPath]){
//        //如果缩略图下跪了，点进看大图的时候再去下一把缩略图
//        __weak typeof(self) wself = self;
//        [[NIMSDK sharedSDK].resourceManager download:object.thumbUrl filepath:object.thumbPath progress:nil completion:^(NSError *error) {
//            if (!error) {
//                [wself uiUpdateMessage:message];
//            }
//        }];
//    }
}

#pragma mark    - XLPhotoBrowserDatasource

- (NSURL *)photoBrowser:(XLPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    
    return [NSURL URLWithString:self.showImageObject.url];
}

- (void)showVideo:(NIMMessage *)message
{
    NIMVideoObject *object = message.messageObject;
    
    NIMSession *session = [self isMemberOfClass:[NTESSessionViewController class]]? self.session : nil;
    
    NTESVideoViewItem *item = [[NTESVideoViewItem alloc] init];
    item.path = object.path;
    item.url  = object.url;
    item.session = session;
    item.itemId  = object.message.messageId;
    
    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoViewItem:item];
    [self.navigationController pushViewController:playerViewController animated:YES];
    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
        //如果封面图下跪了，点进视频的时候再去下一把封面图
        __weak typeof(self) wself = self;
        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
            if (!error) {
                [wself uiUpdateMessage:message];
            }
        }];
    }
//    NTESVideoViewController *playerViewController = [[NTESVideoViewController alloc] initWithVideoObject:object];
//    [self.navigationController pushViewController:playerViewController animated:YES];
//    if(![[NSFileManager defaultManager] fileExistsAtPath:object.coverPath]){
//        //如果封面图下跪了，点进视频的时候再去下一把封面图
//        __weak typeof(self) wself = self;
//        [[NIMSDK sharedSDK].resourceManager download:object.coverUrl filepath:object.coverPath progress:nil completion:^(NSError *error) {
//            if (!error) {
//                [wself uiUpdateMessage:message];
//            }
//        }];
//    }
}

- (void)showLocation:(NIMMessage *)message
{
//    NIMLocationObject *object = message.messageObject;
//    NIMKitLocationPoint *locationPoint = [[NIMKitLocationPoint alloc] initWithLocationObject:object];
//    NIMLocationViewController *vc = [[NIMLocationViewController alloc] initWithLocationPoint:locationPoint];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showFile:(NIMMessage *)message
{
//    NIMFileObject *object = message.messageObject;
//    NTESFilePreViewController *vc = [[NTESFilePreViewController alloc] initWithFileObject:object];
//    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showCustom:(NIMMessage *)message
{
   //普通的自定义消息点击事件可以在这里做哦~
}


#pragma mark - 导航按钮
//个人信息：
- (void)onTouchUpInfoBtn:(id)sender{
//    NTESSessionCardViewController *vc = [[NTESSessionCardViewController alloc] initWithSession:self.session];
//    [self.navigationController pushViewController:vc animated:YES];
}

//历史消息记录操作
/*
- (void)enterHistory:(id)sender{
    [self.view endEditing:YES];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择操作" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"云消息记录",@"搜索本地消息记录",@"清空本地聊天记录", nil];
    [sheet showInView:self.view completionHandler:^(NSInteger index) {
        switch (index) {
            case 0:{ //查看云端消息
                NTESSessionRemoteHistoryViewController *vc = [[NTESSessionRemoteHistoryViewController alloc] initWithSession:self.session];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 1:{ //搜索本地消息
                NTESSessionLocalHistoryViewController *vc = [[NTESSessionLocalHistoryViewController alloc] initWithSession:self.session];
                [self.navigationController pushViewController:vc animated:YES];
                break;
            }
            case 2:{ //清空聊天记录
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"确定清空聊天记录？" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
                __weak UIActionSheet *wSheet;
                [sheet showInView:self.view completionHandler:^(NSInteger index) {
                    if (index == wSheet.destructiveButtonIndex) {
                        BOOL removeRecentSession = [NTESBundleSetting sharedConfig].removeSessionWheDeleteMessages;
                        [[NIMSDK sharedSDK].conversationManager deleteAllmessagesInSession:self.session removeRecentSession:removeRecentSession];
                    }
                }];
                break;
            }
            default:
                break;
        }
    }];
}
*/
//- (void)enterTeamCard:(id)sender{
//    NIMTeam *team = [[NIMSDK sharedSDK].teamManager teamById:self.session.sessionId];
//    UIViewController *vc;
//    if (team.type == NIMTeamTypeNormal) {
//        vc = [[NIMNormalTeamCardViewController alloc] initWithTeam:team];
//    }else if(team.type == NIMTeamTypeAdvanced){
//        vc = [[NIMAdvancedTeamCardViewController alloc] initWithTeam:team];
//    }
//    [self.navigationController pushViewController:vc animated:YES];
//}

#pragma mark - 菜单
- (NSArray *)menusItems:(NIMMessage *)message
{
    NSMutableArray *items = [NSMutableArray array];
    NSArray *defaultItems = [super menusItems:message];
    if (defaultItems) {
        [items addObjectsFromArray:defaultItems];
    }
    //没有朋友列表是无法选择转发对象的
//    if ([NTESSessionUtil canMessageBeForwarded:message]) {
//        [items addObject:[[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)]];
//    }
    
    if ([NTESSessionUtil canMessageBeRevoked:message]) {
        [items addObject:[[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(revokeMessage:)]];
    }
    //转文字功能有问题
//    if (message.messageType == NIMMessageTypeAudio) {
//        [items addObject:[[UIMenuItem alloc] initWithTitle:@"转文字" action:@selector(audio2Text:)]];
//    }
    
    return items;
    
}

//- (void)audio2Text:(id)sender
//{
//    NIMMessage *message = [self messageForMenu];
//    __weak typeof(self) wself = self;
//    NTESAudio2TextViewController *vc = [[NTESAudio2TextViewController alloc] initWithMessage:message];
//    vc.completeHandler = ^(void){
//        [wself uiUpdateMessage:message];
//    };
//    [self presentViewController:vc
//                       animated:YES
//                     completion:nil];
//}


//- (void)forwardMessage:(id)sender
//{
//    NIMMessage *message = [self messageForMenu];
//    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"选择会话类型" delegate:nil cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"个人",@"群组", nil];
//    __weak typeof(self) weakSelf = self;
//    [sheet showInView:self.view completionHandler:^(NSInteger index) {
//        switch (index) {
//            case 0:{
//                NIMContactFriendSelectConfig *config = [[NIMContactFriendSelectConfig alloc] init];
//                config.needMutiSelected = NO;
//                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
//                vc.finshBlock = ^(NSArray *array){
//                    NSString *userId = array.firstObject;
//                    NIMSession *session = [NIMSession session:userId type:NIMSessionTypeP2P];
//                    [weakSelf forwardMessage:message toSession:session];
//                };
//                [vc show];
//            }
//                break;
//            case 1:{
//                NIMContactTeamSelectConfig *config = [[NIMContactTeamSelectConfig alloc] init];
//                NIMContactSelectViewController *vc = [[NIMContactSelectViewController alloc] initWithConfig:config];
//                vc.finshBlock = ^(NSArray *array){
//                    NSString *teamId = array.firstObject;
//                    NIMSession *session = [NIMSession session:teamId type:NIMSessionTypeTeam];
//                    [weakSelf forwardMessage:message toSession:session];
//                };
//                [vc show];
//            }
//                break;
//            case 2:
//                break;
//            default:
//                break;
//        }
//    }];
//}
//
//
- (void)revokeMessage:(id)sender
{
    NIMMessage *message = [self messageForMenu];
    __weak typeof(self) weakSelf = self;
    [[NIMSDK sharedSDK].chatManager revokeMessage:message completion:^(NSError * _Nullable error) {
        if (error) {
            if (error.code == NIMRemoteErrorCodeDomainExpireOld) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"发送时间超过2分钟的消息，不能被撤回" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
            }else{
                NSLog(@"revoke message eror code %zd",error.code);
                [weakSelf.view makeToast:@"消息撤回失败，请重试" duration:2.0 position:CSToastPositionCenter];
            }
        }
        else
        {
            NIMMessageModel *model = [self uiDeleteMessage:message];
            NIMMessage *tip = [NTESSessionMsgConverter msgWithTip:[NTESSessionUtil tipOnMessageRevoked:message]];
            tip.timestamp = model.messageTime;
            [self uiInsertMessages:@[tip]];
            
            tip.timestamp = message.timestamp;
            // saveMessage 方法执行成功后会触发 onRecvMessages: 回调，但是这个回调上来的 NIMMessage 时间为服务器时间，和界面上的时间有一定出入，所以要提前先在界面上插入一个和被删消息的界面时间相符的 Tip, 当触发 onRecvMessages: 回调时，组件判断这条消息已经被插入过了，就会忽略掉。
            [[NIMSDK sharedSDK].conversationManager saveMessage:tip forSession:message.session completion:nil];
        }
    }];
}


//- (void)forwardMessage:(NIMMessage *)message toSession:(NIMSession *)session
//{
//    NSString *name;
//    if (session.sessionType == NIMSessionTypeP2P)
//    {
//        NIMKitInfoFetchOption *option = [[NIMKitInfoFetchOption alloc] init];
//        option.session = session;
//        name = [[NIMKit sharedKit] infoByUser:session.sessionId option:option].showName;
//    }
//    else
//    {
//        name = [[NIMKit sharedKit] infoByTeam:session.sessionId option:nil].showName;
//    }
//    NSString *tip = [NSString stringWithFormat:@"确认转发给 %@ ?",name];
//    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"确认转发" message:tip delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
//    
//    __weak typeof(self) weakSelf = self;
//    [alert showAlertWithCompletionHandler:^(NSInteger index) {
//        if(index == 1){
//            [[NIMSDK sharedSDK].chatManager forwardMessage:message toSession:session error:nil];
//            [weakSelf.view makeToast:@"已发送" duration:2.0 position:CSToastPositionCenter];
//        }
//    }];
//}

#pragma mark - 辅助方法

//- (void)sendImageMessagePath:(NSString *)path
//{
//
//    [self sendSnapchatMessagePath:path];
//}
//

- (BOOL)checkCondition
{
    BOOL result = YES;
    
//    if (![[Reachability reachabilityForInternetConnection] isReachable]) {
//        [self.view makeToast:@"请检查网络" duration:2.0 position:CSToastPositionCenter];
//        result = NO;
//    }
    NSString *currentAccount = [[NIMSDK sharedSDK].loginManager currentAccount];
    if ([currentAccount isEqualToString:self.session.sessionId]) {
        [self.view makeToast:@"不能和自己通话哦" duration:2.0 position:CSToastPositionCenter];
        result = NO;
    }
    return result;
}

//没用
- (NIMKitMediaFetcher *)mediaFetcher
{
    if (!_mediaFetcher) {
        _mediaFetcher = [[NIMKitMediaFetcher alloc] init];
        _mediaFetcher.limit = 1;
        _mediaFetcher.mediaTypes = @[(NSString *)kUTTypeImage];;;
    }
    return _mediaFetcher;
}


//- (BOOL)shouldAutorotate{
//    return !self.currentSingleSnapView;
//}

@end
