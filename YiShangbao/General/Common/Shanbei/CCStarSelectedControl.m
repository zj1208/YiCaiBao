//
//  CCStarSelectedControl.m
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CCStarSelectedControl.h"

@interface CCStarSelectedControl ()

@property (nonatomic ,strong) UIView *backView;

@end

@implementation CCStarSelectedControl

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)commonInit {
    self.backgroundColor = [UIColor clearColor];
    
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    
    self.starCount = 5;
    self.selectedControlIndex = 5;
    self.starWidth = 19.0;
    self.spaceWidth = 10.0;
    
    self.selectedStarImageName = @"icon_red_star";
    self.notSelectedStarImageName = @"icon_gray_star";
    
    self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateControlRects];
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    
    [self updateControlRects];
}

- (void)setSelectedControlIndex:(NSInteger)selectedControlIndex{
    _selectedControlIndex = selectedControlIndex;
    [self setNeedsDisplay];
}

#pragma mark - Drawing

- (void)updateControlRects {
    self.backView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
    
}

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    [[self.backView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
//    CGRect oldRect = rect;
    
    for (int i = 0; i < self.starCount; i++) {
        CGRect newRect;
        newRect = CGRectMake((self.starWidth + self.spaceWidth) * i + self.spaceWidth / 2, (CGRectGetHeight(self.frame) - self.starWidth) / 2 , self.starWidth, self.starWidth);
        
        UIImageView *imageView = [[UIImageView alloc]init];
        imageView.frame = newRect;
        if (self.selectedControlIndex >= i + 1 && self.selectedStarImageName){
            imageView.image = [UIImage imageNamed:self.selectedStarImageName];
        }
        if (self.selectedControlIndex >= i + 1 && self.selectedStarImage){
            imageView.image = self.selectedStarImage;
        }
        if (self.selectedControlIndex < i + 1 && self.notSelectedStarImageName){
            imageView.image = [UIImage imageNamed:self.notSelectedStarImageName];
        }
        if (self.selectedControlIndex < i + 1 && self.notSelectedStarImage){
            imageView.image = self.notSelectedStarImage;
        }
        
        [self.backView addSubview:imageView];
    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self];
    
    NSInteger selectedIndex = 0;
    selectedIndex = touchLocation.x / (self.starWidth + self.spaceWidth) + 1;
    if (selectedIndex > _starCount) {
        selectedIndex = _starCount;
    }
    if (selectedIndex != self.selectedControlIndex) {
        [self setSelectedStarIndex:selectedIndex animated:YES notify:YES];
    }
}

- (void)setSelectedStarIndex:(NSInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedControlIndex = index;
    [self updateControlRects];
    [self setNeedsDisplay];
    
    if (notify)
        [self notifyForControlChangeToIndex:index];
}

- (void)notifyForControlChangeToIndex:(NSInteger)index {
    if (self.superview)
        [self sendActionsForControlEvents:UIControlEventValueChanged];
    
    if (self.indexChangeBlock)
        self.indexChangeBlock(index);
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
