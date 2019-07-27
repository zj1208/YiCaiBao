//
//  CommonTradePersonalCell.m
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "CommonTradePersonalCell.h"

@implementation CommonTradePersonalCell

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
    
    [self updateConstraintsIfNeeded];
    [self.headBtn zh_setButtonImageViewScaleAspectFill];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    iconsView.minimumInteritemSpacing = 2.f;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];

}

- (void)setData:(id)data
{

//  NSURL *url = [NSURL URLWithString:@"http://wx.qlogo.cn/mmopen/6UJuicibgVeQICSht7lHnkib75eYzRqk2UEJsC3Y8eS0Bv4vbib4zJpOoZjYZtT2kFVf23hKszLBb4y0fDJ5G0GeBzibnia9yIZyvv/0"];
    NSURL *url = [data iconURL];
    NSURL *picUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w300_hX relativeToImgPath:url.absoluteString];

    [self.headBtn sd_setImageWithURL:picUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
    self.nickNameLab.text = [data userName];
    self.companyLab.text = [data companyName];
    NSArray *buyerBadges = [data buyerBadges];
    NSMutableArray *imgIcons = [NSMutableArray array];
    [buyerBadges  enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];
    
    [self layoutIfNeeded];
    CGSize size  = [self.iconsView sizeWithContentData:self.iconsView.dataMArray];
    
    [self.iconsContainerView mas_updateConstraints:^(MASConstraintMaker *make) {
        
        make.height.mas_equalTo (size.height);
        make.width.mas_equalTo(size.width);
        
    }];
    
}

- (void)updateConstraints
{
    [super updateConstraints];
  
}

@end
