//
//  MakeBillGoodsCell.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillGoodsCell.h"
#import "MakeBillModel.h"

#import "NSString+ccTool.h"
NSString *const MakeBillGoodsCellID = @"MakeBillGoodsCellID";

@interface MakeBillGoodsCell ()

@property (weak, nonatomic) IBOutlet UILabel *goodsNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsUnitPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLabel;

@property (nonatomic) NSInteger index;

@end

@implementation MakeBillGoodsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(MakeBillGoodsModel *)model index:(NSInteger)index{
    self.index = index;
    
    self.goodsNameLabel.text = model.goodsName;
    NSString *countString = @"请输入数量";
    NSString *countPriceString = @"自动计算";
    if (model.totalNumStr.length > 0) {
        
        NSDecimalNumber *countNumber = [NSDecimalNumber decimalNumberWithString:model.totalNumStr];
        countString = model.totalNumStr;
//        NSDecimalNumber *boxNumber = [NSDecimalNumber decimalNumberWithString:model.boxNum.stringValue];
//        NSDecimalNumber *boxPerNumber = [NSDecimalNumber decimalNumberWithString:model.boxPerNum.stringValue];
//        NSDecimalNumber *countNumber = [boxNumber decimalNumberByMultiplyingBy:boxPerNumber];
//        countString = [NSString stringWithFormat:@"%@",countNumber];

        NSDecimalNumber *minPriceDisplayNumber = [NSDecimalNumber decimalNumberWithString:model.minPriceDisplay];
        NSDecimalNumber *money = [countNumber decimalNumberByMultiplyingBy:minPriceDisplayNumber];
        countPriceString = [NSString stringWithFormat:@"%@",money];
        countPriceString = [countPriceString cc_stringKeepTwoDecimal];
    }
    if (model.minUnit.length > 0){
        self.goodsCountLabel.text = [NSString stringWithFormat:@"数量：%@(%@)",countString,model.minUnit];
    }else{
        self.goodsCountLabel.text = [NSString stringWithFormat:@"数量：%@",countString];
    }
    self.goodsUnitPriceLabel.text = [NSString stringWithFormat:@"单价：¥%@",model.minPriceDisplay];
    self.goodsPriceLabel.text = [NSString stringWithFormat:@"总价：¥%@",countPriceString];
}

- (IBAction)deleteButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(deleteGoodsIndex:)]) {
        [self.delegate deleteGoodsIndex:self.index];
    }
}


@end
