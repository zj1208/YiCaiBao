//
//  WYIntegralButton.m
//  YiShangbao
//
//  Created by light on 2017/10/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYIntegralButton.h"

@interface WYIntegralButton()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIImageView *arrowImageView;
@end

@implementation WYIntegralButton

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundView = [[UIView alloc]init];
    self.backgroundView.userInteractionEnabled = NO;
    [self addSubview:self.backgroundView];
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(2);
        make.left.equalTo(self).offset(2);
        make.right.equalTo(self).offset(-2);
        make.bottom.equalTo(self).offset(-2);
    }];
    self.backgroundView.backgroundColor = [UIColor colorWithHex:0xFFFFFF alpha:0.7];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.right.equalTo(self).offset(-14);
    }];

    return self;
}

- (void)setArrowImage:(NSString *)arrow{
    self.arrowImageView.image = [UIImage imageNamed:arrow];
}

- (void)setImage:(UIImage *)image forState:(UIControlState)state{
    [super setImage:image forState:state];
    [self bringSubviewToFront:self.imageView];
    [self sizeToFit];
    self.backgroundView.layer.cornerRadius = self.backgroundView.frame.size.height/2;
}

- (void)setTitle:(NSString *)title forState:(UIControlState)state{
    
    NSString *string = [title stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    string = [string stringByReplacingOccurrencesOfString:@"-"withString:@""];
    if(string.length > 0){
        title = [NSString stringWithFormat:@" %@        ",title];
    }else{
        title = [NSString stringWithFormat:@" 积分 %@        ",title];
    }
    [super setTitle:title forState:state];
    [self bringSubviewToFront:self.titleLabel];
    [self sizeToFit];
    self.backgroundView.layer.cornerRadius = self.backgroundView.frame.size.height/2;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
