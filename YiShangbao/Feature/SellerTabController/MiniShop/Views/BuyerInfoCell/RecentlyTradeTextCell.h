//
//  RecentlyTradeTextCell.h
//  YiShangbao
//
//  Created by simon on 17/2/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  最近发布的生意

#import "BaseTableViewCell.h"

#import "ProductModel.h"

@interface RecentlyTradeTextCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
