//
//  CommonTradePersonalCell.h
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ProductModel.h"
#import "ZXImgIconsCollectionView.h"

static NSString *Xib_CommonTradePersonalCell = @"CommonTradePersonalCell";

@interface CommonTradePersonalCell : BaseTableViewCell

// 用户头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;


// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;


/**
 标题
 */
//@property (weak, nonatomic) IBOutlet UILabel *titleLab;


@end
