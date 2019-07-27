//
//  BuyerInfoContentCell.h
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

@interface BuyerInfoContentCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *cityLab;

@property (weak, nonatomic) IBOutlet UILabel *productNameLab;

// 来源
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
// 来源
@property (weak, nonatomic) IBOutlet UIView *sourceContainerView;

@property (weak, nonatomic) IBOutlet UILabel *briefLab;

@end
