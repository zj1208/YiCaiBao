//
//  WYPlaceOrderAPI.h
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

//500201_下单确认页
static NSString *Get_buyer_confirmOrder_URL = @"mtop.buy.confirmOrder";

//500202_创建订单
static NSString *buyer_createOrder_URL = @"mtop.buy.createOrder";

@interface WYPlaceOrderAPI : BaseHttpAPI


/**
 下单确认页信息

 立即下单：只需要传itemId、quantity
 购物车下单：只需要传cartIds
 
 @param itemId 产品id
 @param quantity 产品数量
 @param skuId 产品sku，单个商品对应多个。v1交易不支持
 @param cartIds 购物车id，多个购物车id通过逗号“，”分隔
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBuyerConfirmOrderWithItemId:(NSInteger)itemId quantity:(NSInteger)quantity skuId:(NSNumber *)skuId cartIds:(NSString *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 创建订单

 @param address 地址信息
 @param orderList 订单商品列表
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postBuyerCreatOrderAddress:(NSDictionary *)address orderList:(NSArray *)orderList success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
