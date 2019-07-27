//
//  ShopInfoView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListCell.h"

@interface ShopInfoView : UIView

@property(nonatomic, strong)UIScrollView *scroll_bg;
@property(nonatomic, strong)CommonListCell *shopHeadImage;
@property(nonatomic, strong)CommonListCell *shopName;
@property(nonatomic, strong)CommonListCell *shopIntro;
@property(nonatomic, strong)CommonListCell *shopAddress;
@property(nonatomic, strong)CommonListCell *manageInfo;
@property(nonatomic, strong)CommonListCell *shopContactInfo;
@property(nonatomic, strong)CommonListCell *bankAccount;

@property(nonatomic, strong)CommonListCell *shopShiJing;

@property(nonatomic, strong)CommonListCell *tradeSetting;

@property (nonatomic, copy)NSString *marketStr;

-(void)initCell:(ShopListModel *)data;
@end
