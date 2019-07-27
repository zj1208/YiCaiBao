//
//  ExtendProductAlertController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ExtendProductAlertController.h"

@interface ExtendProductAlertController ()

@end

@implementation ExtendProductAlertController
+(void)showWithMessage:(NSString *)message presenting:(UIViewController *)presentingVC cancelTitle:(NSString *)canTitle cancelBlock:(CancelBlock)cancelBlock cerTitle:(NSString *)cerTitle certificationNowBlock:(CertificationNowBlock)certificationNowBlock
{
    UIStoryboard* SB = [UIStoryboard storyboardWithName:sb_Extend bundle:nil];
    ExtendProductAlertController* alertVC =  [SB instantiateViewControllerWithIdentifier:SBID_ExtendProductAlertController];
    
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentingVC presentViewController:alertVC animated:NO completion:^{
        CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
        animation.duration = 0.2;
        NSMutableArray *values = [NSMutableArray array];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1.0)]];
        [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
        animation.values = values;
        [alertVC.alertContentView.layer addAnimation:animation forKey:nil];
    }];
    alertVC.alertMessage = message;
    if (canTitle) {
        [alertVC.cancelBtn setTitle:canTitle forState:UIControlStateNormal];
    }
    if (cerTitle) {
        [alertVC.CertificationImmediatelyBtn setTitle:cerTitle forState:UIControlStateNormal];
    }

    __weak __typeof(&*alertVC)weakAlert = alertVC;
    alertVC.cancelBlock = ^{
        [weakAlert dismissViewControllerAnimated:NO completion:nil];
        if (cancelBlock) {
            cancelBlock();
        }
        
    };
    alertVC.certificationNowBlock = ^{
        [weakAlert dismissViewControllerAnimated:NO completion:nil];
        if (certificationNowBlock) {
            certificationNowBlock();
        }
    };
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.alertContentView.layer.masksToBounds = YES;
    self.alertContentView.layer.cornerRadius = 5.f;
    
  
   
}
-(void)setAlertMessage:(NSString *)alertMessage
{
    _alertMessage = alertMessage;
    [self.descLabel jl_setAttributedText:_alertMessage withMinimumLineHeight:25];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)CertificationImmediatelyBtnClick:(id)sender {
    if (self.certificationNowBlock) {
        NSLog(@"certificationNowBlock");
        self.certificationNowBlock();
    }
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    if (self.cancelBlock) {
        NSLog(@"cancelBlock");
        self.cancelBlock();
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
