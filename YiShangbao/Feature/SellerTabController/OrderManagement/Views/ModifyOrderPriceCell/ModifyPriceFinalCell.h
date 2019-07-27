//
//  ModifyPriceFinalCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface ModifyPriceFinalCell : BaseTableViewCell

//原价
@property (weak, nonatomic) IBOutlet UILabel *prodsPriceLab;

//运费
@property (weak, nonatomic) IBOutlet UILabel *transFeeLab;

//折扣
@property (weak, nonatomic) IBOutlet UILabel *discountLab;

//总额
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLab;
@end
