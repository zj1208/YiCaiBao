//
//  WYSurveyResultTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/28.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SurveyModel.h"
#define kCellIdentifier_WYSurveyResultTableViewCell @"WYSurveyResultTableViewCell"
@interface WYSurveyResultTableViewCell : UITableViewCell
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *labelTip;
@property(nonatomic, strong) UIImageView *icon;
@property(nonatomic, strong) UILabel *address;
@property(nonatomic, strong) UIImageView *arrow;

-(void)setData:(id)data;
@end
