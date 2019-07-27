//
//  JLDynamicMenuCollectionViewCell.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLDynamicMenuCollectionViewCell : UICollectionViewCell
//和cell等大的UIImageView
@property (weak, nonatomic) IBOutlet UIImageView *backgroundIMV;
//title
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//icon
@property (weak, nonatomic) IBOutlet UIImageView *iconIMV;
//icon右上角图标，default hidden=yes
@property (weak, nonatomic) IBOutlet UIImageView *iocnRightIMV;

//default is 8.f
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topIconConstraint;
//default is LCDScale_iPhone6_Width(40.f)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconWidthConstraint;
//default is LCDScale_iPhone6_Width(40.f)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconHeihtConstraint;

//default is lessEqual LCDScale_iPhone6_Width(15.f)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconHeightContraint;
//default is lessEqual LCDScale_iPhone6_Width(15.f)
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIconWidthContraint;
//default is -2.f
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIcon_AlignTop_IconIMV_Contraint;
//default is 3.f
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightIcon_AlignTrailing_IconIMV_Contraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *title_height_Contraint;

@end
