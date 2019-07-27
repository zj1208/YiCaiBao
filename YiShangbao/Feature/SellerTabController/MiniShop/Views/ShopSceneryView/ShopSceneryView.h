//
//  ShopSceneryView.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SceneryCellView : UIView

@property(nonatomic, strong)UIImageView *bg;
@property(nonatomic, strong)UIImageView *photo;
@property(nonatomic, strong)UILabel *lbl_text;
@property(nonatomic, strong)UIImageView *pic;
@property(nonatomic, strong)UIButton *btn;

@end



@interface ShopSceneryView : UIView

@property(nonatomic, strong)SceneryCellView *cellTop;
@property(nonatomic, strong)UIButton *btn_top;
@property(nonatomic, strong)SceneryCellView *cellLeftup;
@property(nonatomic, strong)UIButton *btn_Leftup;
@property(nonatomic, strong)SceneryCellView *cellLeftDown;
@property(nonatomic, strong)UIButton *btn_LeftDown;
@property(nonatomic, strong)SceneryCellView *cellRightup;
@property(nonatomic, strong)UIButton *btn_Rightup;
@property(nonatomic, strong)SceneryCellView *cellRightDown;
@property(nonatomic, strong)UIButton *btn_RightDown;


@end
