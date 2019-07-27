//
//  RefundingCellFooterView.h
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  退款详情：退款一系列信息，如订单编号，退款编号等；

#import "BaseTableViewCell.h"

static NSString *const nibName_RefundingOrderPriceCell2 = @"RefundingOrderPriceCell2";


@interface RefundingOrderPriceCell2 : BaseTableViewCell
//1.订单编号
@property (weak, nonatomic) IBOutlet UILabel *bizOrderIdLab;
//2.退款id
@property (weak, nonatomic) IBOutlet UILabel *refundingOrderIdLab;

//3.退款金额
@property (weak, nonatomic) IBOutlet UILabel *refundFinalPriceLab;

//4.申请退款时间
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLab;

//5.同意退款时间
@property (weak, nonatomic) IBOutlet UILabel *agreeRefundingTimeLab;

//6.退款完成时间
@property (weak, nonatomic) IBOutlet UILabel *refundingFinishedTimeLab;

//7.申请退款原因
@property (weak, nonatomic) IBOutlet UILabel *applyReasonLab;

//8.退款说明
@property (weak, nonatomic) IBOutlet UILabel *refundingDesLab;

@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *imBtn;

@end
