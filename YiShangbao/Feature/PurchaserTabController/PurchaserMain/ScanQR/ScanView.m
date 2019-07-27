//
//  ScanView.m
//  ScanTest
//
//  Created by QBL on 2017/3/21.
//  Copyright © 2017年 team.com All rights reserved.
//

#import "ScanView.h"
#import <AVFoundation/AVFoundation.h>
#define TopEdge 100
@interface ScanView ()
@property(nonatomic,strong)UIImageView *lineImageView;
@end
@implementation ScanView
{
    CGFloat _leftEdge;
    CGSize _scanWindow;
    CGFloat _minX,_maxX,_minY,_maxY,_viewWidth,_viewHeigth;
    CGContextRef _context;
    NSTimer *_animationTimer;
}

- (instancetype)initWithFrame:(CGRect)frame leftEdge:(CGFloat)edge{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _leftEdge = edge;
        [self addlineImageView];
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect{
    
    _scanWindow = CGSizeMake(CGRectGetWidth(self.bounds) - _leftEdge * 2, CGRectGetWidth(self.bounds) - _leftEdge *2);
    _viewWidth = CGRectGetWidth(self.bounds);
    _viewHeigth = CGRectGetHeight(self.bounds);
    _minX = _leftEdge;
    _maxX = _leftEdge + _scanWindow.width;
    _minY = TopEdge;
    _maxY = TopEdge + _scanWindow.height;
    _context = UIGraphicsGetCurrentContext();
    //绘制遮罩
    [self drawMask];
    //矩形框
    [self drawScanRect];
    
}
- (void)drawMask{
    CGContextSetRGBFillColor(_context,0.0,0.0,0.0,0.60);
    //上部
    CGRect makeRect = CGRectMake(0, 0, _viewWidth, TopEdge);
    CGContextFillRect(_context, makeRect);
    
    //左部
    makeRect = CGRectMake(0, _minY, _leftEdge, _scanWindow.height);
    CGContextFillRect(_context, makeRect);
    
    //右部
    makeRect = CGRectMake(_maxX, _minY, _leftEdge, _scanWindow.height);
    CGContextFillRect(_context, makeRect);
    
    //下部
    makeRect = CGRectMake(0, _maxY, _viewWidth, _viewHeigth - _scanWindow.height - TopEdge);
    CGContextFillRect(_context, makeRect);

}
- (void)drawScanRect{
    CGContextSetStrokeColorWithColor(_context, [UIColor whiteColor].CGColor);
    CGContextSetLineWidth(_context, 1);
    CGContextAddRect(_context, CGRectMake(_minX, _minY, _scanWindow.width, _scanWindow.width));
    CGContextStrokePath(_context);
    
    CGFloat lineWidth = 30;
    CGFloat lineHeight = 30;
    CGFloat line_minX = _minX - 2 / 2;
    CGFloat line_maxX = _maxX + 2 / 2;
    CGFloat line_minY = _minY - 2 / 2;
    CGFloat line_maxY = _maxY + 2 / 2;
    
    CGContextSetStrokeColorWithColor(_context, [UIColor colorWithHexString:@"#F58F23"].CGColor);
    CGContextSetLineWidth(_context, 2);
    
    CGContextMoveToPoint(_context, line_minX, line_minY);
    CGContextAddLineToPoint(_context, line_minX + lineWidth, line_minY);
    
    CGContextMoveToPoint(_context, line_minX, line_minY - 1);
    CGContextAddLineToPoint(_context, line_minX, line_minY + lineHeight + 1);
    
    CGContextMoveToPoint(_context, line_minX, line_maxY);
    CGContextAddLineToPoint(_context, line_minX + lineWidth, line_maxY);
    
    CGContextMoveToPoint(_context, line_minX, line_maxY + 1);
    CGContextAddLineToPoint(_context, line_minX, line_maxY - lineHeight - 1);

    CGContextMoveToPoint(_context, line_maxX, line_maxY);
    CGContextAddLineToPoint(_context, line_maxX - lineWidth, line_maxY);

    CGContextMoveToPoint(_context, line_maxX, line_maxY + 1);
    CGContextAddLineToPoint(_context, line_maxX, line_maxY - lineHeight - 1);
    
    CGContextMoveToPoint(_context, line_maxX, line_minY);
    CGContextAddLineToPoint(_context, line_maxX - lineWidth, line_minY);
    
    CGContextMoveToPoint(_context, line_maxX, line_minY - 1);
    CGContextAddLineToPoint(_context, line_maxX, line_minY + lineHeight + 1);


    CGContextStrokePath(_context);
}

- (void)addlineImageView{
    //动态扫描条
    _lineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"pic_saoyisao"]];
    [self addSubview:_lineImageView];
    [_lineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(TopEdge);
        make.left.equalTo(self.mas_left).with.offset(_leftEdge);
        make.right.equalTo(self.mas_right).with.offset(-_leftEdge);
    }];

    UILabel *reminderLabel = [UILabel new];
    reminderLabel.text = @"可扫描商铺二维码，进商铺首页";
    reminderLabel.textAlignment = NSTextAlignmentCenter;
    reminderLabel.textColor = [UIColor whiteColor];
    [self addSubview:reminderLabel];
    [reminderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@(TopEdge+SCREEN_WIDTH-2*_leftEdge+20));
        make.centerX.equalTo(self.mas_centerX);
    }];
}

- (void)lineStartAnimation{
    if (!_animationTimer) {
        _animationTimer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(animation) userInfo:nil repeats:YES];
    }
}

- (void)animation{
    [_lineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(self.mas_top).with.offset(TopEdge + _scanWindow.height - 5);
        make.left.equalTo(self.mas_left).with.offset(_leftEdge);
        make.right.equalTo(self.mas_right).with.offset(-_leftEdge);
    }];
    [UIView animateWithDuration:2 animations:^{
        _lineImageView.hidden = NO;
        [self setNeedsLayout];
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self.lineImageView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.mas_centerX);
            make.top.equalTo(self.mas_top).with.offset(TopEdge);
            make.left.equalTo(self.mas_left).with.offset(_leftEdge);
            make.right.equalTo(self.mas_right).with.offset(-_leftEdge);
        }];
        _lineImageView.hidden = YES;
    }];
}

- (void)lineStopAnimation{

    _lineImageView.hidden = YES;
    [_animationTimer invalidate];
    _animationTimer = nil;
}
@end
