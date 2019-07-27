//
//  WYMakeBillGoodsViewController.h
//  YiShangbao
//
//  Created by light on 2018/1/5.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MakeBillModel;

typedef void (^MakeBillGoodsListBlock)(MakeBillGoodsModel * goodsModel,NSInteger index);

@interface WYMakeBillGoodsViewController : UIViewController

@property (nonatomic) BOOL isEditBill;


/**
 传入相关参数

 @param goodsModel 商品信息
 @param isAdd 是不是添加新的商品
 @param index 修改index
 @param block <#block description#>
 */
- (void)updataGoodsModel:(MakeBillGoodsModel *)goodsModel isAdd:(BOOL)isAdd index:(NSInteger)index block:(MakeBillGoodsListBlock)block;

@end
