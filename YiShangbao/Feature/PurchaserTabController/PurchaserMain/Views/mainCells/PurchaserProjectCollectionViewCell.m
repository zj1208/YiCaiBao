//
//  PurchaserProjectCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserProjectCollectionViewCell.h"
#import "PurchaserModel.h"
@implementation PurchaserProjectCollectionViewCell

- (void)prepareForReuse
{
    [super prepareForReuse];
}
- (void)awakeFromNib {
    [super awakeFromNib];

    self.firstBtn.layer.masksToBounds = YES;
    self.firstBtn.layer.borderWidth = 0.5f;
    self.firstBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"EFEFEF"].CGColor;
    
    self.secondBtn.layer.masksToBounds = YES;
    self.secondBtn.layer.borderWidth = 0.5f;
    self.secondBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"EFEFEF"].CGColor;
    
    self.thirdBtn.layer.masksToBounds = YES;
    self.thirdBtn.layer.borderWidth = 0.5f;
    self.thirdBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"EFEFEF"].CGColor;


}
-(void)settData:(id)data
{
    if (self.type == PurchaserProjectCollectionViewCellProduct) {
        prodRecmdModel* model = (prodRecmdModel*)data;
        
        bgpModel* bgpmodel =  model.bgp;
        NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:bgpmodel.p];
        [self.backGroundView sd_setImageWithURL:url placeholderImage:nil];
        
        self.TitleLAbel.text = model.title;
        self.descLabel.text = model.descriptionN;
        
        NSArray* array = model.prods;
        if (array.count>=3) {
            prodsModel* pmodel_0 = array[0];
            prodsModel* pmodel_1 = array[1];
            prodsModel* pmodel_2 = array[2];
            
            bgpModel* bgpmodel_0 =  pmodel_0.pic;
            bgpModel* bgpmodel_1 =  pmodel_1.pic;
            bgpModel* bgpmodel_2 =  pmodel_2.pic;
            
            NSURL *url_0 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_0.p];
            [self.firstIMG sd_setImageWithURL:url_0 placeholderImage:AppPlaceholderImage];
            self.firstdescLabel.text = pmodel_0.prodName;
            self.firstPriceLabel.text = [NSString stringWithFormat:@"%@",pmodel_0.price];
            
            NSURL *url_1 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_1.p];
            [self.secondIMG sd_setImageWithURL:url_1 placeholderImage:AppPlaceholderImage];
            self.seconddescLabel.text = pmodel_1.prodName;
            self.secondPriceLabel.text = [NSString stringWithFormat:@"%@",pmodel_1.price];
            
            NSURL *url_2 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_2.p];
            [self.thirdIMG sd_setImageWithURL:url_2 placeholderImage:AppPlaceholderImage];
            self.thirddescLabel.text = pmodel_2.prodName;
            self.thirdPriceLabel.text = [NSString stringWithFormat:@"%@",pmodel_2.price];
            
        }


    }
    if (self.type == PurchaserProjectCollectionViewCellShop) {
        ShopRecmdListModel* model = (ShopRecmdListModel*)data;
       
        bgpModel* bgpmodel =  model.bgp;
        NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:bgpmodel.p];
        [self.backGroundView sd_setImageWithURL:url placeholderImage:nil];
        
        self.TitleLAbel.text = model.title;
        self.descLabel.text = model.outline;
        
        NSArray* array = model.shops;
        if (array.count>=3) {
            RecmdShopsModel* pmodel_0 = array[0];
            RecmdShopsModel* pmodel_1 = array[1];
            RecmdShopsModel* pmodel_2 = array[2];
            
            bgpModel* bgpmodel_0 =  pmodel_0.pic;
            bgpModel* bgpmodel_1 =  pmodel_1.pic;
            bgpModel* bgpmodel_2 =  pmodel_2.pic;
            
            NSURL *url_0 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_0.p];
            [self.firstIMG sd_setImageWithURL:url_0 placeholderImage:AppPlaceholderImage];
            self.firstdescLabel.text = pmodel_0.name;
            
            NSURL *url_1 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_1.p];
            [self.secondIMG sd_setImageWithURL:url_1 placeholderImage:AppPlaceholderImage];
            self.seconddescLabel.text = pmodel_1.name;
            
            NSURL *url_2 = [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:bgpmodel_2.p];
            [self.thirdIMG sd_setImageWithURL:url_2 placeholderImage:AppPlaceholderImage];
            self.thirddescLabel.text = pmodel_2.name;
            
            
        }

    }
}



- (IBAction)firstBtnClick:(UIButton *)sender {
    [self clcikWithInteger:0];
}
- (IBAction)secondBtnClick:(UIButton *)sender {
    [self clcikWithInteger:1];
}
- (IBAction)thirdBtnClcik:(UIButton *)sender {
    [self clcikWithInteger:2];
}
-(void)clcikWithInteger:(NSInteger)integer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_PurchaserProjectCollectionViewCell:didSelectItemAtInteger:)]) {
        [self.delegate jl_PurchaserProjectCollectionViewCell:self didSelectItemAtInteger:integer];
    }
}
-(void)setType:(PurchaserProjectCollectionViewCellStyle)type
{
    _type = type;
    
    switch (type) {
        case PurchaserProjectCollectionViewCellProduct:
            self.firstPriceLabel.hidden = NO;
            self.secondPriceLabel.hidden = NO;
            self.thirdPriceLabel.hidden = NO;
            break;
        case PurchaserProjectCollectionViewCellShop:
            self.firstPriceLabel.hidden = YES;
            self.secondPriceLabel.hidden = YES;
            self.thirdPriceLabel.hidden = YES;
            break;
            
        default:
            break;
    }
}
@end
