//
//  WYTradeDetailTableViewCell.h
//  YiShangbao
//
//  Created by simon on 17/1/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"

#import "WYTradeModel.h"
#import "ZXImgIconsCollectionView.h"
#import "JLCopyLabel.h"
@interface WYTradeDetailTableViewCell : BaseTableViewCell


// 用户头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;


// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *companyLab;


@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

//求购次数
@property (weak, nonatomic) IBOutlet UILabel *numTradeLab;

//求购数量的2个约束
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numLabLeadingCompanyConstraint;

/**
 标题
 */
@property (weak, nonatomic) IBOutlet JLCopyLabel *titleLab;


//类型标识
@property (weak, nonatomic) IBOutlet UILabel *titleTypeLab;

@property (nonatomic, strong) UIButton *personalBtn;

/**
 内容
 */
@property (weak, nonatomic) IBOutlet JLCopyLabel *contentLab;






@end
