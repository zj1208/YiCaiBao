//
//  TradeDetailOtherReplyCell.h
//  YiShangbao
//
//  Created by simon on 17/4/13.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZXImgIconsCollectionView.h"


@interface TradeDetailOtherReplyCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headBtn;
@property (weak, nonatomic) IBOutlet UILabel *shopNameLab;
@property (weak, nonatomic) IBOutlet UILabel *bidTimesLab;



@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;
@end
