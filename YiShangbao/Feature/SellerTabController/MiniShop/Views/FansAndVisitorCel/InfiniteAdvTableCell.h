//
//  InfiniteAdvTableCell.h
//  YiShangbao
//
//  Created by simon on 2018/3/19.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "JLCycleScrollerView.h"

@interface InfiniteAdvTableCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet JLCycleScrollerView *infiniteView;

@end

/*
UINib *nib =[UINib nibWithNibName:NSStringFromClass([InfiniteAdvTableCell class]) bundle:nil];
[self.tableView registerNib:nib forCellReuseIdentifier:reuse_infiniteScrollView];
*/
