//
//  TradeMainAPI.m
//  YiShangbao
//
//  Created by Lance on 17/1/3.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "TradeMainAPI.h"

@implementation TradeMainAPI

- (void)getkTradeReleaseBusinessListURLBuyerId:(NSString *)buyerId pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary * parameters = @{
                                  @"buyerId"    :buyerId,
                                  @"pageNum"    :@(pageNum),
                                  @"pageSize"   :@(pageSize)
                                  };
    [self getRequest:kTrade_get_releaseBusinessList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[ReleaseBusniessModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            
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

-(void)postMtopOrderRomSetURLWithRom:(BOOL)rom success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSNumber*num = [NSNumber numberWithBool:rom];
    NSDictionary * parameters = @{
                           @"rom":num
                           };
    [self postRequest:kTrade_post_mtop_order_romSet_URL parameters:parameters success:^(id data) {
        if (success) {
            
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
}
-(void)getkTradeMtopOrderRomQueryURLsuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kTrade_get_mtop_order_romQuery_URL parameters:nil success:^(id data) {
        
        if (success)
        {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    
}
- (void)getkTradeGetOrderSubjectIncrementsuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kTrade_get_order_subject_increment_URL parameters:nil success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
//            TradeMoveTitleModel *model = [MTLJSONAdapter modelOfClass:[TradeMoveTitleModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(data);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];
    

}
-(void)getTradeAdvWithQuKuaiID:(NSInteger)iid success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"id":@(iid),
                                  };
    [self getRequest:Trade_getAdv_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            TradeMoveTitleModel *model = [MTLJSONAdapter modelOfClass:[TradeMoveTitleModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
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

- (void)getTradeBussinessListWithBided:(NSMutableArray *)bidedArray ignored:(NSMutableArray *)ignoredArray  pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize  relatedToMe:(TradeRelatedToMeListType)relatedtoMeType  requestId:(NSString *)requestId success:(void(^)(id data,PageModel *pageModel,NSString * responseId))success failure:(ErrorBlock)failure
{
    NSDictionary * par = @{
                                  kHTTP_PAGENO_KEY:@(pageNo),
                                  kHTTP_PAGESIZE_KEY:pageSize,
                                  @"rtm":@(relatedtoMeType),
                                  @"v" :@"2.0"
                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:par];
    
    if (bidedArray.count>0)
    {
        NSString *bided = [bidedArray componentsJoinedByString:@","];
        [parameters setObject:bided forKey:@"bided"];
    }
//    忽略有问题，会报错，目前不传；
    if (ignoredArray.count>0)
    {
        NSString *ignored = [ignoredArray componentsJoinedByString:@","];
        [parameters setObject:ignored forKey:@"ignored"];
    }
    if (requestId)
    {
        [parameters setObject:requestId forKey:@"requestId"];
    }
    [self getRequest:kTrade_BusinessList_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            
            NSArray * dataArray = [data objectForKey:@"list"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYTradeModel class] fromJSONArray:dataArray error:error];
            
            NSString * responseId = [data objectForKey:@"responseId"];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array, page,responseId);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}
//生意搜索
- (void)getSearchTradeBussinessListPageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize keywords:(NSString *)keywords  requestId:(NSString *)requestId success:(void(^)(id data,PageModel *pageModel,NSString * responseId))success failure:(ErrorBlock)failure
{
    NSDictionary * par = @{
                           kHTTP_PAGENO_KEY:@(pageNo),
                           kHTTP_PAGESIZE_KEY:pageSize,
                           @"keywords":keywords

                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:par];
    if (requestId)
    {
        [parameters setObject:requestId forKey:@"requestId"];
    }
    [self getRequest:kTrade_businessSearchList_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            
            NSArray * dataArray = [data objectForKey:@"list"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYTradeModel class] fromJSONArray:dataArray error:error];
            
            NSString * responseId = [data objectForKey:@"responseId"];
            
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array, page,responseId);
            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

    
}



- (void)getTradeBussinessDetailWithPostId:(NSString *)postId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{kHTTP_ID_KEY:postId,HEAD_API_VERSION:@"2.0"};
    [self getRequest:kTrade_detail_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            TradeDetailModel *model = [MTLJSONAdapter modelOfClass:[TradeDetailModel class] fromJSONDictionary:data error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
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


- (void)getMyTradeBusinessListWithType:(WYBuyType)buyType pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"v" :@"2.0",
                                  kHTTP_PAGENO_KEY:@(pageNo),
                                  kHTTP_PAGESIZE_KEY:pageSize
                                  };
    
    [self getRequest:kTrade_myBusinessList_URL parameters:parameters success:^(id data) {
        
        if (success) {
            NSArray * dataArray = [data objectForKey:@"list"];
          
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[MYTradeUnderwayModel class] fromJSONArray:dataArray error:error];
          
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array,page);
            }
        }
    } failure:failure];
}


- (void)getTradeDetailTakeOrderingWithPostId:(NSString *)postId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{@"sid":postId,@"v":@"2.0"};
    [self getRequest:kTrade_detailTakeOrdering_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

- (void)postOrderWithPostId:(NSString *)postId replyContent:(NSString *)content promptGoodsType:(WYPromptGoodsType)goodsType price:(NSString *)price minCount:(NSString *)countString photos:(NSArray *)photosArray success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSDictionary * dic = @{@"sid":postId,@"desc":content,@"st":@(goodsType),@"p":price};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (countString)
    {
        [parameters setObject:countString forKey:@"mq"];
    }
    if (photosArray)
    {
        [parameters setObject:photosArray forKey:@"pics"];
    }
    [self postRequest:kTrade_postOrder_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];


}


- (void)getRemainOrderingTimesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kTrade_remainOrderingTimes_URL parameters:nil success:^(id data) {
        if (success) {
                   success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];

}
//评价页面初始化
- (void)getTradeInitEvaluateInfoWithIdentityType:(NSNumber *)identityType tradeId:(NSString *)sid success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{@"rt":identityType,
                                 @"sid":sid
                                 };
    [self getRequest:kTrade_evalueteInitInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MyEvaluateModel *model = [MTLJSONAdapter modelOfClass:[MyEvaluateModel class] fromJSONDictionary:data error:error];
            success(model);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}



- (void)postTradeCommentWithPostId:(NSString *)postId content:(NSString *)content starNum:(NSNumber *)starNum tag:(NSString *)tags identityType:(NSNumber *)identityType evaluate:(NSString *)ratings  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                                  @"sid" :postId,
                                  @"s":starNum,
                                  @"ls":tags,
                                  @"rt":identityType,
                                  @"ratings":ratings
                                  };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (content){
        [parameters setObject:content forKey:@"d"];
    }
    [self postRequest:kTrade_evaluate_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getTradeEvaluateListByBuyerId:(NSString *)uid pageNum:(NSNumber *)pageNum pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure{
    NSDictionary * parameters = @{
                           @"uid"       :uid,
                           @"pageNum"   :pageNum,
                           @"pageSize"  :pageSize,
                           };
    
    [self getRequest:kTrade_buyerEvalueteList_URL parameters:parameters success:^(id data) {
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[EvaluateInfoModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            if (failure&&error){
                failure(*error);
            }else{
                success(array,page);
            }        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getTradePicClickWithTradeId:(NSString *)tradeId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{@"id":tradeId};
    [self getRequest:kTrade_ClickPic_URL parameters:parameters success:^(id data) {
        if (success) {
            
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


- (void)postIgnoreSubjectWithTradeId:(NSString *)tradeId reason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"subjectId" :tradeId,
                           };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    if (reason){
        [parameters setObject:reason forKey:@"reason"];
    }
    [self postRequest:kTrade_post_ignoreSubject_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getTranslatorSimpleWithType:(WYTranslatorType )type sources:(NSArray *)sources  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (type == WYTranslatorType_CN_to_EN) {
        [parameters setObject:@"zh_CN" forKey:@"srcLang"];
        [parameters setObject:@"en" forKey:@"destLang"];
    }else{
        [parameters setObject:@"en" forKey:@"srcLang"];
        [parameters setObject:@"zh_CN" forKey:@"destLang"];
    }
    
   NSString *sou = [NSString zhGetJSONSerializationStringFromObject:sources];
    if (sou) {
        [parameters setObject:sou forKey:@"sources"];
    }
    
    [self getRequest:kTrade_get_translatorSimple_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray *arr = [data objectForKey:@"translation"];
            success(arr);
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}


@end
