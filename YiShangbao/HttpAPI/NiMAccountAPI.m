//
//  NiMAccountAPI.m
//  YiShangbao
//
//  Created by simon on 17/5/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "NiMAccountAPI.h"

@implementation NiMAccountAPI


- (void)getChatUserIMInfoWithIDType:(NIMIDType)type thisId:(NSString *)aId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{kHTTP_ID_KEY:aId,@"type":@(type)};
    [self getRequest:kNIM_getChatUserIMInfo parameters:parameters success:^(id data) {
        
        if (success) {
            
            success(data);
//            NSError *__autoreleasing *error = nil;
//            IMChatInfoModel *model = [MTLJSONAdapter modelOfClass:[IMChatInfoModel class] fromJSONDictionary:data error:error];
//
//            if (failure&&error)
//            {
//                failure(*error);
//            }
//            else
//            {
//                success(model);
//            }
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}

- (void)getChatUserIMInfo2WithIDType:(NIMIDType)type thisId:(NSString *)aId productId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{kHTTP_ID_KEY:aId,@"type":@(type),@"prodId":productId};
    [self getRequest:kNIM_getChatUserIMInfo parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            IMChatInfoModel *model = [MTLJSONAdapter modelOfClass:[IMChatInfoModel class] fromJSONDictionary:data error:error];
            
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


- (void)getNIMUserIMInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kNIM_getUserIMInfo parameters:nil success:^(id data) {
        
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

/**
 801003_批量发送点对点消息接口
 
 @param toIds 批量发送的对象用户id，多个id间用逗号分隔，最多9个
 @param picUrl 图片url
 @param recommendation 推荐语
 @param title 标题
 @param linkUrl 链接url
 @param addedText 添加的文字内容，可为空
 @param success success description
 @param failure failure description
 */
- (void)postNIMSendBatchMsgToIds:(NSString *)toIds picUrl:(NSString *)picUrl recommendation:(NSString *)recommendation title:(NSString *)title linkUrl:(NSString *)linkUrl addedText:(NSString *)addedText success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (toIds) {
        [parameters setObject:toIds forKey:@"toIds"];
    }
    if (picUrl) {
        [parameters setObject:picUrl forKey:@"picUrl"];
    }
    if (recommendation) {
        [parameters setObject:recommendation forKey:@"recommendation"];
    }
    if (title) {
        [parameters setObject:title forKey:@"title"];
    }
    if (linkUrl) {
        [parameters setObject:linkUrl forKey:@"linkUrl"];
    }
    if (addedText) {
        [parameters setObject:addedText forKey:@"addedText"];
    }
    [self postRequest:kNIM_sendBatchMsg_URL parameters:parameters success:^(id data) {
        
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


- (void)getNIMSupportIMAccidWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kNIM_getSupportIMAccid_URL parameters:nil success:^(id data) {
        
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
@end
