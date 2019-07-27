//
//  SurveyMainAPI.h
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"

#pragma mark - Survey URL

//701001 获取经侦查询列表
#define List_DetectionSearchList_URL        @"mtop.external.detection.getDetectionSearchList"
//701002_获取失信通报详情接口
#define Detail_CircularDetail_URL             @"mtop.external.detection.getCircularDetail"
//701003_获取填报详情接口
#define Detail_ReportedDetail_URL             @"mtop.external.detection.getReportedDetail"
//701004_获取失信通报列表接口
#define List_CircularList_URL               @"mtop.external.detection.getCircularList"
//701010_获取经侦查询历史
#define List_SearchHistoryList_URL          @"mtop.external.detection.getSearchHistoryList"
//701011_获取诈骗案例列表接口
#define List_FraudCaseList_URL              @"mtop.external.detection.getFraudCaseList"


@interface SurveyMainAPI : BaseHttpAPI


/**
 获取经侦查询列表

 @param searchKey 搜索字段
 @param hasReadReported 已经读取的填报记录数，默认-1
 @param comType 公司类型，默认0
 @param pageNo 页码，默认第1页
 @param pageSize 单页记录数，默认10条
 @param success success block
 @param failure failure block
 
 */
- (void)getDetectionSearchListWithsearchKey:(NSString *)searchKey hasReadReported:(NSNumber *)hasReadReported comType:(NSString *)comType pageNo:(NSString *)pageNo pageSize:(NSString *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 获取失信通报详情接口

 @param detectionID 经侦id
 @param success success block
 @param failure failure block
 */
- (void)getCircularDetailWithid:(NSString *)detectionID success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取填报详情接口

 @param detectionID 经侦id
 @param feedback_count 反馈信息条数
 @param reported_count 填报信息条数
 @param success success description
 @param failure failure description
 */
//-(void)getReportedDetailWithid:(NSString *)detectionID feedback_count:(NSInteger)feedback_count reported_count:(NSInteger)reported_count success:(CompleteBlock)success failure:(ErrorBlock)failure;
-(void)getReportedDetailWithid:(NSString *)detectionID success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取失信通报列表接口

 @param success success block
 @param failure failure block
 */
-(void)getCircularListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取经侦查询历史

 @param success success block
 @param failure failure block
 */
-(void)getSearchHistoryListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 获取诈骗案例列表接口

 @param pageNo 页码，默认1
 @param pageSize 单页的纪录数，默认10
 @param success success block
 @param failure failure block
 */
-(void)getFraudCaseListWithPageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure;







@end
