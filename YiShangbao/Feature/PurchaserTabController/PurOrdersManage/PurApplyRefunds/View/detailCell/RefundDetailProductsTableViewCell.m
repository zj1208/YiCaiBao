//
//  RefundDetailProductsTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "RefundDetailProductsTableViewCell.h"

#import "Communicationview.h"

#import "OrderManagementDetailModel.h"

@interface RefundDetailProductsTableViewCell ()
@property(nonatomic,strong)CommunicationView * cview;

@property(nonatomic,strong)NSString* ComplaintTelephone;

@end
@implementation RefundDetailProductsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    _cview = [[[NSBundle mainBundle] loadNibNamed:@"CommunicationView" owner:self options:nil] firstObject];
    [self.commitContentView addSubview:_cview];
    
    [_cview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.commitContentView);
        make.left.mas_equalTo(self.commitContentView);
        make.right.mas_equalTo(self.commitContentView);
        make.bottom.mas_equalTo(self.commitContentView);
    }];

    
    self.productsview.cellType = SOD_ProductsRefundDetailCollectionViewCell;

}
- (IBAction)toushu:(id)sender {
    [self zx_performCallPhone:_ComplaintTelephone];
}

-(void)setCellData:(id)data
{
    
    OMRefundDetailInfoModel* model = data;
   
    self.bizOrderIdLabel.text = [NSString stringWithFormat:@"订单编号：%@",model.bizOrderId];
    self.refundIdLabel.text = [NSString stringWithFormat:@"退款编号：%@",model.iid];
    self.finalPriceLabel.text = [NSString stringWithFormat:@"退款金额：%@",model.finalPrice];
    self.applyTimeLabel.text = [NSString stringWithFormat:@"申请退款时间：%@",model.applyTime];
    if (![NSString zhIsBlankString:model.agreeTime]) {
        self.agreeTimeLabel.text = [NSString stringWithFormat:@"同意退款时间：%@",model.agreeTime];
    }
    if (![NSString zhIsBlankString:model.finishTime]) {
        self.finishTimeLabel.text = [NSString stringWithFormat:@"退款完成时间：%@",model.finishTime];
    }
    self.applyReasonLabel.text = [NSString stringWithFormat:@"退款原因：%@",model.applyReason];
    self.explainLabel.text = [NSString stringWithFormat:@"退款说明：%@",model.explain];

    [self.explainLabel jl_setAttributedText:nil withMinimumLineHeight:18.5];

    [_cview setButtonUid:model.bizOrderId buttonCall:model.buttonCall];

    _ComplaintTelephone = [NSString stringWithFormat:@"%@",model.buttonComplaint];
    [self.ComplaintTelephoneBtn setTitle: [NSString stringWithFormat:@"投诉电话：%@",model.buttonComplaint] forState:UIControlStateNormal];
    
    
}

-(CGFloat)getCellHeightWithContentData:(id)data
{
    OMRefundDetailInfoModel* model = data;
   
    CGFloat explainRectH;
    NSMutableParagraphStyle *paraStyl = [[NSMutableParagraphStyle alloc] init];
    paraStyl.lineBreakMode = _explainLabel.lineBreakMode; //单个字符换行模式
    paraStyl.minimumLineHeight = 18.5f;
    NSString *explainLabelStr =  [NSString stringWithFormat:@"退款说明：%@",model.explain];
    CGRect explainRect = [explainLabelStr boundingRectWithSize:CGSizeMake(LCDW-30, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.f],NSParagraphStyleAttributeName:paraStyl} context:nil];
    if (explainRect.size.height == 0) {
        explainRectH = 16;
    }else{
        explainRectH = explainRect.size.height+1;
    }
    
    CGFloat H = 43;
    if ([NSString zhIsBlankString:model.agreeTime]) {
        H -=21.5;
    }
    if ([NSString zhIsBlankString:model.finishTime]) {
        H -=21.5;
    }
    [self.refundTimecontentview mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(232-43+H-16+explainRectH);
    }];
    [self.explainLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(explainRectH);
    }];
   
    
    return 505 +(-43+H)+(-16+explainRectH)+(-140.5+[self.productsview getCellHeightWithContentData:model.subBizOrders]);

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
