//
//  ApplyRefundsProductsTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ApplyRefundsProductsTableViewCell.h"

#import "OrderManagementDetailModel.h"

@implementation ApplyRefundsProductsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellData:(id)data
{
    OMDSubBizOrdersMode* model = data;
   
    self.descLabel.text = [NSString stringWithFormat:@"%@",model.prodName];
    self.sizeLabel.text = [NSString stringWithFormat:@"%@",model.skuInfo];

    NSURL* url = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.prodPic];
    [self.productIMG sd_setImageWithURL:url placeholderImage:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
