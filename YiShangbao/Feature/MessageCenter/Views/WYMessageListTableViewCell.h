//
//  WYMessageListTableViewCell.h
//  YiShangbao
//
//  Created by Lance on 16/12/16.
//  Copyright © 2016年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageModel.h"

@interface WYMessageListTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *serviceImageView;
@property (weak, nonatomic) IBOutlet UILabel *messageNub;
@property (weak, nonatomic) IBOutlet UILabel *dotNumLab;

@property (weak, nonatomic) IBOutlet UILabel *messageTitle;
@property (weak, nonatomic) IBOutlet UILabel *messageDetail;

@property (weak, nonatomic) IBOutlet UILabel *messageTime;
@end
