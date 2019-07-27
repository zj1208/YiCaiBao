//
//  SellingProductCell.m
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SellingProductCell.h"

@implementation SellingProductCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.iconImageView.hidden = YES;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.priceLab.backgroundColor = [UIColor clearColor];
    self.supplyOfGoodsLab.backgroundColor =[UIColor clearColor];
    
    [self.previewBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    [self.previewBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [self.editBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    [self.promotionBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    
    [self.picImageView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];

    
    self.titleLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.supplyOfGoodsLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.priceLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];

    self.previewBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14)];
    self.editBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];
    self.promotionBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];

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
    ShopMyProductModel *model = (ShopMyProductModel *)data;
//    NSURL *url = [NSURL URLWithString:@"http://wx.qlogo.cn/mmopen/6UJuicibgVeQICSht7lHnkib75eYzRqk2UEJsC3Y8eS0Bv4vbib4zJpOoZjYZtT2kFVf23hKszLBb4y0fDJ5G0GeBzibnia9yIZyvv/0"];
    NSURL *url = [data iconURL];
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url.absoluteString];
    //这个网络图无法下载显示？
//    NSURL *picUrl = [NSURL URLWithString:@"http://img3.imgtn.bdimg.com/it/u=1059547346,2075007433&fm=27&gp=0.jpg"];
    [self.picImageView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderImage];
    self.titleLab.text = [data name];
    self.supplyOfGoodsLab.text = model.sourceType;
    if ([model.price isEqualToString:@"-1"])
    {
        self.priceLab.text = @"面议";
    }
    else
    {
        self.priceLab.text = [NSString stringWithFormat:@"¥ %@",model.price];
    }


    self.iconImageView.hidden = !model.isMain;

}
@end
