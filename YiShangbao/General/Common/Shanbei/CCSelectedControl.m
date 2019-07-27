//
//  CCSelectedControl.m
//  YiShangbao
//
//  Created by light on 2018/4/13.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "CCSelectedControl.h"

@interface CCSelectedControl ()

@property (nonatomic ,strong) UIView *backView;
@property (nonatomic ,strong) UIImageView *backImageView;

@end

@implementation CCSelectedControl

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
    
    self.backImageView = [[UIImageView alloc]init];
    [self addSubview:self.backImageView];
    UIImage *image = [UIImage imageNamed:@"tankuang"];
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(100, 100, 100, 100);
    image = [image resizableImageWithCapInsets:edgeInsets resizingMode:UIImageResizingModeStretch];
    [self.backImageView setImage:image];
    
    self.backView = [[UIView alloc] init];
    [self addSubview:self.backView];
    
    
    self.cellWidth = 136;
    self.cellHeight = 50;
    self.spaceWidth = 0.5;
    self.backImageViewEdgeInset = UIEdgeInsetsMake(22, 7, 7, 7);
    self.spaceEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    
    self.spaceColor = [UIColor colorWithHex:0xCCCCCC];
    
//    self.contentMode = UIViewContentModeRedraw;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self updateControlRects];
}

//- (void)setFrame:(CGRect)frame {
//    [super setFrame:frame];
//
//    [self updateControlRects];
//}

#pragma mark - Drawing

- (void)updateControlRects {
//    self.backView.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame));
//    self.bounds = CGRectMake(0, 0, self.cellWidth + self.backImageViewEdgeInset.left + self.backImageViewEdgeInset.right, (self.cellHeight + self.spaceWidth) * self.titles.count + self.backImageViewEdgeInset.top + self.backImageViewEdgeInset.bottom);
    
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.cellWidth + self.backImageViewEdgeInset.left + self.backImageViewEdgeInset.right, (self.cellHeight + self.spaceWidth) * self.titles.count + self.backImageViewEdgeInset.top + self.backImageViewEdgeInset.bottom);
    
    self.backImageView.frame = self.bounds;
    self.backView.frame = CGRectMake(self.backImageViewEdgeInset.left, self.backImageViewEdgeInset.top, self.cellWidth, (self.cellHeight + self.spaceWidth) * self.titles.count);
}

- (void)drawRect:(CGRect)rect {
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    [[self.backView subviews]makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    //    CGRect oldRect = rect;
    
    for (int i = 0; i < self.titles.count; i++) {
        CGRect newRect;
        newRect = CGRectMake(0, (self.cellHeight + self.spaceWidth) * i, self.cellWidth, self.cellHeight);
        UILabel *label = [[UILabel alloc]init];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:15.0];
        label.textColor = [UIColor colorWithHex:0x2F2F2F];
        label.frame = newRect;
        label.text = self.titles[i];
        [self.backView addSubview:label];

        if (i > 0) {
            CGRect lineRect = CGRectMake(self.spaceEdgeInset.left, (self.cellHeight + self.spaceWidth) * i - self.spaceWidth, self.cellWidth - self.spaceEdgeInset.left - self.spaceEdgeInset.right, self.spaceWidth);
            UIView *line = [[UIView alloc]init];
            line.frame = lineRect;
            line.backgroundColor = self.spaceColor;
            [self.backView addSubview:line];
        }

    }
}

#pragma mark - Touch

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.backView];
    
    NSInteger selectedIndex = 0;
    selectedIndex = touchLocation.y / (self.cellHeight + self.spaceWidth);
    if (selectedIndex >= self.titles.count){
        selectedIndex = self.titles.count - 1;
    }
    [self setSelectedStarIndex:selectedIndex animated:YES notify:YES];
}

- (void)setSelectedStarIndex:(NSInteger)index animated:(BOOL)animated notify:(BOOL)notify {
    _selectedControlIndex = index;
//    [self updateControlRects];
//    [self setNeedsDisplay];
    
    if (notify)
        [self notifyForControlChangeToIndex:index];
}

- (void)notifyForControlChangeToIndex:(NSInteger)index {
    if (self.superview){
        [self sendActionsForControlEvents:UIControlEventValueChanged];
        self.hidden = YES;
    }
    
    if (self.indexChangeBlock){
        self.indexChangeBlock(index);
        self.hidden = YES;
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
