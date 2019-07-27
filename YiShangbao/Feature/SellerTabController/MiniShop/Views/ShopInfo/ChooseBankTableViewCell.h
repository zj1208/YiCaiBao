//
//  ChooseBankTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShopModel.h"

#define kCellIdentifier_ChooseBankTableViewCell @"ChooseBankTableViewCell"
@interface ChooseBankTableViewCell : UITableViewCell

@property (nonatomic, strong)UIImageView *image_view;
@property (nonatomic, strong)UILabel *lbl_title;

-(void)setData:(BankModel *)data;
@end
