//
//  SMSelectProductCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMSelectProductCell.h"

@implementation SMSelectProductCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
    self.proImageView.layer.masksToBounds = YES;
    self.proImageView.layer.cornerRadius = 4.f;
}
-(void)setData:(id)data
{
    ExtendSelectProcuctModel *model = (ExtendSelectProcuctModel *)data;
    
    self.proTitleLabel.text = [NSString stringWithFormat:@"%@",model.name];
    self.proSizeLabel.text = [NSString stringWithFormat:@"%@",model.model];
    self.proPriceLabel.text = [NSString stringWithFormat:@"%@",model.priceDisp];

    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:model.mainPic.p];
    [self.proImageView sd_setImageWithURL:url placeholderImage:nil ];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    self.selBtn.selected = selected;
    // Configure the view for the selected state
}

@end
