//
//  PurTbzgAdvCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurTbzgAdvCell.h"
#import "PurchaserModel.h"

@implementation PurTbzgAdvCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setDatalowPriceStockAdv:(NSArray *)lowPriceStockAdv hotShopAdv:(NSArray *)hotShopAdv tbzgAdv:(NSArray *)tbzgAdv
{
    PurchaserCommonAdvModel* tbzgAdvModel = tbzgAdv.firstObject;
    PurchaserCommonAdvModel* hotShopAdvModel = hotShopAdv.firstObject;
    PurchaserCommonAdvModel* lowPriceStockAdvModel = lowPriceStockAdv.firstObject;
    
    if (tbzgAdvModel) {
        self.tabbaozhigongBtn.enabled=YES;
        NSURL *urltaobao = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:tbzgAdvModel.pic];
        [self.tabbaozhigongBtn sd_setBackgroundImageWithURL:urltaobao forState:UIControlStateNormal placeholderImage:AppPlaceholderImage];
    }else{
        self.tabbaozhigongBtn.enabled=NO;
    }
    
    if (hotShopAdvModel) {
        self.rexiaoBtn.enabled=YES;
        NSURL *urldi = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:hotShopAdvModel.pic];
        [self.rexiaoBtn sd_setBackgroundImageWithURL:urldi forState:UIControlStateNormal placeholderImage:AppPlaceholderImage];
    }else{
        self.rexiaoBtn.enabled=NO;
    }
    
    if (lowPriceStockAdvModel) {
        self.dijiaBtn.enabled=YES;
        NSURL *urlre = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:lowPriceStockAdvModel.pic];
        [self.dijiaBtn sd_setBackgroundImageWithURL:urlre forState:UIControlStateNormal placeholderImage:AppPlaceholderImage];
    }else{
        self.dijiaBtn.enabled=NO;
    }
    
}



- (IBAction)dijiaBtnClick:(UIButton *)sender {
    [self  btnWith:PurTbzgAdvCellBtnType_DiJiaBtn];
    
}
- (IBAction)rexiaoBtnClick:(UIButton *)sender {
    [self  btnWith:PurTbzgAdvCellBtnType_ReXiaoBtn];
    
}
- (IBAction)tabbaoBtn:(id)sender {
    [self  btnWith:PurTbzgAdvCellBtnType_TaoBaoBtn];
}
-(void)btnWith:(PurTbzgAdvCellBtnType)type
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(jl_PurTbzgAdvCell:type:)]) {
        [self.delegate jl_PurTbzgAdvCell:self type:type];
    }
}
@end

