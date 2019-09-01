//
//  WYTradeAdvCell.m
//  YiShangbao
//
//  Created by simon on 17/6/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTradeAdvCell.h"


#define ContentWidth LCDW-30

@implementation WYTradeAdvCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    [self.advIconLab zx_setCornerRadius:10.f borderWidth:0.6f borderColor:UIColorFromRGB_HexValue(0x868686)];
    self.advIconLab.textColor =UIColorFromRGB_HexValue(0x868686);
    self.advIconLab.hidden = YES;
    
    [self.headBtn zh_setButtonImageViewScaleAspectFill];
    self.advImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.advImageView.clipsToBounds = YES;
    
//   下一期优化：去掉containerView
    [self.photoContainerView zx_setCornerRadius:2.f borderWidth:1.f borderColor:nil];

    [self.photoContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo(LCDScale_iPhone6_Width(345)*8.f/25);
    }];

}

- (void)setData:(id)data
{
    WYTradeModel *model = (WYTradeModel *)data;
    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:[data URL].absoluteString];
    [self.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
    self.advIconLab.hidden = NO;

    self.nickNameLab.text = model.userName;
    self.companyLab.text = model.companyName;
    self.contentLab.text = [data content];
    if (model.photosArray.count >0)
    {
        AliOSSPicModel *picModel = [model.photosArray firstObject];
        NSURL *url = [NSURL URLWithString:picModel.picURL];
        [self.advImageView sd_setImageWithURL:url placeholderImage:AppPlaceholderMainWidthImage];
    }
    self.advIconLab.text = [model mark];
//  self.advIconLab.text = @"我在家里呢你";
    CGRect bounds = [self.advIconLab.text boundingRectWithSize:CGSizeMake(150, 20) options:NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:self.advIconLab.font} context:nil];
    self.advIconLabWidthLayout.constant = bounds.size.width+20;
    self.advIconLab.hidden = [NSString zhIsBlankString:model.mark]?YES:NO;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}


- (CGFloat)getCellHeightWithContentData:(id)data
{
//  xib中如果设置了，这里就不用写了；
//  [self.contentLab setPreferredMaxLayoutWidth:ContentWidth];
    self.contentLab.text = [data content];
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    return size.height+1.0f;
}


@end
