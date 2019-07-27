//
//  HeaderCollectionCell.h
//  YiShangbao
//
//  Created by simon on 17/3/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  弃用

#import "BaseCollectionViewCell.h"
#import "ZXProgressView.h"
#import "ProductModel.h"
#import "ZXBadgeView.h"
#import "MessageModel.h"
#import "ZXImgIconsCollectionView.h"

@interface HeaderCollectionCell : BaseCollectionViewCell
//顶部背景
@property (weak, nonatomic) IBOutlet UIImageView *topContainerView;


@property (weak, nonatomic) IBOutlet UIView *cardContainerView;

// 头像容器view
@property (weak, nonatomic) IBOutlet UIView *headContainerView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 公司名
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;

// 图标容器view
@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

//@property (weak, nonatomic) IBOutlet ZXProgressView *progressView;
//@property (weak, nonatomic) IBOutlet UILabel *progressLab;
//
//@property (weak, nonatomic) IBOutlet UIButton *updateInfomationBtn;

//@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//编辑按钮
@property (weak, nonatomic) IBOutlet UIButton *editInfomationBtn;
//二维码按钮
@property (weak, nonatomic) IBOutlet UIButton *erWeiMaBtn;

@property (weak, nonatomic) IBOutlet UILabel *erWeiMaLab;

@property (weak, nonatomic) IBOutlet UIImageView *isNewErWeiMaView;


//粉丝访客容器view
@property (weak, nonatomic) IBOutlet UIView *btnContainerView;


@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *visitorLab;

@property (weak, nonatomic) IBOutlet UILabel *fansNumLab;
@property (weak, nonatomic) IBOutlet UILabel *visitorNumLab;

@property (weak, nonatomic) IBOutlet ZXBadgeView *vistitorIsNewImgView;

@property (weak, nonatomic) IBOutlet UIImageView *fansIsNewImgView;

//广告按钮
@property (weak, nonatomic) IBOutlet UIButton *advBtn;

- (void)setNewFansOrVisitor:(BOOL)isNewFans visitor:(BOOL)isNewVisitor;

- (void)setRightAdvData:(advArrModel *)model;

@end
