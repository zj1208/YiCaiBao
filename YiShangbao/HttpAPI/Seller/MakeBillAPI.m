//
//  MakeBillAPI.m
//  YiShangbao
//
//  Created by light on 2018/1/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillAPI.h"
#import "SMCustomerModel.h"

@implementation MakeBillAPI

- (void)getBillListBySearchWord:(NSString *)searchWord payStatus:(NSNumber *)payStatus pageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (searchWord) {
        [parameters setObject:searchWord forKey:@"searchWord"];
    }
    if (payStatus) {
        [parameters setObject:payStatus forKey:@"payStatus"];
    }
    if (pageNo) {
        [parameters setObject:@(pageNo) forKey:@"pageNo"];
    }
    if (pageSize) {
        [parameters setObject:@(pageSize) forKey:@"pageSize"];
    }
    [self getRequest:kBill_Get_BillSaleList_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MakeBillHomeModel *model = [MTLJSONAdapter modelOfClass:[MakeBillHomeModel class] fromJSONDictionary:data error:error];
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

- (void)getBillInfoByBillId:(NSString *)billId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (billId) {
        [parameters setObject:billId forKey:@"id"];
    }
    [self getRequest:kBill_Get_BillSaleInfo_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MakeBillUploadModel *model = [MTLJSONAdapter modelOfClass:[MakeBillUploadModel class] fromJSONDictionary:data error:error];
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

- (void)postMakeBill:(MakeBillUploadModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * par = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    [self postRequest:kBill_Get_Billing_URL parameters:par success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getkBillHistoryGoodsNameListWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:kBill_Get_HistoryGoodsNameList_URL parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getkBillHistoryGoodsNameInfoByGoodsname:(NSString *)goodsName success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (goodsName) {
        [parameters setObject:goodsName forKey:@"goodsName"];
    }
    [self getRequest:kBill_Get_HistoryGoodsName_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MakeBillGoodsModel *model = [MTLJSONAdapter modelOfClass:[MakeBillGoodsModel class] fromJSONDictionary:data error:error];
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

-(void)postkBillNewCustomerInfo:(NSDictionary *)parm success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self postRequest:kBill_Post_NewCustomerInfo_URL parameters:parm success:^(id data) {
        if (success)
        {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

- (void)postBillConfirmAddGoodsWithModel:(MakeBillGoodsModel *)goodsModel success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSDictionary * par = [MTLJSONAdapter JSONDictionaryFromModel:goodsModel error:nil];
    [self postRequest:kBill_Post_ConfirmAddGoods_URL parameters:par success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getBillGenerateBillNoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:kBill_Get_GenerateBillNo_URL parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)getBillPreviewInfoByBillId:(NSString *)billId  success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (billId) {
        [parameters setObject:billId forKey:@"id"];
    }
    [self getRequest:kBill_bill_previewView_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postBillDeleteByBillId:(NSString *)billId success:(CompleteBlock)success failure:(ErrorBlock)failure{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (billId) {
        [parameters setObject:billId forKey:@"id"];
    }
    [self postRequest:kBill_bill_deleteBillSale_URL parameters:parameters success:^(id data) {
        if (success) {
            success(data);
        }
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
-(void)getBillShareByBillId:(NSString *)billId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (billId) {
        [parameters setObject:billId forKey:@"id"];
    }
    [self getRequest:kBill_billShare_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MakeBillShareModel *model = [MTLJSONAdapter modelOfClass:[MakeBillShareModel class] fromJSONDictionary:data error:nil];
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

- (void)getBillSearchWordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self getRequest:kBill_bill_searchWords_URL parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)postBillDeleteSearchWordsSuccess:(CompleteBlock)success failure:(ErrorBlock)failure{
    [self postRequest:kBill_bill_deleteSearchWords_URL parameters:nil success:^(id data) {
        if (success) {
            success(data);
        }
        
    } failure:^(NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}
- (void)getBillDisplayClauseSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kBill_bill_getDisplayClause_URL parameters:nil success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            MBDisplayClauseModel *model = [MTLJSONAdapter modelOfClass:[MBDisplayClauseModel class] fromJSONDictionary:data error:error];
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
- (void)postBillSaveClauseDisplay:(NSString *)display content:(NSString *)content bankCard:(NSString *)bankCard success:(CompleteBlock)success failure:(ErrorBlock)failure;
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (display) {
        [parameters setObject:display forKey:@"display"];
    }
    if (content) {
        [parameters setObject:content forKey:@"content"];
    }
    if (bankCard) {
        [parameters setObject:bankCard forKey:@"bankCard"];
    }
    [self postRequest:kBill_bill_saveClauseContent_URL parameters:parameters success:^(id data) {
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
-(void)postkBillBatchNewCustomerInfoArr:(NSString *)contacts success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                           @"contacts":contacts
                           };
    [self postRequest:kBill_Post_BatchNewCustomerInfo_URL parameters:parameters success:^(id data) {
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
- (void)getkBillQueryContacts:(NSString *)keyword pageNum:(NSInteger)pageNum pageSize:(NSInteger)pageSize Success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
//    NSDictionary * dict = @{ //不分页了
//                              @"pageNum"    :@(pageNum),
//                              @"pageSize"   :@(pageSize)
//                                  };
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (keyword) {
        [parameters setObject:keyword forKey:@"keyword"];
    }
    [self getRequest:kBill_Get_QueryContacts_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[SMCustomerModel class] fromJSONArray:[data objectForKey:@"list"] error:error];
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
-(void)getkBillGetContact:(NSString *)contactId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
    if (contactId) {
        [parameters setObject:contactId forKey:@"contactId"];
    }
    [self getRequest:kBill_Get_GetContact_URL parameters:parameters success:^(id data) {
        if (success) {
            NSError *__autoreleasing *error = nil;
            SMCustomerAddModel *model = [MTLJSONAdapter modelOfClass:[SMCustomerAddModel class] fromJSONDictionary:data error:error];
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


- (void)getBillDataWithAllDataWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure
{
    [self getRequest:kBill_data_getDataAll_URL parameters:nil success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        BillDataAllDataModel *shopModel = [MTLJSONAdapter modelOfClass:[BillDataAllDataModel class] fromJSONDictionary:data error:error];
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



- (void)getBillDataWithGetSaleAmountWithYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"year":year,
                                  @"month":month
                                  };
    [self getRequest:kBill_data_getSaleAmount_URL parameters:parameters success:^(id data) {
        
                NSError *__autoreleasing *error = nil;
                BillDataSaleAmountModel *shopModel = [MTLJSONAdapter modelOfClass:[BillDataSaleAmountModel class] fromJSONDictionary:data error:error];
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

- (void)getBillDataWithGetSaleGoodsYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (year)
    {
        [parameters setObject:year forKey:@"year"];
    }
    if (month)
    {
        [parameters setObject:month forKey:@"month"];
    }

    [self getRequest:kBill_data_getSaleGoods_URL parameters:parameters success:^(id data) {
        
        NSError *__autoreleasing *error = nil;
        BillDataSaleGoodsModel *shopModel = [MTLJSONAdapter modelOfClass:[BillDataSaleGoodsModel class] fromJSONDictionary:data error:error];
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

- (void)getBillDataWithGetSaleClientsWithYear:(NSString *)year month:(NSString *)month success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (year)
    {
        [parameters setObject:year forKey:@"year"];
    }
    if (month)
    {
        [parameters setObject:month forKey:@"month"];
    }

    [self getRequest:kBill_data_getSaleClients_URL parameters:parameters success:^(id data) {
        
                NSError *__autoreleasing *error = nil;
                BillDataSaleClientsModel *shopModel = [MTLJSONAdapter modelOfClass:[BillDataSaleClientsModel class] fromJSONDictionary:data error:error];
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
-(void)getBillOpenBillStatusInfoWithFuncName:(NSString *)funcName Success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if (funcName)
    {
        [parameters setObject:funcName forKey:@"funcName"];
    }
    [self getRequest:kBill_getOpenBillStatusInfo_URL parameters:parameters success:^(id data) {
        NSError *__autoreleasing *error = nil;
        BillOpenBillServiceStatusModel *model = [MTLJSONAdapter modelOfClass:[BillOpenBillServiceStatusModel class] fromJSONDictionary:data error:error];
        if (error){
            if (failure) failure(*error);
        }else{
            if (success){
                success(model);
            }
        }
    } failure:^(NSError *error) {
        if (failure){
            failure(error);
        }
    }];
}

@end
