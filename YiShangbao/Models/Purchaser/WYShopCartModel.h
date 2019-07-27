//
//  WYShopCartModel.h
//  YiShangbao
//
//  Created by light on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface WYShopCartModel : BaseModel

@property (nonatomic ) NSInteger productCount;
@property (nonatomic ) NSInteger quantityLimit;
@property (nonatomic ,strong) NSString *shopUrl;
@property (nonatomic ,strong) NSString *productUrl;
@property (nonatomic ,strong) NSString *tipInfo;
@property (nonatomic ,strong) NSArray *list;
@property (nonatomic ,strong) NSArray *invalidProducts;

@end
//购物车中商家信息
@interface WYShopCartShopInfoModel : BaseModel

@property (nonatomic ,strong) NSString *shopId;
@property (nonatomic ,strong) NSString *shopName;
@property (nonatomic ,strong) NSArray *products;

@property (nonatomic ) BOOL isSelected;//当前商家所有产品有没有被选中

@end
//购物车商品信息
@interface WYShopCartGoodsModel : BaseModel

@property (nonatomic ,strong) NSString *cartId;
@property (nonatomic ,strong) NSString *goodsId;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *picUrl;
@property (nonatomic ) NSInteger price;
@property (nonatomic ,strong) NSString *price4Disp;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ) NSInteger moq;
@property (nonatomic ,strong) NSString *unit;
@property (nonatomic ) NSInteger quantity;

@property (nonatomic ) BOOL isSelected;//当前产品有没有被选中

@end
//购物车失效商品信息
@interface WYShopCartLoseGoodsModel : BaseModel

@property (nonatomic ,strong) NSString *label;
@property (nonatomic ,strong) NSString *cartId;
@property (nonatomic ,strong) NSString *goodsId;
@property (nonatomic ,strong) NSString *name;
@property (nonatomic ,strong) NSString *picUrl;
@property (nonatomic ,strong) NSString *spec;
@property (nonatomic ,strong) NSString *desc;

@end

@interface WYGoodsPriceModel : BaseModel

@property (nonatomic ,strong) NSNumber *price;
@property (nonatomic ,copy) NSString *price4Disp;
@property (nonatomic ,strong) NSNumber *moq;

@end

