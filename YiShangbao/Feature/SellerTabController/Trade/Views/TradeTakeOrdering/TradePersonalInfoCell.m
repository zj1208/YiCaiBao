//
//  TradePersonalInfoCell.m
//  YiShangbao
//
//  Created by simon on 17/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradePersonalInfoCell.h"

@implementation TradePersonalInfoCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    
//    [self.companyCerLab zx_setCornerRadius:2.f borderWidth:1.f borderColor:WYUISTYLE.colorSblue];
//    [self.personalCerLab zx_setCornerRadius:2.f borderWidth:1.f borderColor:UIColorFromRGB(255.f, 132.f, 0)];
//    self.personalCerLab.textColor = UIColorFromRGB(255.f, 132.f, 0);
//
//    [self.speciallyInviteLab zx_setCornerRadius:2.f borderWidth:1.f borderColor:WYUISTYLE.colorMred];
//    self.headBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    
}

- (void)setData:(id)data
{
    TradeDetailModel *model = (TradeDetailModel *)data;

//    NSURL *headUrl = [NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:[data URL]];
//    [self.headBtn sd_setImageWithURL:headUrl forState:UIControlStateNormal placeholderImage:AppPlaceholderHeadImage];
//
//    self.nickNameLab.text = model.userName;
//    self.companyLab.text = model.companyName;
//
//    
//    WYCertificationType certificationType = model.certificationType;
//    
//    self.companyCerLab.hidden = YES;
//    self.personalCerLab.hidden = YES;
//    self.companyLab.hidden = NO;
//    self.speciallyInviteLab.hidden = YES;
//    
//    if (certificationType ==WYCertificationType_personage)
//    {
//        self.personalCerLab.hidden = NO;
//    }
//    else if (certificationType ==WYCertificationType_enterprise)
//    {
//        self.companyCerLab.hidden = NO;
//    }
//    else if (certificationType ==WYCertificationType_buyer)
//    {
//        self.speciallyInviteLab.hidden = NO;
//        self.companyCerLab.hidden = NO;
//    }
    
    self.titleLab.text =[NSString stringWithFormat:@"求购:%@",model.title];
    self.contentLab.text = [data content];
    [self.contentLab jl_setAttributedText:nil withMinimumLineHeight:19.f];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
