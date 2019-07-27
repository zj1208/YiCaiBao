//
//  SWButtonsTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/6/25.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const SWButtonsTableViewCellID;

@interface SWButtonsTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *protocolButton;//查看协议
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;//确认授权
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;//暂不授权

@end
