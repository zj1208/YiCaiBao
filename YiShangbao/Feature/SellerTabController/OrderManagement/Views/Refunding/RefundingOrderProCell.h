//
//  RefundingOrderProCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  退款详情页面-退款产品部分

#import "BaseTableViewCell.h"


static NSString *const nibName_RefundingOrderProCell = @"RefundingOrderProCell";


@interface RefundingOrderProCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

//产品名称
@property (weak, nonatomic) IBOutlet UILabel *productNameLab;

//规格文案，包含尺寸颜色
@property (weak, nonatomic) IBOutlet UILabel *skuInfoLab;

@end
