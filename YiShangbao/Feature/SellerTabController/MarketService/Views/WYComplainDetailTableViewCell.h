//
//  WYComplainDetailTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_WYComplainDetailTableViewCell @"WYComplainDetailTableViewCell"
@interface WYComplainDetailTableViewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *content;
@property(nonatomic, strong) UILabel *date;

- (float)getAutoCellHeight;
@end
