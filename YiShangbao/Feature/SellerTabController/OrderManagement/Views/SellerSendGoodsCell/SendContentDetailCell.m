//
//  SendContentDetailCell.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SendContentDetailCell.h"

@implementation SendContentDetailCell

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)awakeFromNib
{
    [super awakeFromNib];
    self.trackingNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"填写运单号码" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(142.f, 142.f, 142.f)}];
    self.logisticsCompanyTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入物流公司名称" attributes:@{NSForegroundColorAttributeName:UIColorFromRGB(142.f, 142.f, 142.f)}];
  
    self.trackingNumberTextField.delegate = self;
    self.logisticsCompanyTextField.delegate = self;
//    [self.logisticsCompanyTextField zx_setCornerRadius:CGRectGetHeight(self.logisticsCompanyTextField.frame)/2 borderWidth:0.5 borderColor:UIColorFromRGB(225.f, 225.f, 225.f)];
//    [self.trackingNumberTextField zx_setCornerRadius:CGRectGetHeight(self.logisticsCompanyTextField.frame)/2 borderWidth:0.5 borderColor:UIColorFromRGB(225.f, 225.f, 225.f)];
}

- (void)setLogisticsCompanay:(NSString *)company trackingNumber:(NSString *)trackingNumber
{
    self.logisticsCompanyTextField.text = company;
    self.trackingNumberTextField.text = trackingNumber;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.logisticsCompanyTextField])
    {
        return [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:20 remainTextNum:^(NSInteger remainLength) {
            
        }];

    }
    if ([textField isEqual:self.trackingNumberTextField])
    {
        return [UITextField zx_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:25 remainTextNum:^(NSInteger remainLength) {
            
        }];
    }
    
    return YES;
}

@end
