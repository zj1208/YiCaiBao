//
//  TradeOrderedPersonalCell.h
//  YiShangbao
//
//  Created by simon on 17/1/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZXProgressView.h"
#import "RemindSpaceLayout.h"
@interface TradeOrderedPersonalCell : BaseTableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property (weak, nonatomic) IBOutlet ZXProgressView *progressView;

@property (weak, nonatomic) IBOutlet UILabel *numPersonalLab;

@property (weak, nonatomic) IBOutlet UILabel *progressLab;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet RemindSpaceLayout *flowLayout;

//@property (weak, nonatomic) IBOutlet UICollectionViewFlowLayout *flowLayout;
@end
