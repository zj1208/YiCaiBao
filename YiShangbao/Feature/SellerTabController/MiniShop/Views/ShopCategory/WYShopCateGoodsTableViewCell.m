//
//  WYShopCateGoodsTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCateGoodsTableViewCell.h"

@interface WYShopCateGoodsTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;
//主营
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *supplyOfGoodsLab;

@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UILabel *statusNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *statusNameImageView;

@end

@implementation WYShopCateGoodsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.hidden = YES;
    self.titleLab.backgroundColor = [UIColor clearColor];
    self.priceLab.backgroundColor = [UIColor clearColor];
    self.supplyOfGoodsLab.backgroundColor = [UIColor clearColor];
    
    [self.picImageView zx_setCornerRadius:2.f borderWidth:0.5f borderColor:UIColorFromRGB_HexValue(0xE8E8E8)];
    
    
    self.titleLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(15.f)];
    self.supplyOfGoodsLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    self.priceLab.font =[UIFont systemFontOfSize:LCDScale_5Equal6_To6plus(14.f)];
    

    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(WYShopCategoryGoodsModel *)model{
    NSURL *url = [NSURL URLWithString:model.pic.p];
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url.absoluteString];
    [self.picImageView sd_setImageWithURL:picUrl placeholderImage:AppPlaceholderImage];
    self.titleLab.text = model.name;
    self.supplyOfGoodsLab.text = model.sourceType;
    self.priceLab.text = [NSString stringWithFormat:@"%@",model.price];
    self.statusNameLabel.text = model.statusName;
    self.iconImageView.hidden = !model.isMain;
    
    self.statusNameImageView.hidden = !model.statusName;
    
    [self changeStatus:model];
}

- (void)changeStatus:(WYShopCategoryGoodsModel *)model{
    if (model.isSelected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_shijianzhou_yiwancheng"]];
    }else{
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
    }
}


@end
