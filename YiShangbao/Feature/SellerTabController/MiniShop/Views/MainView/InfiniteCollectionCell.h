//
//  InfiniteCollectionCell.h
//  YiShangbao
//
//  Created by simon on 17/3/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "JLCycleScrollerView.h"

@interface InfiniteCollectionCell : BaseCollectionViewCell

@property (weak, nonatomic) IBOutlet JLCycleScrollerView *infiniteView;

@end
