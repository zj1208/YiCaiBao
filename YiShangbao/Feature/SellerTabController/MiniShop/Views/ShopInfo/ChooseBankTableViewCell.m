//
//  ChooseBankTableViewCell.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ChooseBankTableViewCell.h"

@implementation ChooseBankTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    self.image_view = [[UIImageView alloc]init];
    [self addSubview:self.image_view];
    
    self.lbl_title = [[UILabel alloc] init];
    [self addSubview:self.lbl_title];
    self.lbl_title.textColor = WYUISTYLE.colorMTblack;
    self.lbl_title.font = WYUISTYLE.fontWith32;
    
    [self.image_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
        make.left.equalTo(self.mas_left).offset(12);
        make.width.equalTo(@24);
        make.height.equalTo(@24);
    }];
    [self.lbl_title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.mas_centerY);
         make.left.equalTo(self.image_view.mas_right).offset(20);
    }];
    return self;
}
-(void)setData:(BankModel *)data{
    [self.image_view sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:data.icon] placeholderImage:nil options:SDWebImageAllowInvalidSSLCertificates];
    self.lbl_title.text = data.bankValue;
}
@end
