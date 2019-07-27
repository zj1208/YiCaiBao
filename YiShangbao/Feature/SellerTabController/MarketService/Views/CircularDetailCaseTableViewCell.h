//
//  CircularDetailCaseTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_CircularDetailCaseTableViewCell @"CircularDetailCaseTableViewCell"
@interface CircularDetailCaseTableViewCell : UITableViewCell

@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *content;
@property(nonatomic, strong) UIView *line;
- (float)getAutoCellHeight:(BOOL)selected;
- (float)getEditAutoCellHeight;
@end
