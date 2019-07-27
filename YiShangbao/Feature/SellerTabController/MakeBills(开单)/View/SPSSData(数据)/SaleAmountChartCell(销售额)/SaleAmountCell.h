//
//  SaleAmountCell.h
//  YiShangbao
//
//  Created by simon on 2018/1/11.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SaleAmountCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateLab;

@property (weak, nonatomic) IBOutlet UILabel *totalFeeLab;

@property (weak, nonatomic) IBOutlet UILabel *maxAmountLab;
@end
