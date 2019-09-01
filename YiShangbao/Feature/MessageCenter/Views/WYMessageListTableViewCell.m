//
//  WYMessageListTableViewCell.m
//  YiShangbao
//
//  Created by Lance on 16/12/16.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "WYMessageListTableViewCell.h"

@implementation WYMessageListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
//    self.messageNub.layer.masksToBounds = YES;
//    self.messageNub.layer.cornerRadius =7.0;
//    self.messageNub.layer.borderWidth= 2;
    self.messageNub.layer.borderColor = [UIColor whiteColor].CGColor;
    
    self.messageNub.font = [UIFont systemFontOfSize:12];
    
    self.messageTitle.font = [UIFont systemFontOfSize:15];
    self.messageTitle.textColor = UIColorFromRGB_HexValue(0x222222);

    self.messageDetail.font = [UIFont systemFontOfSize:12];
    self.messageDetail.textColor = UIColorFromRGB_HexValue(0x666666);

    self.messageTime.font = [UIFont systemFontOfSize:12];
    self.messageTime.textColor = UIColorFromRGB_HexValue(0x999999);
    
    [self.dotNumLab zx_setCornerRadius:4.f borderWidth:0.f borderColor:nil];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setData:(id)data
{
    MessageModelSub *model = (MessageModelSub *)data;
    
    [self.serviceImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.typeIcon] placeholderImage:AppPlaceholderImage options:SDWebImageAllowInvalidSSLCertificates];
    self.messageTitle.text = model.typeName;
//    if (model.type ==8 ||model.type ==2)
//    {
//        self.messageNub.hidden = YES;
//        self.dotNumLab.hidden = model.num>0?NO:YES;
//    }
//    else
//    {
        self.dotNumLab.hidden = YES;
        self.messageNub.hidden = model.num>0?NO:YES;
       [self.messageNub zh_digitalIconWithBadgeValue:model.num maginY:1.f badgeFont:[UIFont systemFontOfSize:LCDScale_iPhone6_Width(12)] titleColor:[UIColor whiteColor] backgroundColor:[UIColor redColor]];
//    }
    self.messageDetail.text = model.subMsg.abbr;
    self.messageTime.text = model.subMsg.date;
}
@end
