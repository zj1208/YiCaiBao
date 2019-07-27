//
//  FastOpenShopView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListCell.h"

@interface FastOpenShopView : UIView

@property (nonatomic, strong)UIScrollView *scroll_bg;
@property (nonatomic, strong)CommonListCell *shopHeadImage;
@property (nonatomic, strong)CommonListCell *shopName;
@property (nonatomic, strong)CommonListCell *mainCategory;
@property (nonatomic, strong)CommonListCell *mainProducts;
@property (nonatomic, strong)CommonRadioButtonCell *businessPattern;
@property (nonatomic, strong)CommonListChooseCell *chooseMarket;
@property (nonatomic, strong)CommonListNoArrowCell *name;
@property (nonatomic, strong)CommonListNoArrowCell *phone;
@property (nonatomic, strong)UIButton *btn_confirm;

@property (nonatomic, copy)NSDictionary *marketStr;

-(void)initCell;

-(void)setUIChooseMarket;
@end
