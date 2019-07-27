//
//  CircularDetailPersonTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Info_showView :UIView
@property(nonatomic, strong) UILabel *title;
@property(nonatomic, strong) UILabel *content;
@property(nonatomic, strong) UIView *line;
@end

#define kCellIdentifier_CircularDetailPersonTableViewCell @"CircularDetailPersonTableViewCell"
@interface CircularDetailPersonTableViewCell : UITableViewCell
@property(nonatomic, strong) UIImageView *personImage;
@property(nonatomic, strong) Info_showView *personName;
@property(nonatomic, strong) Info_showView *personNation;
@property(nonatomic, strong) Info_showView *personDuty;
@property(nonatomic, strong) Info_showView *personIDNumber;
-(void)setData:(id)data;
@end
