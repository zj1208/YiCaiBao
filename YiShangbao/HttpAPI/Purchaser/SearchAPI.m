//
//  SearchAPI.m
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SearchAPI.h"
#import "PurClassifyModel.h"
@implementation SearchAPI
-(void)getHotSysCateSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:Get_cat_hotSysCate_URL parameters:nil success:^(id data) {
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            PurClassifyModel *model = [MTLJSONAdapter modelOfClass:[PurClassifyModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)getCatSysCatesURLWithId:(NSNumber *)iid level:(NSNumber *)level Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (iid)
    {
        [parameters setObject:iid forKey:@"id"];
    }
    if (level)
    {
        [parameters setObject:level forKey:@"level"];
    }
    [self getRequest:Get_cat_sysCates_URL parameters:parameters success:^(id data) {
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[SysCateModel class] fromJSONArray:data error:error];
            
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(array);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

    
}
//搜索商铺
-(void)getSearchShopURLWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize searchKeyword:(NSString *)searchKeyword sellChannel:(NSInteger)sellChannel keywordType:(NSInteger)keywordType catId:(NSNumber *)catId submarketIdFilter:(NSString *)submarketIdFilter authStatus:(NSInteger)authStatus success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"pageNo":@(pageNo),
                           @"pageSize":@(pageSize),
                           @"searchKeyword" :searchKeyword,
                           @"sellChannel" :@(sellChannel),
                           @"keywordType" :@(keywordType),
                           @"authStatus" :@(authStatus),

                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (catId)
    {
        [parameters setObject:catId forKey:@"catId"];
    }
    if (submarketIdFilter)
    {
        [parameters setObject:submarketIdFilter forKey:@"submarketIdFilter"];
    }
    [self getRequest:Get_search_searchShop_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSArray * dataArray = [data objectForKey:@"shops"];

            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[SearchShopModel class] fromJSONArray:dataArray error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(array);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
-(void)getSearchGetFilterConditionsURLWithType:(NSInteger)type searchKeyword:(NSString *)searchKeyword keywordType:(NSInteger)keywordType catId:(NSNumber *)catId authStatus:(NSInteger)authStatus Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dic = @{
                          @"v":@"2.0",

                          @"type":@(type),
                          @"searchKeyword" :searchKeyword,
                          @"keywordType" :@(keywordType),
                          @"authStatus" :@(authStatus),

                          };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (catId)
    {
        [parameters setObject:catId forKey:@"catId"];
    }
    [self getRequest:Get_search_getFilterConditions_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            SearchScreenModel *model = [MTLJSONAdapter modelOfClass:[SearchScreenModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

    
}
-(void)getSearchProductAdditionalURWithSearchKeyword:(NSString *)searchKeyword keywordType:(NSNumber *)keywordType catId:(NSNumber *)catId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dic = @{
                                 @"searchKeyword"    :searchKeyword,
                                 @"keywordType"      :keywordType,

                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (catId)
    {
        [parameters setObject:catId forKey:@"catId"];
    }
    [self getRequest:Get_search_searchProductAdditional_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            SearchLunBoMainModel *model = [MTLJSONAdapter modelOfClass:[SearchLunBoMainModel class] fromJSONDictionary:data error:error];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
//（合并相同商铺）
-(void)getSearchProductByShopWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize searchKeyword:(NSString *)searchKeyword productSourceType:(NSInteger)productSourceType keywordType:(NSInteger)keywordType catId:(NSNumber *)catId submarketIdFilter:(NSString *)submarketIdFilter catIdFilter:(NSString *)catIdFilter authStatus:(NSInteger)authStatus success:(CompleteBlock)success failure:(ErrorBlock)failure
{
        NSDictionary * dic = @{
                                      @"pageNo":@(pageNo),
                                      @"pageSize":@(pageSize),
                                      @"searchKeyword" :searchKeyword,
                                      @"productSourceType" :@(productSourceType),
                                      @"keywordType" :@(keywordType),
                                      @"authStatus" :@(authStatus),

                                      };
        NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
        
        if (catId)
        {
            [parameters setObject:catId forKey:@"catId"];
        }
        if (submarketIdFilter)
        {
            [parameters setObject:submarketIdFilter forKey:@"submarketIdFilter"];
        }
        if (catIdFilter)
        {
            [parameters setObject:catIdFilter forKey:@"catIdFilter"];
        }
        [self getRequest:Get_search_searchProductByShop_URL parameters:parameters success:^(id data) {
            
            if (success) {
                
                NSArray * dataArray = [data objectForKey:@"shops"];
                
                NSError *__autoreleasing *error = nil;
                NSArray *array = [MTLJSONAdapter modelsOfClass:[SearchShopModel class] fromJSONArray:dataArray error:error];
                if (failure&&error)
                {
                    failure(*error);
                }
                else
                {
                    if (success) {
                        success(array);
                    }
                }
            }
        } failure:^(NSError *error) {
            if (failure)
            {
                failure(error);
            }
        }];
}
//产品
-(void)getSearchProductWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize searchKeyword:(NSString *)searchKeyword productSourceType:(NSInteger)productSourceType keywordType:(NSInteger)keywordType catId:(NSNumber *)catId submarketIdFilter:(NSString *)submarketIdFilter catIdFilter:(NSString *)catIdFilter authStatus:(NSInteger)authStatus requestId:(NSString *)requestId success:(CompleteBlock)success failure:(ErrorBlock)failure
{

    NSDictionary * dic = @{
                          @"v":@"2.0",
                          
                          @"pageNo":@(pageNo),
                          @"pageSize":@(pageSize),
                          @"searchKeyword" :searchKeyword,
                          @"productSourceType" :@(productSourceType),
                          @"keywordType" :@(keywordType),
                          @"authStatus" :@(authStatus),
                           
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (requestId)
    {
        [parameters setObject:requestId forKey:@"requestId"];
    }
    if (catId)
    {
        [parameters setObject:catId forKey:@"catId"];
    }
    if (submarketIdFilter)
    {
        [parameters setObject:submarketIdFilter forKey:@"submarketIdFilter"];
    }
    if (catIdFilter)
    {
        [parameters setObject:catIdFilter forKey:@"catIdFilter"];
    }
    [self getRequest:Get_search_searchProduct_URL parameters:parameters success:^(id data) {
        
        if (success) {
//            NSArray * tuijianArray = [data objectForKey:@"tryKeywords"]; //试试看推荐关键词数组,先不做
//            if (tuijianArray.count >=1) {
//                
//            }
            
            NSError *__autoreleasing *error = nil;
            SearchProMainModel *model = [MTLJSONAdapter modelOfClass:[SearchProMainModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(model);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    

}
-(void)postDelHistorySearchKeywordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{};
    [self postRequest:Post_search_delHistorySearchKeywords_URL parameters:parameters success:^(id data) {
    if (success) {
        NSError *__autoreleasing *error = nil;
        if (failure&&error)
        {
            failure(*error);
        }
        else
        {
            if (success) {
                success(data);
            }
        }
    }
} failure:^(NSError *error) {
    if (failure) {
        failure(error);
    }
}];

    
}
-(void)getHistorySearchKeywordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{};
    [self getRequest:Get_search_getHistorySearchKeywords_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(data);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
-(void)getGuessYouWantToFindSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{};
    [self getRequest:Get_search_getGuessYouWantToFind_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(data);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    

}



-(void)getHistorySearchKeywordsWithBizType:(NSInteger)bizType success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"bizType":@(bizType)
                                 };
    [self getRequest:Get_search_getHistorySearchKeywords_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(data);
                }
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}
- (void)postDelTradeHistorySearchKeywordsWithBizTyp:(NSInteger)bizType success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizType":@(bizType)
                                  };
    
    [self postRequest:Post_search_delHistorySearchKeywords_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
@end
