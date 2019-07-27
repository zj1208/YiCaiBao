//
//  WYEvaluateTradeTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

extern NSString *const WYEvaluateTradeTableViewCellID;

typedef void (^HeightChangeBlock)(CGFloat height);

@interface WYEvaluateTradeTableViewCell : UITableViewCell

@property (nonatomic, copy) HeightChangeBlock heightChangeBlock;

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *evaluateString;
@property(nonatomic, strong) NSMutableArray *selectedArray;

- (void)updateData:(id)data;

@end
