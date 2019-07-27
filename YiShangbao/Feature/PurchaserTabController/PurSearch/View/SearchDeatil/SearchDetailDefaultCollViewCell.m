//
//  SearchDetailDefaultCollViewCell.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchDetailDefaultCollViewCell.h"

@implementation SearchDetailDefaultCollViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self changeUI];

}
-(void)changeUI
{
    self.contentView.layer.masksToBounds = YES;
    self.contentView.layer.borderWidth = 0.5f;
    self.contentView.layer.borderColor = [WYUISTYLE colorWithHexString:@"EFEFEF"].CGColor;

}
-(void)setHalfLCDWCellData:(SearchModel *)data
{
    NSURL *url =  [NSURL URLWithString:data.picUrl];
    [self.headerImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url] placeholderImage:AppPlaceholderImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
    
    self.titleLabel.text = data.name;
//    self.sizeLabel.text = data.specs;
//    self.addressLabel.text = data.address;
    self.priceLabel.text = data.price;
    
    if (data.sourceType == WYSearchProductTypeXianHuo) {
        self.xianzuoImageView.image = [UIImage imageNamed:@"searchxianzuo"];
    }else if (data.sourceType == WYSearchProductTypeDingZuo){
        self.xianzuoImageView.image = [UIImage imageNamed:@"searchdingzuo"];
    }

    if ([NSString zhIsBlankString:data.payMark]) {
        self.tuiguangContentView.hidden = YES;
        self.tuiguangLabel.text = @"";
    }else{
        self.tuiguangContentView.hidden = NO;
        self.tuiguangLabel.text = data.payMark;
    }
}


@end
