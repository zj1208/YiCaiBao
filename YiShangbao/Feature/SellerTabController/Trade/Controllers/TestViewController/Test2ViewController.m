//
//  Test2ViewController.m
//  YiShangbao
//
//  Created by simon on 17/3/2.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "Test2ViewController.h"
#import "AliOSSUploadManager.h"

@interface Test2ViewController ()

@property (nonatomic, strong)UIImageView *baseImageView;
@property (nonatomic, strong)UIImageView *maskImageView;

@property (nonatomic, strong)CALayer *colorMaskLayer;
@end

@implementation Test2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"返回", nil) style:UIBarButtonItemStyleDone target:self action:@selector(goBack)];
    self.view.backgroundColor = [UIColor whiteColor];

    //灰色背景图片
    UIImageView *grayImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    grayImgView.image = [UIImage  imageNamed:@"jobs_gray"];
    grayImgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:grayImgView];
    
    //彩色的背景图片
    UIImageView *colorImgView =[[UIImageView alloc] initWithFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT)];
    colorImgView.image = [UIImage  imageNamed:@"jobs_color"];
    colorImgView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:colorImgView];
    
    UIView *maskView = [[UIView alloc] initWithFrame:colorImgView.bounds];
    colorImgView.maskView = maskView;
    
    UIImageView *picView = [[UIImageView alloc] initWithFrame:maskView.bounds];
    picView.image        = [UIImage imageNamed:@"mask1"];
    [maskView addSubview:picView];
    
    [UIView animateWithDuration:5.f delay:1.f options:0 animations:^{
        picView.zx_y -= picView.bounds.size.height;
    } completion:^(BOOL finished) {
        
    }];
    
//    if (Device_SYSTEMVERSION_Greater_THAN_OR_EQUAL_TO(8.0))
//    {
//        UIImageView *maskView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mask_image"]];
//        maskView.center = CGPointMake(200, SCREEN_HEIGHT/2);
//        colorImgView.maskView = maskView;
//    }
//    else
//    {
//        //只会显示与view.layer.mask重叠部分,填充了内容的layer（形成想要的展示区域）
//        self.colorMaskLayer = [CALayer layer];
//        self.colorMaskLayer.frame = CGRectMake(0, 0, 240, 240);
//        self.colorMaskLayer.contents = (__bridge id _Nullable)([UIImage imageNamed:@"mask_image"].CGImage) ; //使用图片填充
//        self.colorMaskLayer.position = CGPointMake(200, SCREEN_HEIGHT/2);
//        colorImageV.layer.mask = self.colorMaskLayer;
//    }
}



- (void)goBack
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
