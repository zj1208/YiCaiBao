//
//  UserModelExtendAPI.m
//  YiShangbao
//
//  Created by simon on 2018/4/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "UserModelExtendAPI.h"


@implementation UserModelExtendAPI


/**
 //100038_获取联系人列表接口
 
 @param success success description
 @param failure failure description
 */
- (void)getShareLinkmanListSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:kShare_linkmanList_URL parameters:nil success:^(id data) {
        NSError *__autoreleasing *error = nil;
        WYShareLinkmanListModel *model = [MTLJSONAdapter modelOfClass:[WYShareLinkmanListModel class] fromJSONDictionary:data error:error];
        
        if (failure&&error){
            failure(*error);
        }else{
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)getOnlineCustomerListWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"pageNo":@(pageNo),
                                  @"pageSize":@(pageSize)
                                  };
    [self getRequest:kUserEx_getOnlineCustomerList parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSDictionary *dic = [data objectForKey:@"page"];
            PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
            
            NSArray * dataArray = [data objectForKey:@"list"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[OnlineCustomerListModel class] fromJSONArray:dataArray error:error];
            if (failure&&error)
            {
                failure(*error);
            }
            else
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

-(void)postAddOnlineCustomerWithBuyerBizId:(NSString *)buyerBizId source:(AddOnlineCustomerSourceType)source remark:(NSString *)remark mobile:(NSString *)mobile address:(NSString *)address describe:(NSString *)describe success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dict  = @{
                              @"buyerBizId":buyerBizId,
                              @"source":@(source)
                              };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }
    if (mobile) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if (address) {
        [parameters setObject:address forKey:@"address"];
    }
    if (describe) {
        [parameters setObject:describe forKey:@"describe"];
    }
    [self postRequest:kUserEx_addOnlineCustomer parameters:parameters success:^(id data) {
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

- (void)postDeleteOnlineCustomerWithBuyerBizId:(NSString *)buyerBizId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"buyerBizId":buyerBizId
                                  };
    [self postRequest:kUserEx_deleteOnlineCustomer parameters:parameters success:^(id data) {
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

/**
 100042_获取线上客户信息详情
 
 @param buyerBizId 采购商组合id
 @param type 1-添加客户时 2-获取客户详情时 3-修改客户详情时
 */
- (void)getCustomerOnlineInfoWithBuyerBizId:(NSString *)buyerBizId type:(GetCustomerOnlineInfoType)type success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters  = @{
                            @"buyerBizId":buyerBizId,
                            @"type":@(type)
                            };
    [self getRequest:kUserEx_getCustomerOnlineInfo parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            CustomerInfoModel *model = [MTLJSONAdapter modelOfClass:[CustomerInfoModel class] fromJSONDictionary:data error:error];
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


/**
 100043_修改线上客户信息
 
 @param buyerBizId 采购商组合id
 @param remark 备注
 @param mobile 手机
 @param address 地址
 @param describe 描述
 */
- (void)postUpdateCustomerOnlineInfoWithBuyerBizId:(NSString *)buyerBizId remark:(NSString *)remark mobile:(NSString *)mobile address:(NSString *)address describe:(NSString *)describe success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dict  = @{
                            @"buyerBizId":buyerBizId,
                            };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (remark) {
        [parameters setObject:remark forKey:@"remark"];
    }
    if (mobile) {
        [parameters setObject:mobile forKey:@"mobile"];
    }
    if (address) {
        [parameters setObject:address forKey:@"address"];
    }
    if (describe) {
        [parameters setObject:describe forKey:@"describe"];
    }
    [self postRequest:kUserEx_updateCustomerOnlineInfo parameters:parameters success:^(id data) {
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
@end
