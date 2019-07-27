//
//  BankAccountListTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BankAccountListTableViewCell.h"

@implementation BankAccountListTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    self.selectionStyle = UITableViewCellSelectionStyleGray;
    self.accessoryType = UITableViewCellAccessoryNone;
    self.bank_bg = [[UIImageView alloc]init];
    [self addSubview:self.bank_bg];
    self.bank_bg.contentMode = UIViewContentModeScaleToFill;
//    self.bank_bg.backgroundColor = WYUISTYLE.colorMTblack;

    self.icon_bg = [[UIImageView alloc] init];
    [self addSubview:self.icon_bg];
    self.icon_bg.image = [UIImage imageNamed:@"Oval"];
    
    self.image_icon = [[UIImageView alloc]init];
    [self addSubview:self.image_icon];
    
    self.lbl_bankName = [[UILabel alloc]init];
    [self addSubview:self.lbl_bankName];
//    self.lbl_bankName.text = @"广发银行 | 杭州支行";
    self.lbl_bankName.textColor = WYUISTYLE.colorBWhite;
    self.lbl_bankName.font = WYUISTYLE.fontWith30;
    
    self.lbl_openName = [[UILabel alloc] init];
    [self addSubview:self.lbl_openName];
    self.lbl_openName.textColor = WYUISTYLE.colorBWhite;
    self.lbl_openName.font = WYUISTYLE.fontWith30;

    self.lbl_bankInfo = [[UILabel alloc]init];
    [self addSubview:self.lbl_bankInfo];
//    self.lbl_bankInfo.text = @"孔鑫 | (6222 3051 2245 9359 789)";
    self.lbl_bankInfo.textColor = WYUISTYLE.colorBWhite;
    self.lbl_bankInfo.font = WYUISTYLE.fontWith36;
    if ([WYUTILITY.getMainScreen isEqualToString:@"5"]) {
        self.lbl_bankInfo.font = WYUISTYLE.fontWith30;
    }
    
    [self.bank_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@0);
        make.left.equalTo(@0);
        make.width.equalTo(@(SCREEN_WIDTH));
        make.height.equalTo(@107);
    }];
    
    [self.icon_bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.image_icon.mas_centerX);
        make.centerY.equalTo(self.image_icon.mas_centerY).offset(2);
        make.width.equalTo(@69);
        make.height.equalTo(@69);
    }];
    
    [self.image_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bank_bg.mas_left).offset(35);
        make.top.equalTo(self.bank_bg.mas_top).offset(17);
        make.width.equalTo(@(45));
        make.height.equalTo(@(45));
    }];

    [self.lbl_bankName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.image_icon.mas_right).offset(18);
        make.right.equalTo(self.bank_bg.mas_right).offset(-24);
        make.top.equalTo(self.bank_bg.mas_top).offset(17);
    }];
    [self.lbl_openName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbl_bankName.mas_left);
        make.top.equalTo(self.lbl_bankName.mas_bottom).offset(10);
    }];
    
    [self.lbl_bankInfo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.lbl_bankName.mas_left);
        make.right.equalTo(self.bank_bg.mas_right).offset(-12);
        make.bottom.equalTo(self.bank_bg.mas_bottom).offset(-13);
    }];
    return self;
}

-(void)setData:(AcctInfoModel *)data{
    if ([data.color isEqualToString:@"red"]) {
        self.bank_bg.image = [UIImage imageNamed:@"pic_red"];
    }else if ([data.color isEqualToString:@"green"]){
        self.bank_bg.image = [UIImage imageNamed:@"pic_green"];
    }else{
        self.bank_bg.image = [UIImage imageNamed:@"pic_bule"];
    }
    [self.image_icon sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:data.bankIcon]  placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.lbl_bankName.text = [NSString stringWithFormat:@"%@ | %@",data.bankValue, data.bankPlace];
    self.lbl_openName.text = data.acctName;
    self.lbl_bankInfo.text = [self formatterBankCardNum:data.bankNo];
}


#pragma mark - 银行卡格式 
//后4位一组
- (NSString *)formatCardNumber:(NSString *)cardNum {
    NSNumber *number = @([cardNum longLongValue]);
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    [formatter setUsesGroupingSeparator:YES];
    [formatter setGroupingSize:4];
    [formatter setGroupingSeparator:@" "];
    return [formatter stringFromNumber:number];
}
//前4位一组
-(NSString *)formatterBankCardNum:(NSString *)string

{
    NSString *tempStr=string;
    NSInteger size =(tempStr.length / 4);
    NSMutableArray *tmpStrArr = [[NSMutableArray alloc] init];
    for (int n = 0;n < size; n++)
    {
        [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(n*4, 4)]];
    }
    [tmpStrArr addObject:[tempStr substringWithRange:NSMakeRange(size*4, (tempStr.length % 4))]];
    tempStr = [tmpStrArr componentsJoinedByString:@" "];
    return tempStr;
}
@end
