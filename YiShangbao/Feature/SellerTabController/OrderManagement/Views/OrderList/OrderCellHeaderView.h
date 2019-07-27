//
//  OrderCellHeaderView.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetDataProtocol.h"



@interface OrderCellHeaderView : UITableViewHeaderFooterView<SetDataProtoct>

@property (weak, nonatomic) IBOutlet UIButton *shopNameBtn;

@property (weak, nonatomic) IBOutlet UILabel *orderStatuLab;



@end
