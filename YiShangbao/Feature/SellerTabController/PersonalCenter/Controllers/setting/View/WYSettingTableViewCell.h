//
//  WYSettingTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/10/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
extern NSString *const WYSettingTableViewCellID;

@interface WYSettingTableViewCell : UITableViewCell

- (void)updataName:(NSString *)name showArrow:(BOOL)show;
- (void)updataName:(NSString *)name content:(NSString *)content showArrow:(BOOL)show;

@end
