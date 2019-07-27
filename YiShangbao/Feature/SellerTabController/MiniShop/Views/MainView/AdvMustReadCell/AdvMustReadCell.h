//
//  AdvMustReadCell.h
//  YiShangbao
//
//  Created by simon on 2017/12/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  在用

#import "BaseCollectionViewCell.h"
#import "JLCycleScrollerView.h"



@interface AdvMustReadCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *dotImageView;

@property (weak, nonatomic) IBOutlet UILabel *briefLab;

@property (weak, nonatomic) IBOutlet JLCycleScrollerView *cycleTitleView;

@end
