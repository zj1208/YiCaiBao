//
//  WYAlertViewController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "WYAlertViewController.h"

@interface WYAlertViewController ()
@property (weak, nonatomic) IBOutlet UIView *alertContentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *alertContentViewWidthLayout;

@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelBottonLayout;

@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineHCenterXLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightBtnHeightLayout;


@property(nonatomic,copy)WYAlertBlock leftBlock;
@property(nonatomic,copy)WYAlertBlock rightBlock;
@end

@implementation WYAlertViewController
+(void)presentedBy:(UIViewController *)presentingVC message:(NSString *)message bottonBtnTitle:(NSString *)bottonBtnTitle bottonBtnBlock:(WYAlertBlock)bottonBtnBlock
{
    WYAlertViewController *alertVC = [[WYAlertViewController alloc] initWithNibName:@"WYAlertViewController" bundle:nil];
    alertVC.alertMessage = message;
    alertVC.rightBtnTitle = bottonBtnTitle;
    alertVC.singleBtn = YES;

    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentingVC presentViewController:alertVC animated:NO completion:nil];
    
    __weak __typeof(&*alertVC)weakAlert = alertVC;
    [alertVC addLeftBlock:nil rightBlock:^{
        if (bottonBtnBlock) {
            bottonBtnBlock();
        }
        [weakAlert dismissViewControllerAnimated:NO completion:nil];
    }];
    
}

+ (void)presentedBy:(UIViewController *)presentingVC animated:(BOOL)animated message:(NSString *)message  leftBtnTitle:(NSString *)leftBtnTitle leftBlock:(WYAlertBlock)leftBlock rightBtnTitle:(NSString *)rightBtnTitle rightBlock:(WYAlertBlock)rightBlock;
{
    WYAlertViewController *alertVC = [[WYAlertViewController alloc] initWithNibName:@"WYAlertViewController" bundle:nil];
    alertVC.alertMessage = message;
    alertVC.leftBtnTitle = leftBtnTitle;
    alertVC.rightBtnTitle = rightBtnTitle;
    
    alertVC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presentingVC presentViewController:alertVC animated:NO completion:^{
        if (animated) {
            CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
            animation.duration = 0.2;
            NSMutableArray *values = [NSMutableArray array];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.6, 0.6, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.15, 1.15, 1.0)]];
            [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
            animation.values = values;
            [alertVC.alertContentView.layer addAnimation:animation forKey:nil];
        }
    }];

    __weak __typeof(&*alertVC)weakAlert = alertVC;
    [alertVC addLeftBlock:^{
        if (leftBlock) {
            leftBlock();
        }
        [weakAlert dismissViewControllerAnimated:NO completion:nil];
    }rightBlock:^{
        if (rightBlock) {
            rightBlock();
        }
        [weakAlert dismissViewControllerAnimated:NO completion:nil];
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.messageLabel.font = [UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.rightBtnHeightLayout.constant = LCDScale_5Equal6_To6plus(45.f);
    if (LCDW<414.f) {
        self.alertContentViewWidthLayout.constant += 5.f;
        self.messageLabelTopLayout.constant -= 5.f;
        self.messageLabelBottonLayout.constant -= 5.f;
    }
    self.alertContentView.layer.masksToBounds = YES;
    self.alertContentView.layer.cornerRadius = 5.f;
    
    [self.messageLabel jl_setAttributedText:_alertMessage?_alertMessage:@"" withMinimumLineHeight:25];
    [self.leftBtn setTitle:_leftBtnTitle?_leftBtnTitle:@"取消" forState:UIControlStateNormal];
    [self.rightBtn setTitle:_rightBtnTitle?_rightBtnTitle:@"确定" forState:UIControlStateNormal];
    self.singleBtn = _singleBtn;
        
    [self.leftBtn addTarget:self action:@selector(clickLeftBtn:) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn addTarget:self action:@selector(clickRightBtn:) forControlEvents:UIControlEventTouchUpInside];    
}
-(void)setSingleBtn:(BOOL)singleBtn
{
    _singleBtn = singleBtn;
    self.leftBtn.hidden = _singleBtn;
    if (_singleBtn) {
        self.lineHCenterXLayout.constant = -LCDScale_iPhone6_Width(300.f/2.f)-0.25 ;
        if (LCDW<414.f) {
             self.lineHCenterXLayout.constant -= 5.f;
        }
    }else{
        self.lineHCenterXLayout.constant = 0;
    }
}
-(void)clickLeftBtn:(UIButton *)sender
{
    if (self.leftBlock) {
        NSLog(@"leftBlock");
        self.leftBlock();
    }
}
-(void)clickRightBtn:(UIButton *)sender
{
    if (self.rightBlock) {
        NSLog(@"rightBlock");
        self.rightBlock();
    }
}
- (void)addLeftBlock:(WYAlertBlock)leftBlock rightBlock:(WYAlertBlock)rightBlock
{
    _leftBlock = [leftBlock copy];
    _rightBlock = [rightBlock  copy];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc{
    NSLog(@"WYAlertBlock dealloc ");
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
