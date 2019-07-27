//
//  BankAccountListTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"
#define kCellIdentifier_BankAccountListTableViewCell @"BankAccountListTableViewCell"
@interface BankAccountListTableViewCell : UITableViewCell
@property(nonatomic, strong)UIImageView *bank_bg;
@property(nonatomic, strong)UIImageView *image_icon;
@property(nonatomic, strong)UIImageView *icon_bg;
@property(nonatomic, strong)UILabel *lbl_bankName;
@property(nonatomic, strong)UILabel *lbl_openName;
@property(nonatomic, strong)UILabel *lbl_bankInfo;

-(void)setData:(AcctInfoModel *)data;
@end
