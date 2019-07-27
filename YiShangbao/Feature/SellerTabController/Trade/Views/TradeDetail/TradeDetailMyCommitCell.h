//
//  TradeDetailMyCommitCell.h
//  YiShangbao
//
//  Created by simon on 17/1/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "TradeDetailMyCommitCell.h"
#import "ZXPhotosView.h"
#import "JLCopyLabel.h"

@interface TradeDetailMyCommitCell : BaseTableViewCell

@property (nonatomic,strong) ZXPhotosView *photosView;


/**
 回复时间 
 */
@property (weak, nonatomic) IBOutlet UILabel *replyTimeLab;
/**
 是否现货，卖货的类型
 */
@property (weak, nonatomic) IBOutlet UILabel *sellGoodsTypeLab;
/**
 商品单价
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsPriceLab;

/**
 起订量
 */
@property (weak, nonatomic) IBOutlet UILabel *orderCountBegainLab;

/**
 回复内容
 */

@property (weak, nonatomic) IBOutlet JLCopyLabel *contentLab;
/**
 回复的图片
 */
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;


/**
 回复内容容器
 */
@property (weak, nonatomic) IBOutlet UIView *contentContainerView;

/**
 起订量容器
 */
@property (weak, nonatomic) IBOutlet UIView *orderBegainContainerView;


@property (weak, nonatomic) IBOutlet UIView *autolabeltopView;

@property (weak, nonatomic) IBOutlet UIView *autophotoview;
@end


