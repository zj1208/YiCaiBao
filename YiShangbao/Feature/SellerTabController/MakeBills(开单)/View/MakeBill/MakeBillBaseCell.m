//
//  MakeBillBaseCell.m
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillBaseCell.h"

NSString *const MakeBillBaseCellID = @"MakeBillBaseCellID";

@interface MakeBillBaseCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *valueLabel;

@end

@implementation MakeBillBaseCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateName:(NSString *)name value:(NSString *)value defaultString:(NSString *)defaultString{
    self.nameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.nameLabel.text = name;
    self.valueLabel.text = value;
    self.valueLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    if (!value || value.length == 0){
        self.valueLabel.text = defaultString;
        self.valueLabel.textColor = [UIColor colorWithHex:0xC2C2C2];
    }
    [self redStar:self.nameLabel];
}

- (void)redStar:(UILabel *)label{
    if ([label.text hasPrefix:@"*"]) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:label.text attributes:@{NSForegroundColorAttributeName:label.textColor,
                                                                                                                                NSFontAttributeName:label.font
                                                                                                                                }];
        [attributedString setAttributes:@{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFF5434],
                                          NSFontAttributeName:label.font
                                          } range:NSMakeRange(0,1)];
        label.attributedText = attributedString;
    }
}

@end
