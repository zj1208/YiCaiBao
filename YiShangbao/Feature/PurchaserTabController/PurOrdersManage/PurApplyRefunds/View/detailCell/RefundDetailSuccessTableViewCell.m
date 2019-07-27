//
//  RefundDetailSuccessTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundDetailSuccessTableViewCell.h"
#import "OrderManagementDetailModel.h"

@implementation RefundDetailSuccessTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setCellData:(id)data
{
    OMRefundDetailInfoModel* model = data;
    
    self.decLabel.text = [NSString stringWithFormat:@"%@",model.statusDesp];
    self.timelabel.text = [NSString stringWithFormat:@"%@",model.statusTimeAbout];
    
    NSArray* decArray = model.reminders;
    self.moneyLabel.text = [NSString stringWithFormat:@"%@",decArray.firstObject];
    self.RefundPathLabel.text = [NSString stringWithFormat:@"%@",decArray.lastObject];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
