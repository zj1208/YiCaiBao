//
//  MessageAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "MessageAPI.h"
#import "MessageModel.h"

#import "SurveyModel.h"
@implementation MessageAPI

//后台广告点击量埋头统计(广告)
-(void)postAddTrackInfoWithAreaId:(NSNumber *)areaId advId:(NSString *)advId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSString* mobileInfo = [NSString stringWithFormat:@"%@,%@",WYUTILITY.iphoneType,CurrentSystemVersion];
    NSDictionary * dic = @{
                                  @"mobileInfo":mobileInfo,
                                  @"action":@"clickAdv",  //clickAdv（点击广告）

                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (areaId){
        [parameters setObject:areaId forKey:@"areaId"];
    }
    if (advId){
        [parameters setObject:advId forKey:@"advId"];
    }
    [self postRequest:Trade_postMonitor_addTrackInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    
}

// 获取消息摘要列表-3.7.0(3.0)
- (void)getAbbrMsgListWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    int receiverType = 0;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        receiverType = 2;
    }else{
        receiverType = 1;
    }
    NSDictionary *parameters = @{@"receiverType" : @(receiverType),
                                 @"v" :@"3.0"
                                 };
    [self getRequest:Main_MessageList_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        MessageModel *model = [MTLJSONAdapter modelOfClass:[MessageModel class] fromJSONDictionary:data error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
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

//获取分类消息列表
- (void)getDetailMsgListWithType:(NSNumber *)type pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure{
    int receiverType = 0;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        receiverType = 2;
    }else{
        receiverType = 1;
    }
    NSDictionary *parameters = @{
                                 @"type":type,
                                 @"pageNo":@(pageNo),
                                 @"pageSize":pageSize,
                                 @"receiverType":@(receiverType)
                                 };
    [self getRequest:Detail_MessageList_URL parameters:parameters success:^(id data) {
        NSDictionary *dic = [data objectForKey:@"page"];
        PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
        
        NSArray * dataArray = [data objectForKey:@"list"];
        
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[MessageDetailModel class] fromJSONArray:dataArray error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(array,page);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//标记消息已查看
-(void)markMsgReadWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    int receiverType = 0;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        receiverType = 2;
    }else{
        receiverType = 1;
    }
    NSDictionary *parameters = @{
                                 @"type":type,
                                 @"receiverType":@(receiverType)
                                 };
    [self postRequest:MarkMsgRead_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
//未读消息数目
-(void)getshowMsgCountWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    int receiverType = 0;
    if ([WYUserDefaultManager getUserTargetRoleType] == 2) {
        receiverType = 2;
    }else{
        receiverType = 1;
    }
    NSDictionary *parameters = @{@"receiverType":@(receiverType)};
    [self getRequest:ShowMsgCount_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取分类消息列表（无需登陆）
- (void)getPublicMsgListWithType:(int)type pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"type":@(type),
                                 @"pageNo":@(pageNo),
                                 @"pageSize":pageSize
                                 };
    [self getRequest:Get_PublicMsgList_URL parameters:parameters success:^(id data) {
        NSArray * dataArray = [data objectForKey:@"list"];
        
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[MarketAnnouncementModel class] fromJSONArray:dataArray error:error];
        NSLog(@"array = %@",array);
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


// 获取分享配置
- (void)getShareWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"type":type,
                                 HEAD_API_VERSION:@"2.0"
                                 };
    [self getRequest:Get_Share_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        shareModel *model = [MTLJSONAdapter modelOfClass:[shareModel class] fromJSONDictionary:data error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getShareWithType:(NSNumber *)type shopId:(NSString *)shopId shopCateName:(NSString *)shopCateName shopCateId:(NSString *)shopCateId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary *dic = @{
                                 @"type":type,
                                 HEAD_API_VERSION:@"2.0"
                                 };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    if (shopCateName){
        [parameters setObject:shopCateName forKey:@"shopCateName"];
    }
    if (shopCateId){
        [parameters setObject:shopCateId forKey:@"shopCateId"];
    }
    [self getRequest:Get_Share_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        shareModel *model = [MTLJSONAdapter modelOfClass:[shareModel class] fromJSONDictionary:data error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//获取最新版本
- (void)checkAppVersionWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"type":@"0",
                                 kROLETYPE_KEY:
                                     @([WYUserDefaultManager getUserTargetRoleType]),
                                 };
    [self getRequest:Get_LastVersion_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        VersionModel *model = [MTLJSONAdapter modelOfClass:[VersionModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//获取区块内容
- (void)GetAdvWithType:(NSNumber *)type success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"id":type
                                 };
    [self getRequest:Get_Adv_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        AdvModel *model = [MTLJSONAdapter modelOfClass:[AdvModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)GetAdvWithType:(NSNumber *)type rnd:(NSNumber *)rnd success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"id":type,
                                 @"rnd":rnd
                                 };
    [self getRequest:Get_Adv_URL parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        AdvModel *model = [MTLJSONAdapter modelOfClass:[AdvModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(model);
            }
        }
    
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)GetFenLeiAdvWithType:(NSNumber *)type sysCatesId:(NSString *)sysCatesId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dic = @{
                                 @"id":type
                                 };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (sysCatesId) {
        NSDictionary* dictjson = @{
                                   @"subId":sysCatesId
                                   };
          [parameters setObject:[NSString zhGetJSONSerializationStringFromObject:dictjson] forKey:@"extra"];
    }
    [self getRequest:Get_Adv_URL parameters:parameters success:^(id data) {
       
        NSArray * dataArray = [data objectForKey:@"items"];
        NSError *__autoreleasing *error = nil;
        NSArray *array = [MTLJSONAdapter modelsOfClass:[FenLeiLunboAdvModel class] fromJSONArray:dataArray error:error];
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(array);
            }
        }

    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getShopQuerySellerMustReadsWithListType:(SellerMustReadsType)type  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"type":@(type),
                                 @"v" :@"2.0"
                                 };
    [self getRequest:kAdv_Get_gquerySellerMustReads parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        if ([data isKindOfClass:[NSDictionary class]])
        {
            ShopMustReadAdvFatherModel *model = [MTLJSONAdapter modelOfClass:ShopMustReadAdvFatherModel.class fromJSONDictionary:data error:error];
            if (error)
            {
                if (failure) failure(*error);
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

/**
 设备更新接口
 */
- (void)PostDeviceInfoWithParameters:(NSDictionary *)params success:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self postRequest:Post_DeviceInfo_URL parameters:params success:^(id data) {
        if (success) {
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//
- (void)updateSoundSettingWithSubject:(NSString*)subject fan:(NSString*)fan visitor:(NSString*)visitor success:(CompleteBlock)success failure:(ErrorBlock)failure{
   
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (subject) {
        [parameters setObject:subject forKey:@"enableSubject"];
    }
    if (fan) {
        [parameters setObject:fan forKey:@"enableFan"];
    }
    if (visitor) {
        [parameters setObject:visitor forKey:@"enableVisitor"];
    }
   
    [self postRequest:Update_SoundSetting_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        if (error)
        {
            if (failure) failure(*error);
        }
        else
        {
            if (success) {
                success(data);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)querySoundSettingWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Query_SoundSetting_URL parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        SoundModel *model = [MTLJSONAdapter modelOfClass:[SoundModel class] fromJSONDictionary:data error:error];
        if (error)
        {
           if (failure) failure(*error);
        }
        else
        {
            if (success) {
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
