//
//  OSTradeTypeTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/7/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "OSTradeTypeTableViewCell.h"

NSString *const OSTradeTypeTableViewCellID = @"OSTradeTypeTableViewCellID";

@interface OSTradeTypeTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *domesticTypeButton;//内销
@property (weak, nonatomic) IBOutlet UIButton *foreignTypeButton;//外贸

@property (nonatomic) TradeType type;

@end

@implementation OSTradeTypeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.domesticTypeButton.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    self.domesticTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    self.foreignTypeButton.imageEdgeInsets = UIEdgeInsetsMake(3, 0, 0, 0);
    self.foreignTypeButton.titleEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)domesticTypeButtonAction:(id)sender {
    if (self.type & TradeTypeDomestic) {
        self.type -= TradeTypeDomestic;
        [self.domesticTypeButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [self.domesticTypeButton setTitleColor:[UIColor colorWithHex:0xCCCCCC] forState:UIControlStateNormal];
    }else{
        self.type += TradeTypeDomestic;
        [self.domesticTypeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [self.domesticTypeButton setTitleColor:[UIColor colorWithHex:0xEE4F4F] forState:UIControlStateNormal];
    }
    [self returnTradeType];
}

- (IBAction)foreignTypeButtonAction:(id)sender {
    if (self.type & TradeTypeForeign) {
        self.type -= TradeTypeForeign;
        [self.foreignTypeButton setImage:[UIImage imageNamed:@"未选"] forState:UIControlStateNormal];
        [self.foreignTypeButton setTitleColor:[UIColor colorWithHex:0xCCCCCC] forState:UIControlStateNormal];
    }else{
        self.type += TradeTypeForeign;
        [self.foreignTypeButton setImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
        [self.foreignTypeButton setTitleColor:[UIColor colorWithHex:0xEE4F4F] forState:UIControlStateNormal];
    }
    [self returnTradeType];
}

- (void)returnTradeType{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tradeType:)]) {
        [self.delegate tradeType:self.type];
    }
}

@end
