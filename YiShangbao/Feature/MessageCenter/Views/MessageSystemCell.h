//
//  MessageSystemCell.h
//  YiShangbao
//
//  Created by simon on 2017/12/25.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageModel.h"

@interface MessageSystemCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *topTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;


@property (weak, nonatomic) IBOutlet UIView *containerView;

@end
