//
//  LiveActionAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "LiveActionAPI.h"
#import "LiveAcitonModel.h"

@implementation LiveActionAPI

//获取实景
-(void)getLiveActionWithShopId:(NSNumber *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Info_getLiveAction_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            LiveAcitonModel *model = [MTLJSONAdapter modelOfClass:[LiveAcitonModel class] fromJSONDictionary:data error:error];
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

//增修实景
-(void)addOrUpdateLiveActionWith:(NSNumber *)shopId left:(NSString *)left center:(NSString *)center right:(NSString *)right others:(NSString *)others success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"left":left,
                                 @"center":center,
                                 @"right":right,
                                 @"others":others
                                 };
    [self postRequest:Edit_addOrUpdateLiveAction_URL parameters:parameters success:^(id data) {
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
@end
