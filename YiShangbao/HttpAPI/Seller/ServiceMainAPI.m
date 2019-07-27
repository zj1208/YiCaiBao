//
//  ServiceMainAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ServiceMainAPI.h"
#import "ServiceModel.h"

@implementation ServiceMainAPI

// 获取转租转让列表
- (void)getSubletOrTransferListWithNULLSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:List_SubletOrTransferList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSArray * dataArray = [data objectForKey:@"records"];
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[ServiceModel class] fromJSONArray:dataArray error:error];
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

// 获取转租转让列表
- (void)getSubletOrTransferListWithPage:(NSNumber *)page pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"currentPage"         :page,
                                 @"recordPerPage"       :pageSize
                                 };
    [self getRequest:List_SubletOrTransferList_URL parameters:parameters success:^(id data) {
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            SubletListModel *model = [MTLJSONAdapter modelOfClass:[SubletListModel class] fromJSONDictionary:data error:error];
            if (failure&&error){
                failure(*error);
            }else{
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getAuthResultWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Result_AuthResult_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
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
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getAuthResultWithModuleTypeName:(NSString *)moduleType success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{@"moduleType":moduleType,@"v":@"2.0"};
    [self getRequest:Result_AuthResult_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
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
        if (failure) {
            failure(error);
        }
    }];

}

- (void)getBlgAuthResultWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Result_BlgAuthResult_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            if (failure&&error){
                failure(*error);
            }else {
                success(data);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//菜单进入权限控制
- (void)getRoleStrategyCtrlWithmoduleType:(NSString *)moduleType success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"moduleType":moduleType
                                 };
    [self getRequest:Get_RoleStrategyCtrl_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
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
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getMenuWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
   
    NSDictionary *parameters = @{@"v":@"1.0",
//                                 @"fromVersion":@"1"
                                 };
    [self getRequest:Get_Menu_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ServiceMenuModel *model = [MTLJSONAdapter modelOfClass:[ServiceMenuModel class] fromJSONDictionary:data error:error];
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
@end
