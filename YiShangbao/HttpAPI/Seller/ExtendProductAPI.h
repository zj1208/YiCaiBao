//
//  ExtendProductAPI.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "ExtendModel.h"

//304004_推广产品初始化
static NSString *Get_initExtendProduct_URL = @"mtop.spread.prod.init";
//304006_新增库存初始化
static NSString *Get_initExtendInventory_URL = @"mtop.inventory.init";

//304005_新增推广产品
static NSString *Post_addExtendProduct_URL = @"mtop.spread.prod.add";
//304007_新增库存
static NSString *Post_addExtendInventory_URL = @"mtop.inventory.add";
//304017_剩余推广次数
static NSString *Get_remainExtendTimes  = @"mtop.spread.times.left";

//308001_选择产品初始化
static NSString *Extent_Get_spread_chooseProduct  = @"mtop.spread.chooseProduct";

//100025_app获取用户市场认证情况==>去认证
static NSString *Extent_Get_getMarketQualiInfo  = @"mtop.user.getMarketQualiInfo";

//304023_获取推广
static NSString *Extent_Get_getSpread  = @"mtop.shop.getSpread";


@interface ExtendProductAPI : BaseHttpAPI


/**
 304023_获取推广

 @param oldId 库存/推广id
 */
- (void)getExtendOldSpreadWithOldId:(NSNumber*)oldId Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 100025_app获取用户市场认证情况==>去认证

 @param success success description
 @param failure failure description
 */
-(void)getExtentgetMarketQualiInfoSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301201_分类查询
 //V2.0用于产品选择
 @param shopId 店铺ID
 @param isNoGroup 是否包括未分类
  */
-(void)getExtentShopCategoryDataWithShopId:(NSString *)shopId appendNoGroup:(BOOL)isNoGroup success:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
 308001_选择产品初始化

 @param shopCategoryId 商铺内分类
 @param name 产品名称，型号
 @param pageNum page number
 @param pageSize page size
 */
- (void)getExtendChooseProductWithShopCategoryId:(NSString *)shopCategoryId name:(NSString *)name pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
  推产品/推库存  新增

 @param desc 推广产品,库存描述
 @param sysCate 系统类目id
 @param photosArray 图片url数组
 @param success success description
 @param failure failure description
 */
- (void)postExtendWithCateLevel:(NSNumber*)cateLevel Desc:(NSString *)desc sysCate:(NSString *)sysCate photos:(NSArray *)photosArray success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 304003_新增库存初始化2.0/304002_推广产品初始化2.0
 
 @param numId  @1-推产品 @2-库存
 @param success success description
 @param failure failure description
 */
- (void)getExtendProductOrInventoryWithNumId:(NSNumber*)numId Success:(CompleteBlock)success failure:(ErrorBlock)failure;


//304014_剩余推广次数
- (void)getRemainExtendTimesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
