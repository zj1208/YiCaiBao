//
//  ExtendSuccessViewController.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendSuccessViewController.h"

@interface ExtendSuccessViewController ()
//分享参数
@property(nonatomic,strong)NSString* shareimageStr;
@property(nonatomic,strong)NSString* sharetitle;
@property(nonatomic,strong)NSString* sharecontent;
@property(nonatomic,strong)NSString* shareUrl;
@end

@implementation ExtendSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


//退出按钮
- (IBAction)exit:(id)sender {
    
    if (self.parentViewController)
    {
        [self willMoveToParentViewController:nil];
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
        
    }

    if (self.delegate &&[self.delegate respondsToSelector:@selector(ExtendSuccessViewControllerViewWillRemoveFromSuperview:)]){
        [self.delegate ExtendSuccessViewControllerViewWillRemoveFromSuperview:self];
    }
}
//qq
- (IBAction)qqBtn:(id)sender {
    
    [self shareWithShareType:SSDKPlatformSubTypeQQFriend];

    [self exit:nil];
}

//微信好友
- (IBAction)wechatFriends:(id)sender {
    
    
    [self shareWithShareType:SSDKPlatformSubTypeWechatSession];

    [self exit:nil];

}
//qq空间
- (IBAction)qqZone:(id)sender {
    
    [self shareWithShareType:SSDKPlatformSubTypeQZone];

    [self exit:nil];

}

//微信朋友圈
- (IBAction)wechat:(id)sender {
    [self shareWithShareType:SSDKPlatformSubTypeWechatTimeline];
    [self exit:nil];

}
-(void)shareWithShareType:(SSDKPlatformType)shareType
{
    //创建分享参数
    [WYShareManager shareSDKWithShareType:shareType Image:self.shareimageStr Title:self.sharetitle Content:self.sharecontent withUrl:self.shareUrl];

}

-(void)shareWithImage:(NSString *)imageStr Title:(NSString *)title Content:(NSString *)content withUrl:(NSString *)url
{
    //分享参数
    self.shareimageStr = [NSString stringWithFormat:@"%@",imageStr];
    self.sharetitle = [NSString stringWithFormat:@"%@",title];;
    self.sharecontent = [NSString stringWithFormat:@"%@",content];;
    self.shareUrl = [NSString stringWithFormat:@"%@",url];;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
