//
//  WYPurchaserConfirmOrderHeaderView.m
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderHeaderView.h"
#import "WYPlaceOrderModel.h"

NSString * const WYPurchaserConfirmOrderHeaderViewID = @"WYPurchaserConfirmOrderHeaderViewID";

@interface WYPurchaserConfirmOrderHeaderView()

@property (nonatomic ,strong) UILabel *shopNameLabel;
//@property (nonatomic ,strong) UIImageView *arrowImageView;
@property (nonatomic ,strong) UIButton *shopButton;

@property (nonatomic ,weak) WYConfirmOrderModel *model;

@end

@implementation WYPurchaserConfirmOrderHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.shopNameLabel = [[UILabel alloc]init];
        self.shopNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.shopNameLabel.font = [UIFont systemFontOfSize:14];
        [self addSubview:self.shopNameLabel];
        [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerY.equalTo(self);
            make.bottom.equalTo(self).offset(-13);
            make.left.equalTo(self).offset(15);
            make.right.equalTo(self).offset(-35);
        }];
        
//        self.arrowImageView = [[UIImageView alloc]init];
//        [self.arrowImageView setImage:[UIImage imageNamed:@"ic_more"]];
//        [self addSubview:self.arrowImageView];
//        [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
////            make.centerY.equalTo(self);
//            make.bottom.equalTo(self).offset(-17);
//            make.right.equalTo(self).offset(-15);
//            make.width.equalTo(@6);
//            make.height.equalTo(@10);
//        }];
        
        self.shopButton = [[UIButton alloc]init];
        [self addSubview:self.shopButton];
        [self.shopButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(@44);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        [self.shopButton addTarget:self action:@selector(goShop:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYConfirmOrderModel class]]) {
        self.model = model;
        self.shopNameLabel.text = self.model.shopName;
    }
}

- (void)goShop:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goShopId:)]){
        [self.delegate goShopId:[NSString stringWithFormat:@"%@",[self.model.storage objectForKey:@"shopId"]]];
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
