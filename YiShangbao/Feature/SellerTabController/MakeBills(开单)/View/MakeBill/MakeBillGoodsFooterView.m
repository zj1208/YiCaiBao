//
//  MakeBillGoodsFooterView.m
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillGoodsFooterView.h"
#import "MakeBillModel.h"

#import "NSString+ccTool.h"

NSString *const MakeBillGoodsFooterViewID = @"MakeBillGoodsFooterViewID";

@interface MakeBillGoodsFooterView ()

@property (nonatomic, strong) UILabel *countLabel;
@property (nonatomic, strong) UILabel *moneyLabel;

@end

@implementation MakeBillGoodsFooterView

- (instancetype)initWithReuseIdentifier:(nullable NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self != nil){
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        UIView *line2 = [[UIView alloc]init];
        [self addSubview:line2];
        line2.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
        
        UIView *line = [[UIView alloc]init];
        [self addSubview:line];
        line.backgroundColor = [UIColor colorWithHex:0xE5E5E5];
        
        self.countLabel = [[UILabel alloc]init];
        [self addSubview:self.countLabel];
        self.countLabel.text = @"总量：0.00";
        self.countLabel.font = [UIFont systemFontOfSize:14.0];
        self.countLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        
        self.moneyLabel = [[UILabel alloc]init];
        [self addSubview:self.moneyLabel];
        self.moneyLabel.text = @"总额：¥0.00";
        self.moneyLabel.font = [UIFont systemFontOfSize:14.0];
        self.moneyLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        
        self.tapButton = [[UIButton alloc]init];
        [self addSubview:self.tapButton];
        
        [line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(8);
            make.bottom.equalTo(self).offset(-8);
            make.centerX.equalTo(self);
            make.width.equalTo(@0.5);
        }];
        
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(15);
            make.right.equalTo(line).offset(-15);
            make.centerY.equalTo(self);
        }];
        
        [self.moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(line).offset(15);
            make.right.equalTo(self).offset(-15);
            make.centerY.equalTo(self);
        }];
        
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@0.5);
        }];
        
        [self.tapButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    return self;
}

- (void)updateData:(NSArray *)array{
    NSDecimalNumber *allCountNumber = [NSDecimalNumber decimalNumberWithString:@"0"];
    NSDecimalNumber *allMoney = [NSDecimalNumber decimalNumberWithString:@"0.00"];
    for (MakeBillGoodsModel *model in array) {
        if (model.totalNumStr.length > 0) {
            NSDecimalNumber *countNumber = [NSDecimalNumber decimalNumberWithString:model.totalNumStr];
            
            NSDecimalNumber *minPriceDisplayNumber = [NSDecimalNumber decimalNumberWithString:model.minPriceDisplay];
            NSDecimalNumber *money = [countNumber decimalNumberByMultiplyingBy:minPriceDisplayNumber];
            
            allCountNumber = [allCountNumber decimalNumberByAdding:countNumber];
            allMoney = [allMoney decimalNumberByAdding:money];
        }
    }
    NSString *allMoneyString = [NSString stringWithFormat:@"%@",allMoney];
    allMoneyString = [allMoneyString cc_stringKeepTwoDecimal];
    NSString *countString = [NSString stringWithFormat:@"总量：%@",allCountNumber];
    NSString *countPriceString = [NSString stringWithFormat:@"总额：¥%@",allMoneyString];
    self.countLabel.text = countString;
    self.moneyLabel.text = countPriceString;
}

@end
