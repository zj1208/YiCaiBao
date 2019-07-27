//
//  StarView.m
//  StartForComment
//  Created by STBL－LHY on 16/5/10.
//  Copyright © 2016年 STBL－LHY. All rights reserved.
//

#import "StarView.h"
#import "Masonry.h"

static NSInteger const kImageViewTag = 10000;
static NSInteger const kMaxStar = 5;

@implementation PaddingButton

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL hit = [super pointInside:point withEvent:event];
    if (hit == NO)
    {
        if (point.x > -_exWidth && point.x - CGRectGetMaxX(self.bounds) <= _exWidth && fabs(point.y - CGRectGetMidY(self.bounds)) <= CGRectGetHeight(self.bounds)/2 + _exWidth)
        {
            return YES;
        }
    }
    return hit;
}

@end

@implementation StarView

- (instancetype)initWithFrame:(CGRect)frame imageWidth:(CGFloat)imageWidth
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:_titleLabel];
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.centerY.equalTo(self);
        }];
        
        for (NSInteger i = 0; i < kMaxStar; i++)
        {
            UIImage *img = [UIImage imageNamed:@"点评-五星-点亮"];
            CGFloat imgWidth = imageWidth;
           
            PaddingButton *button = [PaddingButton new];
            button.exWidth = 5;
            [button setImage:img forState:UIControlStateNormal];
            [button setImage:[StarView ipMaskedImage:img color:[UIColor lightGrayColor]] forState:UIControlStateSelected];
            [button addTarget:self action:@selector(onButtonPress:) forControlEvents:UIControlEventTouchUpInside];
            button.tag = kImageViewTag + i;
            [self addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(_titleLabel.mas_right).with.offset(2*(i+1) + imgWidth*i);
                make.centerY.equalTo(self);
                make.size.mas_equalTo(CGSizeMake(imgWidth, imgWidth));
            }];
        }
        
    }
    return self;
}

- (void)setForSelect:(BOOL)forSelect
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.userInteractionEnabled = forSelect;
    }
}

+ (UIImage *)ipMaskedImage:(UIImage *)image color:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, image.scale);
    CGContextRef c = UIGraphicsGetCurrentContext();
    [image drawInRect:rect];
    CGContextSetFillColorWithColor(c, [color CGColor]);
    CGContextSetBlendMode(c, kCGBlendModeSourceAtop);
    CGContextFillRect(c, rect);
    UIImage *result = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return result;
}

- (void)markStar:(NSInteger)star
{
    for (NSInteger i = 0; i < kMaxStar; i++)
    {
        UIButton *view = [self viewWithTag:kImageViewTag + i];
        view.selected = i >= star;
    }
}

- (void)onButtonPress:(UIButton *)button
{
    NSInteger star = button.tag - kImageViewTag + 1;
    self.onStart(star);
    [self markStar:star];
}



@end
