//
//  PurchaserMineViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/5/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserMineViewController.h"
//#import "PurMainTableViewCell.h"
#import "WYTabBarViewController.h"

#import "ZXWebViewController.h"

#import "ZXBadgeIconButton.h"
#import "WYIntegralButton.h"
#import "JLDragImageView.h"
#import "MessageModel.h"
//#import "GuideMineController.h"

#import "WYMessageListViewController.h"
#import "PurchaserMineTableViewController.h"

//#import "UIButton+WYMoreClickZone.h"
@interface PurchaserMineViewController ()<UIViewControllerTransitioningDelegate, UIWebViewDelegate, JLDragImageViewDelegate>

@property (nonatomic, strong) WYIntegralButton *integralBtn;
@property (nonatomic, strong) ZXBadgeIconButton* messageBadgeButton;
@property (nonatomic, strong) JLDragImageView *tradeMoveView;

//分享有礼
@property (nonatomic, strong)advArrModel *advItemModel;
@end

@implementation PurchaserMineViewController

#pragma mark - life cycle
- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = WYUISTYLE.colorBGgrey;
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController xm_navigationBar_Single_BackIndicatorImage:@"back_onlyImage" isOriginalImage:YES];
//    [self creatUI];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initData];
    
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
    [self.navigationController.navigationBar setBackgroundImage:[self creatImage] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.translucent = NO;
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

    if (!self.presentedViewController){
        [super viewWillDisappear:animated];
        [self.navigationController.navigationBar setShadowImage:nil];
        [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
        self.navigationController.navigationBar.translucent = YES;
    }
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

//- (UIStatusBarStyle)preferredStatusBarStyle{
//    return UIStatusBarStyleLightContent;
//}

//- (void)lauchFirstNewFunction{
//    if (![WYUserDefaultManager getNewNewFunctionGuide_MineV1]){
//        UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        GuideMineController *vc = [sb instantiateViewControllerWithIdentifier:@"GuideMineControllerID"];
//        [self.tabBarController addChildViewController:vc];
//        [self.tabBarController.view addSubview:vc.view];
//    }
//}

#pragma mark - private function
//-(void)creatUI{
//
//    [self lauchFirstNewFunction];
//
//}

- (void)goWebViewWithUrl:(NSString *)url{
    
    [[WYUtility dataUtil]routerWithName:url withSoureController:self];

}

#pragma mark --Request
-(void)initData{
    
    [self requestMessageADInfo];
    
}

//拖动广告按钮内容
- (void)requestMessageADInfo{
    [[[AppAPIHelper shareInstance] getMessageAPI] GetAdvWithType:@2004 success:^(id data) {
       
        AdvModel *model = (AdvModel *)data;
        if (model.advArr.count>0){
            self.advItemModel = [model.advArr firstObject];
                        
            //拖动按钮
            if (!self.tradeMoveView) {
                self.tradeMoveView = [[JLDragImageView alloc] init];
                self.tradeMoveView.delegate = self;
            }
            [self.tradeMoveView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:self.advItemModel.pic] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                [self.tradeMoveView showSuperview:self.view frameOffsetX:0 offsetY:50 Width:70 Height:70];
            }];
        }
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - JLDragImageViewDelegate
-(void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer *)tapGes
{
    [self requestClickAdvWithAreaId:@2004 advId:[NSString stringWithFormat:@"%@",self.advItemModel.iid] ];
    [self goWebViewWithUrl:self.advItemModel.url];
}
#pragma mark 后台广告点击统计
-(void)requestClickAdvWithAreaId:(NSNumber*)areaId advId:(NSString*)advId{
    [[[AppAPIHelper shareInstance] getMessageAPI] postAddTrackInfoWithAreaId:areaId advId:advId success:^(id data) {
        
    } failure:^(NSError *error) {
        
    }];
    
}

//-(void)AlertUnverify{
//    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"身份认证即将审核通过，请耐心等待~", nil) preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"取消", nil)  style:UIAlertActionStyleCancel handler:nil];
//       [alertController addAction:cancelAction];
//    [self presentViewController:alertController animated:YES completion:nil];
//}

//导航栏颜色
- (UIImage *)creatImage{
    NSArray *ar = @[(__bridge id) [UIColor colorWithHex:0xFFC14B].CGColor, (__bridge id) [UIColor colorWithHex:0xFF8D42].CGColor];
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREEN_WIDTH, 1), YES, 1);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGColorSpaceRef rgbSapceRef = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(rgbSapceRef, (CFArrayRef)ar, NULL);
    CGPoint start = CGPointMake(0.0, 0.0);
    CGPoint end = CGPointMake(SCREEN_WIDTH, 0.0);
    
    CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    UIGraphicsEndImageContext();
    [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    return image;
}

@end
