//
//  ShopAddressView.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListCell.h"
#import "ShopModel.h"

@interface ShopAddressView : UIView
@property (nonatomic, strong)UIScrollView *scroll_bg;
@property (nonatomic, strong)CommonListChooseCell *chooseMarket;

@property (nonatomic, copy)NSDictionary *marketStr;


-(void)setData:(ShopAddrModel *)data;
@end
