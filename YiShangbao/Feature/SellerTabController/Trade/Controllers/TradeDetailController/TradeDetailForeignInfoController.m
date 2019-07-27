//
//  TradeDetailForeignInfoController.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/5/15.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "TradeDetailForeignInfoController.h"

@interface TradeDetailForeignInfoController ()
@end

@implementation TradeDetailForeignInfoController

+(void)presentBy:(UIViewController *)presenting email:(NSString *)email mobile:(NSString *)mobile
{
    UIStoryboard *sb=[UIStoryboard storyboardWithName:storyboard_Trade  bundle:[NSBundle mainBundle]];
    TradeDetailForeignInfoController *VC = [sb instantiateViewControllerWithIdentifier:@"TradeDetailForeignInfoControllerID"];
    
    VC.email = email;
    VC.mobile = mobile;
    
    VC.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    [presenting presentViewController:VC animated:NO completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self buildUI];
    
    
}
-(void)setEmail:(NSString *)email
{
    _email = email;

    if ([NSString zhIsBlankString:_email]) {
        [self.emailLabel.superview removeFromSuperview];
        [self.messageContentView sizeToFit];
    }else{
        self.emailLabel.text= _email;
    }
}
-(void)setMobile:(NSString *)mobile
{
    _mobile = mobile;

    if ([NSString zhIsBlankString:_mobile]) {
        [self.phoneLabel.superview removeFromSuperview];
        [self.messageContentView sizeToFit];
    }else{
        self.phoneLabel.text = _mobile;
    }
}
- (void)buildUI
{
    self.messageContentView.layer.masksToBounds = YES;
    self.messageContentView.layer.cornerRadius = 4.f;
    
    if ([NSString zhIsBlankString:_email]) {
        [self.emailLabel.superview removeFromSuperview];
        [self.messageContentView sizeToFit];
    }else{
        self.emailLabel.text= _email;
    }

    if ([NSString zhIsBlankString:_mobile]) {
        [self.phoneLabel.superview removeFromSuperview];
        [self.messageContentView sizeToFit];
    }else{
        self.phoneLabel.text = _mobile;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)knowBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:nil];
}
#pragma mark 邮箱
- (IBAction)emileBtnclick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        NSString *emailUrl = [NSString stringWithFormat:@"mailto://%@",self.email];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:emailUrl]];
    }];
}
#pragma mark 电话
- (IBAction)mobileBtnClick:(UIButton *)sender {
    [self dismissViewControllerAnimated:NO completion:^{
        NSString *mobileUrl = [NSString stringWithFormat:@"tel:%@",self.mobile];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:mobileUrl]];
    }];
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
