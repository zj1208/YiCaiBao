//
//  WYPurchaserShoppingCartTableViewCell.h
//  YiShangbao
//
//  Created by light on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const WYPurchaserShoppingCartTableViewCellID;

typedef NS_ENUM(NSInteger, ChangeGoodsCountStatus){
    ChangeGoodsCountStatusSuccess               = (1 << 0),
    ChangeGoodsCountStatusFailureByMin          = (1 << 1),
    ChangeGoodsCountStatusFailureByMax          = (1 << 2),
    
};

@class WYPurchaserShoppingCartTableViewCell;
@protocol WYPurchaserShoppingCartTableViewCellDelegate <NSObject>

@optional
//选中商铺中商品
- (void)goodsSelected:(BOOL)isSelected indexPath:(NSIndexPath *)indexPath;

- (void)goodsChangeStatus:(ChangeGoodsCountStatus)status goodsId:(NSString *)cartId quantity:(NSInteger)quantity;

@end

@interface WYPurchaserShoppingCartTableViewCell : UITableViewCell

//最大位数
@property (nonatomic) NSInteger maxProductDigit;

@property (nonatomic, weak) id<WYPurchaserShoppingCartTableViewCellDelegate> delegate; ///< 代理对象

- (void)updateData:(id)model indexPath:(NSIndexPath *)indexPath;

- (void)updateData:(id)model;

@end
