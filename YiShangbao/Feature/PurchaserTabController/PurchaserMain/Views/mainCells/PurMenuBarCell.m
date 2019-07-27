//
//  PurMenuBarCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurMenuBarCell.h"
#import "PurchaserModel.h"
@implementation PurMenuBarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.titleLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(12.5f)];
    self.iconWidthConstraint.constant = LCDScale_iPhone6_Width(40.f);
    
}
-(void)setCellData:(id) data
{
    if ([data isKindOfClass:[TopCategoryModel class]]) { //人气分类
        self.iconWidthConstraint.constant = LCDScale_iPhone6_Width(64.f);

        TopCategoryModel *model = data;

        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:model.icon];
        [self.iconIMV sd_setImageWithURL:url placeholderImage:AppPlaceholderImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    }
    
    
    if ([data isKindOfClass:[PurchaserCommonAdvModel class]]) { //bannar
        self.iconWidthConstraint.constant = LCDScale_iPhone6_Width(40.f);

        PurchaserCommonAdvModel *model = data;
        
        NSURL* url =  [NSURL ossImageWithResizeType:OSSImageResizeType_w414_hX relativeToImgPath:model.pic];
        [self.iconIMV sd_setImageWithURL:url placeholderImage:AppPlaceholderImage options:SDWebImageRetryFailed | SDWebImageRefreshCached ];
        self.titleLabel.text = [NSString stringWithFormat:@"%@",model.title];
    }
}
@end
