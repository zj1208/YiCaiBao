//
//  SellingProductController.h
//  YiShangbao
//
//  Created by simon on 17/2/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SellingProductController : UITableViewController


- (void)updateData:(id)notification;

/**
 筛选产品
 
 onlyMain 是否只查询主营，非空表示是    onlyMain=true 2018.4.8
 direction 1-修改时间升序 -1-修改时间降序 默认-1    -1 2018.4.8
 
 YES = 1,NO = -1,默认NO;
 */

@property(nonatomic,assign)BOOL onlyMain;
@property(nonatomic,assign)BOOL direction;

@end

