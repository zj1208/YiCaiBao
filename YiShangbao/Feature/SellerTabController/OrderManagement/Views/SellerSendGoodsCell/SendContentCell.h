//
//  SendContentCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface SendContentCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *sendGoodTypeBtn;
@property (weak, nonatomic) IBOutlet UITextField *sendGoodTypeTextField;



- (void)setSendGoodType:(NSNumber *)sendType;
@end
