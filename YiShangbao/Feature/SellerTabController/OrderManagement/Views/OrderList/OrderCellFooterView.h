//
//  OrderCellFooterView.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  订单管理列表组尾= 1.更多按钮展示容器+2.价格展示容器+3.动态个数操作按钮容器 + 4.底下留下10个间距空间；

//  动态展示高度，根据字段是否展示更多按钮容器view；

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"

#import "ZXLabelsTagsView.h"



@interface OrderCellFooterView : UITableViewHeaderFooterView<SetDataProtoct>

///1.更多按钮展示容器
@property (weak, nonatomic) IBOutlet UIView *moreContainerView;

@property (weak, nonatomic) IBOutlet UIButton *moreBtn;


///2.价格展示容器
@property (weak, nonatomic) IBOutlet UIView *totalPriceContainerView;

//（含运费Y21.00）
@property (weak, nonatomic) IBOutlet UILabel *transFeeLab;
//最终价格
@property (weak, nonatomic) IBOutlet UILabel *finalPriceLab;

//几件商品描述
@property (weak, nonatomic) IBOutlet UILabel *numProDesLab;

///3.动态个数操作按钮容器
@property (weak, nonatomic) IBOutlet UIView *labelTagsContainerView;

@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;
@end
