//
//  MakeBillRemarkCell.h
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXPlaceholdTextView.h"

extern NSString *const MakeBillRemarkCellID;

@interface MakeBillRemarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *remarkTextView;

@end
