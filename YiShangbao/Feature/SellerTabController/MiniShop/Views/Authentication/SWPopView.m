//
//  SWPopView.m
//  YiShangbao
//
//  Created by light on 2018/6/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SWPopView.h"
#import "YYText.h"

@interface SWPopView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) YYLabel *titleLabel;
@property (nonatomic, strong) UIButton *confirmButton;

@end

@implementation SWPopView

- (id)init{
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.backgroundColor = [UIColor colorWithHex:0x000000 alpha:0.3];
    
    
    self.backView = [[UIView alloc]init];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self addSubview:self.backView];
    [self.backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self).offset(-60);
        make.width.equalTo(@300);
        make.height.equalTo(@174);
    }];
    
    self.titleLabel = [[YYLabel alloc]init];
    [self.backView addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backView).offset(30);
        make.left.equalTo(self.backView).offset(20);
        make.right.equalTo(self.backView).offset(-20);
        make.height.equalTo(@80);
    }];
    
    self.confirmButton = [[UIButton alloc]init];
    [self.backView addSubview:self.confirmButton];
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.backView);
        make.width.equalTo(@300);
        make.height.equalTo(@45);
    }];
    [self.confirmButton setTitle:NSLocalizedString(@"知道了",@"知道了") forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:[UIColor colorWithHex:0xFF5434] forState:UIControlStateNormal];
    [self.confirmButton.titleLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
    [self.backView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backView);
        make.bottom.equalTo(self.confirmButton.mas_top);
        make.width.equalTo(@300);
        make.height.equalTo(@0.5);
    }];
    
    
    self.backView.layer.cornerRadius = 4.0;
    self.backView.layer.masksToBounds = YES;
    
    [self.confirmButton addTarget:self action:@selector(confirmButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.titleLabel.numberOfLines = 0;
    
    NSString *string = NSLocalizedString(@"抱歉，当前服务仅对商城集团认证商户开通，若您需要认证，请联系客服：400-666-0998", @"");
    NSMutableAttributedString *one = [[NSMutableAttributedString alloc] initWithString:string];
    one.yy_font = [UIFont systemFontOfSize:15];
    one.yy_color = [UIColor colorWithHex:0x2F2F2F];
    one.yy_lineSpacing = 5;
    
    WS(weakSelf)
    NSRange range = [string rangeOfString:@"400-666-0998"];
    if (range.location != NSNotFound){
        [one yy_setTextHighlightRange:range
                                color:[UIColor colorWithHex:0x42B5FF]
                      backgroundColor:[UIColor colorWithWhite:0.000 alpha:0.220]
                            tapAction:^(UIView *containerView, NSAttributedString *text, NSRange range, CGRect rect){
                                [weakSelf call];
                            }];
    }
    self.titleLabel.attributedText = one;
    
    return self;
}

- (void)call{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"tel://4006660998"]];
    self.hidden = YES;
}

- (void)confirmButtonAction{
    self.hidden = YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
