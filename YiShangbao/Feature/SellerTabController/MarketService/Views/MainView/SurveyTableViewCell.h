//
//  SurveyTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_SurveyTableViewCell @"SurveyTableViewCell"
@interface SurveyTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *image_searchLogo;

@property (nonatomic, strong) UIView *searchBarBg;
@property (nonatomic, strong) UIImageView *searchImg;
@property (nonatomic, strong) UILabel *searchText;
@property (nonatomic, strong) UIButton *searchBtn;

@end
