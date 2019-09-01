//
//  TradeDetailOtherReplyCell.m
//  YiShangbao
//
//  Created by simon on 17/4/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeDetailOtherReplyCell.h"

@implementation TradeDetailOtherReplyCell

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
    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.headBtn.contentHorizontalAlignment= UIControlContentHorizontalAlignmentFill;
    self.headBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
    
    [self.headBtn zx_setBorderWithRoundItem];
    
    ZXImgIconsCollectionView *iconsView = [[ZXImgIconsCollectionView alloc] init];
    self.iconsView = iconsView;
    [self.iconsContainerView addSubview:iconsView];
    self.iconsContainerView.backgroundColor = [UIColor clearColor];
    [iconsView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.mas_equalTo(self.iconsContainerView).with.insets(UIEdgeInsetsMake(0, 0, 0,0));
        
    }];
}


- (void)setData:(id)data
{
    TradeOtherReplyModel *model = (TradeOtherReplyModel *)data;
    
    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.shopIcon];
    [self.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderShopImage];
    
    self.shopNameLab.text = model.shopName;
    self.bidTimesLab.text = [NSString stringWithFormat:@"%@单",model.bidTimes];
 
    
    NSMutableArray *imgIcons = [NSMutableArray array];
    [model.sellerBadges enumerateObjectsUsingBlock:^(WYIconModlel*  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        ZXImgIcons *icon = [ZXImgIcons photoWithOriginalUrl:obj.iconUrl];
        icon.width = [obj.width floatValue];
        icon.height = [obj.height floatValue];
        [imgIcons addObject:icon];
    }];
    [self.iconsView setData:imgIcons];

}
@end
