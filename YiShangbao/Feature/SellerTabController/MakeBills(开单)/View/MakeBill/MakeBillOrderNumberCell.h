//
//  MakeBillOrderNumberCell.h
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MakeBillOrderNumberCellID;

@interface MakeBillOrderNumberCell : UITableViewCell

- (void)updateData:(NSString *)orderNumber;

@end
