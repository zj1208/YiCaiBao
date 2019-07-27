//
//  ShopInfoBaseTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ShopInfoBaseTableViewCellID;

@interface ShopInfoBaseTableViewCell : UITableViewCell

- (void)setName:(NSString *)name value:(NSString *)value isHiddenRed:(BOOL)isShow;

@end
