//
//  WYODInformationTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//订单信息

#define ContentWidth LCDW-30

#import "WYODInformationTableViewCell.h"
#import "OrderManagementDetailModel.h"

@interface WYODInformationTableViewCell ()
@property(nonatomic,strong)NSString* ComplaintTelephone;
@end
@implementation WYODInformationTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    

}
- (IBAction)clickComplaintTelephoneBtn:(UIButton *)sender {
    
    [self zx_performCallPhone:_ComplaintTelephone];

}


-(void)setCellData:(id)data
{
    OrderManagementDetailModel* model = data;
   
    if (![NSString zhIsBlankString:model.bizOrderId]) {
        self.bizOrderIdLabel.text =  [NSString stringWithFormat:@"订单编号：%@",model.bizOrderId];
    }else{
        self.bizOrderIdLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.createTime]) {
        self.createTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.createTime];
    }else{
        self.createTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.confirmTime]) {
        self.confirmTimeLabel.text = [NSString stringWithFormat:@"确认时间：%@",model.confirmTime];
    }else{
        self.confirmTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.payTime]) {
        self.payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",model.payTime];
    }else{
        self.payTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.deliveryTime]) {
        self.deliveryTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",model.deliveryTime];
    }else{
        self.deliveryTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.finishTime]) {
        self.finishTimeLabel.text =  [NSString stringWithFormat:@"完成时间：%@",model.finishTime];
    }else{
        self.finishTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    

    _ComplaintTelephone = [NSString stringWithFormat:@"%@",model.buttonComplaint];
    [self.ComplaintTelephoneBtn setTitle: [NSString stringWithFormat:@"投诉电话：%@",model.buttonComplaint] forState:UIControlStateNormal];
}

- (CGFloat)getCellHeightWithContentData:(id)data
{
    OrderManagementDetailModel* model = data;

    if (![NSString zhIsBlankString:model.bizOrderId]) {
        self.bizOrderIdLabel.text =  [NSString stringWithFormat:@"订单编号：%@",model.bizOrderId];
    }else{
        self.bizOrderIdLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.createTime]) {
        self.createTimeLabel.text = [NSString stringWithFormat:@"下单时间：%@",model.createTime];
    }else{
        self.createTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.confirmTime]) {
        self.confirmTimeLabel.text = [NSString stringWithFormat:@"确认时间：%@",model.confirmTime];
    }else{
        self.confirmTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.payTime]) {
        self.payTimeLabel.text = [NSString stringWithFormat:@"支付时间：%@",model.payTime];
    }else{
        self.payTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.deliveryTime]) {
        self.deliveryTimeLabel.text = [NSString stringWithFormat:@"发货时间：%@",model.deliveryTime];
    }else{
        self.deliveryTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    if (![NSString zhIsBlankString:model.finishTime]) {
        self.finishTimeLabel.text =  [NSString stringWithFormat:@"完成时间：%@",model.finishTime];
    }else{
        self.finishTimeLabel.text =  [NSString stringWithFormat:@""];
    }
    [_bizOrderIdLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];
    [_createTimeLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];
    [_confirmTimeLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];
    [_payTimeLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];
    [_deliveryTimeLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];
    [_finishTimeLabel jl_setAttributedText:nil withMinimumLineHeight:16.5];


    [self.bizOrderIdLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.bizOrderIdLabel layoutIfNeeded];
    
    [self.createTimeLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.createTimeLabel layoutIfNeeded];

    [self.confirmTimeLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.confirmTimeLabel layoutIfNeeded];
    
    [self.payTimeLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.payTimeLabel layoutIfNeeded];
    
    [self.deliveryTimeLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.deliveryTimeLabel layoutIfNeeded];
    
    [self.finishTimeLabel setPreferredMaxLayoutWidth:ContentWidth];
    [self.finishTimeLabel layoutIfNeeded];
    
    
    [self.contentView layoutIfNeeded];
    CGSize size = [self.contentView systemLayoutSizeFittingSize:UILayoutFittingCompressedSize];
    
    return size.height+1.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
