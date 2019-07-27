//
//  SearchDetailShangPuCollViewCell.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/28.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "ZXPhotosView.h"
#import "ZXImgIconsCollectionView.h"
@interface SearchDetailShangPuCollViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moshiLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *zhuyingLabel;
@property (weak, nonatomic) IBOutlet UIButton *jindianBtn;
@property (weak, nonatomic) IBOutlet UIView *photosBackView;
//@property (weak, nonatomic) IBOutlet UIImageView *jinpaiImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *shichangImageView;

@property (weak, nonatomic) IBOutlet UIView *tuiguangContentView;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLabel;

@property (nonatomic, weak) ZXPhotosView *photosView;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

-(void)setShopCellData:(SearchShopModel *)data;

//- (CGSize)getShopCellHeightWithSearchShopModel:(SearchShopModel*)searchModel;

@end
