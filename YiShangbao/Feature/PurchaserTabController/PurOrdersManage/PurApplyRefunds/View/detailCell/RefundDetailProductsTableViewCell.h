//
//  RefundDetailProductsTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SODProductsView.h"

@interface RefundDetailProductsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *bizOrderIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *refundIdLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *agreeTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *finishTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *applyReasonLabel;
@property (weak, nonatomic) IBOutlet UIView *refundTimecontentview;

@property (weak, nonatomic) IBOutlet UILabel *explainLabel;

@property (weak, nonatomic) IBOutlet UIView *commitContentView;
@property (weak, nonatomic) IBOutlet UIButton *ComplaintTelephoneBtn;

@property (weak, nonatomic) IBOutlet SODProductsView *productsview;

-(void)setCellData:(id)data;

-(CGFloat)getCellHeightWithContentData:(id)data;
@end
