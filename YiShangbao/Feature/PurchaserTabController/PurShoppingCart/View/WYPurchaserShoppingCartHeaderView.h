//
//  WYPurchaserShoppingCartHeaderView.h
//  YiShangbao
//
//  Created by light on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>


@class WYPurchaserShoppingCartHeaderView;
@protocol WYPurchaserShoppingCartHeaderViewDelegate <NSObject>

@optional
//选中商铺中所有商品
- (void)shopAllSelected:(BOOL)isSelected section:(NSInteger)section;
- (void)goShopId:(NSString *)shopId;

@end


extern NSString * const WYPurchaserShoppingCartHeaderViewID;

@interface WYPurchaserShoppingCartHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id<WYPurchaserShoppingCartHeaderViewDelegate> delegate;

- (void)updateData:(id)model section:(NSInteger)section;
- (void)updateData:(id)model;

@end
