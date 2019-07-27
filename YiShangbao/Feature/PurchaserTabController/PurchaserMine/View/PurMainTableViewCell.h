//
//  PurMainTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_PurMainTableViewCell @"PurMainTableViewCell"
@interface PurMainTableViewCell : UITableViewCell

@property(nonatomic, strong)UIView *viewbg;
@property(nonatomic, strong)UIImageView *imageHead;
@property(nonatomic, strong)UIButton *btn;
@property(nonatomic, strong)UIImageView *imageLogo1;
@property(nonatomic, strong)UIImageView *imageLogo2;
@property(nonatomic, strong)UIImageView *imageLogo3;
@property(nonatomic, strong)UILabel *labelName;
@property(nonatomic, strong)UIImageView *imageicon;
@property(nonatomic, strong)UILabel *labelIntr;
@property(nonatomic, strong)UIView *viewLine;
@property(nonatomic, strong)UIButton *attentionBtn;
@property(nonatomic, strong)UIButton *collectBtn;

@end
