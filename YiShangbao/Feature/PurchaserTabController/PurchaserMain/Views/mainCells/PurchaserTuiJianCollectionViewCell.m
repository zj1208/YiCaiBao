//
//  PurchaserTuiJianCollectionViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "PurchaserTuiJianCollectionViewCell.h"
#import "PurchaserModel.h"
@implementation PurchaserTuiJianCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"EFEFEF"].CGColor;


}
-(void)settData:(id)data
{
    PurchaserListModel* model = (PurchaserListModel*) data;
    
    self.descLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",model.price];
    if ([model.sourceType isEqualToNumber:@1]) {
        self.xianhuoimageView.image = [UIImage imageNamed:@"searchxianzuo"];
    }else{
        self.xianhuoimageView.image = [UIImage imageNamed:@"searchdingzuo"];
    }
    
    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w600_hX relativeToImgPath:model.picUrl];
    [self.imageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
}
@end
