//
//  ContactView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/22.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListCell.h"
#import "ShopModel.h"

@interface ContactView : UIView
@property(nonatomic, strong)UIScrollView *scorll_bg;
@property(nonatomic, strong)CommonListNoArrowCell *cell_name;
@property(nonatomic, strong)CommonListNoArrowCell *cell_phone;
@property(nonatomic, strong)CommonListNoArrowCell *cell_tel;
@property(nonatomic, strong)CommonListNoArrowCell *cell_fax;
@property(nonatomic, strong)CommonListNoArrowCell *cell_email;
@property(nonatomic, strong)CommonListNoArrowCell *cell_qq;
@property(nonatomic, strong)CommonListNoArrowCell *cell_wechat;
@property(nonatomic, strong)UILabel *lbl_tip;
-(void)setData:(ShopContactModel *)data;
@end
