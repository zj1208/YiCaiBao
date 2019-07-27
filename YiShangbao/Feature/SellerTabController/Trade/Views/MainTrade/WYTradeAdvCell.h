//
//  WYTradeAdvCell.h
//  YiShangbao
//
//  Created by simon on 17/6/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FLAnimatedImageView.h"

@interface WYTradeAdvCell : BaseTableViewCell

// 用户头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;

// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

// 内容
@property (weak, nonatomic) IBOutlet UILabel *contentLab;

// 动态图的容器
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;
@property (weak, nonatomic) IBOutlet FLAnimatedImageView *advImageView;

@property (weak, nonatomic) IBOutlet UILabel *advIconLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *advIconLabWidthLayout;
@end
