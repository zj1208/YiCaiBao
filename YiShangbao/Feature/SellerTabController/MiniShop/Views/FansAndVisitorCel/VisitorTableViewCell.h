//
//  VisitorTableViewCell.h
//  YiShangbao
//
//  Created by simon on 17/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "ZXImgIconsCollectionView.h"

@interface VisitorTableViewCell : BaseTableViewCell


// 用户头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;


// 昵称
@property (weak, nonatomic) IBOutlet UILabel *nickNameLab;

// 公司名字
@property (weak, nonatomic) IBOutlet UILabel *companyLab;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;




@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@end
