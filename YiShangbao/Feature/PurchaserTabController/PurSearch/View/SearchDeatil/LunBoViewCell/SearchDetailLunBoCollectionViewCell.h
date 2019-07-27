//
//  SearchDetailLunBoCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/7/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
#import "JLCycSrollCellDataProtocol.h"
#import "ZXImgIconsCollectionView.h"
@interface SearchDetailLunBoCollectionViewCell : UICollectionViewCell<JLCycSrollCellDataProtocol>
@property (weak, nonatomic) IBOutlet UIImageView *touxiangImageView;
@property (weak, nonatomic) IBOutlet UILabel *shangpuNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *jinyingLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIButton *gotoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *jinpaiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *shichangImageView;

@property (weak, nonatomic) IBOutlet UIView *yinyingView; //阴影效果
@property (weak, nonatomic) IBOutlet UILabel *mainSellLabel;

@property (weak, nonatomic) IBOutlet UIView *tuiguangContentView;
@property (weak, nonatomic) IBOutlet UILabel *tuiguangLabel;

@property (weak, nonatomic) IBOutlet UIView *iconsContainerView;
@property (nonatomic ,strong) ZXImgIconsCollectionView * iconsView;

@end
