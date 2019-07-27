//
//  WYshare.m
//  YiShangbao
//
//  Created by 何可 on 2016/12/5.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYshare.h"


@implementation WYshare
+(WYshare *)wyshare
{
    static dispatch_once_t once;
    static WYshare *mInstance;
    dispatch_once(&once, ^ { mInstance = [[WYshare alloc] init]; });
    return mInstance;
}



//1、创建分享参数
-(void)shareSDKWithImage:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url{
    //         url = [NSString stringWithString:[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"wx"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
    if (imageStr) {
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        //        [shareParams SSDKSetupShareParamsByText:[NSString stringWithFormat:@"%@",content]
        //                                         images:imageStr
        //                                            url:[NSURL URLWithString:url]
        //                                          title:title
        //                                           type:SSDKContentTypeAuto];
        
        //分享特殊渠道
        NSString *strWX = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"wx"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *urlWX = [NSURL URLWithString:strWX];
        
        NSString *strQQ = [[[url stringByReplacingOccurrencesOfString:@"{channel}" withString:@"qq"] copy] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        NSURL *urlQQ = [NSURL URLWithString:strQQ];
        
        NSString *thumbImageName = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageStr];
//        微信好友
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
                              forPlatformSubType:SSDKPlatformSubTypeWechatTimeline];
        //QQ分享
        [shareParams SSDKSetupQQParamsByText:content
                                       title:title
                                         url:urlQQ
                                  thumbImage:thumbImageName
                                       image:thumbImageName
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeQQFriend];
        
        [shareParams SSDKSetupQQParamsByText:content
                                       title:title
                                         url:urlQQ
                                  thumbImage:thumbImageName
                                       image:thumbImageName
                                        type:SSDKContentTypeAuto
                          forPlatformSubType:SSDKPlatformSubTypeQZone];
        
        
        
        NSArray *shareList = @[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline), @(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone)];
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        [ShareSDK showShareActionSheet:nil
                                 items:shareList
                           shareParams:shareParams
                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
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
                                                                               message:@"您的手机上还没有安装您要分享的app，请您安装后再分享哦～"
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil, nil];
                               [alert show];
                               break;
                           }
                           default:
                               break;
                       }
                   }];
    }
}
//自定义Ui分享
//1、创建分享参数
-(void)shareSDKWithShareType:(SSDKPlatformType)shareType Image:(id)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url
{
    
    NSString *thumbImageName = [NSString stringWithFormat:@"%@?x-oss-process=image/resize,m_lfit,h_100,w_100",imageStr];
    NSURL *urlWX = [NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@"{ttid}" withString:@"wx"]];
    NSURL *urlQQ =[NSURL URLWithString:[url stringByReplacingOccurrencesOfString:@"{ttid}" withString:@"qq"]];
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
                                                 url:urlQQ
                                          thumbImage:thumbImageName
                                               image:thumbImageName
                                                type:SSDKContentTypeAuto
                                  forPlatformSubType:SSDKPlatformSubTypeQZone];
            case 23:
                //微信朋友圈
                
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
            
            
        }];
        
        
    }
}











//+(void)sharewithStrImage:(NSString *)image title:(NSString *)tile content:(NSString *)content andUrl:(NSString *)url{
//    //1、创建分享参数
////    NSArray* imageArray = @[[UIImage imageNamed:@"shareImg.png"]];
//    NSArray* imageArray = @[image];
//    //（注意：图片必须要在Xcode左边目录里面，名称必须要传正确，如果要分享网络图片，可以这样传iamge参数 images:@[@"http://mob.com/Assets/images/logo.png?v=20150320"]）
//    if (imageArray) {
//
//        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
//        [shareParams SSDKSetupShareParamsByText:content
//                                         images:imageArray
//                                            url:[NSURL URLWithString:url]
//                                          title:tile
//                                           type:SSDKContentTypeAuto];
//        //2、分享（可以弹出我们的分享菜单和编辑界面）
//        [ShareSDK showShareActionSheet:nil //要显示菜单的视图, iPad版中此参数作为弹出菜单的参照视图，只有传这个才可以弹出我们的分享菜单，可以传分享的按钮对象或者自己创建小的view 对象，iPhone可以传nil不会影响
//                                 items:nil
//                           shareParams:shareParams
//                   onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
//
//                       switch (state) {
//                           case SSDKResponseStateSuccess:
//                           {
//                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
//                                                                                   message:nil
//                                                                                  delegate:nil
//                                                                         cancelButtonTitle:@"确定"
//                                                                         otherButtonTitles:nil];
//                               [alertView show];
//                               break;
//                           }
//                           case SSDKResponseStateFail:
//                           {
//                               UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
//                                                                               message:[NSString stringWithFormat:@"%@",error]
//                                                                              delegate:nil
//                                                                     cancelButtonTitle:@"OK"
//                                                                     otherButtonTitles:nil, nil];
//                               [alert show];
//                               break;
//                           }
//                           default:
//                               break;
//                       }
//                   }
//         ];}
//}


@end
