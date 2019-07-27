//
//  RecentlyFindLabCell.h
//  YiShangbao
//
//  Created by simon on 17/2/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  最近在找的产品

#import "BaseTableViewCell.h"
#import "ZXLabelsTagsView.h"


@interface RecentlyFindLabCell : BaseTableViewCell<ZXLabelsTagsViewDelegate>


@property (weak, nonatomic) IBOutlet ZXLabelsTagsView *labelsTagsView;


@end
