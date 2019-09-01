//
//  WYShareViewController.m
//  YiShangbao
//
//  Created by light on 2018/4/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYShareViewController.h"
#import "WYShareCollectionViewCell.h"

#import <TencentOpenAPI/QQApiInterface.h>
#import "WXApi.h"

#import "WYShareLinkmanViewController.h"
 #import "ZXModalPresentaionController.h"
@interface WYShareViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate,UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) IBOutlet UIView *shareView;
@property (weak, nonatomic) IBOutlet UICollectionView *pushCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *shareCollectionView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shareViewHightConstraint;


@property (nonatomic) WYShareType shareType;
@property (nonatomic) BOOL isHaveWechat;
@property (nonatomic) BOOL isHaveQQ;

@property (nonatomic, weak) UIViewController *showVC;
@property (nonatomic) id imageStr;
@property (nonatomic, copy) NSString *shareTitle;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *url;

@property (nonatomic, copy) WYShareTypeBlock block;
@end

@implementation WYShareViewController

#pragma mark ------LifeCircle------

+(WYShareViewController *)shareManeger{
    static dispatch_once_t once;
    static WYShareViewController *mInstance;
    dispatch_once(&once, ^ { mInstance = [[WYShareViewController alloc]initWithNibName:@"WYShareViewController" bundle:nil]; });
    return mInstance;
}

- (void)canPushInAPPWithShareType:(WYShareTypeBlock)block{
    self.block = block;
    self.shareViewHightConstraint.constant = 320.0;
    [self.shareView setNeedsLayout];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUI];
    
    
    if ([QQApiInterface isQQInstalled]) {
        self.isHaveQQ = YES;
    }
    if ([WXApi isWXAppInstalled]) {
        self.isHaveWechat = YES;
    }

//    self.imageStr = @"https://www.baidu.com/img/bd_logo1.png?qua=high";
//    self.shareTitle = @"123";
//    self.content = @"123412";
//    self.url = @"www.baidu.com";
    
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showIn:(UIViewController *)viewController{
    float safeBottom = 0;
    if (@available(iOS 11.0, *)) {
        safeBottom = viewController.navigationController.view.safeAreaInsets.bottom;
    } else {
        // Fallback on earlier versions
    }
    
    self.shareViewHightConstraint.constant = 175.0;
    [self.shareView setNeedsLayout];
    self.showVC = viewController;
    self.modalPresentationStyle = UIModalPresentationCustom;
    self.transitioningDelegate = self;
//    viewController.definesPresentationContext = YES;
//    self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
//    viewController.tabBarController.tabBar.hidden = YES;
    
    
    [viewController presentViewController:self animated:NO completion:nil];
    
//    if (viewController.tabBarController){
//        [viewController.tabBarController addChildViewController:self];
//        [viewController.tabBarController.view addSubview:self.view];
//        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(viewController.tabBarController.view);
//            make.left.equalTo(viewController.tabBarController.view);
//            make.right.equalTo(viewController.tabBarController.view);
//            make.bottom.equalTo(viewController.tabBarController.view).offset(-safeBottom);
//        }];
//    }else if(viewController.navigationController){
////        [viewController.navigationController addChildViewController:self];
//        [viewController.navigationController.view addSubview:self.view];
//        [self.view mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(viewController.navigationController.view);
//            make.left.equalTo(viewController.navigationController.view);
//            make.right.equalTo(viewController.navigationController.view);
//            make.bottom.equalTo(viewController.navigationController.view).offset(-safeBottom);
//        }];
//    }
    
//    self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
////    self.shareView.bounds = CGRectMake(0, 500, SCREEN_WIDTH, 500);
////    [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500)];
//    [self.shareView setBounds:CGRectMake(0, 500, SCREEN_WIDTH, 500)];
//    [UIView animateWithDuration:1.5 animations:^{
//        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
////        [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT - 500, SCREEN_WIDTH, 500)];
//        [self.shareView setBounds:CGRectMake(0, 0, SCREEN_WIDTH, 500)];
//    }];
    
//    self.view.backgroundColor = [UIColor clearColor];
    
    self.shareCollectionView.contentOffset=CGPointMake(0, 0);
}

- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    ZXModalPresentaionController *presentation =  [[ZXModalPresentaionController alloc] initWithPresentedViewController:presented presentingViewController:presenting];
    if (@available(iOS 11.0, *)) {
        presentation.frameOfPresentedView = CGRectMake(0, LCDH-320-self.showVC.navigationController.view.safeAreaInsets.bottom, LCDW, 320);
    } else {
        presentation.frameOfPresentedView = CGRectMake(0, LCDH-320, LCDW, 320);
        // Fallback on earlier versions
    }
    return presentation;
}
#pragma mark ------ShareInAPP------

- (void)shareHotProduct{
    if (self.block) {
        self.block(WYShareTypeHotProduct);
        [self dissmissView];
    }
}

- (void)shareStock{
    if (self.block) {
        self.block(WYShareTypeStock);
        [self dissmissView];
    }
}

//复制链接
- (void)shareCopyLink{
    [MobClick event:kUM_b_component_copylink];
    self.url = [self.url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"copy"];
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.url;
    [MBProgressHUD zx_showSuccess:@"已复制成功" toView:nil];
    [self dissmissView];
}

//分享给义采宝客户
- (void)shareCustomers{
    if (![self zx_performIsLoginActionWithPopAlertView:NO]){
        return;
    }
    [MobClick event:kUM_b_component_linkman];
    self.url = [self.url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"customer"];
    WYShareLinkmanViewController *vc = [[WYShareLinkmanViewController alloc]initWithNibName:@"WYShareLinkmanViewController" bundle:nil];
    [vc shareWithImage:self.imageStr Title:self.shareTitle Content:self.content withUrl:self.url];
    vc.hidesBottomBarWhenPushed = YES;
    [self dissmissView];
    [self.showVC.navigationController pushViewController:vc animated:YES];
}

#pragma mark ------ButtonAction------

- (void)dissmissView{
    [self dismissViewControllerAnimated:NO completion:^{
        self.imageStr = nil;
        self.shareTitle = nil;
        self.content = nil;
        self.url = nil;
    }];
    [UIView animateWithDuration:0.25 animations:^{
        self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    }];
        //            [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500)];
//    if (self.view.superview){
////        [self removeFromParentViewController];
//        [UIView animateWithDuration:0.25 animations:^{
//            self.view.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
//            [self.shareView setFrame:CGRectMake(0, SCREEN_HEIGHT, SCREEN_WIDTH, 500)];
//        } completion:^(BOOL finished) {
//            [self.view removeFromSuperview];
//            self.imageStr = nil;
//            self.shareTitle = nil;
//            self.content = nil;
//            self.url = nil;
//        }];
//    }
}

#pragma mark ------UIGestureRecognizerDelegate------
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isDescendantOfView:self.pushCollectionView] || [touch.view isDescendantOfView:self.shareCollectionView]){
        return NO;
    }
    return YES;
}

#pragma mark ------UICollectionViewDataSource------

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (collectionView == self.pushCollectionView) {
        return 2;
    }else if (collectionView == self.shareCollectionView){
        return 2 + (_isHaveQQ + _isHaveWechat) * 2;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WYShareCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:WYShareCollectionViewCellID forIndexPath:indexPath];
    
    WYShareType shareType = [self shareTypeByCollectionView:collectionView indexPath:indexPath];
    [cell updaDataShareType:shareType];
    return cell;
}

#pragma mark ------UICollectionViewDelgate------

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WYShareType shareType = [self shareTypeByCollectionView:collectionView indexPath:indexPath];
    [self shareType:shareType];
}

#pragma mark ------Private------

- (void)setUI{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(80, 105);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.minimumLineSpacing = 2;
    _pushCollectionView.backgroundColor = [UIColor whiteColor];
    _pushCollectionView.dataSource = self;
    _pushCollectionView.delegate = self;
    _pushCollectionView.scrollsToTop = NO;
    _pushCollectionView.showsVerticalScrollIndicator = NO;
    _pushCollectionView.showsHorizontalScrollIndicator = NO;
    _pushCollectionView.collectionViewLayout = layout;
    
    [_pushCollectionView registerNib:[UINib nibWithNibName:@"WYShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WYShareCollectionViewCellID];
    
    UICollectionViewFlowLayout *layout2 = [[UICollectionViewFlowLayout alloc] init];
    layout2.itemSize = CGSizeMake(80, 105);
    layout2.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout2.minimumLineSpacing = 2;
    _shareCollectionView.backgroundColor = [UIColor whiteColor];
    _shareCollectionView.dataSource = self;
    _shareCollectionView.delegate = self;
    _shareCollectionView.scrollsToTop = NO;
    _shareCollectionView.showsVerticalScrollIndicator = NO;
    _shareCollectionView.showsHorizontalScrollIndicator = NO;
    _shareCollectionView.collectionViewLayout = layout2;
    
    [_shareCollectionView registerNib:[UINib nibWithNibName:@"WYShareCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:WYShareCollectionViewCellID];
    
    UITapGestureRecognizer *tapGesturRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dissmissView)];
    tapGesturRecognizer.delegate = self;
    [self.view addGestureRecognizer:tapGesturRecognizer];
    
    self.shareView.layer.masksToBounds = YES;
}

- (void)shareType:(WYShareType)shareType{
    switch (shareType) {
        case WYShareTypeHotProduct:
            [self shareHotProduct];
            break;
        case WYShareTypeStock:
            [self shareStock];
            break;
        case WYShareTypeCopyLink:
            [self shareCopyLink];
            break;
        case WYShareTypeCustomers:
            [self shareCustomers];
            break;
        case WYShareTypeWechatSession:
            [self shareSDKWithShareType:SSDKPlatformSubTypeWechatSession];
            break;
        case WYShareTypeWechatCircle:
            [self shareSDKWithShareType:SSDKPlatformSubTypeWechatTimeline];
            break;
        case WYShareTypeQQ:
            [self shareSDKWithShareType:SSDKPlatformSubTypeQQFriend];
            break;
        case WYShareTypeQQZone:
            [self shareSDKWithShareType:SSDKPlatformSubTypeQZone];
            break;
            
        default:
            break;
    }
}

//返回当前cell分享类型
- (WYShareType)shareTypeByCollectionView:(UICollectionView *)collectionView indexPath:(NSIndexPath *)indexPath{
    //没有安装微信QQ位置变化
    if (!self.isHaveWechat && indexPath.item > 1) {
        indexPath = [NSIndexPath indexPathForRow:indexPath.item + 2 inSection:indexPath.section];;
    }
    
    if (collectionView == self.pushCollectionView) {
        if (indexPath.item == 0) {
            return  WYShareTypeHotProduct;
        }else if (indexPath.item == 1){
            return  WYShareTypeStock;
        }
    }else if (collectionView == self.shareCollectionView){
        if (indexPath.item == 0) {
            return  WYShareTypeCopyLink;
        }else if (indexPath.item == 1){
            return  WYShareTypeCustomers;
        }else if (indexPath.item == 2){
            return  WYShareTypeWechatSession;
        }else if (indexPath.item == 3){
            return  WYShareTypeWechatCircle;
        }else if (indexPath.item == 4){
            return  WYShareTypeQQ;
        }else if (indexPath.item == 5){
            return  WYShareTypeQQZone;
        }
    }
    return WYShareTypeNot;
}

#pragma mark ------Share处理------

- (void)shareSDKWithShareType:(SSDKPlatformType)shareType{
    [self shareSDKWithShareType:shareType Image:self.imageStr Title:self.shareTitle Content:self.content withUrl:self.url];
}

- (void)shareDataWithImage:(NSString *)imageStr withTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)url{
    
    url = [url stringByReplacingOccurrencesOfString:@"{ttid}" withString:[BaseHttpAPI getCurrentAppVersion]];
    url = [url stringByReplacingOccurrencesOfString:@"{os}" withString:@"ios"];
    
    self.imageStr = imageStr;
    self.shareTitle = title;
    self.content = content;
    self.url = url;
}

- (void)shareInVC:(UIViewController *)viewController withImage:(NSString *)imageStr withTitle:(NSString *)title withContent:(NSString *)content withUrl:(NSString *)url{
    [self showIn:viewController];
    [self shareDataWithImage:imageStr withTitle:title withContent:content withUrl:url];
}

//自定义Ui分享
//1、创建分享参数
- (void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url{
    
    NSString *thumbImageName = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageStr];
    
    //分享特殊渠道
    NSString *strWX = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"wx"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *urlWX = [NSURL URLWithString:strWX];
    
    NSString *strWechatCircle = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"pyq"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *urlWechatCircle = [NSURL URLWithString:strWechatCircle];
    
    NSString *strQQ = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"qq"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *urlQQ = [NSURL URLWithString:strQQ];
    
    NSString *strQZone = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"qqkj"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    NSURL *urlQZone = [NSURL URLWithString:strQZone];
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageStr) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        //        [shareParams SSDKSetupShareParamsByText:content
        //                                         images:@[imageStr]
        //                                            url:[NSURL URLWithString:url]
        //                                          title:title
        //                                           type:SSDKContentTypeAuto];
        
        
        //url: http://wykj-internal.s-ant.cn/yicaibao/stockShare?id=126&ttid={ttid}
        
        //        NSLog(@"%@",url);
        
        switch (shareType) {
            case 24:
                //QQ分享
                [shareParams SSDKSetupQQParamsByText:content
                                               title:title
                                                 url:urlQQ
                                          thumbImage:thumbImageName
                                               image:thumbImageName
                                                type:SSDKContentTypeAuto
                                  forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                break;
            case 6:
                //空间
                [shareParams SSDKSetupQQParamsByText:content
                                               title:title
                                                 url:urlQZone
                                          thumbImage:thumbImageName
                                               image:thumbImageName
                                                type:SSDKContentTypeAuto
                                  forPlatformSubType:SSDKPlatformSubTypeQZone];
            case 23:
                //微信朋友圈
                
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
                                                     url:urlWechatCircle
                                              thumbImage:imageStr
                                                   image:imageStr
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAuto
                                      forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                break;
            case 22:
                //微信好友
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
                                                     url:urlWX
                                              thumbImage:imageStr
                                                   image:imageStr
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAuto
                                      forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                break;
                
            default:
                break;
        }
        
        WS(weakSelf)
        /*
         调用shareSDK的无UI分享类型，
         */
        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            NSLog(@"%ld",state);
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
            [weakSelf dissmissView];
            
        }];
        
        
    }
}

#pragma mark ---不编码，目前只用于开单预览的分享微信好友-单独copy不影响其他地方------
//encodedUrl 已编码完成不需要对URL再编码
- (void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withPercentEncodedUrl:(NSString *)encodedUrl
{
    
    NSString *thumbImageName = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageStr];
    
    //分享特殊渠道
    NSString *strWX = [[encodedUrl stringByReplacingOccurrencesOfString:@"{channel}" withString:@"wx"] copy];
    NSURL *urlWX = [NSURL URLWithString:strWX];
    
    NSString *strWechatCircle = [[encodedUrl stringByReplacingOccurrencesOfString:@"{channel}" withString:@"pyq"] copy];
    NSURL *urlWechatCircle = [NSURL URLWithString:strWechatCircle];

    NSString *strQQ = [[encodedUrl stringByReplacingOccurrencesOfString:@"{channel}" withString:@"qq"] copy] ;
    NSURL *urlQQ = [NSURL URLWithString:strQQ];
    
    NSString *strQZone = [[encodedUrl stringByReplacingOccurrencesOfString:@"{channel}" withString:@"qqkj"] copy];
    NSURL *urlQZone = [NSURL URLWithString:strQZone];
    
    
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageStr) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        
        //        [shareParams SSDKSetupShareParamsByText:content
        //                                         images:@[imageStr]
        //                                            url:[NSURL URLWithString:url]
        //                                          title:title
        //                                           type:SSDKContentTypeAuto];
        
        
        //url: http://wykj-internal.s-ant.cn/yicaibao/stockShare?id=126&ttid={ttid}
        
        //        NSLog(@"%@",url);
        
        switch (shareType) {
            case 24:
                //QQ分享
                [shareParams SSDKSetupQQParamsByText:content
                                               title:title
                                                 url:urlQQ
                                          thumbImage:thumbImageName
                                               image:thumbImageName
                                                type:SSDKContentTypeAuto
                                  forPlatformSubType:SSDKPlatformSubTypeQQFriend];
                break;
            case 6:
                //空间
                [shareParams SSDKSetupQQParamsByText:content
                                               title:title
                                                 url:urlQZone
                                          thumbImage:thumbImageName
                                               image:thumbImageName
                                                type:SSDKContentTypeAuto
                                  forPlatformSubType:SSDKPlatformSubTypeQZone];
            case 23:
                //微信朋友圈
                
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
                                                     url:urlWechatCircle
                                              thumbImage:imageStr
                                                   image:imageStr
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAuto
                                      forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
                break;
            case 22:
                //微信好友
                [shareParams SSDKSetupWeChatParamsByText:content
                                                   title:title
                                                     url:urlWX
                                              thumbImage:imageStr
                                                   image:imageStr
                                            musicFileURL:nil
                                                 extInfo:nil
                                                fileData:nil
                                            emoticonData:nil
                                                    type:SSDKContentTypeAuto
                                      forPlatformSubType:SSDKPlatformSubTypeWechatSession];
                break;
                
            default:
                break;
        }
        
        WS(weakSelf)
        /*
         调用shareSDK的无UI分享类型，
         */
        [ShareSDK share:shareType parameters:shareParams onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
            
            NSLog(@"%ld",state);
            
            switch (state) {
                case SSDKResponseStateSuccess:
                {
                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                        message:nil
                                                                       delegate:nil
                                                              cancelButtonTitle:@"确定"
                                                              otherButtonTitles:nil];
                    [alertView show];
                    break;
                }
                case SSDKResponseStateFail:
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                    message:[NSString stringWithFormat:@"%@",error]
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                    [alert show];
                    break;
                }
                default:
                    break;
            }
            [weakSelf dissmissView];
            
        }];
        
        
    }
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
