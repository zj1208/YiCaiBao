//
//  ShopAPI.m
//  YiShangbao
//
//  Created by 何可 on 2017/2/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ShopAPI.h"

@implementation ShopAPI
-(void)postShopStoreMfyShopMgr4orderWithSysCates:(NSString *)sysCates mainSell:(NSString *)mainSell success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (sysCates) {
        [parameters setObject:sysCates forKey:@"sysCates"];
    }
    if (mainSell) {
        [parameters setObject:mainSell forKey:@"mainSell"];
    }

    [self postRequest:Post_Trade_shop_store_mfyShopMgr4order_URL parameters:parameters success:^(id data) {
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
//创建商铺
-(void)postCreateShopInfoWithParameters:(ShopModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *dic = @{
                                 @"name":model.name,
                                 @"sysCates":model.sysCates,
                                 @"mainSell":model.mainSell,
//                                 @"submarketCode":model.submarketCode,
//                                 @"submarketValue":model.submarketValue,
//                                 @"door":model.door,
//                                 @"floor":model.floor,
//                                 @"street":model.street,
//                                 @"province":model.province,
//                                 @"city":model.city,
//                                 @"area":model.area,
//                                 @"address":model.address,
//                                 @"boothNo":model.boothNos,
                                 @"sellerName":model.sellerName,
                                 @"sellerPhone":model.sellerPhone,
                                 @"sellChannel":model.sellChannel
                                 };
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (model.marketId) {
        [parameters setObject:model.marketId forKey:@"marketId"];
    }
    if (model.submarketCode) {
        [parameters setObject:model.submarketCode forKey:@"submarketCode"];
    }
    if (model.submarketValue) {
        [parameters setObject:model.submarketValue forKey:@"submarketValue"];
    }
    if (model.iconUrl) {
        [parameters setObject:model.iconUrl forKey:@"iconUrl"];
    }
    if (model.door) {
        [parameters setObject:model.door forKey:@"door"];
    }
    if (model.floor) {
        [parameters setObject:model.floor forKey:@"floor"];
    }
    if (model.street) {
        [parameters setObject:model.street forKey:@"street"];
    }
    if (model.province) {
        [parameters setObject:model.province forKey:@"province"];
    }
    if (model.city) {
        [parameters setObject:model.city forKey:@"city"];
    }
    if (model.area) {
        [parameters setObject:model.area forKey:@"area"];
    }
    if (model.address) {
        [parameters setObject:model.address forKey:@"address"];
    }
    if (model.boothNos) {
        [parameters setObject:model.boothNos forKey:@"boothNo"];
    }
    
    [self postRequest:Post_createShopInfo_URL parameters:parameters success:^(id data) {
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

//查询商铺ID（判断是否开店）
-(void)getMyShopIdsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Select_quryShopInfo_URL parameters:parameters success:^(id data) {
        
        if (success) {
            if (![data isEqual:[NSNull null]])
            {
                NSString *idStrings = [data objectForKey:@"ids"];
                NSArray *ids = [idStrings componentsSeparatedByString:@","];
                
                success([ids firstObject]);
            }
            else
            {
                NSLog(@"返回null了");
                success(nil);
            }
        }
     } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

//查询商铺ID（判断是否开店）
-(void)getSynchronousShopIdWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{

    [self synchronouslyGetRequest:Select_quryShopInfo_URL parameters:nil success:^(id data) {
        
        if (success) {
            if (![data isEqual:[NSNull null]])
            {
                NSString *idStrings = [data objectForKey:@"ids"];
                NSArray *ids = [idStrings componentsSeparatedByString:@","];
                
                success([ids firstObject]);
            }
            else
            {
                NSLog(@"返回null了");
                success(nil);
            }
        }

    } failure:^(NSError *error) {
        
        if (failure) {
            failure(error);
        }

    }];
}

//修改商铺头像
-(void)modifyShopIconWithIcon:(NSString *)icon success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"icon":icon
                                 };
    [self postRequest:modify_ShopIcon_URL parameters:parameters success:^(id data) {
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

//获取商铺详情
-(void)getShopDetailWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_ShopDetail_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopListModel *model = [MTLJSONAdapter modelOfClass:[ShopListModel class] fromJSONDictionary:data error:error];
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
//获取商铺地址信息
-(void)getShopArrdWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_ShopArrd_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopAddrModel *model = [MTLJSONAdapter modelOfClass:[ShopAddrModel class] fromJSONDictionary:data error:error];
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

//301100_获取地址信息2

- (void)getShopArrdNewWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    [self getRequest:Get_ShopArrdNew_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopAddrModel *model = [MTLJSONAdapter modelOfClass:[ShopAddrModel class] fromJSONDictionary:data error:error];
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

// 修改地址信息
-(void)modifyShopArrdWithParameters:(ShopAddrModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (model.marketId) {
        [parameters setObject:model.marketId forKey:@"marketId"];
    }
    if (model.submarket) {
        [parameters setObject:model.submarket forKey:@"submarket"];
    }
    if (model.gr1) {
        [parameters setObject:model.gr1 forKey:@"gr1"];
    }
    if (model.gr2) {
        [parameters setObject:model.gr2 forKey:@"gr2"];
    }
    if (model.gr3) {
        [parameters setObject:model.gr3 forKey:@"gr3"];
    }
    if (model.gr4) {
        [parameters setObject:model.gr4 forKey:@"gr4"];
    }
    [self postRequest:Modify_ShopArrd_URL parameters:parameters success:^(id data) {
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

//301101_修改地址信息2
- (void)postModifyShopArrdWithParameters:(ShopAddrModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (model.marketId) {
        [parameters setObject:model.marketId forKey:@"marketId"];
    }
    if (model.submarket) {
        [parameters setObject:model.submarket forKey:@"submarket"];
    }
    if (model.door) {
        [parameters setObject:model.door forKey:@"door"];
    }
    if (model.floor) {
        [parameters setObject:model.floor forKey:@"floor"];
    }
    if (model.street) {
        [parameters setObject:model.street forKey:@"street"];
    }
    if (model.booth) {
        [parameters setObject:model.booth forKey:@"booth"];
    }
    if (model.pro) {
        [parameters setObject:model.pro forKey:@"pro"];
    }
    if (model.city) {
        [parameters setObject:model.city forKey:@"city"];
    }
    if (model.area) {
        [parameters setObject:model.area forKey:@"area"];
    }
    if (model.addr) {
        [parameters setObject:model.addr forKey:@"addr"];
    }
    [self postRequest:Modify_ShopArrdNew_URL parameters:parameters success:^(id data) {
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



//获取商铺简介
-(void)getShopIntroduceWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_ShopIntroduce_URL parameters:parameters success:^(id data) {
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


//修改简介
-(void)modifyShopIntroduceWithoutline:(NSString *)outline success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"outline":outline
                                 };
    [self postRequest:Modify_ShopIntroduce_URL parameters:parameters success:^(id data) {
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

/**
 获取经营信息
 */
-(void)getShopManagerInfoWithshopId:(NSString *)shopId success:(CompleteBlock)success failure:(ErrorBlock)failure{

    [self getRequest:Get_ShopManagerInfo_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopManagerInfoModel *model = [MTLJSONAdapter modelOfClass:[ShopManagerInfoModel class] fromJSONDictionary:data error:error];
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

/**
 更新经营信息
 */
-(void)modifyShopManagerInfoWithParameters:(ShopManagerInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
//    NSDictionary *parameters = @{
//                                 @"id":model.shopId,
//                                 @"sysCates":model.sysCates,
//                                 @"mainSell":model.mainSell,
//                                 @"mainBrand":model.mainBrand,
//                                 @"mgrPeriod":model.mgrPeriod,
//                                 @"mgrType":model.mgrType,
//                                 @"factoryPics":model.factoryPics,
//                                 @"sellChannel":model.sellChannel
//                                 };
    NSDictionary * dic = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    NSMutableDictionary *parameters = [dic mutableCopy];
    [parameters removeObjectForKey:@"sysCates"];
    [parameters setObject:model.sysCatesIds forKey:@"sysCates"];
    [self postRequest:Modify_ShopManagerInfo_URL parameters:parameters success:^(id data) {
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

/**
 获取联系信息
 */
-(void)getShopContactWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_ShopContact_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopContactModel *model = [MTLJSONAdapter modelOfClass:[ShopContactModel class] fromJSONDictionary:data error:error];
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

/**
 修改联系信息
 */
-(void)modifyShopContactWithParameters:(ShopContactModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
//    NSDictionary *parameters = @{
//                                 @"id":model.shopContactId,
//                                 @"shopId":model.shopId,
//                                 @"sellerName":model.sellerName,
//                                 @"sellerPhone":model.sellerPhone,
//                                 @"tel":model.tel,
//                                 @"fax":model.fax,
//                                 @"qq":model.qq,
//                                 @"wechat":model.wechat,
//                                 @"email":model.email
//                                 };
    [self postRequest:Modify_ShopContact_URL parameters:parameters success:^(id data) {
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

/**
 获取银行账户信息
 */
-(void)getAcctInfoWithType:(NSNumber *)type Success:(CompleteBlock)success failure:(ErrorBlock)failure

{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (type) {
        [parameters setObject:type forKey:@"type"];
    }
    [self getRequest:Get_AcctInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[AcctInfoModel class] fromJSONArray:data error:error];
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

/**
 增加银行账户信息
 */
-(void)addAcctInfoWithChannel:(NSNumber *)channel Parameters:(AcctInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary *dict = @{
                                 @"bankId":model.bankId,
                                 @"bankCode":model.bankCode,
                                 @"bankValue":model.bankValue,
                                 @"bankNo":model.bankNo,
                                 @"bankPlace":model.bankPlace,
                                 @"acctName":model.acctName
                                 };
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (channel) {
        [parameters setObject:channel forKey:@"channel"];
    }
    [self postRequest:Add_AcctInfo_URL parameters:parameters success:^(id data) {
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

/**
 删除银行账户信息
 */
-(void)deleteAcctInfoWithAccId:(NSNumber *)AccId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{@"id":AccId};
    [self postRequest:Delete_AcctInfo_URL parameters:parameters success:^(id data) {
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

/**
 修改账户信息
 */
-(void)updateAcctInfoWithChannel:(NSNumber *)channel Parameters:(AcctInfoModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *dict = @{
                                 @"id":model.shopId,
                                 @"bankId":model.bankId,
                                 @"bankCode":model.bankCode,
                                 @"bankValue":model.bankValue,
                                 @"bankNo":model.bankNo,
                                 @"bankPlace":model.bankPlace,
                                 @"acctName":model.acctName
                                 };
    NSMutableDictionary* parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (channel) {
        [parameters setObject:channel forKey:@"channel"];
    }
    [self postRequest:Update_AcctInfo_URL parameters:parameters success:^(id data) {
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

//获取银行列表
-(void)getBankListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_BankList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[BankModel class] fromJSONArray:data error:error];
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

-(void)getMarketsWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"ext":@"1"
                                 };
    [self getRequest:Get_Markets_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[marketModel class] fromJSONArray:data error:error];
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


// 711030_获取市场New

- (void)getMarketsByCity:(NSString *)city success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary*parameters = [NSMutableDictionary dictionary];
    if (city)
    {
        [parameters setObject:city forKey:@"city"];
    }
    [self getRequest:Get_MarketsNew_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[marketModel class] fromJSONArray:data error:error];
            if (failure&&error){
                failure(*error);
            }else{
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
/**
 获取公告
 */
-(void)getShopAnnouncementWithsuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{};
    [self getRequest:Get_ShopAnnouncement_URL parameters:parameters success:^(id data) {
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


/**
 增加公告
 */
-(void)addShopAnnouncementWithshopId:(NSString *)shopId content:(NSString *)content success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"shopId":shopId,
                                 @"content":content
                                 };
    [self postRequest:Add_ShopAnnouncement_URL parameters:parameters success:^(id data) {
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

/**
 获取系统类目
 */
-(void)getSysCatesWithId:(NSNumber *)tagId level:(NSNumber *)level success:(CompleteBlock)success failure:(ErrorBlock)failure{

    NSMutableDictionary*parameters = [NSMutableDictionary dictionary];
    if (tagId)
    {
        [parameters setObject:tagId forKey:@"id"];
    }
    if (level)
    {
        [parameters setObject:level forKey:@"level"];
    }
    [self getRequest:Get_SysCates_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[SysCateModel class] fromJSONArray:data error:error];
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

- (void)postShopTradeSettingWithStatus:(NSNumber *)status success:(CompleteBlock)success failure:(ErrorBlock)failure{
    
    NSDictionary *parameters = @{
                                 @"status":status
                                 };
    
    [self postRequest:Post_mtop_shop_store_modifyShopCantrade_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


- (void)postShopStorePruneNewOrderMarkWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kShop_store_pruneNewOrderMark_URL parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getShopStoreCheckShopName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name){
        [parameters setObject:name forKey:@"name"];
    }
    [self getRequest:kShop_store_CheckShopname_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postShopStoreModifyShopName:(NSString *)name success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name){
        [parameters setObject:name forKey:@"name"];
    }
    [self postRequest:kShop_store_modifyShopName_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

// 点击刷新
- (void)postShopStoreFlushClickWithName:(NSString *)name  success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (name){
        [parameters setObject:name forKey:@"name"];
    }
    [self postRequest:kShop_store_flushSubscribe_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}


//商铺设置查看
- (void)getShopStoreShopInfoNewSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:kShop_store_getShopInfoNew_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ShopInfoModel *model = [MTLJSONAdapter modelOfClass:[ShopInfoModel class] fromJSONDictionary:data error:error];
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


- (void)getShopHomeInfoWithFactor:(NSNumber *)factor Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary *parameters = @{
                                 @"factor":factor
                                 };
    [self getRequest:kShop_store_shopHome parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        ShopHomeInfoModel *shopModel = [MTLJSONAdapter modelOfClass:[ShopHomeInfoModel class] fromJSONDictionary:data error:error];
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


//301051_关注、取关店铺

- (void)postShopAttentionShopId:(NSString *)shopId status:(NSString *)status success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary *parameters = @{
                                 @"shopId":shopId,
                                 @"status":status,
                                 };
    [self postRequest:kShop_store_attention parameters:parameters success:^(id data) {
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
