//
//  WYCaseTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/20.
//  Copyright © 2016年 com.Microants. All rights reserved.
//  还用吗？

#import <UIKit/UIKit.h>
#define kCellIdentifier_WYCaseTableViewCell @"WYCaseTableViewCell"
@interface WYCaseTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image_view;
@property (nonatomic, strong) UILabel *lbl_title;
@property (nonatomic, strong) UILabel *lbl_date;

-(void)setData:(id)data;

@end
