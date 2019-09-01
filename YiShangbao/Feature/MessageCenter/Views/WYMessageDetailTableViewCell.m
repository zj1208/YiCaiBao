//
//  WYMessageDetailTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYMessageDetailTableViewCell.h"


#define ContentWidth LCDW-60

@implementation WYMessageDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = WYUISTYLE.colorBGgrey;
    self.titleLab.font = [UIFont boldSystemFontOfSize:LCDScale_iPhone6_Width(17)];
    self.descLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
    self.dateLab.font =[UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
    self.topTimeLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(11)];
    self.promtLab.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(13)];
    
    self.contentImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.contentImageView.clipsToBounds = YES;
    self.imageBgView.backgroundColor = WYUISTYLE.colorBWhite;
    
    [self.topTimeLab zx_setCornerRadius:4.f borderWidth:0.f borderColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (void)setData:(id)data
{
    MessageDetailModel *model = (MessageDetailModel *)data;
    self.topTimeLab.text = model.date;
    self.titleLab.text = model.title;
    self.dateLab.text = model.dateYmd;
    self.descLab.text =model.abbr ;
    NSURL *url = [NSURL ossImageWithResizeType:OSSImageResizeType_w828_hX relativeToImgPath:model.image];
    [self.contentImageView sd_setImageWithURL:url placeholderImage:AppPlaceholderImage];
    
    if (model.image.length==0)
    {
        [self.imageBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(0);
        }];
        
    }
    else
    {
        [self.imageBgView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo((LCDW-30*2)*20.f/63+10);
        }];

    }

}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    MessageDetailModel *model = (MessageDetailModel *)data;
    
    [self.titleLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.titleLab layoutIfNeeded];
    self.titleLab.text = model.title;
    
    [self.descLab setPreferredMaxLayoutWidth:ContentWidth];
    [self.descLab layoutIfNeeded];
    self.descLab.text = model.abbr;
    
    [self.contentView layoutIfNeeded];
    
    
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    CGFloat height = size.height+1.0f-110;
    if (model.image.length>0)
    {
        height = height+(LCDW-30*2)*20.f/63+10;
    }
    return height;
}
@end
