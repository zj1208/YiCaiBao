//
//  ExtendProductAPI.m
//  YiShangbao
//
//  Created by 海狮 on 17/5/17.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "ExtendProductAPI.h"

@implementation ExtendProductAPI

-(void)getExtendOldSpreadWithOldId:(NSNumber *)oldId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (oldId){
        [parameters setObject:oldId forKey:@"id"];
    }
    [self getRequest:Extent_Get_getSpread parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            ExtendOldModel *model = [MTLJSONAdapter modelOfClass:[ExtendOldModel class] fromJSONDictionary:data error:error];
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

-(void)getExtentgetMarketQualiInfoSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:Extent_Get_getMarketQualiInfo parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)getExtentShopCategoryDataWithShopId:(NSString *)shopId appendNoGroup:(BOOL)isNoGroup success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{@"v":@"2.0"};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (shopId){
        [parameters setObject:shopId forKey:@"shopId"];
    }
    [parameters setObject:@(isNoGroup) forKey:@"appendNoGroup"];
    [[ProductMdoleAPI alloc] getRequest:kShop_categoryQuery_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            
            NSArray *array = [MTLJSONAdapter modelsOfClass:[WYShopCategoryInfoModel class] fromJSONArray:[data objectForKey:@"catgs"] error:error];
            if (failure&&error){
                failure(*error);
            }else{
                success(array);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

-(void)getExtendChooseProductWithShopCategoryId:(NSString *)shopCategoryId name:(NSString *)name pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dict = @{
                                  @"pageNum"    :@(pageNum),
                                  @"pageSize"   :@(pageSize)
                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dict];
    if (shopCategoryId) {
        [parameters setObject:shopCategoryId forKey:@"shopCategoryId"];
    }
    if (name) {
        [parameters setObject:name forKey:@"name"];
    }
    [self getRequest:Extent_Get_spread_chooseProduct parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
           
            NSArray *array = [MTLJSONAdapter modelsOfClass:[ExtendSelectProcuctModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
            
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
-(void)postExtendWithCateLevel:(NSNumber *)cateLevel Desc:(NSString *)desc sysCate:(NSString *)sysCate photos:(NSArray *)photosArray success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSString* strtype = [NSString string];
    if ([cateLevel isEqualToNumber:@2]) {
        strtype = Post_addExtendInventory_URL;
    }else if ([cateLevel isEqualToNumber:@1]){
        strtype = Post_addExtendProduct_URL;
    }
    
    NSDictionary * dic = @{@"desc":desc,@"sysCate":sysCate};
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (photosArray)
    {
        [parameters setObject:photosArray forKey:@"pics"];
    }
    [self postRequest:strtype parameters:parameters success:^(id data) {
        
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

-(void)getExtendProductOrInventoryWithNumId:(NSNumber *)numId Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSString* strtype = [NSString string];
    if ([numId isEqualToNumber:@2]) {
        strtype = Get_initExtendInventory_URL;
    }else if ([numId isEqualToNumber:@1]){
        strtype = Get_initExtendProduct_URL;
    }
    NSDictionary * dic = @{@"v":@"2.0"};
    [self getRequest:strtype parameters:dic success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            ExtendModel *model = [MTLJSONAdapter modelOfClass:[ExtendModel class] fromJSONDictionary:data error:error];
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
- (void)getRemainExtendTimesWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:Get_remainExtendTimes parameters:nil success:^(id data) {
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
