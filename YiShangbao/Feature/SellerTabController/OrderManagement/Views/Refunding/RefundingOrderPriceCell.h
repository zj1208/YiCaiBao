//
//  RefundingOrderPriceCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const nibName_RefundingOrderPriceCell = @"RefundingOrderPriceCell";

@interface RefundingOrderPriceCell : BaseTableViewCell

//退款金额
@property (weak, nonatomic) IBOutlet UILabel *refundFinalPriceLab;
//申请退款原因
@property (weak, nonatomic) IBOutlet UILabel *applyReasonLab;

//退款说明
@property (weak, nonatomic) IBOutlet UILabel *explainLab;


@property (weak, nonatomic) IBOutlet UIButton *callPhoneBtn;

@property (weak, nonatomic) IBOutlet UIButton *imBtn;

@end
