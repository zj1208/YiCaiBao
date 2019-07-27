//
//  WYPurchaserShoppingCartToolView.h
//  YiShangbao
//
//  Created by light on 2017/8/31.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPurchaserShoppingCartToolView : UIView

@property (nonatomic ,strong) UIButton *selectedButton;

@property (nonatomic ,strong) UIButton *settleAccountsButton;
@property (nonatomic ,strong) UIButton *collectButton;
@property (nonatomic ,strong) UIButton *deleteButton;
@property (nonatomic ,strong) UIView *editView;

@property (nonatomic ,strong) UILabel *tipLabel;

- (void)isAllSelected:(BOOL)isSelected;


/**
 <#Description#>

 @param price 合计价格
 @param count 选中商品数
 */
- (void)totalPrice:(CGFloat)price selectdCount:(NSInteger)count;

@end
