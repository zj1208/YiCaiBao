//
//  BillShareView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/17.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BillShareView.h"

@implementation BillShareView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithXib
{
    BillShareView* view = [[[NSBundle mainBundle] loadNibNamed:@"BillShareView" owner:self options:nil] firstObject];
//    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    return view;
}
-(void)showSuperview:(UIView *)superview animated:(BOOL)animated
{
    if (animated) {
        self.bottonContentView.transform = CGAffineTransformMakeTranslation(0, 210);
        [superview addSubview:self];
        [UIView animateWithDuration:0.25 animations:^{
            self.bottonContentView.transform = CGAffineTransformIdentity;
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        }];
    }else{
        [superview addSubview:self];
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    }
}
-(void)dismiss:(BOOL)animated
{
    if (animated) {
        self.bottonContentView.transform = CGAffineTransformIdentity;
        [UIView animateWithDuration:0.2 animations:^{
            self.bottonContentView.transform = CGAffineTransformMakeTranslation(0, 210);
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
        } completion:^(BOOL finished) {
            if (self.superview) {
                [self removeFromSuperview];
            }
            self.bottonContentView.transform = CGAffineTransformIdentity;
            self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

        }];
    }else{
        if (self.superview) {
            [self removeFromSuperview];
        }
    }
}
- (IBAction)ClickwechatBtn:(id)sender {
    [self dismiss:NO];
    if (self.shareBlock) {
        self.shareBlock(SSDKPlatformSubTypeWechatSession);
    }
}
- (IBAction)ClickQQBtn:(id)sender {
    [self dismiss:NO];
    if (self.shareBlock) {
        self.shareBlock(SSDKPlatformSubTypeQQFriend);
    }
}
- (IBAction)ClcikCancelBtn:(id)sender {
    [self dismiss:YES];
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //指定某块区域点击移除
    UITouch* touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    BOOL bo = CGRectContainsPoint(CGRectMake(0,0,LCDW, LCDH-210), point);
    if (bo) {
        [self dismiss:YES];
    }
}
@end
