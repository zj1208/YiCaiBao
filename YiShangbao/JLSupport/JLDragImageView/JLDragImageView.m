//
//  JLDragImageView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "JLDragImageView.h"

@implementation JLDragImageView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        [self addGestureRecognizers];
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self addGestureRecognizers];
    }
    return self;
}
-(void)showSuperview:(UIView *)view frameOffsetX:(CGFloat)offsetH offsetY:(CGFloat)offsetV Width:(CGFloat)width Height:(CGFloat)height
{
    [view addSubview:self];
    CGFloat SCR_W = self.superview.bounds.size.width;
    CGFloat SCR_H = self.superview.bounds.size.height;
    CGRect temp = self.frame;
    temp.size.width = width;
    temp.size.height = height;
    self.frame = temp;
    if (self.layoutDirectionH == JLDragIVLayoutCenterX)
    {
        CGPoint center = self.superview.center;
        center.x = offsetH;
        self.center = center;
    }else if (self.layoutDirectionH == JLDragIVLayoutLeft)
    {
        CGRect temp = self.frame;
        temp.origin.x = offsetH;
        self.frame = temp;
    }else{
        CGRect temp = self.frame;
        temp.origin.x = SCR_W-self.frame.size.width-offsetH;
        self.frame = temp;
    }
    if (self.layoutDirectionV == JLDragIVLayoutCenterY)
    {
        CGPoint center = self.superview.center;
        center.y = offsetV;
        self.center = center;
    }else if (self.layoutDirectionV == JLDragIVLayoutTop)
    {
        CGRect temp = self.frame;
        temp.origin.y = offsetV;
        self.frame = temp;
    }else{
        CGRect temp = self.frame;
        temp.origin.y = SCR_H-self.frame.size.height-offsetV;
        self.frame = temp;
    }
}
-(void)addGestureRecognizers
{
    self.jl_outBounds = NO;
    self.jl_isAdsorption = YES;
    self.jl_adsorption = 40.f;
    self.jl_sectionInset = UIEdgeInsetsZero;
    self.layoutDirectionV = JLDragIVLayoutBottom;
    self.layoutDirectionH = JLDragIVLayoutRight;

    self.jl_panGes = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGes:)];
    [self addGestureRecognizer:self.jl_panGes];
    self.jl_tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGes:)];
    [self addGestureRecognizer:self.jl_tapGes];
    self.userInteractionEnabled = YES;
}
- (void)panGes:(UIPanGestureRecognizer *)sender
{
    if (!self.superview) {return;}
    CGFloat SCR_W = self.superview.bounds.size.width;
    CGFloat SCR_H = self.superview.bounds.size.height;
    CGPoint point = [sender translationInView:sender.view];//移动的是偏移量
    if (sender.state == UIGestureRecognizerStateChanged) {
        if (sender.view.frame.origin.x +point.x < self.jl_sectionInset.left || sender.view.frame.origin.x +point.x >SCR_W-sender.view.frame.size.width-self.jl_sectionInset.right || sender.view.frame.origin.y +point.y < self.jl_sectionInset.top || sender.view.frame.origin.y +point.y > SCR_H-sender.view.frame.size.height-self.jl_sectionInset.bottom) {
            if (self.jl_outBounds) {//允许拖出父视图
                [sender.view setTransform:CGAffineTransformTranslate(sender.view.transform, point.x, point.y)];
            }
        }else{
            [sender.view setTransform:CGAffineTransformTranslate(sender.view.transform, point.x, point.y)];
        }
        [sender setTranslation:CGPointZero inView:sender.view];//位移清零
    }else if (sender.state == UIGestureRecognizerStateEnded){
        CGRect frameEnd = sender.view.frame;
        if (frameEnd.origin.x >=SCR_W/2) {
            frameEnd.origin.x = SCR_W-self.frame.size.width;
        }else{
            frameEnd.origin.x = self.jl_sectionInset.left;
        }
        if (frameEnd.origin.y <= self.jl_sectionInset.top) {
            frameEnd.origin.y = self.jl_sectionInset.top;
        }
        if (self.jl_isAdsorption) {
            if (frameEnd.origin.y >= SCR_H-self.frame.size.height-self.jl_sectionInset.bottom-self.jl_adsorption) {
                frameEnd.origin.y = SCR_H-self.frame.size.height-self.jl_sectionInset.bottom;
            }
        }else{
            if (frameEnd.origin.y >= SCR_H-self.frame.size.height-self.jl_sectionInset.bottom) {
                frameEnd.origin.y = SCR_H-self.frame.size.height-self.jl_sectionInset.bottom;
            }
        }
       
        [UIView animateWithDuration:0.2 animations:^{
            self.frame = frameEnd;
        } completion:^(BOOL finished) {
            NSLog(@"MM%@",NSStringFromCGRect(self.frame));
            NSLog(@"MM%@",NSStringFromCGRect(self.superview.frame));
            NSLog(@"MM%f",LCDH);
        }];
    }
    
}
- (void)tapGes:(UITapGestureRecognizer *)sender
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(JLDragImageView:tapGes:)]) {
        [self.delegate  JLDragImageView:self tapGes:sender];
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//- (void)willMoveToSuperview:(UIView *)newSuperview
//{
//    [super willMoveToSuperview:newSuperview];
//    if (newSuperview) {
//        self setFrameOffsetH: offsetV: Width: Height:
//    }else{
//    }
//}
@end
