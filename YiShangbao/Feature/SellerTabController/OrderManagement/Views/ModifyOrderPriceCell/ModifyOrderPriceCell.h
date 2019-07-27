//
//  ModifyOrderPriceCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ModifyOrderPriceCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UITextField *transFeeTextField;

//最新价格
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

- (void)setData:(id)data withTransFee:(NSString *)transFee;
@end
