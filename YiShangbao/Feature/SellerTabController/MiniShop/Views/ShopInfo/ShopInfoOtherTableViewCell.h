//
//  ShopInfoOtherTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const ShopInfoOtherTableViewCellID;

@interface ShopInfoOtherTableViewCell : UITableViewCell

- (void)updateName:(NSString *)name content:(NSString *)content score:(NSString *)score icons:(NSArray *)icons;

@end
