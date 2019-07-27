//
//  MyTradeFinishedTVCell.h
//  YiShangbao
//
//  Created by simon on 17/1/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "FMLStarView.h"
#import "ZXImgIconsCollectionView.h"

@interface MyTradeFinishedTVCell : BaseTableViewCell

@property (weak, nonatomic) IBOutlet UIButton *headBtn;


@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;



@property (weak, nonatomic) IBOutlet UILabel *titleLab;
//类型标识
@property (weak, nonatomic) IBOutlet UILabel *titleTypeLab;


@property (weak, nonatomic) IBOutlet UILabel *contentLab;
@property (weak, nonatomic) IBOutlet UIView *lineView;

//
@property (weak, nonatomic) IBOutlet UILabel *isLookedLab;

@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

/**
 立即评价
 */
@property (weak, nonatomic) IBOutlet UIButton *evaluateBtn;


/**
 已评价
 */
@property (weak, nonatomic) IBOutlet UIButton *evaluatedBtn;

///**
// 几分
// */
//@property (weak, nonatomic) IBOutlet UILabel *starLevelLab;

/**
 星级
 */
@property (weak, nonatomic) IBOutlet UIView *starContainerView;


@property (nonatomic,strong) FMLStarView *starView;
@end
