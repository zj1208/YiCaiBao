//
//  WYPurchaserShoppingCartToolView.m
//  YiShangbao
//
//  Created by light on 2017/8/31.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserShoppingCartToolView.h"

@interface WYPurchaserShoppingCartToolView()

@property (nonatomic ,strong) UIImageView *selectedImageView;

@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *label1;
@property (nonatomic ,strong) UILabel *label2;

@end

@implementation WYPurchaserShoppingCartToolView

- (id)init{
    self = [super init];
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
    
    self.selectedButton = [[UIButton alloc]init];
    [self addSubview:self.selectedButton];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@42);
    }];
    
    self.settleAccountsButton = [[UIButton alloc]init];
    [self.settleAccountsButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.settleAccountsButton setTitle:@"结算(0)" forState:UIControlStateNormal];
    [self.settleAccountsButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self addSubview:self.settleAccountsButton];
    [self.settleAccountsButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.right.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@100);
    }];
    
    self.tipLabel = [[UILabel alloc]init];
    self.tipLabel.text = @"不包含运费及面议产品";
    self.tipLabel.textColor = [UIColor colorWithHex:0x868686];
    self.tipLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:self.tipLabel];
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settleAccountsButton.mas_left).offset(-10);
        make.bottom.equalTo(self).offset(-9);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.text = @"¥0";
    self.priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.settleAccountsButton.mas_left).offset(-10);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-4);
    }];
    
    UILabel *priceNameLabel = [[UILabel alloc]init];
    priceNameLabel.text = @"总计：";
    priceNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    priceNameLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:priceNameLabel];
    [priceNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.priceLabel.mas_left);
        make.bottom.equalTo(self.tipLabel.mas_top).offset(-6);
    }];
    
    //编辑时View
    self.editView = [[UIView alloc]init];
    [self.editView setBackgroundColor:[UIColor whiteColor]];
    [self addSubview:self.editView];
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self.selectedButton.mas_right);
        make.bottom.equalTo(self);
        make.right.equalTo(self);
    }];
    
    self.deleteButton = [[UIButton alloc]init];
    [self.deleteButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [self.deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editView addSubview:self.deleteButton];
    [self.deleteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editView);
        make.right.equalTo(self.editView);
        make.bottom.equalTo(self.editView);
        make.width.equalTo(@100);
    }];
    
    self.collectButton = [[UIButton alloc]init];
    [self.collectButton.titleLabel setFont:[UIFont systemFontOfSize:15.0]];
    [self.collectButton setTitle:@"移入收藏夹" forState:UIControlStateNormal];
    [self.collectButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.editView addSubview:self.collectButton];
    [self.collectButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editView);
        make.right.equalTo(self.deleteButton.mas_left);
        make.bottom.equalTo(self.editView);
        make.width.equalTo(@100);
    }];
    
    //
    UILabel *allLabel = [[UILabel alloc]init];
    allLabel.text = @"全选";
    allLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    allLabel.font = [UIFont systemFontOfSize:16];
    [self addSubview:allLabel];
    [allLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.selectedButton.mas_right);
        make.centerY.equalTo(self);
    }];
    
    UIView *line = [[UIView alloc]init];
    line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@0.5);
    }];
    
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    gradientLayer.frame = CGRectMake(0, 0, 100, 53);
    gradientLayer.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
    [self.settleAccountsButton.layer insertSublayer:gradientLayer atIndex:0];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.startPoint = CGPointMake(0, 0);
    gradientLayer2.endPoint = CGPointMake(1, 0);
    gradientLayer2.frame = CGRectMake(0, 0, 100, 53);
    gradientLayer2.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFFBA49].CGColor,(id)[UIColor colorWithHex:0xFF8D32].CGColor, nil];
    [self.deleteButton.layer insertSublayer:gradientLayer2 atIndex:0];
    
    CAGradientLayer *gradientLayer3 = [CAGradientLayer layer];
    gradientLayer3.startPoint = CGPointMake(0, 0);
    gradientLayer3.endPoint = CGPointMake(1, 0);
    gradientLayer3.frame = CGRectMake(0, 0, 100, 53);
    gradientLayer3.colors = [NSArray arrayWithObjects:(id)[UIColor colorWithHex:0xFF8848].CGColor,(id)[UIColor colorWithHex:0xFF5535].CGColor, nil];
    [self.collectButton.layer insertSublayer:gradientLayer3 atIndex:0];
    
    self.editView.hidden = YES;
    self.collectButton.hidden = YES;//收藏夹
    return self;
}

- (void)isAllSelected:(BOOL)isSelected{
    if (isSelected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_sel"]];
    }else{
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
    }
}

- (void)totalPrice:(CGFloat)price selectdCount:(NSInteger)count{
//    if (count) {
        [self.settleAccountsButton setTitle:[NSString stringWithFormat:@"结算(%ld)",count] forState:UIControlStateNormal];
//    }else{
//        [self.settleAccountsButton setTitle:@"结算" forState:UIControlStateNormal];
//    }
    self.priceLabel.text = [NSString stringWithFormat:@"¥%.2f",price];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
