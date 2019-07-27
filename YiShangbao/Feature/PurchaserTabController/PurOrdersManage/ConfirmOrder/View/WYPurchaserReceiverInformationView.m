//
//  WYPurchaserReceiverInformationView.m
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserReceiverInformationView.h"
#import "WYPlaceOrderModel.h"

@interface WYPurchaserReceiverInformationView()

@property (nonatomic ,strong) UIImageView *addressImageView;
@property (nonatomic ,strong) UIImageView *arrowImageView;

@property (nonatomic ,strong) UILabel *nameLabel;
@property (nonatomic ,strong) UILabel *phoneLabel;
@property (nonatomic ,strong) UILabel *editLabel;


@end

@implementation WYPurchaserReceiverInformationView

- (id)init{
    self = [super init];
    if (!self) return nil;
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.addressImageView = [[UIImageView alloc]init];
    [self.addressImageView setImage:[UIImage imageNamed:@"ic_ditu"]];
    [self addSubview:self.addressImageView];
    [self.addressImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-5);
        make.left.equalTo(self).offset(10);
        make.width.equalTo(@18);
        make.height.equalTo(@18);
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self.arrowImageView setImage:[UIImage imageNamed:@"pic_>_or"]];
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-5);
        make.right.equalTo(self).offset(-15);
        make.width.equalTo(@6);
        make.height.equalTo(@10);
    }];
    
    self.editLabel = [[UILabel alloc]init];
    self.editLabel.text = @"修改";
    self.editLabel.textColor = [UIColor colorWithHex:0xF58F23];
    self.editLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.editLabel];
    [self.editLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self).offset(-5);
        make.right.equalTo(self.arrowImageView.mas_left).offset(-3);
    }];
    
    self.nameLabel = [[UILabel alloc]init];
    self.nameLabel.text = @"收货人：无";
    self.nameLabel.textColor = [UIColor colorWithHex:0x757575];
    self.nameLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.nameLabel];
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38);
        make.top.equalTo(self).offset(15);
    }];
    
    self.phoneLabel = [[UILabel alloc]init];
    self.phoneLabel.text = @" ";
    self.phoneLabel.textColor = [UIColor colorWithHex:0x757575];
    self.phoneLabel.font = [UIFont systemFontOfSize:13];
    [self addSubview:self.phoneLabel];
    [self.phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel.mas_right).offset(15);
        make.right.equalTo(self).offset(-55);
        make.top.equalTo(self).offset(15);
    }];
    
    self.addressLabel = [[UILabel alloc]init];
    self.addressLabel.text = @"收货地址：无";
    self.addressLabel.textColor = [UIColor colorWithHex:0x757575];
    self.addressLabel.font = [UIFont systemFontOfSize:13];
    self.addressLabel.numberOfLines = 2;
    [self addSubview:self.addressLabel];
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(38);
        make.top.equalTo(self.nameLabel.mas_bottom).offset(3);
        make.right.equalTo(self).offset(-55);
        make.bottom.equalTo(self).offset(-25);
    }];
    
    
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self).offset(-10);
        make.height.equalTo(@0.5);
    }];
    
    UIView *backView = [[UIView alloc]init];
    backView.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
    [self addSubview:backView];
    [backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@10);
    }];
    
    self.editButton = [[UIButton alloc]init];
    [self addSubview:self.editButton];
    [self.editButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    
    [self.phoneLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    return self;
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYAddressModel class]]) {
        WYAddressModel *addressModel = model;
        self.nameLabel.text = [NSString stringWithFormat:@"收货人：%@", addressModel.fullName];
        self.phoneLabel.text = addressModel.mobile;
        self.addressLabel.text = [NSString stringWithFormat:@"收货地址：%@", addressModel.addressDetail];
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
