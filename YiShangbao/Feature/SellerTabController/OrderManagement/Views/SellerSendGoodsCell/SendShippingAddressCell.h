//
//  SendShippingAddressCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendShippingAddressCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;

@property (weak, nonatomic) IBOutlet UILabel *receiverNameLab;

@property (weak, nonatomic) IBOutlet UILabel *receiverAddressLab;

@end
