//
//  WYFeedbackTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//  反馈

#import <UIKit/UIKit.h>
#define kCellIdentifier_WYFeedbackTableViewCell @"WYFeedbackTableViewCell"
@interface WYFeedbackTableViewCell : UITableViewCell

@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *content;

- (float)getAutoCellHeight;
@end
