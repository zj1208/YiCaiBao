//
//  TradeDetailSecondCell.h
//  YiShangbao
//
//  Created by simon on 2017/10/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TradeDetailSecondCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *needCountLab;

@property (weak, nonatomic) IBOutlet UILabel *deliveryTimeLab;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@end
