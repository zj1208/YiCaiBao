//
//  OrderCellFooterView.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  订单管理列表组尾

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"

#import "ZXLabelsTagsView.h"



@interface OrderCellFooterView : UITableViewHeaderFooterView<SetDataProtoct>

@property (weak, nonatomic) IBOutlet UIView *moreContainerView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;



@property (weak, nonatomic) IBOutlet UIView *totalPriceContainerView;

//（含运费Y21.00）
@property (weak, nonatomic) IBOutlet UILabel *transFeeLab;
//最终价格
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLab;

//几件商品描述
@property (weak, nonatomic) IBOutlet UILabel *numProDesLab;

//外部容器
@property (weak, nonatomic) IBOutlet UIView *labelTagsContainerView;

@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;
@end
