//
//  MakeBillPicsTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/4.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXAddPicCollectionView.h"

extern NSString *const MakeBillPicsTableViewCellID;

@interface MakeBillPicsTableViewCell : UITableViewCell

@property (nonatomic, strong)ZXAddPicCollectionView *picsCollectionView;

- (void)setData:(id)data;

@end
