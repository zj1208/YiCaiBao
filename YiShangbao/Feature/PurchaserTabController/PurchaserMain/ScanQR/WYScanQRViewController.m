//
//  WYScanQRViewController.m
//  YiShangbao
//
//  Created by 何可 on 2017/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYScanQRViewController.h"
#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import "PhotoLibraryViewController.h"
#import "ScanErrorViewController.h"
@interface WYScanQRViewController ()<AVCaptureMetadataOutputObjectsDelegate,PhotoLibraryScanResultDelegate>{
    UIAlertController *_messageAlerController;
}
@property(nonatomic,strong)UIView *lineView;
@property(nonatomic,strong)AVCaptureSession *scanCaptureSession;
@property(nonatomic,strong)AVCaptureVideoPreviewLayer *avcLayer;
@property(nonatomic,strong)NSTimer *animtaingTimer;
@property(nonatomic,strong)NSObject *observer;

@property(nonatomic,assign)BOOL ifInitSuccess;//

@end

@implementation WYScanQRViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    if ([self respondsToSelector:@selector(setExtendedLayoutIncludesOpaqueBars:)]) {
        self.extendedLayoutIncludesOpaqueBars = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"扫一扫";
   self.ifInitSuccess = [self startScanning];
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    if (self.avcLayer) {
        self.avcLayer.frame = self.view.layer.bounds;
    }
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.ifInitSuccess) {
        [self scanView];
        [self.scanCaptureSession startRunning];
    }
;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if (self.ifInitSuccess) {
        [self.scanView lineStartAnimation];
    }
}
- (UIView *)scanView{
    if (!_scanView) {
        _scanView = [[ScanView alloc]initWithFrame:CGRectZero leftEdge:(CGRectGetWidth(self.view.bounds) * 1 / 5) / 2];
        [self.view addSubview:_scanView];
        [_scanView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.and.right.and.top.and.bottom.equalTo(self.view);
        }];
    }
    return _scanView;
}
- (BOOL)startScanning{
    //创建会话
    self.scanCaptureSession = [[AVCaptureSession alloc]init];
    //获取AVCaptureDevice 实例并设置defaultDeviceWithMediaType类型
    AVCaptureDevice *avCaptureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error;
    //初始化输入流
    AVCaptureDeviceInput *avCaptureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:avCaptureDevice error:&error];
    //给会话添加输入流
    //!!
    if (!avCaptureDeviceInput) {
        
        
        if (error.code == -11852) {//未授权
            
            if (IOS_VERSION>=10) {
                [UIAlertController zx_presentGeneralAlertInViewController:self withTitle:@"提示"  message:[error localizedFailureReason] cancelButtonTitle:@"取消" cancleHandler:^(UIAlertAction * _Nonnull action) {
                    [self.navigationController popViewControllerAnimated:NO];
                    
                } doButtonTitle:@"立即设置" doHandler:^(UIAlertAction * _Nonnull action) {
                    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:^(BOOL success) {
                        self.ifInitSuccess = [self startScanning];
                    }];
                    
                }];
                
            
            }else{ //8-9
                
                [MBProgressHUD zx_showError:[error localizedFailureReason] toView:self.view];
                //                NSString *bunbleID =  [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleIdentifier"];
                //                NSString* strurl = [NSString stringWithFormat:@"prefs:root=%@",bunbleID];
                //                NSURL*url=[NSURL URLWithString:strurl];//@"prefs:root=你app的bunbleId"]]; //这个方法只支持iOS8及以上的系统!ios10以上又不能用了《有空在加iOS8-9自动跳转》
                //
                //                if ([[UIApplication sharedApplication] canOpenURL:url]){
                //                    NSLog(@"666");
                //                    [[UIApplication sharedApplication] openURL:url options:nil completionHandler:^(BOOL success) {
                //
                //                    }];
                //                }
                

            }
            

        }else{
            [MBProgressHUD zx_showError:[error localizedFailureReason] toView:self.view];
        }
        return NO;
    }
    [self.scanCaptureSession addInput:avCaptureDeviceInput];
    //创建输出流
    AVCaptureMetadataOutput *avCaptureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    //给会话添加输出流
    [self.scanCaptureSession addOutput:avCaptureMetadataOutput];
    //设置代理
    [avCaptureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //先添加再设置输出的类型
    [avCaptureMetadataOutput setMetadataObjectTypes:[NSArray arrayWithObject:AVMetadataObjectTypeQRCode]];
    //摄像头图层显示的范围大小,可以自己随便设置。与下面avCaptureMetadataOutput.rectOfInterest这个属性是两个概念(这个指的是扫一扫有效区域)
    self.avcLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.scanCaptureSession];
    [self.avcLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.view.layer addSublayer:self.avcLayer];
    [self.scanCaptureSession startRunning];
    //设置扫描的有效范围（默认是全屏，可以不设置）
    //    self.observer = [[NSNotificationCenter defaultCenter] addObserverForName:AVCaptureInputPortFormatDescriptionDidChangeNotification
    //                                                      object:nil
    //                                                       queue:nil
    //                                                  usingBlock: ^(NSNotification *_Nonnull note) {
    //                                                      avCaptureMetadataOutput.rectOfInterest = [self.avcLayer metadataOutputRectOfInterestForRect:CGRectMake(CGRectGetWidth(self.view.bounds) * 1 / 5 / 2, 80,CGRectGetWidth(self.view.bounds) * 4 / 5,CGRectGetWidth(self.view.bounds) * 4 / 5)];
    //                                                  }];
    
    return YES;
}
#pragma mark -AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if (_messageAlerController) {
        return;
    }
    if (metadataObjects.count > 0) {
        [self.scanView lineStopAnimation];
        [self.scanCaptureSession stopRunning];
        AVMetadataMachineReadableCodeObject *metadataMacObj = metadataObjects[0];
        NSString *result = metadataMacObj.stringValue;
        NSLog(@"scnString = %@",result);
        dispatch_async(dispatch_get_main_queue(), ^{
            [[[AppAPIHelper shareInstance] getPurchaserAPI] getAppScanQRWithRoleType:[WYUserDefaultManager getUserTargetRoleType] qrOriginStr:result success:^(id data) {
                [self.scanView lineStopAnimation];
                NSString *url = nil;
                NSDictionary *dic = (NSDictionary *)data;
                if (![dic objectForKey:@"jumpUrl"]){
                    ScanErrorViewController *vc = [[ScanErrorViewController alloc] init];
                    if ([dic objectForKey:@"tip"]) {
                        vc.errorStr = result;
                    }
                    [self.navigationController pushViewController:vc animated:YES];
                }else{
                    url = [dic objectForKey:@"jumpUrl"];
                    
                    [[WYUtility dataUtil]routerWithName:url withSoureController:self];
                }
            } failure:^(NSError *error) {
                [self zhHUD_showErrorWithStatus:[error localizedDescription]];
                [self.scanView lineStartAnimation];
                [self.scanCaptureSession startRunning];
            }];
        });
    }
}
- (void)messageAlertController:(NSString *)title aletMessage:(NSString *)message action:(NSString *)actionTitle handler:(void (^)(NSInteger buttonIndex))block{
    [self.scanView lineStopAnimation];
    _messageAlerController = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *alerAction = [UIAlertAction actionWithTitle:actionTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block(1);
        }
    }];
    [_messageAlerController addAction:alerAction];
    [self presentViewController:_messageAlerController animated:YES completion:nil];
}

- (void)photoLibraryScanResult:(NSString *)result{
    [self.scanView lineStopAnimation];
    [self.scanCaptureSession stopRunning];
    [self messageAlertController:@"温馨提示" aletMessage:result action:@"cancel" handler:^(NSInteger buttonIndex) {
        [self.scanCaptureSession startRunning];
        [self.scanView lineStartAnimation];
        _messageAlerController = nil;
    }];
    
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self.observer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
