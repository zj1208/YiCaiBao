//
//  HeaderCollectionCell2.h
//  YiShangbao
//
//  Created by simon on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseCollectionViewCell.h"
#import "ZXProgressView.h"
#import "ProductModel.h"
#import "ZXBadgeView.h"
#import "MessageModel.h"
#import "ZXImgIconsCollectionView.h"

@interface HeaderCollectionCell2 : BaseCollectionViewCell
//顶部背景
@property (weak, nonatomic) IBOutlet UIImageView *topContainerView;


@property (weak, nonatomic) IBOutlet UIView *cardContainerView;

// 头像容器view
@property (weak, nonatomic) IBOutlet UIView *headContainerView;
// 头像
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;

// 公司名
@property (weak, nonatomic) IBOutlet UILabel *companyNameLab;

@property (weak, nonatomic) IBOutlet UIImageView *renZhenImgView;

// 图标容器view
@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;

@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;



@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyTopLayout;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *companyBtnTopLayout;

// 交易得分
@property (weak, nonatomic) IBOutlet UILabel *tradeLevelLab;
//@property (weak, nonatomic) IBOutlet UIImageView *tradeLevelImgView;
@property (weak, nonatomic) IBOutlet UIButton *tradeLevelBtn;
@property (weak, nonatomic) IBOutlet UILabel *tradeLevelNumLab;
//覆盖点击交易区域的按钮
@property (weak, nonatomic) IBOutlet UIButton *tradeLevelActionBtn;

//@property (weak, nonatomic) IBOutlet ZXProgressView *progressView;
//@property (weak, nonatomic) IBOutlet UILabel *progressLab;
//
//@property (weak, nonatomic) IBOutlet UIButton *updateInfomationBtn;

//@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
//编辑按钮
//@property (weak, nonatomic) IBOutlet UIButton *editInfomationBtn;
//二维码按钮
@property (weak, nonatomic) IBOutlet UIButton *erWeiMaBtn;

@property (weak, nonatomic) IBOutlet UILabel *erWeiMaLab;

@property (weak, nonatomic) IBOutlet UIImageView *isNewErWeiMaView;


//粉丝访客,曝光 容器view
@property (weak, nonatomic) IBOutlet UIView *btnContainerView;


@property (weak, nonatomic) IBOutlet UILabel *fansLab;
@property (weak, nonatomic) IBOutlet UILabel *fansNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *fansIsNewImgView;

@property (weak, nonatomic) IBOutlet UILabel *visitorLab;
@property (weak, nonatomic) IBOutlet UILabel *visitorNumLab;
@property (weak, nonatomic) IBOutlet UIImageView *vistitorIsNewImgView;


@property (weak, nonatomic) IBOutlet UILabel *exposureNumLab;

@property (weak, nonatomic) IBOutlet UIButton *exposureBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *exposureCenterXLayout;
@property (weak, nonatomic) IBOutlet UIImageView *exposureArrowImgView;


@property (weak, nonatomic) IBOutlet UIButton *shopInfoActionBtn;
@property (weak, nonatomic) IBOutlet UIButton *infoButton2;

//广告按钮
@property (weak, nonatomic) IBOutlet UIButton *advBtn;

- (void)setNewFansOrVisitor:(BOOL)isNewFans visitor:(BOOL)isNewVisitor;

- (void)setRightAdvData:(advArrModel *)model;

@end
