//
//  SendContentDetailCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendContentDetailCell : BaseTableViewCell<UITextFieldDelegate>


//物流公司
@property (weak, nonatomic) IBOutlet UITextField *logisticsCompanyTextField;
//运单号码
@property (weak, nonatomic) IBOutlet UITextField *trackingNumberTextField;


- (void)setLogisticsCompanay:(NSString *)company trackingNumber:(NSString *)trackingNumber;
@end
