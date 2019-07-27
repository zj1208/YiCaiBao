//
//  FreightListTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const FreightListTableViewCellID;

@interface FreightListTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *detailButton;
- (void)updateModel:(id)model;
- (void)selectedCell;

@end
