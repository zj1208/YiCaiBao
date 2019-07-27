//
//  RefundingContentCell.h
//  YiShangbao
//
//  Created by simon on 2017/9/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  退款-顶部UI

#import "BaseTableViewCell.h"
#import "OrderManagementDetailModel.h"

#import "ZXLabelsTagsView.h"


@interface RefundingContentCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *statusIconImgView;

@property (weak, nonatomic) IBOutlet UILabel *statusDespLab;

@property (weak, nonatomic) IBOutlet UILabel *statusTimeAboutLab;

@property (weak, nonatomic) IBOutlet UILabel *reminder1Lab;
@property (weak, nonatomic) IBOutlet UILabel *reminder2Lab;

@property (weak, nonatomic) IBOutlet UIView *btnContainerView;

@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;

@end
