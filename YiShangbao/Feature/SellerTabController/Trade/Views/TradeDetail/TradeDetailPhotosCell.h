//
//  TradeDetailPhotosCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"


#import "ZXPhotosView.h"
#import "WYTradeModel.h"

@interface TradeDetailPhotosCell : BaseTableViewCell

/**
 动态图的容器
 */
@property (weak, nonatomic) IBOutlet UIView *photoContainerView;

@property (nonatomic, weak) ZXPhotosView *photosView;


- (CGFloat)getCellHeightWithContentData:(id)data;
@end
