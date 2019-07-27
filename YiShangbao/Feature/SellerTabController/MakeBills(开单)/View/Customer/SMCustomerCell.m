//
//  SMCustomerCell.m
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "SMCustomerCell.h"
#import "SMCustomerModel.h"

@implementation SMCustomerCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (void)setData:(id)data
{
    SMCustomerSubModel *model = data;
    self.companyNameLabel.text = model.companyName;
    self.contactLabel.text = model.contact;
    self.mobileLabel.text = model.mobile;
    if ([model.contact isEqualToString:@""]) {
        self.companyTop.constant = 24;
    }else{
        self.companyTop.constant = 10;
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
    self.iconBtn.selected = selected;

}
-(void)setHighlighted:(BOOL)highlighted animated:(BOOL)animated
{
    [super setHighlighted:highlighted animated:animated];
    self.iconBtn.selected = highlighted;

}
@end
