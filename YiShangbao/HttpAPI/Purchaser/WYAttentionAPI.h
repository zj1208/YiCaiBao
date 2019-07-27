//
//  WYAttentionAPI.h
//  YiShangbao
//
//  Created by light on 2018/6/6.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

//100044_获取我关注的商铺动态列表
static NSString *kAttention_buyer_followShopsDynamics_URL = @"mtop.user.getFollowShopsDynamics";

//100045_获取关注中精选商铺
static NSString *kAttention_buyer_priseSuppliers_URL = @"mtop.user.getPriseSuppliers";

@interface WYAttentionAPI : BaseHttpAPI


/**
 //100044_获取我关注的商铺动态列表

 @param pageNo 当前页码
 @param pageSize 单页数量
 @param type 类型
 @param requestId 请求id
 @param success success description
 @param failure failure description
 */
- (void)getFollowShopsDynamicsPageNo:(NSNumber *)pageNo pageSize:(NSNumber *)pageSize type:(NSNumber *)type requestId:(NSString *)requestId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 
 //100045_获取关注中精选商铺

 @param type 类型
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBuyerPriseSuppliersType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
