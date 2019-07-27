//
//  MakeBillGoodsHeaderView.m
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillGoodsHeaderView.h"

NSString *const MakeBillGoodsHeaderViewID = @"MakeBillGoodsHeaderViewID";

@interface MakeBillGoodsHeaderView ()

@property (nonatomic, strong) UILabel *titleLabel;

@end

@implementation MakeBillGoodsHeaderView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil){
        UIView *backgroundView = [[UIView alloc]init];
        backgroundView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backgroundView];
        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
        
        self.titleLabel = [[UILabel alloc]init];
        [backgroundView addSubview:self.titleLabel];
        self.titleLabel.text = @"产品";
        self.titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.titleLabel.font = [UIFont systemFontOfSize:14.0];
        
        self.imageView = [[UIImageView alloc]init];
        [backgroundView addSubview:self.imageView];
        [self.imageView setImage:[UIImage imageNamed:@"ic_arrow_up"]];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        
        self.addButton = [[UIButton alloc]init];
        [backgroundView addSubview:self.addButton];
        [self.addButton setImage:[UIImage imageNamed:@"ic_add"] forState:UIControlStateNormal];
        
        self.tapButton = [[UIButton alloc]init];
        [self addSubview:self.tapButton];
        
        [backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(0);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
         
        [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(backgroundView).offset(15);
            make.centerY.equalTo(backgroundView);
        }];
        
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLabel.mas_right).offset(5);
            make.width.equalTo(@12);
            make.top.equalTo(backgroundView);
            make.bottom.equalTo(backgroundView);
        }];
         
        [self.addButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(backgroundView).offset(-5);
            make.width.equalTo(@35);
            make.top.equalTo(backgroundView);
            make.bottom.equalTo(backgroundView);
        }];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [self.tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self).offset(-50);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)imageIsHideImage:(BOOL)isHide{
    if (isHide) {
        [self.imageView setImage:[UIImage imageNamed:@"ic_arrow_down"]];
    }else {
        [self.imageView setImage:[UIImage imageNamed:@"ic_arrow_up"]];
    }
}
@end
