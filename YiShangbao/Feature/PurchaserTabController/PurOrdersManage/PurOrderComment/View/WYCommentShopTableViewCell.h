//
//  WYCommentShopTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JLStartView.h"

@class WYCommentShopTableViewCell;
@protocol WYCommentShopTableViewCellDelegate <NSObject>

-(void)jl_WYCommentShopTableViewCell:(WYCommentShopTableViewCell*)cell serviceStart:(NSString*)serviceStart  velocityStart:(NSString*)velocityStart;

@end

@interface WYCommentShopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet JLStartView *servicestartView;
@property (weak, nonatomic) IBOutlet JLStartView *velocityStartView;

@property (weak, nonatomic) IBOutlet UILabel *startServiceDescLabel;
@property (weak, nonatomic) IBOutlet UILabel *startVelocDescLabel;


@property(nonatomic,weak)id<WYCommentShopTableViewCellDelegate>delegate;

@property (strong, nonatomic)NSArray *startTitleList;

@end
