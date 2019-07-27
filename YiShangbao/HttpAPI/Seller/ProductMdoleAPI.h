//
//  ProductMdoleAPI.h
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "ProductModel.h"


//301040_开店引导页配置
static NSString *kShop_openGuide = @"mtop.shop.guide.cfg";

//查询商铺是否开店，获取商铺id
static NSString *kShop_queryShopInfo = @"mtop.shop.store.quryShopInfo";

//海象301005_获取商铺概括信息
static NSString *kShop_getShopMainInfo = @"mtop.shop.store.getShopInfoOutline";

//301053_粉丝访客更新接口
static NSString *kShop_checkNewFansAndVisitors = @"mtop.shop.store.checkFansAndVisitors";

//302001_上架商品初始化
static NSString *kProduct_putawayInit = @"mtop.shop.prod.init4new";
//302002_新增产品
static NSString *kProduct_newProduct  =@"mtop.shop.prod.newprod";
//302010_产品详情(编辑)
static NSString *kProduct_detail  = @"mtop.shop.prod.get";
//302003_更新商品
static NSString *kProduct_infoUpdate  = @"mtop.shop.prod.mdprod";
//302005_转为删除
static NSString *kProduct_deleteProduct = @"mtop.shop.prod.toinvisible";
//302005_转为下架
static NSString *kProduct_soldout =@"mtop.shop.prod.tounshelve";

//推荐产品标签
static NSString *kProudct_usualProdLabels = @"mtop.shop.prod.usualProdLabels";
//010201_系统推荐类目
static NSString *kProduct_sysCates = @"mtop.cat.sysCates";

//获取粉丝列表
static NSString *kShop_getFansList = @"mtop.shop.store.getFansList";
//海星301023_获取访客列表
static NSString *kShop_getVisitorsList = @"mtop.shop.store.getVisitorsList";

//301021_获取采购商(访客，粉丝)信息-已弃用
static NSString *kShop_getPurchaser = @"mtop.shop.store.getPurchaser";
//100028_交易，粉丝 采购商详情
static NSString *kUser_getBuyerInfo = @"mtop.user.getBizBuyerInfo";

//302008_卖家商品列表
static NSString *kShop_prod_myProductList = @"mtop.shop.prod.myprod";

//303014_分状态获取产品数
static NSString *kShop_prod_productManagerCount  =@"mtop.shop.groupCountProdByStatus";

//302005_转为私密
static NSString *kShop_prod_toprotected  = @"mtop.shop.prod.toprotected";
//302004_转为公开
static NSString *kShop_prod_topublic = @"mtop.shop.prod.topublic";
//302016_设为主营
static NSString *kShop_prod_toMainProd = @"mtop.shop.toMainProd";
//302017_取消主营
static NSString *kShop_prod_cancelMainProd = @"mtop.shop.cancelMainProd";


//810013_搜索类目(正则)
static NSString *kProduct_search_SearchSysCategory_URL = @"mtop.search.searchSysCategoryByRex";
//303015_未搜索到类目的关键词
static NSString *kShop_prod_cateNotFound_URL = @"mtop.shop.prod.cateNotFound";

//810009_获取商户产品列表接口
static NSString *kShop_search_getSellerProducts = @"mtop.search.getSellerProducts";

//330001_运费模板列表
static NSString *kShop_freight_getFreightList = @"mtop.shop.freight.getFreightList";

//店铺本地分类
//301201_分类查询
static NSString *kShop_categoryQuery_URL = @"mtop.shop.category.query";
//301202_新增分类
static NSString *kShop_categoryNew_URL = @"mtop.shop.category.new";
//301203_修改名称
static NSString *kShop_categoryModifyName_URL = @"mtop.shop.category.modifyName";
//301204_修改排序
static NSString *kShop_categoryModifyIndex_URL = @"mtop.shop.category.modifyIndex";
//301205_删除分类
static NSString *kShop_categoryDel_URL = @"mtop.shop.category.del";
//301208_产品列表
static NSString *kShop_categoryList_URL = @"mtop.prod.category.list";
//301209_批量移动产品
static NSString *kShop_prod_categoryBatchMove_URL = @"mtop.prod.category.batchMove";
//301210_批量删除产品
static NSString *kShop_prod_categoryBatchDel_URL = @"mtop.prod.category.batchDel";


//309003_查询是否启用水印
static NSString *kShop_queryIsExistWaterMark_URL = @"mtop.shop.prod.queryIsExistWaterMark";

//309004_上传水印图片
static NSString *kShop_uploadGetWaterMarkPic_URL = @"mtop.shop.prod.uploadGetWaterMarkPic";


@interface ProductMdoleAPI : BaseHttpAPI

//获取商铺引导页的企业列表信息
+ (void)getShopOpenGuideWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


///**
// 蓝鲸301003_查询商铺ID（判断是否开店）
// 
// @param success success description
// @param failure failure description
// */
//+ (void)getMyShopIdsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;
//


/**
 海象301005_获取商铺概括信息
 
 @param shopId 商铺id
 */
+ (void)getMyShopMainInfoWithShopId:(NSString *)shopId Success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 301053_粉丝访客更新接口
 
 */
+ (void)getCheckNewFansAndVisitorsWithSuccess:(void (^)(BOOL fansAdd, BOOL visitorsAdd,BOOL newOrderAdd, BOOL newBizAdd))success failure:(ErrorBlock)failure;


//302001_上架商品初始化
+ (void)getProductPutawayInitWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

//302002_新增商品
+ (void)postProductNewPro:(AddProductModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 302006_商品详情(展示)

 @param productId 商品id

 @param success success description
 @param failure failure description
 */
+ (void)getProductDetailInfoWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 302010_常用商品标签

 @param success success description
 @param failure failure description
 */
+ (void)getProductUsualProdLabelsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 302003_更新商品

 @param model model
 @param success success description
 @param failure failure description
 */
+ (void)postUpdateProductInfo:(AddProductModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure;


//302005_转为删除
+ (void)postDeleteProductWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure;

//302005_转为下架
+ (void)postSoldoutProductWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 一开始类目传nil，level传2级

 @param cateId 一开始为nil
 @param level 从2级类目开始
 @param success success description
 @param failure failure description
 */
+ (void)getProductSystemCatesWithCateId:(NSNumber *)cateId levelId:(NSNumber *)level success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取粉丝列表

 @param shopId 商铺id
 @param pageNo pageNo description
 @param pageSize pageSize description
 */
+ (void)getShopFansListWithShopId:(NSString *)shopId pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(NSNumber *todayAdd, id data,PageModel *pageModel))success failure:(ErrorBlock)failure;

//获取访客列表
+ (void)getShopVisitorsListWithShopId:(NSString *)shopId pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(NSNumber *todayAdd, id data,PageModel *pageModel))success failure:(ErrorBlock)failure;



/**
 100028_交易，粉丝 采购商详情
 */

+ (void)getBuyerInfoWithbizId:(NSString *)bizId Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 302008_卖家商品列表

 @param productType 商品状态 1-出售公开 2-私密产品 0-已下架
 @param onlyMain    是否只查询主营，非空表示是 onlyMain=true<目前是传入YES，不是传NO>
 @param direction   1：修改时间升序    -1：修改时间降序<修改时间升序YES, 修改时间降序NO>
 */
+ (void)getMyProductListWithType:(MyProductType)productType onlyMain:(BOOL )onlyMain direction:(BOOL)direction pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void(^)(id data,PageModel *pageModel))success failure:(ErrorBlock)failure;

//303014_分状态获取产品数
+ (void)getMyProductListProCountWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

//302005_转为私密
+ (void)postMyProductToProtectedWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure;

//302004_转为公开
+ (void)postMyProductToPublicWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure;
//302016_设为主营
+ (void)postMyProductToMainWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure;
//302017_取消主营
+ (void)postMyProductToCancelMainWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810009_获取商户产品列表接口

 @param productType 产品类型，不包括下架产品；产品类型，可为空，1-公开 2-私密
 @param keyword 搜索文字
 @param pageNo pageNo description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */

+ (void)getSellerProductsWithProductType:(MyProductType)productType keyword:(NSString *)keyword pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
 810013_搜索类目(正则)
 
 @param word 搜索关键词
 @param pageNum pageNum description
 @param pageSize pageSize description
 @param success success description
 @param failure failure description
 */
+ (void)getSearchCategoryWithWord:(NSString *)word shopId:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
 303015_未搜索到类目的关键词

 @param string 未搜索到类目关键字
 @param success success description
 @param failure failure description
 */
+ (void)postNotFoundcategoryString:(NSString *)string shopId:(NSString *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 //330001_运费模板列表

 @param appendMore 是否需要返回具体运费信息
 @param success success description
 @param failure failure description
 */
+ (void)getShopFreightListWithAppendMore:(BOOL)appendMore success:(CompleteBlock)success failure:(ErrorBlock)failure;

#pragma mark- 店铺内分类

/**
 301201_分类查询

 @param shopId 店铺ID
 @param isNoGroup 是否包括未分类
 @param success success description
 @param failure failure description
 */
+ (void)getShopCategoryDataWithShopId:(NSString *)shopId appendNoGroup:(BOOL)isNoGroup success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301202_新增分类

 @param name 分类名
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryCreatNewByName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301203_修改名称

 @param categoryId 分类ID
 @param name 分类名
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryRenameById:(NSString *)categoryId rename:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301204_修改排序

 @param categoryId 商铺分类标识
 @param upDown 位置变化 排序，0-上升一位；1-下降一位
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryRemoveById:(NSString *)categoryId upDown:(NSInteger)upDown success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301205_删除分类

 @param categoryId 商铺分类标识
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryDelById:(NSString *)categoryId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301208_产品列表

 @param shopId 商铺标识
 @param shopCatgId 商铺分类标识， 默认0标识“未分类产品”
 @param pageNo 页码 默认1 如果是-1不分页处理
 @param pageSize 单页记录数 默认10
 @param success success description
 @param failure failure description
 */
+ (void)getShopCategoryListByShopId:(NSString *)shopId shopCatgId:(NSString *)shopCatgId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
 301209_批量移动产品

 @param from 商铺分类标识
 @param to 商铺分类标识, 多个“,”分割
 @param prodIds 产品标识","分割
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryBatchMoveFromCategory:(NSString *)from toCategory:(NSString *)to prodIds:(NSString *)prodIds success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 301210_批量删除产品

 @param categoryId 商铺分类标识
 @param prodIds 产品标识","分割
 @param success success description
 @param failure failure description
 */
+ (void)postShopCategoryBatchDelById:(NSString *)categoryId prodIds:(NSString *)prodIds success:(CompleteBlock)success failure:(ErrorBlock)failure;

//309003_查询是否启用水印
//0：不使用，1：使用
+ (void)getQueryIsExistWaterMarkWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

//309004_上传水印图片
+ (void)postUploadGetWaterMarkPicWithPicUrl:(NSString *)picUrl success:(CompleteBlock)success failure:(ErrorBlock)failure;
@end
