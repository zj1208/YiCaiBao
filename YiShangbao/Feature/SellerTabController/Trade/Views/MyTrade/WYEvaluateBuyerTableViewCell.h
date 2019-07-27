//
//  WYEvaluateSellerTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

extern NSString *const WYEvaluateBuyerTableViewCellID;

@interface WYEvaluateBuyerTableViewCell : UITableViewCell

@property (nonatomic, strong) NSNumber *score;
@property (nonatomic, copy) NSString *evaluateString;
- (void)updateData:(id)data;

@end
