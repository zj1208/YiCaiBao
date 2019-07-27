//
//  JLStartView.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
// 默认满分5🌟
#define SCR_W   [UIScreen mainScreen].bounds.size.width
#define PLUS (SCR_W > 375.0)
#define JLStartView_W   150         //(PLUS ? (150.f*1.1) : (150))
#define JLStartViewItems_WH  25     //(PLUS ? (25.f*1.1) : (25))
#define JLStartViewItems_LR  5      //(PLUS ? (5.f*1.1) : (5)) //5个间隙
#import "JLStartView.h"

@interface JLStartView ()
@property(nonatomic,strong)UIView* norContentView;
@property(nonatomic,strong)UIView* selContentView;

@property(nonatomic,strong)UIImage* selImage;

@end
@implementation JLStartView

-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        _isCanZero = YES;
        [self buildUIWithNorImg:@"pic_pingjia_nor" selImg:@"pic_pingjia_sel_purchaser"];

    }
    return self;
}
-(instancetype)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        _isCanZero = YES;
        [self buildUIWithNorImg:@"pic_pingjia_nor" selImg:@"pic_pingjia_sel_purchaser"];
    }
    return self;
}
-(void)buildUIWithNorImg:(NSString*)NorImg selImg:(NSString*)selImg
{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    _norContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JLStartView_W, JLStartViewItems_WH)];
    [self addSubview:_norContentView];
    _selContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, JLStartView_W, JLStartViewItems_WH)];
    _selContentView.clipsToBounds = YES;//
    [self addSubview:_selContentView];

    CGFloat nor_X = -JLStartViewItems_WH-JLStartViewItems_LR;
    for (int i = 1; i<6; ++i) {
        nor_X = nor_X+JLStartViewItems_WH+JLStartViewItems_LR;
        UIButton* norBtn = [[UIButton alloc] initWithFrame:CGRectMake(nor_X, 0,JLStartViewItems_WH, JLStartViewItems_WH)];
        UIButton* selBtn = [[UIButton alloc] initWithFrame:CGRectMake(nor_X, 0,JLStartViewItems_WH, JLStartViewItems_WH)];
        [norBtn setBackgroundImage:[UIImage imageNamed:NorImg] forState:UIControlStateNormal];
        [selBtn setBackgroundImage:[UIImage imageNamed:selImg]  forState:UIControlStateNormal];

        [norBtn addTarget:self action:@selector(clcickNor:) forControlEvents:UIControlEventTouchUpInside];
        [selBtn addTarget:self action:@selector(clcickSel:) forControlEvents:UIControlEventTouchUpInside];
        norBtn.tag = 66600+i;
        selBtn.tag = 88800+i;
        [_norContentView addSubview:norBtn];
        [_selContentView addSubview:selBtn];
    }
}
-(void)setIsSeller:(BOOL)isSeller
{
    _isSeller = isSeller;
    if (_isSeller) {
        [self buildUIWithNorImg:@"pic_pingjia_nor" selImg:@"pic_pingjia_sel_seller"];
    }

}
-(void)setIsCanZero:(BOOL)isCanZero
{
    _isCanZero = isCanZero;
    
}
//间隙导致误差问题待完善
//-(void)setStartScore:(CGFloat)startScore
//{
//    _startScore = startScore;
//    if (startScore>=1.f) {
//        startScore = 1.f;
//    }
//    if (startScore<=0.f) {
//        startScore = 0.f;
//    }
//    CGFloat selContentView_W = JLStartView_W*startScore;
//    
//    CGRect frame = _selContentView.frame;
//    frame.size.width = selContentView_W;
//    _selContentView.frame = frame;
//    [self layoutIfNeeded];
//
//}

-(CGFloat)curryScore
{
    [self layoutIfNeeded];
    CGFloat Max_X = CGRectGetMaxX(_selContentView.frame);
//    NSLog(@"%f>%f",Max_X/JLStartView_W,Max_X);
    return Max_X/JLStartView_W*5.f;
}
-(void)clcickNor:(UIButton*)sender
{
    if (sender.tag -66600 == 1 && !_isCanZero) {

    }else{
        CGFloat Max_X = CGRectGetMaxX(sender.frame);
        CGRect frame = _selContentView.frame;
        frame.size.width = Max_X+JLStartViewItems_LR;
        _selContentView.frame = frame;
    }
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_JLStartView:didClcikWithScore:)]) {
        [self.delegate jl_JLStartView:self didClcikWithScore:sender.tag-66600];
    }
}
//点击同一个取消
-(void)clcickSel:(UIButton*)sender
{
    CGFloat Max_X = CGRectGetMaxX(sender.frame);
    if (_selContentView.frame.size.width > Max_X) {

        CGRect frame = _selContentView.frame;
        frame.size.width = Max_X+JLStartViewItems_LR;
        _selContentView.frame = frame;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(jl_JLStartView:didClcikWithScore:)]) {
            [self.delegate jl_JLStartView:self didClcikWithScore:sender.tag-88800];
        }
    }else{ //=
        if (sender.tag -88800 == 1 && !_isCanZero) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(jl_JLStartView:didClcikWithScore:)]) {
                [self.delegate jl_JLStartView:self didClcikWithScore:sender.tag-88800];
            }
        }else{
            CGFloat Min_x = CGRectGetMinX(sender.frame);
            CGRect frame = _selContentView.frame;
            frame.size.width = Min_x;
            _selContentView.frame = frame;

            if (self.delegate && [self.delegate respondsToSelector:@selector(jl_JLStartView:didClcikWithScore:)]) {
                [self.delegate jl_JLStartView:self didClcikWithScore:sender.tag-88800-1];
            }
        }
        
       

    }
    
   
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
