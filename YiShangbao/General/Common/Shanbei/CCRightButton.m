//
//  CCRightButton.m
//  YiShangbao
//
//  Created by light on 2018/4/2.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CCRightButton.h"

@interface CCRightButton ()

//@property (nonatomic, strong) UIView *backgroundView;

@end

@implementation CCRightButton

- (id)initWithFrame:(CGRect)frame{
    CGRect oldFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 28);
    self = [super initWithFrame:oldFrame];
    if (self) {
        [self commonInit];
        [self setButtonFrame:frame];
    }
    return self;
}

- (id)init{
    self = [super init];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.button = [[UIButton alloc]init];
    self.button.isMoreClickZone = YES;
    [self.button addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    self.rightButtonType = CCRightButtonTypeDefault;
}

- (void)setButtonFrame:(CGRect)frame{
    CGRect buttonFrame = CGRectMake(0, (28 - frame.size.height) / 2.0, frame.size.width, frame.size.height);
    [self.button setFrame:buttonFrame];
    [self updateButtonView];
}

//------设置多种风格按钮
- (void)updateRightButtonType {
    if (_rightButtonType == CCRightButtonTypeDefault) {
        _titleColorHex = 0xE23728;
        _backgroundColorHex = 0xFFF5F6;
        _borderColorHex = 0xE23728;
        _titleFontSize = 14.0;
        _borderColorWidth = 0.5;
    }else if (_rightButtonType == CCRightButtonTypeSeller) {
        _titleColorHex = 0xFF6935;
        _backgroundColorHex = 0xFFF5F1;
        _borderColorHex = 0xFE744A;
        _titleFontSize = 13.0;
        _borderColorWidth = 0.5;
    }
    
    
}

//MARK:-------Setter Update View
//- (void)setFrame:(CGRect)frame {
//    CGRect oldFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 28);
//    [super setFrame:oldFrame];
//    [self setButtonFrame:frame];
//    [self updateButtonView];
//}

- (void)setRightButtonType:(CCRightButtonType)rightButtonType{
    _rightButtonType = rightButtonType;
    
    [self updateRightButtonType];
    [self updateButtonView];
}

- (void)setTitleColorHex:(NSInteger)titleColorHex {
    _titleColorHex = titleColorHex;
    
    [self updateButtonView];
}

- (void)setTitleFontSize:(CGFloat)titleFontSize {
    _titleFontSize = titleFontSize;
    
    [self updateButtonView];
}

- (void)setBackgroundColorHex:(NSInteger)backgroundColorHex{
    _backgroundColorHex = backgroundColorHex;
    
    [self updateButtonView];
}

- (void)setBorderColorHex:(NSInteger)borderColorHex {
    _borderColorHex = borderColorHex;
    
    [self updateButtonView];
}

- (void)setBorderColorWidth:(CGFloat)borderColorWidth {
    _borderColorWidth = borderColorWidth;
    
    [self updateButtonView];
}

- (void)updateButtonView {
    
    [self.button setTitleColor:[UIColor colorWithHex:self.titleColorHex] forState:UIControlStateNormal];
    [self.button.titleLabel setFont:[UIFont systemFontOfSize:self.titleFontSize]];
    [self.button setBackgroundColor:[UIColor colorWithHex:self.backgroundColorHex]];
    self.button.layer.borderColor = [UIColor colorWithHex:self.borderColorHex].CGColor;
    self.button.layer.borderWidth = self.borderColorWidth;
    self.button.layer.cornerRadius = self.button.frame.size.height/2.0;
    self.button.layer.masksToBounds= YES;
    
}

#pragma mark ------ButtonAction------

- (void)confirmButtonAction{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)setTitle:(nullable NSString *)title forState:(UIControlState)state{
    [self.button setTitle:title forState:state];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
