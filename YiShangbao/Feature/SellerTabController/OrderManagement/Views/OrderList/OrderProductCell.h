//
//  OrderProductCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"


@interface OrderProductCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;

//规格文案，包含尺寸颜色
@property (weak, nonatomic) IBOutlet UILabel *skuInfoLab;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLab;

//最终价格
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLab;

//数量
@property (weak, nonatomic) IBOutlet UILabel *quantityLab;

//退款中
@property (weak, nonatomic) IBOutlet UILabel *refundingLab;


@end
