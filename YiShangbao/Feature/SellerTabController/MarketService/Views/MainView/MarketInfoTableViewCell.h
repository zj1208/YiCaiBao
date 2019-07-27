//
//  MarketInfoTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  还用吗？

#import <UIKit/UIKit.h>
#define kCellIdentifier_MarketInfoTableViewCell @"MarketInfoTableViewCell"
@interface MarketInfoTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image_view;
@property (nonatomic, strong) UILabel *lbl_title;
@property (nonatomic, strong) UILabel *lbl_date;

-(void)setData:(id)data;

@end
