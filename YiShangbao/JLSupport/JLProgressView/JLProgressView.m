//
//  JLProgressView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "JLProgressView.h"
@interface JLProgressView ()
@property(nonatomic, weak) NSTimer *timer;
@property(nonatomic, assign) BOOL endProgress;
@end;

@implementation JLProgressView
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame]) {
        _jl_progress = 0.0;
    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _jl_progress = 0.0;
    }
    return self;
}
-(void)setJl_progress:(float)jl_progress
{
    _jl_progress = jl_progress<0?0.0:jl_progress;
    _jl_progress = jl_progress>1?1.0:jl_progress;
    [self setNeedsDisplay];

}
- (void)drawRect:(CGRect)rect
{
    CGContextRef context_Background = UIGraphicsGetCurrentContext();
    CGFloat arcB = 2 * M_PI ;
    // x,y为圆点坐标，radius半径，startAngle为开始的弧度，endAngle为 结束的弧度，clockwise 0为顺时针，1为逆时针
    CGContextAddArc(context_Background, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.height/2 - 5, 0, arcB, 0);
    [[WYUISTYLE colorWithHexString:@"dcdcdc"] set];
    CGContextSetLineWidth(context_Background, 10);
    CGContextSetLineCap(context_Background, kCGLineCapButt);
    CGContextSetLineJoin(context_Background, kCGLineJoinMiter);
    CGContextDrawPath(context_Background, kCGPathStroke);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGFloat arc = 2 * M_PI * _jl_progress-M_PI/2.f;
    CGContextAddArc(context, self.frame.size.width/2, self.frame.size.height/2, self.frame.size.height/2 - 5, -M_PI/2.f, arc, 0);
    [[WYUISTYLE colorWithHexString:@"ff450c"] set];
    CGContextSetLineWidth(context, 10);
    CGContextSetLineCap(context, kCGLineCapButt);
    CGContextSetLineJoin(context, kCGLineJoinMiter);
    CGContextDrawPath(context, kCGPathStroke);
    
    NSString *str = [NSString stringWithFormat:@"%.0f%%",_jl_progress * 100];
    NSDictionary *dcit = @{
                           NSFontAttributeName:[UIFont fontWithName:@"Helvetica-Bold" size:LCDScale_5Equal6_To6plus(24.f)],
                           NSForegroundColorAttributeName:[WYUISTYLE colorWithHexString:@"999999"]
                           };
    CGSize size =  [str sizeWithAttributes:dcit];
    CGRect rectStr = CGRectMake(self.bounds.size.width/2- size.width/2,self.bounds.size.height/2- size.height/2, size.width, size.height);
    [str drawInRect:rectStr withAttributes:dcit];
}

-(void)addTimer
{
    NSTimer* timer = [NSTimer scheduledTimerWithTimeInterval:1.0/20.0 target:self selector:@selector(drawProgress) userInfo:nil repeats:YES];
    self.timer = timer;
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}
-(void)deallocTimer
{
    if (self.timer && self.timer.isValid) {
        [_timer invalidate];
        _timer=nil;
    }
}
-(void)drawProgress
{
    if (self.jl_progress>=1.0) {
        [self deallocTimer];
        self.endProgress = NO;
        return;
    }
    if (self.endProgress) {
        CGFloat random = (1.0-self.jl_progress)/0.5/20.0; //模拟剩下的0.5s跑完
        self.jl_progress +=random;
    }else{
        //10s接口超时，前3s跑90%,剩余10%跑7s
        CGFloat random =0.0 ;//(arc4random()%10);
        if (self.jl_progress>0.9) {
            random+=0.1/7.0/20.0;
        }
        else{
            random+=0.9/3.0/20.0; //20*X*3=0.9
        }
        self.jl_progress +=random;
        if (self.jl_progress>=0.9&&!self.endProgress) {
            self.jl_progress = 0.9;//停在0.9
        }
    }
}
-(void)simulationProgress
{
    [self addTimer];
}
-(void)simulationEndProgress:(BOOL)animated completion:(void (^)(void))completion
{
    if (animated) {
        self.endProgress = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.65 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.jl_progress = 1.0;
            completion();
        });
    }
}
- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [super willMoveToSuperview:newSuperview];
    if (!newSuperview) {
        [self deallocTimer];
    }
}
@end
