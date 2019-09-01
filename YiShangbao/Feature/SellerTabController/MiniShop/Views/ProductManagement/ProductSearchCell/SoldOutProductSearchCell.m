//
//  SoldOutProductSearchCell.m
//  YiShangbao
//
//  Created by simon on 2017/11/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SoldOutProductSearchCell.h"

@implementation SoldOutProductSearchCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.hidden = YES;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.priceLab.backgroundColor = [UIColor clearColor];
    //    [self.editBtn setBackgroundColor:[UIColor clearColor]];
    self.supplyOfGoodsLab.backgroundColor =[UIColor clearColor];
    
    
    [self.previewBtn zx_setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    [self.previewBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [self.promotionBtn zx_setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    [self.editBtn zx_setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xFE744A)];

    [self.picImageView zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    
    self.titleLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.supplyOfGoodsLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.priceLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    
    self.previewBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14)];
    self.promotionBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];
    self.editBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];

    [self.previewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.bottom.mas_greaterThanOrEqualTo(self.contentView.mas_bottom).offset(-LCDScale_5Equal6_To6plus(15.f));
        make.top.mas_equalTo(self.picImageView.mas_bottom).offset(LCDScale_5Equal6_To6plus(15.f));
    }];
    [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.centerY.mas_equalTo(self.previewBtn.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(LCDScale_5Equal6_To6plus(12.f));
    }];
    [self.promotionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.centerY.mas_equalTo(self.editBtn.mas_centerY);
        make.right.mas_equalTo(self.editBtn.mas_left).offset(-LCDScale_5Equal6_To6plus(25.f));
    }];
    
}

- (void)setData:(id)data
{
    MyProductSearchModel *model = (MyProductSearchModel *)data;
    //    NSURL *url = [NSURL URLWithString:@"http://wx.qlogo.cn/mmopen/6UJuicibgVeQICSht7lHnkib75eYzRqk2UEJsC3Y8eS0Bv4vbib4zJpOoZjYZtT2kFVf23hKszLBb4y0fDJ5G0GeBzibnia9yIZyvv/0"];
    NSURL *url = [data iconURL];
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url.absoluteString];
    [self.picImageView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderImage];
    self.typeLab.text = model.typeName;

    self.titleLab.text = [data name];
    self.supplyOfGoodsLab.text = model.sourceType;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    self.iconImageView.hidden = !model.isMain;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
