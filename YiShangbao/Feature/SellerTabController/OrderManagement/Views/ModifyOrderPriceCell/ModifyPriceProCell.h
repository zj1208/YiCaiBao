//
//  ModifyPriceProCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

static NSString *const Xib_ModifyPriceProCell = @"ModifyPriceProCell";

@interface ModifyPriceProCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;

//规格文案，包含尺寸颜色
@property (weak, nonatomic) IBOutlet UILabel *skuInfoLab;

//价格
@property (weak, nonatomic) IBOutlet UILabel *priceLab;


//数量
@property (weak, nonatomic) IBOutlet UILabel *quantityLab;

@property (weak, nonatomic) IBOutlet UIButton *editBtn;
@property (weak, nonatomic) IBOutlet UITextField *nPriceTextField;
@property (weak, nonatomic) IBOutlet UILabel *nPriceLab;


@property (weak, nonatomic) IBOutlet UILabel *discountLab;


//总价
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLab;

@end
