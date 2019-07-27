//
//  ServiceMainAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"


//703001 获取转租转让列表
#define List_SubletOrTransferList_URL        @"mtop.external.sublet.getSubletOrTransferList"

// 711008 判断是否在市场内的
#define Result_AuthResult_URL                @"mtop.external.base.getAuthResult"
// 711007 判断是否拨浪鼓认证
#define Result_BlgAuthResult_URL                @"mtop.external.base.getBlgAuthResult"

//711011 菜单进入权限控制
#define Get_RoleStrategyCtrl_URL                @"mtop.external.base.roleStrategyCtrl"
//700000_菜单
#define Get_Menu_URL                @"mtop.shop.config.marketServiceMenu"



@interface ServiceMainAPI : BaseHttpAPI

/**
 获取转租转让列表
 @param success success block
 @param failure failure block
 
 */
- (void)getSubletOrTransferListWithNULLSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取转租转让列表

 @param page 页码
 @param pageSize 单页数量
 @param success success description
 @param failure failure description
 */
- (void)getSubletOrTransferListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure;

// 711008 判断是否在市场内的
/**
 用户是否已经认证/ 

 @param success success block
 @param failure failure block
 */
- (void)getAuthResultWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

- (void)getAuthResultWithModuleTypeName:(NSString *)moduleType success:(CompleteBlock)success failure:(ErrorBlock)failure;

// 711007
- (void)getBlgAuthResultWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 菜单进入权限控制

 @param moduleType 子菜单模块，在线报修“repair”，转租转让“sublet”，泊车位办理“parking”，服务电话“call”
 @param success success block
 @param failure failure block
 */
- (void)getRoleStrategyCtrlWithmoduleType:(NSString *)moduleType success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 获取服务模板

 @param success success block
 @param failure failure block
 */
- (void)getMenuWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
