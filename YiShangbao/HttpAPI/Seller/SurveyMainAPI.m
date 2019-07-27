//
//  SurveyMainAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "SurveyMainAPI.h"
#import "SurveyModel.h"

@implementation SurveyMainAPI

// 获取经侦查询列表
- (void)getDetectionSearchListWithsearchKey:(NSString *)searchKey hasReadReported:(NSNumber *)hasReadReported comType:(NSString *)comType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"searchKey":searchKey,
                                 @"hasReadReported":hasReadReported,
                                 @"comType":comType,
                                 @"pageNo":pageNo,
                                 @"pageSize":pageSize
                                 };
    [self getRequest:List_DetectionSearchList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray * dataArray = [data objectForKey:@"records"];
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[DetectSearchModel class] fromJSONArray:dataArray error:error];
            NSLog(@"array = %@",array);
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 获取失信通报详情接口
- (void)getCircularDetailWithid:(NSString *)detectionID success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"id":detectionID
                                 };
    [self getRequest:Detail_CircularDetail_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            CircularDetailModel *model = [MTLJSONAdapter modelOfClass:[CircularDetailModel class] fromJSONDictionary:data error:error];
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
        if (failure) {
            failure(error);
        }
    }];
}



// 获取填报详情接口
//-(void)getReportedDetailWithid:(NSString *)detectionID feedback_count:(NSInteger)feedback_count reported_count:(NSInteger)reported_count success:(CompleteBlock)success failure:(ErrorBlock)failure{
//    NSDictionary *parameters = @{};
//    [self postRequest:Detail_ReportedDetail_URL parameters:parameters success:^(id data) {
//        if (success) {
//            NSArray * dataArray = [data objectForKey:@"list"];
//            
//            NSError *__autoreleasing *error = nil;
//            NSArray *array = [MTLJSONAdapter modelsOfClass:[ReportedDetailModel class] fromJSONArray:dataArray error:error];
//            NSLog(@"array = %@",array);
//            if (failure&&error)
//            {
//                failure(*error);
//            }
//            else
//            {
//                success(array);
//            }
//        }
//    } failure:^(NSError *error) {
//        if (failure) {
//            failure(error);
//        }
//    }];
//}
-(void)getReportedDetailWithid:(NSString *)detectionID success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"id":detectionID};
    [self getRequest:Detail_ReportedDetail_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ReportedDetailModel *model = [MTLJSONAdapter modelOfClass:[ReportedDetailModel class] fromJSONDictionary:data error:error];
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
        if (failure) {
            failure(error);
        }
    }];
}

// 获取失信通报列表接口
-(void)getCircularListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:List_CircularList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray * dataArray = [data objectForKey:@"records"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[CircularListModel class] fromJSONArray:dataArray error:error];
            NSLog(@"array = %@",array);
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// 获取经侦查询历史
-(void)getSearchHistoryListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:List_SearchHistoryList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray * dataArray = [data objectForKey:@"searchKeyHis"];
            success(dataArray);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// 获取诈骗案例列表接口
-(void)getFraudCaseListWithPageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"pageNo"  :   @(pageNo),
                                 @"pageSize":   pageSize
                                 };
    [self getRequest:List_FraudCaseList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray * dataArray = [data objectForKey:@"list"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[SurveyModel class] fromJSONArray:dataArray error:error];
            NSLog(@"array = %@",array);
            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

@end
