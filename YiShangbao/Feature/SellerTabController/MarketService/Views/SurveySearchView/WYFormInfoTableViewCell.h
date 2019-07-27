//
//  WYFormInfoTableViewCell.h
//  YiShangbao
//
//  Created by 何可 on 2016/12/26.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kCellIdentifier_WYFormInfoTableViewCell @"WYFormInfoTableViewCell"


@interface WYFormInfoTableViewCell : UITableViewCell

@property(nonatomic, strong)UILabel *title;
@property(nonatomic, strong)UILabel *content;

-(float)getAutoCellHeight;

@end
