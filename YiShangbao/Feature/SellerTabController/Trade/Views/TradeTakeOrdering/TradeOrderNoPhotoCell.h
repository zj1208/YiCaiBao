//
//  TradeOrderNoPhotoCell.h
//  YiShangbao
//
//  Created by simon on 17/1/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "ZXAddPicCollectionView.h"

@interface TradeOrderNoPhotoCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

@property (nonatomic, strong) ZXAddPicCollectionView *picsCollectionView;

@property (weak, nonatomic) IBOutlet UIButton *picBtn;

@end
