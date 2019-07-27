//
//  WYMessageDetailTableViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/7/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "MessageModel.h"
#import "FLAnimatedImageView.h"

@interface WYMessageDetailTableViewCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *topTimeLab;

@property (weak, nonatomic) IBOutlet UIView *imageBgView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@property (weak, nonatomic) IBOutlet UILabel *descLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
// 阅读全文
@property (weak, nonatomic) IBOutlet UILabel *promtLab;

@property (weak, nonatomic) IBOutlet UIView *containerView;
@end
