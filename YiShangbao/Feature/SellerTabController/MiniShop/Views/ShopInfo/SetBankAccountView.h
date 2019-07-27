//
//  SetBankAccountView.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonListCell.h"
#import "ShopModel.h"

@interface SetBankAccountView : UIView
@property(nonatomic, strong)UIScrollView *scorll_bg;
@property(nonatomic, strong)CommonListCell *cell_bank;
@property(nonatomic, strong)CommonListNoArrowCell *cell_openbank;
@property(nonatomic, strong)CommonListNoArrowCell *cell_openName;
@property(nonatomic, strong)CommonListNoArrowCell *cell_bankID;

@property(nonatomic, strong)UIButton *btn_confirm;

-(void)setData:(AcctInfoModel *)data;
@end
