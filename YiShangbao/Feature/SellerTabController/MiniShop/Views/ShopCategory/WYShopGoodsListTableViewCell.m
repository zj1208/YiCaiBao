//
//  WYShopGoodsListTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/12/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopGoodsListTableViewCell.h"

@implementation WYShopGoodsListTableViewCell

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.iconImageView.hidden = YES;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.priceLab.backgroundColor = [UIColor clearColor];
    self.supplyOfGoodsLab.backgroundColor =[UIColor clearColor];
    
    [self.previewBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    [self.previewBtn zh_centerHorizontalImageAndTitleWithTheirSpace:10.f];
    [self.editBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5 borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    [self.promotionBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    [self.upperBtn setCornerRadius:LCDScale_5Equal6_To6plus(25.f)/2 borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xFE744A)];
    
    [self.picImageView setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    
    
    self.titleLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.supplyOfGoodsLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.priceLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    
    self.previewBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14)];
    self.editBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];
    self.promotionBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];
    self.upperBtn.titleLabel.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(13)];
    
    [self.previewBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.bottom.mas_greaterThanOrEqualTo(self.contentView.mas_bottom).offset(-LCDScale_5Equal6_To6plus(15.f));
        make.top.mas_equalTo(self.picImageView.mas_bottom).offset(LCDScale_5Equal6_To6plus(15.f));
    }];
    
    [self.promotionBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.centerY.mas_equalTo(self.previewBtn.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(LCDScale_5Equal6_To6plus(12.f));
    }];
    
    [self.upperBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.centerY.mas_equalTo(self.previewBtn.mas_centerY);
        make.right.mas_equalTo(self.contentView.mas_right).offset(LCDScale_5Equal6_To6plus(12.f));
    }];
    [self.editBtn mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_5Equal6_To6plus(25.f));
        make.width.mas_equalTo(LCDScale_5Equal6_To6plus(73.f));
        make.centerY.mas_equalTo(self.promotionBtn.mas_centerY);
        make.right.mas_equalTo(self.promotionBtn.mas_left).offset(-LCDScale_5Equal6_To6plus(25.f));
    }];
    
//    [self graduallyColor];
}

- (void)setData:(WYShopCategoryGoodsModel *)model
{
    NSURL *url = [NSURL URLWithString:model.pic.p];
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url.absoluteString];
    //这个网络图无法下载显示？
    //    NSURL *picUrl = [NSURL URLWithString:@"http://img3.imgtn.bdimg.com/it/u=1059547346,2075007433&fm=27&gp=0.jpg"];
    [self.picImageView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderImage];
    self.titleLab.text = model.name;
    self.supplyOfGoodsLab.text = model.sourceType;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    self.statusLabel.text = model.statusName;
    self.iconImageView.hidden = !model.isMain;
    
    self.statusNameImageView.hidden = !model.statusName;
    
    if (model.status) {
        self.editBtn.hidden = NO;
        self.promotionBtn.hidden = NO;
        self.upperBtn.hidden = YES;
    }else{
        self.editBtn.hidden = YES;
        self.promotionBtn.hidden = YES;
        self.upperBtn.hidden = NO;
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)graduallyColor{
    UIColor *colorOne = [UIColor colorWithWhite:0.0 alpha:0.0];
    UIColor *colorTwo = [UIColor colorWithWhite:0.0 alpha:0.5];
    NSArray *colors = [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    NSNumber *stopOne = [NSNumber numberWithFloat:0.0];
    NSNumber *stopTwo = [NSNumber numberWithFloat:1.0];
    NSArray *locations = [NSArray arrayWithObjects:stopOne, stopTwo, nil];
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    
    headerLayer.colors = colors;
    headerLayer.locations = locations;
    headerLayer.frame = CGRectMake(0, 0, 108, 18.0);
    
//    [self.statusLabel setTextColor:[UIColor whiteColor]];
    [self.statusLabel.layer insertSublayer:headerLayer atIndex:0];
}

@end
