//
//  RefundDetailWaitTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundDetailWaitTableViewCell.h"
#import "OrderManagementDetailModel.h"
@implementation RefundDetailWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.decLabel.font = [UIFont systemFontOfSize:LCDScale_iPhone6_Width(15.f)];
    
    
    self.revocationBtn.layer.masksToBounds = YES;
    self.revocationBtn.layer.cornerRadius = 13;
    self.revocationBtn.layer.borderWidth = 0.5;
    self.revocationBtn.layer.borderColor = [WYUISTYLE colorWithHexString:@"#F58F23"].CGColor;
    
    

}
-(void)setCellData:(id)data
{
    OMRefundDetailInfoModel* model = data;
    
    self.decLabel.text = [NSString stringWithFormat:@"%@",model.statusDesp];
    self.timeLabel.text = [NSString stringWithFormat:@"%@",model.statusTimeAbout];
    
    NSArray* decArray = model.reminders;
    self.answerFirstLabel.text = [NSString stringWithFormat:@"%@",decArray.firstObject];
    self.answerSecondLabel.text = [NSString stringWithFormat:@"%@",decArray.lastObject];
    
    [self.answerSecondLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
