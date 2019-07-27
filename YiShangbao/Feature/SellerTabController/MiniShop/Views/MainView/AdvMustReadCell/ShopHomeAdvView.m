//
//  ShopHomeAdvView.m
//  YiShangbao
//
//  Created by light on 2018/8/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopHomeAdvView.h"

@interface ShopHomeAdvView()

@property (nonatomic, strong) advArrModel *model;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation ShopHomeAdvView

#pragma mark ------LifeCircle------

- (instancetype)init{
    self = [super init];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];if (self) {
        [self creatUI];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self creatUI];
    }
    return self;
}

- (void)creatUI{
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
    }];
    
    _closeButton = [[UIButton alloc]init];
    [self addSubview:_closeButton];
    [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@57);
    }];
    
    _advButton = [[UIButton alloc]init];
    [self addSubview:_advButton];
    [_advButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(_closeButton.mas_left);
        make.bottom.equalTo(self);
    }];
    
    [self.advButton addTarget:self action:@selector(advButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)updateAdvModel:(advArrModel *)model{
    self.model = model;
    self.hidden = NO;
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    [self startTimer];
}

- (void)closeButtonAction{
    [MobClick event:kUM_b_home_adclose];
    [self.timer invalidate];
    [self removeAdv];
}

- (void)advButtonAction{
    [MobClick event:kUM_b_home_adsuspension];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopHomeAdvUrl:)]) {
        [self.delegate shopHomeAdvUrl:self.model.url];
        [self.timer invalidate];
        [self removeAdv];
    }
}

- (void)removeAdv{
    self.hidden = YES;
    if (self.superview) {
        [self removeFromSuperview];
    }
}

#pragma mark ------Timer------

- (void)startTimer{
    NSTimer *timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(action:) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
    self.timer = timer;
}

- (void)action:(NSTimer *)sender {
    static int i = 0;
    i++;
    if (i >= 10){
        [self.timer invalidate];
        [self removeAdv];
        i = 0;
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
