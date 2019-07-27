//
//  WYODProductTableViewCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//-------产品列表

#import "WYODProductTableViewCell.h"
#import "CommunicationView.h"

#import "OrderManagementDetailModel.h"

@interface WYODProductTableViewCell ()
@property(nonatomic,strong)CommunicationView * cview;
@end
@implementation WYODProductTableViewCell

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
    
    if ([WYUserDefaultManager getUserTargetRoleType] == WYTargetRoleType_seller) { //2买家图片 4卖家图片
        self.shijifukuanlabel.textColor = [WYUISTYLE colorWithHexString:@"FF5434"];
    }else{
        self.shijifukuanlabel.textColor = [WYUISTYLE colorWithHexString:@"F58F23"];
    }
}

-(void)setCellData:(id)data
{
    OrderManagementDetailModel* model = data;
    
    self.shopnameLabel.text = model.entityName;
    self.shangpinzongjiaLabel.text = model.prodsPrice;
    self.yunfeiLabel.text = model.transFee;
    self.dingdanzongjiaLabel.text = model.orderFee;
    self.shijifukuanlabel.text = model.finalPrice;

    [_cview setButtonUid:model.bizOrderId buttonCall:model.buttonCall];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
