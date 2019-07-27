//
//  HeaderPicsViewCell.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZXAddPicCollectionView.h"



@interface HeaderPicsViewCell : BaseTableViewCell


@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (nonatomic, strong) ZXAddPicCollectionView *picsCollectionView;

@end
