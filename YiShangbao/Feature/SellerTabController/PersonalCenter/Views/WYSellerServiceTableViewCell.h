//
//  WYSellerServiceTableViewCell.h
//  YiShangbao
//
//  Created by light on 2018/1/31.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZXHorizontalPageCollectionView.h"

extern NSString * const WYSellerServiceTableViewCellID;

@interface WYSellerServiceTableViewCell : BaseTableViewCell

@property (nonatomic, strong) ZXHorizontalPageCollectionView *itemPageView;

@end
