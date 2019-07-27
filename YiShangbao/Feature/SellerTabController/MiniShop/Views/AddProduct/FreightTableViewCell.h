//
//  FreightTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/4/24.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const FreightTableViewCellID;

@interface FreightTableViewCell : UITableViewCell

- (void)setTitleString:(NSString *)titleString;
- (void)setTitleString:(NSString *)titleString contentString:(NSString *)contentString;

- (void)selectedCell;

@end
