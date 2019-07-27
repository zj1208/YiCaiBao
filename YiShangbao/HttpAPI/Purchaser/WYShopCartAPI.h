//
//  WYShopCartAPI.h
//  YiShangbao
//
//  Created by light on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

//500102_获取购物车信息接口

static NSString *Get_buyer_cartInfo_URL = @"mtop.cart.getCartInfo";

//500103_修改购物车接口
static NSString *Post_buyer_modifyCartInfo_URL = @"mtop.cart.modifyCartInfo";
//500104_删除购物车产品接口
static NSString *Post_buyer_deleteProduct_URL = @"mtop.cart.deleteProduct";
//500105_清空购物车失效产品接口
static NSString *Post_buyer_clearInvalidProduct_URL = @"mtop.cart.clearInvalidProduct";
//500106_购物车结算接口
static NSString *Post_buyer_settleCart_URL = @"mtop.cart.settleCart";

@interface WYShopCartAPI : BaseHttpAPI


/**
 获取购物车信息接口

 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBuyerShopCartSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 修改购物车产品数量接口

 @param cartId 购物车Id
 @param quantity 购买数量
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postBuyerModifyCartInfoCartId:(NSString *)cartId quantity:(NSInteger)quantity success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 删除购物车产品接口

 @param cartIds 购物车id列表
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postBuyerDeleteProductCartIds:(NSArray *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 清空购物车失效产品接口

 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postBuyerClearInvalidProductSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 购物车结算接口验证

 @param cartIds 购物车id列表
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)postBuySettleCartWithCartIds:(NSArray *)cartIds success:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
