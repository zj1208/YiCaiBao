//
//  MakeBillBaseCell.h
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const MakeBillBaseCellID;

@interface MakeBillBaseCell : UITableViewCell

- (void)updateName:(NSString *)name value:(NSString *)value defaultString:(NSString *)defaultString;

@end
