//
//  ProductMdoleAPI.m
//  YiShangbao
//
//  Created by simon on 17/2/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ProductMdoleAPI.h"
#import "AddressItem.h"
@implementation ProductMdoleAPI



+ (void)getShopOpenGuideWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [[ProductMdoleAPI alloc] getRequest:kShop_openGuide parameters:nil success:^(id data) {
        
        if (success) {
            
            NSArray *list = [data objectForKey:@"list"];
            success(list);
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


//+ (void)getMyShopIdsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
//{
//    [[ProductMdoleAPI alloc] getRequest:kShop_queryShopInfo parameters:nil success:^(id data) {
//        
//        //            [UserInfoUDManager setShopId:[ids firstObject]];
//        //            NSString *shopId = [UserInfoUDManager getShopId];
//        if (success) {
//            NSString *idStrings = [data objectForKey:@"ids"];
//            NSArray *ids = [idStrings componentsSeparatedByString:@","];
//            
//            success([ids firstObject]);
//        }
//    } failure:^(NSError *error) {
//        if (failure)
//        {
//            failure(error);
//        }
//    }];
//}


+ (void)getMyShopMainInfoWithShopId:(NSString *)shopId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    if ([NSString zhIsBlankString:shopId])
    {
        return;
    }
    NSDictionary *parameters = @{@"id":shopId,
                                 @"v" :@"2.0",
                                 };
    [[ProductMdoleAPI alloc] getRequest:kShop_getShopMainInfo parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        ShopMainInfoModel *shopModel = [MTLJSONAdapter modelOfClass:[ShopMainInfoModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(shopModel);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}



+ (void)getCheckNewFansAndVisitorsWithSuccess:(void (^)(BOOL fansAdd, BOOL visitorsAdd,BOOL newOrderAdd, BOOL newBizAdd))success failure:(ErrorBlock)failure;
{
    [[ProductMdoleAPI alloc] getRequest:kShop_checkNewFansAndVisitors parameters:nil success:^(id data) {
        
        if (![data isEqual:[NSNull null]])
        {
            BOOL isNewFans = [[data objectForKey:@"showFansAdd"]boolValue];
            BOOL isNewVisitors = [[data objectForKey:@"showVisitorsAdd"]boolValue];
            BOOL isNewOrderAdd = [[data objectForKey:@"newOrderAdd"]boolValue];
            BOOL isNewBizAdd = [[data objectForKey:@"newBizAdd"]boolValue];

            if (success){
                success(isNewFans,isNewVisitors,isNewOrderAdd,isNewBizAdd);
            }
        }
        
        } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)getProductPutawayInitWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [[ProductMdoleAPI alloc] getRequest:kProduct_putawayInit parameters:nil success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            ProductPutawayInitModel *model = [MTLJSONAdapter modelOfClass:[ProductPutawayInitModel class] fromJSONDictionary:data error:error];
            if (error)
            {
                if (failure) {
                    failure(*error);
                }
            }else{
             success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

+ (void)postProductNewPro:(AddProductModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * par = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:par];
    if (model.volumn)
    {
        [parameters setObject:[model.volumn stringValue] forKey:@"volumn"];
    }
    if (model.weight)
    {
        [parameters setObject:[model.weight stringValue] forKey:@"weight"];
    }
    if (model.number)
    {
        [parameters setObject:[model.number stringValue] forKey:@"number"];
    }
    [parameters setObject:@"2.0" forKey:@"v"];
    [[ProductMdoleAPI alloc] postRequest:kProduct_newProduct parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }

    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

+ (void)getProductDetailInfoWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"id":@([productId integerValue]),
                                  @"v" :@"2.0"
                                  };
    [[ProductMdoleAPI alloc] getRequest:kProduct_detail parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        AddProductModel *shopModel = [MTLJSONAdapter modelOfClass:[AddProductModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(shopModel);
            }
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    

}

+ (void)getProductUsualProdLabelsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [[ProductMdoleAPI alloc] getRequest:kProudct_usualProdLabels parameters:nil success:^(id data) {
        
        if (success) {
            
            success([data objectForKey:@"labels"]);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+ (void)postUpdateProductInfo:(AddProductModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * par = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:par];
    [parameters setObject:model.productId forKey:@"id"];
    [parameters removeObjectForKey:@"productId"];
    [parameters removeObjectForKey:@"isOnshelve"];
    if (model.volumn)
    {
        [parameters setObject:[model.volumn stringValue] forKey:@"volumn"];
    }
    if (model.weight)
    {
        [parameters setObject:[model.weight stringValue] forKey:@"weight"];
    }
    if (model.number)
    {
        [parameters setObject:[model.number stringValue] forKey:@"number"];
    }
    [parameters setObject:@"2.0" forKey:@"v"];
    [[ProductMdoleAPI alloc] postRequest:kProduct_infoUpdate parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)postDeleteProductWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"id":productId,
                                  };

    [[ProductMdoleAPI alloc] postRequest:kProduct_deleteProduct parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)postSoldoutProductWithProductId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"id":productId,
                                  };
    
    [[ProductMdoleAPI alloc] postRequest:kProduct_soldout parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    

}

+ (void)getProductSystemCatesWithCateId:(nullable NSNumber *)cateId levelId:(NSNumber *)level success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters =[NSMutableDictionary dictionary];
    if (cateId)
    {
        [parameters setObject:cateId forKey:@"id"];
    }
    [parameters setObject:level forKey:@"level"];
  
    [[ProductMdoleAPI alloc] getRequest:kProduct_sysCates parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[AddressItem class] fromJSONArray:data error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)getShopFansListWithShopId:(NSString *)shopId pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(NSNumber *todayAdd, id data,PageModel *pageModel))success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"shopId":shopId,
                                  kHTTP_PAGENO_KEY2:@(pageNo),
                                  kHTTP_PAGESIZE_KEY2:pageSize
                                  };
    [[ProductMdoleAPI alloc] getRequest:kShop_getFansList parameters:parameters success:^(id data) {
        
        NSDictionary *dic = [data objectForKey:@"page"];
        PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
        NSNumber *toAdd = [dic objectForKey:@"todayAdd"];
        
        NSArray * dataArray = [data objectForKey:@"list"];
        NSLog(@"%@",dataArray);
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[ShopFansModel class] fromJSONArray:dataArray error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(toAdd,array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)getShopVisitorsListWithShopId:(NSString *)shopId pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void (^)(NSNumber *, id, PageModel *))success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"shopId":shopId,
                                  kHTTP_PAGENO_KEY2:@(pageNo),
                                  kHTTP_PAGESIZE_KEY2:pageSize
                                  };
    [[ProductMdoleAPI alloc] getRequest:kShop_getVisitorsList parameters:parameters success:^(id data) {
        
        NSDictionary *dic = [data objectForKey:@"page"];
        PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
        
        NSArray * dataArray = [data objectForKey:@"list"];
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[ShopVisitorsModel class] fromJSONArray:dataArray error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(nil,array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)getBuyerInfoWithbizId:(NSString *)bizId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{@"bizId":bizId};
    [[ProductMdoleAPI alloc] getRequest:kUser_getBuyerInfo parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        ShopPurchaserInfoModel *shopModel = [MTLJSONAdapter modelOfClass:[ShopPurchaserInfoModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(shopModel);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}




+ (void)getMyProductListWithType:(MyProductType)productType onlyMain:(BOOL )onlyMain direction:(BOOL)direction  pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(void(^)(id data,PageModel *pageModel))success failure:(ErrorBlock)failure
{
    NSInteger timeDir = direction?1:-1;
    NSDictionary *dict = @{
                                 @"status":@(productType),
                                 @"direction":@(timeDir),

                                 kHTTP_PAGENO_KEY3:@(pageNo),
                                 kHTTP_PAGESIZE_KEY3:pageSize
                                 };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (onlyMain) {
        [parameters setObject:@"true" forKey:@"onlyMain"];
    }
    [[ProductMdoleAPI alloc] getRequest:kShop_prod_myProductList parameters:parameters success:^(id data) {
        
        if (success)
        {
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            
            NSArray * dataArray = [data objectForKey:@"list"];
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[ShopMyProductModel class] fromJSONArray:dataArray error:error];
            if (error){
                if (failure) failure(*error);
            }else
            {
                success(array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}


+ (void)getMyProductListProCountWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [[ProductMdoleAPI alloc] getRequest:kShop_prod_productManagerCount parameters:nil success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[ProductManagerCountModel class] fromJSONArray:data error:error];
        if (error){
            if (failure) failure(*error);
        }else
        {
            if (success){
                success(array);
            }
        }

        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


+ (void)postMyProductToProtectedWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"id":productId,
                                };
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_toprotected parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

+ (void)postMyProductToPublicWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"id":productId,
                                 };
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_topublic parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
//302016_设为主营
+ (void)postMyProductToMainWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"id":productId,
                                 };
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_toMainProd parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
//302017_取消主营
+ (void)postMyProductToCancelMainWithProductId:(NSString *)productId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"id":productId,
                                 };
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_cancelMainProd parameters:parameters success:^(id data) {
        
        if (success){
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

+ (void)getSellerProductsWithProductType:(MyProductType)productType keyword:(NSString *)keyword pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 kHTTP_PAGENO_KEY2:@(pageNo),
                                 kHTTP_PAGESIZE_KEY2:pageSize
                                 };
    NSMutableDictionary *par = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (productType != MyProductType_None)
    {
        [par setObject:@(productType) forKey:@"productType"];
    }
    if (keyword)
    {
        [par setObject:keyword forKey:@"keyword"];
    }
    [[ProductMdoleAPI alloc] getRequest:kShop_search_getSellerProducts parameters:par success:^(id data) {
        
        if (success)
        {
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            
            NSArray * dataArray = [data objectForKey:@"list"];
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[MyProductSearchModel class] fromJSONArray:dataArray error:error];
            if (error){
                if (failure) failure(*error);
            }else
            {
                success(array,page);
            }
            
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}




+ (void)getSearchCategoryWithWord:(NSString *)word shopId:(NSString *)shopId pageNum:(NSString *)pageNum pageSize:(NSString *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (word){
        [parameters setObject:word forKey:@"word"];
    }
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    if (pageNum){
        [parameters setObject:pageNum forKey:@"pageNum"];
    }
    if (pageSize){
        [parameters setObject:pageSize forKey:@"pageSize"];
    }
    [[ProductMdoleAPI alloc] getRequest:kProduct_search_SearchSysCategory_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYCategoryModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            if (failure&&error){
                failure(*error);
            }else{
                success(array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
    
}

+ (void)postNotFoundcategoryString:(NSString *)string shopId:(NSString *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (string){
        [parameters setObject:string forKey:@"word"];
    }
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_cateNotFound_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

/**
 //330001_运费模板列表
 
 @param appendMore 是否需要返回具体运费信息
 @param success success description
 @param failure failure description
 */
+ (void)getShopFreightListWithAppendMore:(BOOL)appendMore success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
        @"appendMore":@(appendMore),
    };
    [[ProductMdoleAPI alloc] getRequest:kShop_freight_getFreightList parameters:parameters success:^(id data) {
        if ([data isEqual:[NSNull null]]) {
            success(nil);
        }else{
            NSError *__autoreleasing *error = nil;
            FreightListModel *model = [MTLJSONAdapter modelOfClass:[FreightListModel class] fromJSONDictionary:data error:error];
            if (error){
                if (failure)
                    failure(*error);
            }else{
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)getShopCategoryDataWithShopId:(NSString *)shopId appendNoGroup:(BOOL)isNoGroup success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    [parameters setObject:@(isNoGroup) forKey:@"appendNoGroup"];
    [[ProductMdoleAPI alloc] getRequest:kShop_categoryQuery_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYShopCategoryInfoModel class] fromJSONArray:[data objectForKey:@"catgs"] error:error];
            if (failure&&error){
                failure(*error);
            }else{
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryCreatNewByName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name){
        [parameters setObject:name forKey:@"name"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_categoryNew_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryRenameById:(NSString *)categoryId rename:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (categoryId){
        [parameters setObject:categoryId forKey:@"id"];
    }
    if (name){
        [parameters setObject:name forKey:@"name"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_categoryModifyName_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryRemoveById:(NSString *)categoryId upDown:(NSInteger)upDown success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (categoryId){
        [parameters setObject:categoryId forKey:@"id"];
    }
    [parameters setObject:@(upDown) forKey:@"upDown"];
    [[ProductMdoleAPI alloc] postRequest:kShop_categoryModifyIndex_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryDelById:(NSString *)categoryId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (categoryId){
        [parameters setObject:categoryId forKey:@"id"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_categoryDel_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)getShopCategoryListByShopId:(NSString *)shopId shopCatgId:(NSString *)shopCatgId pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (shopCatgId){
        [parameters setObject:shopCatgId forKey:@"shopCatgId"];
    }
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    [parameters setObject:@(pageNo) forKey:@"pageNo"];
    [parameters setObject:@(pageSize) forKey:@"pageSize"];
    
    [[ProductMdoleAPI alloc] getRequest:kShop_categoryList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYShopCategoryGoodsModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            if (failure&&error){
                failure(*error);
            }else{
                success(array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryBatchMoveFromCategory:(NSString *)from toCategory:(NSString *)to prodIds:(NSString *)prodIds success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (from){
        [parameters setObject:from forKey:@"from"];
    }
    if (to){
        [parameters setObject:to forKey:@"to"];
    }
    if (prodIds) {
        [parameters setObject:prodIds forKey:@"prodIds"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_categoryBatchMove_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

+ (void)postShopCategoryBatchDelById:(NSString *)categoryId prodIds:(NSString *)prodIds success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (categoryId){
        [parameters setObject:categoryId forKey:@"id"];
    }
    if (prodIds){
        [parameters setObject:prodIds forKey:@"prodIds"];
    }
    [[ProductMdoleAPI alloc] postRequest:kShop_prod_categoryBatchDel_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}


+ (void)getQueryIsExistWaterMarkWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [[ProductMdoleAPI alloc] getRequest:kShop_queryIsExistWaterMark_URL parameters:nil success:^(id data) {
        
        if (success){
            
            NSNumber *userWm = [data objectForKey:@"useWm"];
            success(userWm);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}

+ (void)postUploadGetWaterMarkPicWithPicUrl:(NSString *)picUrl success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"picUrl":picUrl,
                                 };
    [[ProductMdoleAPI alloc] postRequest:kShop_uploadGetWaterMarkPic_URL parameters:parameters success:^(id data) {
        
        if (success){
            success([data objectForKey:@"wmPicUrl"]);
        }
        
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}
@end
