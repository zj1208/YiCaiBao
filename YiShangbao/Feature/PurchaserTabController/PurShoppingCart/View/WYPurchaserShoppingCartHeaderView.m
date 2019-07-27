//
//  WYPurchaserShoppingCartHeaderView.m
//  YiShangbao
//
//  Created by light on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserShoppingCartHeaderView.h"
#import "WYShopCartModel.h"

NSString * const WYPurchaserShoppingCartHeaderViewID = @"WYPurchaserShoppingCartHeaderViewID";

@interface WYPurchaserShoppingCartHeaderView()

@property (nonatomic ,strong) UIImageView *selectedImageView;
@property (nonatomic ,strong) UILabel *shopNameLabel;
@property (nonatomic ,strong) UIImageView *arrowImageView;
@property (nonatomic ,strong) UIView *line;

@property (nonatomic ,strong) UIButton *selectedButton;
@property (nonatomic ,strong) UIButton *goShopButton;

@property (nonatomic ,strong) WYShopCartShopInfoModel *shopInfoModel;
@property (nonatomic ) NSInteger section;

@end

@implementation WYPurchaserShoppingCartHeaderView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectedImageView = [[UIImageView alloc]init];
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
    [self addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(13);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    self.shopNameLabel = [[UILabel alloc]init];
    self.shopNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.shopNameLabel.font = [UIFont systemFontOfSize:15];
    [self addSubview:self.shopNameLabel];
    [self.shopNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(42);
    }];
    
    self.arrowImageView = [[UIImageView alloc]init];
    [self.arrowImageView setImage:[UIImage imageNamed:@"pic-jiantou"]];
    [self addSubview:self.arrowImageView];
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self.shopNameLabel.mas_right).offset(5);
        make.right.mas_lessThanOrEqualTo(self).offset(-10);
        make.width.equalTo(@9);
        make.height.equalTo(@17);
    }];
    
    self.line = [[UIView alloc]init];
    self.line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
    [self addSubview:self.line];
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    self.selectedButton = [[UIButton alloc]init];
    [self addSubview:self.selectedButton];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.width.equalTo(@42);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    
    self.goShopButton = [[UIButton alloc]init];
    [self addSubview:self.goShopButton];
    [self.goShopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(42);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.top.equalTo(self);
    }];
    
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    [self.selectedButton addTarget:self action:@selector(selectedShopAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.goShopButton addTarget:self action:@selector(goShop:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)selectedShopAction:(UIButton *)sender{
    self.shopInfoModel.isSelected = !self.shopInfoModel.isSelected;
    [self updateData:self.shopInfoModel];
    if (self.delegate && [self.delegate respondsToSelector:@selector(shopAllSelected:section:)]){
        [self.delegate shopAllSelected:self.shopInfoModel.isSelected section:self.section];
    }
}


- (void)goShop:(UIButton *)sender{
    if (self.delegate && [self.delegate respondsToSelector:@selector(goShopId:)]){
        [self.delegate goShopId:self.shopInfoModel.shopId];
    }
}

- (void)updateData:(id)model section:(NSInteger)section{
    self.section = section;
    [self updateData:model];
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYShopCartShopInfoModel class]]) {
        self.shopInfoModel = model;
        self.shopNameLabel.text = self.shopInfoModel.shopName;
        if (self.shopInfoModel.isSelected) {
            [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_sel"]];
        }else{
            [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
        }
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
