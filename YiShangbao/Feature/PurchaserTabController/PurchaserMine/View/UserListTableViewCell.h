//
//  UserListTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_UserListTableViewCell @"UserListTableViewCell"
@interface UserListTableViewCell : UITableViewCell

@property(nonatomic, strong)UIImageView *image_icon;
@property(nonatomic, strong)UILabel *lbl_text;
@property(nonatomic, strong)UILabel *lbl_sub;
@property(nonatomic, strong)UIImageView *image_arrow;

@end
