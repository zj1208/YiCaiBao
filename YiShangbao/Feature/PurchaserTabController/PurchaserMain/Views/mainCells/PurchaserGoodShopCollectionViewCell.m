//
//  PurchaserGoodShopCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserGoodShopCollectionViewCell.h"
#import "PurchaserModel.h"
@implementation PurchaserGoodShopCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    //icons
    [self updateConstraintsIfNeeded];
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 4.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
    }];
    
}
-(void)settData:(id)data
{
    ShopStandAloneRecmdModel* model = (ShopStandAloneRecmdModel*)data;
    
    [self layoutIfNeeded];
    self.shopHeaderIMV.layer.masksToBounds = YES;
    self.shopHeaderIMV.layer.cornerRadius = self.shopHeaderIMV.bounds.size.height/2;
    
    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:model.iconUrl];
    [self.shopHeaderIMV sd_setImageWithURL:url placeholderImage:nil ];
    
    self.shopNameLabel.text = model.shopName;
    self.shopDescLabel.text = model.descriptionN;

//    if ([model.authMarket isEqualToNumber:@1]) {
//        self.renzhengIMG.image = [UIImage imageNamed:@"yilenzheng"];
//    }else{
//        self.renzhengIMG.image = [UIImage imageNamed:@"weirenzheng"];
//    }
//    if ([model.supplierSig isEqualToNumber:@1]) {
//        self.jinpaiIMG.hidden = NO;
//    }else{
//        self.jinpaiIMG.hidden = YES;
//    }
    //icons
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.identifierIcons enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
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



- (IBAction)firstBtnClick:(UIButton *)sender {
    [self btnWith:0];
}
- (IBAction)secondBtnClick:(UIButton *)sender {
    [self btnWith:1];

}
- (IBAction)thirdBtnClcik:(UIButton *)sender {
    [self btnWith:2];

}
-(void)btnWith:(NSInteger)integer
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_PurchaserGoodShopCollectionViewCell:didSelectItemWithInteger:)]) {
        [self.delegate jl_PurchaserGoodShopCollectionViewCell:self didSelectItemWithInteger:integer];
    }
}


@end
