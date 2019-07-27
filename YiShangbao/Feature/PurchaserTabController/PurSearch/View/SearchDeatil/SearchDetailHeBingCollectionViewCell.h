//
//  SearchDetailHeBingCollectionViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "ZXPhotosView.h"
#import "ZXImgIconsCollectionView.h"
@interface SearchDetailHeBingCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *numsLabel;
@property (weak, nonatomic) IBOutlet UIButton *jindianBtn;
@property (weak, nonatomic) IBOutlet UIView *photosBackView;
//@property (weak, nonatomic) IBOutlet UIImageView *shichangImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *jinpaiImageView;

@property (nonatomic, weak) ZXPhotosView *photosView;

@property (weak, nonatomic) IBOutlet UIView *tuiguangContentView;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLabel;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

-(void)setHeBingCellData:(SearchShopModel*)data;


@end
