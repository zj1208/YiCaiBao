//
//  OrderCellHeaderView.m
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "OrderCellHeaderView.h"

@implementation OrderCellHeaderView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)awakeFromNib
{
    [super awakeFromNib];
    if ([WYUserDefaultManager getUserTargetRoleType] ==WYTargetRoleType_buyer)
    {
        self.orderStatuLab.textColor =UIColorFromRGB(245.f, 143.f, 35.f);
    }
    else
    {
        self.orderStatuLab.textColor = UIColorFromRGB(255.f, 84.f, 52.f);
    }
}

- (void)setData:(id)data
{
    GetOrderManagerModel *model = (GetOrderManagerModel *)data;
    [self.shopNameBtn setTitle:model.entityName forState:UIControlStateNormal];
    
    self.orderStatuLab.text = model.statusV;
}
@end
