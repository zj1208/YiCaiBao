//
//  WYChoosePayWayTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/9/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WYChoosePayWayTableViewCellID;

@interface WYChoosePayWayTableViewCell : UITableViewCell

@property (nonatomic) BOOL isRedHook;

- (void)updateData:(id)model;

- (void)isSelect:(BOOL)isSelect;

@end
