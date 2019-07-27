//
//  WYPurchaserConfirmOrderToolView.m
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderToolView.h"
#import "WYPlaceOrderModel.h"

@interface WYPurchaserConfirmOrderToolView()

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *tipLabel;

@property (nonatomic ,strong) CAGradientLayer *gradientLayer;

@end

@implementation WYPurchaserConfirmOrderToolView

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    self.settleAccountsButton = [[UIButton alloc]init];
    self.settleAccountsButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.settleAccountsButton setTitle:@"提交订单" forState:UIControlStateNormal];
    [self addSubview:self.settleAccountsButton];
    [self.settleAccountsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"¥";
    self.priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
    self.priceLabel.font = [UIFont boldSystemFontOfSize:16];
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settleAccountsButton.mas_left).offset(-10);
        make.centerY.equalTo(self);
//        make.bottom.equalTo(self).offset(-24);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"总计：";
    self.nameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left);
        make.centerY.equalTo(self).offset(1);
//        make.bottom.equalTo(self).offset(-26);
    }];
    
    
//    self.tipLabel = [[UILabel alloc]init];
//    self.tipLabel.text = @"不包含运费及面议";
//    self.tipLabel.textColor = [UIColor colorWithHex:0x868686];
//    self.tipLabel.font = [UIFont systemFontOfSize:10];
//    self.tipLabel.textAlignment = NSTextAlignmentRight;
//    [self addSubview:self.tipLabel];
//    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.settleAccountsButton.mas_left).offset(-10);
//        make.bottom.equalTo(self).offset(-6);
//    }];
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    [self.settleAccountsButton setBackgroundColor:[UIColor colorWithHex:0XDADADA]];
    
    return self;
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYOrderSumInfoModel class]]) {
        WYOrderSumInfoModel *sumInfoModel = model;
        self.nameLabel.text = sumInfoModel.sumTotalPriceLabel;
        self.priceLabel.text = sumInfoModel.sumTotalPrice;
//        self.tipLabel.text = sumInfoModel.tipInfo;
    }
}

- (void)settleAccountsButtonIsTouch:(BOOL)isTouch{
    if (isTouch) {
        [self.settleAccountsButton.layer insertSublayer:self.gradientLayer atIndex:0];
        self.settleAccountsButton.userInteractionEnabled = YES;
    }else{
        [self.gradientLayer removeFromSuperlayer];
        self.settleAccountsButton.userInteractionEnabled = NO;
    }
}

#pragma mark _GetterAndSetter
- (CAGradientLayer *)gradientLayer{
    if (!_gradientLayer) {
        _gradientLayer = [CAGradientLayer layer];
        _gradientLayer.startPoint = CGPointMake(0, 0);
        _gradientLayer.endPoint = CGPointMake(1, 0);
        _gradientLayer.frame = CGRectMake(0, 0, 100, 53);
        _gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
    }
    return _gradientLayer;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
