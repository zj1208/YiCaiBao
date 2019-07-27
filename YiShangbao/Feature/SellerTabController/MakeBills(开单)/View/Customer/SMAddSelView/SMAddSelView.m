//
//  SMAddSelView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMAddSelView.h"

@implementation SMAddSelView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithXib
{
    SMAddSelView* view = [[[NSBundle mainBundle] loadNibNamed:@"SMAddSelView" owner:self options:nil] firstObject];
    view.topConstrain.constant = HEIGHT_NAVBAR;
    return view;
}
-(void)showSuperview:(UIView *)superview animated:(BOOL)animated
{
    if (animated) {
        [superview addSubview:self];
        
//        CAKeyframeAnimation *anima1 = [CAKeyframeAnimation animationWithKeyPath:@"position"];
//        NSValue *value0 = [NSValue valueWithCGPoint:self.menuContentView.center];
//        NSValue *value3 = [NSValue valueWithCGPoint:CGPointMake(150/2, 130/2)];
//        anima1.values = [NSArray arrayWithObjects:value0,value3, nil];
//        
//        CABasicAnimation *anima2 = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
//        anima2.fromValue = [NSNumber numberWithFloat:0.3f];
//        anima2.toValue = [NSNumber numberWithFloat:1.0f];
//        
//        CAAnimationGroup *groupAnimation = [CAAnimationGroup animation];
//        groupAnimation.animations = [NSArray arrayWithObjects:anima1,anima2, nil];
//        groupAnimation.duration = 2.3;
//        groupAnimation.removedOnCompletion = NO;
//        groupAnimation.fillMode = kCAFillModeForwards;
//        [self.menuContentView.layer addAnimation:groupAnimation forKey:@"groupAnimation_Start"];
        
//        self.menuContentView.layer.position = CGPointMake(1, 0);
//        self.menuContentView.layer.anchorPoint = CGPointMake(0, 1);
//        self.menuContentView.transform= CGAffineTransformMakeScale(0.4, 0.4);

//        [UIView animateWithDuration:4 animations:^{
//            self.menuContentView.transform= CGAffineTransformMakeScale(0.5, 0.5);
//            self.menuContentView.transform =  CGAffineTransformMakeScale(1, 1);
//            self.menuContentView.transform = CGAffineTransformIdentity;
//        }];
    }else{
        [superview addSubview:self];
    }
    
}
- (IBAction)nowBtn:(id)sender {
    [self block:0];
}
- (IBAction)addBtn:(id)sender {
    [self block:1];
}
-(void)block:(NSInteger )index
{
    if (self.clickBlock) {
        self.clickBlock(index);
    }
    [self removeFromSuperview];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (self.superview) {
        [self removeFromSuperview];
    }
}
@end
