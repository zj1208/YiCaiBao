//
//  BtnCollectionCell.h
//  YiShangbao
//
//  Created by simon on 17/3/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//
//  弃用

#import "BaseCollectionViewCell.h"

@interface BtnCollectionCell : BaseCollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgViewLayoutWidth;

@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UIImageView *badgeImageView;
@property (weak, nonatomic) IBOutlet UIButton *badgeOrderBtn;
@end
