//
//  TradeDetailRowCell.h
//  YiShangbao
//
//  Created by simon on 17/4/12.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface TradeDetailRowCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UILabel *textLab;


@property (weak, nonatomic) IBOutlet UILabel *detailLab;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineViewleftLeadingLayout;

@property (nonatomic ,strong) UIView *lengthLineView;
/**
 交货时间
 */
/**
 采购量
 */
////发布时间
//@property (weak, nonatomic) IBOutlet UILabel *inputTimeLab;

@end
