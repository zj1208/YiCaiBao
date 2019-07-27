//
//  EventViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/3/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "EventViewController.h"
#import "WYPurchaserViewController.h"

#define kEventTime 3.5
@interface EventViewController ()

@property (nonatomic ,strong) UIButton *skipBtn;
@property (nonatomic, strong) UIImageView *trademarkImageView;//广告位底部商标
@property (nonatomic, strong) UIImageView *ADImageView;//广告位图片
@property (nonatomic, strong) UIButton *ADButton;//广告位按钮

@property (nonatomic, strong) NSTimer *timer;

@end

@implementation EventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self initData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (void)dealloc{
//    if (_timer) {
//        [_timer invalidate];
//        _timer = nil;
//    }
//}

-(void)creatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.trademarkImageView = [[UIImageView alloc] init];
    self.trademarkImageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.view addSubview:self.trademarkImageView];
    [self.trademarkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (IS_IPHONE_XXX) {
            make.bottom.equalTo(self.view).offset(-44);
        }else if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
            make.bottom.equalTo(self.view).offset(-10);
        }
        make.centerX.equalTo(self.view);
    }];
    
    self.ADImageView = [[UIImageView alloc] init];
    self.ADImageView.alpha = 0;
    [self.view addSubview:self.ADImageView];
    [self.ADImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view);
        make.left.equalTo(self.view);
        make.right.equalTo(self.view);
        make.height.equalTo(@(SCREEN_WIDTH / 750.0 * 1116.0));
    }];
    
    self.ADButton = [[UIButton alloc] init];
    [self.view addSubview:self.ADButton];
    [self.ADButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.ADImageView.mas_top);
        make.left.equalTo(self.ADImageView.mas_left);
        make.right.equalTo(self.ADImageView.mas_right);
        make.bottom.equalTo(self.ADImageView.mas_bottom);
    }];
    [self.ADButton addTarget:self action:@selector(jumpTap) forControlEvents:UIControlEventTouchUpInside];
    self.trademarkImageView.image = [UIImage imageNamed:@"pic_hd"];
    
    self.skipBtn = [[UIButton alloc]init];
    [self.view addSubview:self.skipBtn];
    [self.skipBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(SCREEN_STATUSHEIGHT + 20);
        make.right.equalTo(self.view).offset(-15);
        make.width.equalTo(@90);
        make.height.equalTo(@30);
        if (IS_IPHONE_XXX) {
            make.top.equalTo(self.view).offset(64);
        }else if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view).offset(20);
        }
    }];
    self.skipBtn.isMoreClickZone = YES;
    [self.skipBtn setTitle:@"跳过" forState:UIControlStateNormal];
    [self.skipBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    [self.skipBtn addTarget:self action:@selector(hideEventPage) forControlEvents:UIControlEventTouchUpInside];
    [self.skipBtn setBackgroundColor:[UIColor colorWithHex:0x000000 alpha:0.5]];
    self.skipBtn.layer.masksToBounds = YES;
    self.skipBtn.layer.cornerRadius = 15;
    self.skipBtn.hidden = YES;
    [self startCountdownTimer];
}

-(void)initData{

    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_buyer)
    {
        if ([WYUserDefaultManager getOpenAPPPurchaserAdvURL])
        {
            NSURL *url =[NSURL URLWithString:[WYUserDefaultManager getOpenAPPPurchaserAdvURL]];
            [self.ADImageView sd_setImageWithURL:url completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                
                _skipBtn.hidden = NO;
            }];
            [UIView animateWithDuration:.1 animations:^{
                _ADImageView.alpha = 1;
            }];
//            [self performSelector:@selector(hideEventPage)
//                       withObject:nil
//                       afterDelay:3];
            return;
        }
    }
    else
    {
        if ([WYUserDefaultManager getOpenAPPSellerAdvURL])
        {
            NSLog(@"1");
            NSURL *url =[NSURL URLWithString:[WYUserDefaultManager getOpenAPPSellerAdvURL]];
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:url];
            UIImage *lastPreviousCachedImage = [[SDImageCache sharedImageCache] imageFromCacheForKey:key];
            self.ADImageView.image = lastPreviousCachedImage;
            if (lastPreviousCachedImage)
            {
                _skipBtn.hidden = NO;
            }
            [UIView animateWithDuration:.1 animations:^{
                _ADImageView.alpha = 1;
            }];
//            [self performSelector:@selector(hideEventPage)
//                       withObject:nil
//                       afterDelay:3];
            return;
        }
    }
     _skipBtn.hidden = YES;
//    [self performSelector:@selector(hideEventPage)
//               withObject:nil
//               afterDelay:1];
}

- (void)hideEventPage{

    NSLog(@"2");
    if ([APP_MainWindow.rootViewController isKindOfClass:[UITabBarController class]])
    {
        if (self.parentViewController) {
            [self.view removeFromSuperview];
            [self removeFromParentViewController];            
        }
    }
    else
    {
        //角色切换；
        if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_buyer)
        {
            WYPurchaserViewController *vc = [[WYPurchaserViewController alloc] init];
            APP_MainWindow.rootViewController = vc;
        }
        else
        {
            UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            APP_MainWindow.rootViewController =story.instantiateInitialViewController;
        }
    }

}

-(void)jumpTap{
    
    if ([WYUserDefaultManager isOpenAppRemoteNoti])
    {
        return;
    }
    
    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_buyer) {
        [MobClick event:kUM_c_flashscreen];
        
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kImageBuyerUrl])
        {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideEventPage) object:nil];
            
            if ([APP_MainWindow.rootViewController isKindOfClass:[UITabBarController class]])
            {
                UITabBarController *tabBarController = (UITabBarController *)APP_MainWindow.rootViewController;
                UINavigationController *nav = tabBarController.selectedViewController;
                [[WYUtility dataUtil]routerWithName:[[NSUserDefaults standardUserDefaults] objectForKey:kImageBuyerUrl] withSoureController:nav.topViewController];
            }
            else
            {
                [WYUserDefaultManager setDidFinishLaunchRemoteNoti:[[NSUserDefaults standardUserDefaults] objectForKey:kImageBuyerUrl]];
            }
            [self hideEventPage];

        }
        NSNumber* advid = [[NSUserDefaults standardUserDefaults] objectForKey:kImageBuyerUrl_ID];
        if (advid) {
            [self requestClickAdvWithAreaId:@2005 advId:[NSString stringWithFormat:@"%@",advid]];
        }
        
    }else{
        [MobClick event:kUM_b_flashscreen];
        if ([[NSUserDefaults standardUserDefaults] objectForKey:kImageBusinessUrl]) {
            [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(hideEventPage) object:nil];
            
            if ([APP_MainWindow.rootViewController isKindOfClass:[UITabBarController class]])
            {
                UITabBarController *tabBarController = (UITabBarController *)APP_MainWindow.rootViewController;
                UINavigationController *nav = tabBarController.selectedViewController;
                [[WYUtility dataUtil] routerWithName:[[NSUserDefaults standardUserDefaults] objectForKey:kImageBusinessUrl] withSoureController:nav.topViewController];

            }
            else
            {
                [WYUserDefaultManager setDidFinishLaunchRemoteNoti:[[NSUserDefaults standardUserDefaults] objectForKey:kImageBusinessUrl]];
            }
            [self hideEventPage];

        }
        NSNumber* advid = [[NSUserDefaults standardUserDefaults] objectForKey:kImageBusinessUrl_ID];
        if (advid) {
            [self requestClickAdvWithAreaId:@1002 advId:[NSString stringWithFormat:@"%@",advid]];
        }
    }
}

#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId
{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}
- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark ------VerifyCodeTimer

- (void)startCountdownTimer{
    
    self.skipBtn.tag = 4;
    [self.skipBtn setTitle:@"3秒后跳过" forState:UIControlStateNormal];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval: 1.0
                                     target: self
                                   selector: @selector(durationMinus)
                                   userInfo: nil
                                    repeats: YES];
}

- (void)durationMinus{
    NSInteger seconds = self.skipBtn.tag;
    seconds -= 1;
    self.skipBtn.tag = MAX(seconds, 0);
    if (self.skipBtn.tag > 0) {
        [self.skipBtn setTitle:[NSString stringWithFormat:@"%ld秒后跳过", (long)self.skipBtn.tag] forState:UIControlStateNormal];
    } else {
        [_timer invalidate];
        _timer = nil;
        [self hideEventPage];
    }
}

@end
