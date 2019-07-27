//
//  TradeSearchDetailController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TradeSearchController.h"

@interface TradeSearchDetailController : UIViewController

@property(nonatomic, strong, nullable)TradeSearchController *searchVC;
//搜索标题
@property(nonatomic, strong)NSString* searchKeyword ;

@end
