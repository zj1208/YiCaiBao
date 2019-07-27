//
//  APPriceMinQuantityCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/3/20.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "APPriceMinQuantityCell.h"

@implementation APPriceMinQuantityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.numstextFild.layer.cornerRadius = 15.f;
    self.numstextFild.layer.borderWidth = 0.5;
    self.numstextFild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"868686"] CGColor];
    self.numstextFild.layer.masksToBounds = YES;
    
    self.priceTextfild.layer.cornerRadius = 15.f;
    self.priceTextfild.layer.borderWidth = 0.5;
    self.priceTextfild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"868686"] CGColor];
    self.priceTextfild.layer.masksToBounds = YES;
}

-(void)setNumsTextFildRed:(BOOL)numsTextFildRed
{
    _numsTextFildRed = numsTextFildRed;
    if (_numsTextFildRed) {
        self.numstextFild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"ff0000"] CGColor];
        self.numstextFild.textColor = [WYUISTYLE colorWithHexString:@"ff0000"];
    }else{
        self.numstextFild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"868686"] CGColor];
        self.numstextFild.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    }
}
-(void)setPriceTextfildRed:(BOOL)priceTextfildRed
{
    _priceTextfildRed = priceTextfildRed;
    
    if (_priceTextfildRed) {
        self.priceTextfild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"ff0000"] CGColor];
        self.priceTextfild.textColor = [WYUISTYLE colorWithHexString:@"ff0000"];
    }else{
        self.priceTextfild.layer.borderColor = [[WYUISTYLE colorWithHexString:@"868686"] CGColor];
        self.priceTextfild.textColor = [WYUISTYLE colorWithHexString:@"868686"];
    }
   

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
