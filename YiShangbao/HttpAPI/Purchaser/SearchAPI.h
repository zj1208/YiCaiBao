//
//  SearchAPI.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "SearchModel.h"


//810004_获取历史搜索关键词接口 ==819001_获取历史搜索关键词接口
static NSString *Get_search_getHistorySearchKeywords_URL = @"mtop.search.getHistorySearchKeywords";
//810008_删除历史搜索关键词记录接口 ==819002_删除历史搜索关键词记录接口
static NSString *Post_search_delHistorySearchKeywords_URL = @"mtop.search.delHistorySearchKeywords";

//810005_获取猜你想找接口
static NSString *Get_search_getGuessYouWantToFind_URL = @"mtop.search.getGuessYouWantToFind";

//810001_搜索产品接口
static NSString *Get_search_searchProduct_URL = @"mtop.search.searchProduct";
//810002_搜索产品接口（合并相同商铺） 
static NSString *Get_search_searchProductByShop_URL = @"mtop.search.searchProductByShop";
//810003_搜索商铺接口 
static NSString *Get_search_searchShop_URL = @"mtop.search.searchShop";
//810006_获取筛选条件接口(一区～五区等)
static NSString *Get_search_getFilterConditions_URL = @"mtop.search.getFilterConditions";
//810007_搜索产品额外信息接口(轮播广告）接口1.1.3后废弃
//810011_搜索商铺banner信息接口
static NSString *Get_search_searchProductAdditional_URL = @"mtop.search.searchShopBanner";

//分类查找
//010201_获取系统类目
static NSString *Get_cat_sysCates_URL = @"mtop.cat.sysCates";
//010205_热门分类
static NSString *Get_cat_hotSysCate_URL = @"mtop.cat.hotSysCate";

@interface SearchAPI : BaseHttpAPI


/**
 //010205_热门分类

 @param success success description
 @param failure failure description
 */
- (void)getHotSysCateSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //010201_获取系统类目

 @param iid 父类目id id和level不可同时为空
 @param level 类目等级 id和level不可同时为空
 @param success success description
 @param failure failure description
 */
- (void)getCatSysCatesURLWithId:(NSNumber*)iid level:(NSNumber*)level Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //810003_搜索商铺接口
 
 @param pageNo 第几页，未设置的情况默认第一页
 @param pageSize 每页几条，未设置的情况默认每页十条
 @param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
 @param sellChannel 贸易类型 0-全部 1-内销 2-外销
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品
 @param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
 @param submarketIdFilter 筛选条件 所在市场id，多个筛选条件用逗号分隔，可为空
 @param authStatus    认证状态 0-未认证 1-已认证，未设置的情况默认为1
 @param success success description
 @param failure failure description
 */
- (void)getSearchShopURLWithPageNo:(NSInteger)pageNo pageSize:(NSInteger )pageSize  searchKeyword:(NSString*)searchKeyword sellChannel:(NSInteger)sellChannel   keywordType:(NSInteger)keywordType catId:(NSNumber*)catId submarketIdFilter:(NSString*)submarketIdFilter authStatus:(NSInteger)authStatus success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 810006_获取筛选条件接口(一区～五区等)


 @param type 筛选条件类型 0-产品 1-商铺
 @param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品
 @param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
 @param authStatus 认证状态 0-未认证 1-已认证，未设置的情况默认为1
 @param success success description
 @param failure failure description
 */
-(void)getSearchGetFilterConditionsURLWithType:(NSInteger)type searchKeyword:(NSString*)searchKeyword keywordType:(NSInteger)keywordType catId:(NSNumber*)catId authStatus:(NSInteger)authStatus  Success:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
 810007_搜索产品额外信息接口(轮播广告）

 @param searchKeyword 搜索关键词
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品
 @param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空
 @param success success description
 @param failure failure description
 */
- (void)getSearchProductAdditionalURWithSearchKeyword:(NSString*)searchKeyword keywordType:(NSNumber*)keywordType catId:(NSNumber*)catId Success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810002_搜索产品接口（合并相同商铺）
 
 @param pageNo 第几页，未设置的情况默认第一页
 @param pageSize 每页几条，未设置的情况默认每页十条
 @param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
 @param productSourceType 产品货源类型 0-全部 1-现货 2-订做
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品
 @param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
 @param submarketIdFilter 筛选条件 所在市场id，多个筛选条件用逗号分隔，可为空
 @param catIdFilter       筛选条件 类目id，多个筛选条件用逗号分隔，可为
 @param authStatus    认证状态 0-未认证 1-已认证，未设置的情况默认为1
 @param success success description
 @param failure failure description
 */
- (void)getSearchProductByShopWithPageNo:(NSInteger)pageNo pageSize:(NSInteger )pageSize  searchKeyword:(NSString*)searchKeyword productSourceType:(NSInteger)productSourceType   keywordType:(NSInteger)keywordType catId:(NSNumber*)catId submarketIdFilter:(NSString*)submarketIdFilter catIdFilter:(NSString*)catIdFilter authStatus:(NSInteger)authStatus success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810001_搜索产品接口
 
 @param requestId 请求id，pageNo为1的情况可以为空，pageNo大于1的情况必须设置为前一次请求返回来的responseId
 @param pageNo 第几页，未设置的情况默认第一页
 @param pageSize 每页几条，未设置的情况默认每页十条
 @param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
 @param productSourceType 产品货源类型 0-全部 1-现货 2-订做
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品
 @param catId 类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
 @param submarketIdFilter 筛选条件 所在市场id，多个筛选条件用逗号分隔，可为空
 @param catIdFilter       筛选条件 类目id，多个筛选条件用逗号分隔，可为空
 @param authStatus    认证状态 0-未认证 1-已认证，未设置的情况默认为1
 @param success success description
 @param failure failure description
 */
- (void)getSearchProductWithPageNo:(NSInteger)pageNo pageSize:(NSInteger )pageSize  searchKeyword:(NSString*)searchKeyword productSourceType:(NSInteger)productSourceType   keywordType:(NSInteger)keywordType catId:(NSNumber*)catId submarketIdFilter:(NSString*)submarketIdFilter catIdFilter:(NSString*)catIdFilter authStatus:(NSInteger)authStatus requestId:(NSString *)requestId success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810008_删除历史搜索关键词记录接口(删除所有数据)===819002_

 @param success success description
 @param failure failure description
 */
-(void)postDelHistorySearchKeywordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810004_获取历史搜索关键词接口===819001_
 
 @param success success description
 @param failure failure description
 */
- (void)getHistorySearchKeywordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 810005_获取猜你想找接口

 @param success success description
 @param failure failure description
 */
- (void)getGuessYouWantToFindSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 819001_获取历史搜索关键词接口
 
 @param bizType 业务类型 0-搜产品/搜商铺 1-搜推广产品 2-搜推广库存 3-搜生意，默认为0
 @param success success description
 @param failure failure description
 */
-(void)getHistorySearchKeywordsWithBizType:(NSInteger)bizType success:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
 819002_删除历史搜索关键词记录接口
 
 @param bizType 业务类型 0-搜产品/搜商铺 1-搜推广产品 2-搜推广库存 3-搜生意，默认为0
 @param success success description
 @param failure failure description
 */
- (void)postDelTradeHistorySearchKeywordsWithBizTyp:(NSInteger)bizType success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
