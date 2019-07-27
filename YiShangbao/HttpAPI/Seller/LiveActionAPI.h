//
//  LiveActionAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
//301030_获取实景
#define Info_getLiveAction_URL        @"mtop.shop.store.getLiveAction"
//301031_增修实景
#define Edit_addOrUpdateLiveAction_URL        @"mtop.shop.store.addOrUpdateLiveAction"

@interface LiveActionAPI : BaseHttpAPI
/**
 获取实景

 @param shopId 商铺id
 @param success success block
 @param failure failure block
 */
-(void)getLiveActionWithShopId:(NSNumber *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 增修实景

 @param shopId 商铺实景id标识
 @param left 商铺左视图
 @param center 商铺正门
 @param right 商铺右视图
 @param others 附加图片","分割，最多3张
 @param success success block
 @param failure failure block
 */
-(void)addOrUpdateLiveActionWith:(NSNumber *)shopId left:(NSString *)left center:(NSString *)center right:(NSString *)right others:(NSString *)others success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
