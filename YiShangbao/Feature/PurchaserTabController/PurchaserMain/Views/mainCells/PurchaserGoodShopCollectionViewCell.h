//
//  PurchaserGoodShopCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZXImgIconsCollectionView.h"
@class PurchaserGoodShopCollectionViewCell;
@protocol PurchaserGoodShopCollectionViewCellDelegate <NSObject>
//点击按钮代理
-(void)jl_PurchaserGoodShopCollectionViewCell:(PurchaserGoodShopCollectionViewCell *)cell didSelectItemWithInteger:(NSInteger)integer;
@end

@interface PurchaserGoodShopCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)id<PurchaserGoodShopCollectionViewCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIImageView *shopHeaderIMV;
@property (weak, nonatomic) IBOutlet UIButton *shopIconImageView; //阴影
@property (weak, nonatomic) IBOutlet UILabel *shopNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *shopDescLabel;

@property (weak, nonatomic) IBOutlet UIImageView *firstIMG;
@property (weak, nonatomic) IBOutlet UILabel *firstdescLabel;
@property (weak, nonatomic) IBOutlet UILabel *firstPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondIMG;
@property (weak, nonatomic) IBOutlet UILabel *seconddescLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondPriceLabel;

@property (weak, nonatomic) IBOutlet UIImageView *thirdIMG;
@property (weak, nonatomic) IBOutlet UILabel *thirddescLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdPriceLabel;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

-(void)settData:(id)data;

@end
