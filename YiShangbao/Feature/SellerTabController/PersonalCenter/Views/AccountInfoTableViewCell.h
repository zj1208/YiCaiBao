//
//  AccountInfoTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_AccountInfoTableViewCell @"AccountInfoTableViewCell"
@interface AccountInfoTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel *lbl_title;
@property(nonatomic, strong)UILabel *lbl_sub;
@property(nonatomic, strong)UIImageView *userImage;
@property(nonatomic, strong)UIImageView *image_arrow;

@end
