//
//  CircularListTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_CircularListTableViewCell @"CircularListTableViewCell"
@interface CircularListTableViewCell : UITableViewCell
@property(nonatomic, strong)UILabel *lbl_title;
@property(nonatomic, strong)UILabel *lbl_time;
-(void)setData:(id)data;
@end
