//
//  SODProductsRefundDetailCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SODProductsRefundDetailCollectionViewCell.h"
#import "OrderManagementDetailModel.h"

@implementation SODProductsRefundDetailCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.IMV.layer.masksToBounds = YES;
    self.IMV.layer.cornerRadius = 4.f;
    self.IMV.layer.borderWidth = 0.4;
    self.IMV.layer.borderColor  = [WYUISTYLE colorWithHexString:@"d8d8d8"].CGColor;
  
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 4.f;
}
-(void)setData:(id)data
{
    
    OMDSubBizOrdersMode* model = data;
    
    self.productLabel.text = model.prodName;
    self.productSizeLabel.text = model.skuInfo;
    NSURL * url = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.prodPic];
    [self.IMV sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
    
    //设置行高
    [self.productLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];
    [self.productSizeLabel jl_setAttributedText:nil withMinimumLineHeight:15];
    
}

@end
