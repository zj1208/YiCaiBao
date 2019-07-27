//
//  WYODPlaceOrderFlowTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//订单流程view（买家下单-卖家确认。。。）

#import "WYODPlaceOrderFlowTableViewCell.h"
#import "OrderManagementDetailModel.h"
@implementation WYODPlaceOrderFlowTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    if (LCDW<375.f) {
        self.firstDecLabel.font = [UIFont systemFontOfSize:13];
    }
    
    self.headeView.layer.masksToBounds = YES;
    self.headeView.layer.cornerRadius = self.headeView.frame.size.height/2;;
    
    self.rightBtn.layer.masksToBounds = YES;
    self.rightBtn.layer.borderWidth = 0.5;
    
    self.rightBtn.hidden = YES;
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家图片 4卖家图片
        self.rightBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"FF5434"].CGColor;
        [self.rightBtn setTitleColor:[WYUISTYLE colorWithHexString:@"FF5434"] forState:UIControlStateNormal];
//        self.rightBtn.backgroundColor = [WYUISTYLE colorWithHexString:@"FF5434"];
    }else{
        self.rightBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"#F58F23"].CGColor;
        [self.rightBtn setTitleColor:[WYUISTYLE colorWithHexString:@"#F58F23"] forState:UIControlStateNormal];
//        self.rightBtn.backgroundColor = [WYUISTYLE colorWithHexString:@"FF5434"];
    }
    self.rightBtn.layer.cornerRadius = 78.f/375.f*LCDW*4.f/13.f/2;
    self.flowview.backgroundColor = [UIColor whiteColor];


}

-(void)setCellData:(id)data
{
    OrderManagementDetailModel* model  = data;
    
    OMDStatusDescModel* statusDescModel = model.statusDesc;
    NSArray* array = model.upButtons;
    OrderButtonModel* btnModel = array.firstObject;
    
    self.firstDecLabel.text = statusDescModel.desc1;
    self.secondDecLabel.text = statusDescModel.desc2;
    
    [self.firstDecLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];
    [self.secondDecLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];

    NSURL * url = [NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:statusDescModel.pic];
    [self.headeView sd_setImageWithURL:url placeholderImage:AppPlaceholderHeadImage];

    if (array.count>0) {
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:btnModel.name forState:UIControlStateNormal];
    }else{
        self.rightBtn.hidden = YES;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
