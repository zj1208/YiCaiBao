//
//  HSOrderManagementApi.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "HSOrderManagementApi.h"

@implementation HSOrderManagementApi

/**
 504101_更新订单备注 (只有商家才有)
 
 @param bizOrderId string	订单id
 @param remark string	备注
 @param success success description
 @param failure failure description
 */
- (void)PostUppdateOrderRemarkWithBizOrderId:(NSString*)bizOrderId remark:(NSString*)remark  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                             @"bizOrderId":bizOrderId,
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (remark)
    {
        [parameters setObject:remark forKey:@"remark"];
    }
    
    [self postRequest:Post_HSOM_mtop_deal_seller_updateOrderRemark_URL parameters:parameters success:^(id data) {
        
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
 504004_订单详情
 
 @param roleType 角色 2-采购商 4-供应商
 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getOrderManagementDetailWithRoleType:(WYTargetRoleType)roleType BizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"v":@"2.0",

                                  @"roleType" :@(roleType),

                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (bizOrderId)
    {
        [parameters setObject:bizOrderId forKey:@"bizOrderId"];
    }
    [self getRequest:Get_HSOM_mtop_deal_common_getMyOrderInfo_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            OrderManagementDetailModel *model = [MTLJSONAdapter modelOfClass:[OrderManagementDetailModel class] fromJSONDictionary:data error:error];
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
 504003_退款详情
 
 @param roleType 角色，2-采购商，4-供应商
 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getCommonRefundInfoWithRoleType:(WYTargetRoleType)roleType bizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                                  @"roleType" :@(roleType),

                                  };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (bizOrderId)
    {
        [parameters setObject:bizOrderId forKey:@"bizOrderId"];
    }
    [self getRequest:Get_HSOM_mtop_deal_common_refundInfo_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            OMRefundDetailInfoModel *model = [MTLJSONAdapter modelOfClass:[OMRefundDetailInfoModel class] fromJSONDictionary:data error:error];
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
 504002_退款操作
 
 @param bizOrderId 订单id
 @param operationType 操作类型A-同意，R-拒绝，C-取消
 @param reason 理由, 拒绝必填
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostCommonRefundOperationWithBizOrderId:(NSString*)bizOrderId operationType:(NSString*)operationType reason:(NSString*)reason  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"bizOrderId":bizOrderId,
                           @"operationType":operationType,
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (reason)
    {
        [parameters setObject:reason forKey:@"reason"];
    }
   
    [self postRequest:Post_HSOM_mtop_deal_common_refundOperation_URL parameters:parameters success:^(id data) {
        
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
 504212_退款
 
 @param bizOrderId 订单id
 @param reason 原因
 @param append 说明
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostBuyerAddRefundWithBizOrderId:(NSString*)bizOrderId reason:(NSString*)reason append:(NSString*)append  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"bizOrderId":bizOrderId,
                           @"reason":reason,
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (append)
    {
        [parameters setObject:append forKey:@"append"];
    }
    
    [self postRequest:Post_HSOM_mtop_deal_buyer_addRefund_URL parameters:parameters success:^(id data) {
        
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
 504211_退款初始化
 
 @param bizOrderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getBuyerRefundInitWithBizOrderId:(NSString*)bizOrderId  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizOrderId":bizOrderId
                                  };
    [self getRequest:Get_HSOM_mtop_deal_buyer_refundInit_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            OMRefundInitModel *model = [MTLJSONAdapter modelOfClass:[OMRefundInitModel class] fromJSONDictionary:data error:error];
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
 504202_买家提交评价
 
 @param dict 业务请求参数
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostPurCommitBuyerAddOrderCommentWithDict:(NSDictionary*)dict  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    [self postRequest:Post_HSOM_mtop_deal_buyer_buyerAddOrderComment_URL parameters:dict success:^(id data) {
        
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
 504201_采购商评价初始化
 
 @param orderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostPurCommitInitWithOrderId:(NSString*)orderId  success:(CompleteBlock)success failure:(ErrorBlock)failure

{
    NSDictionary * parameters = @{
                           @"orderId":orderId,

                           };
    
    [self getRequest:Get_HSOM_mtop_deal_buyer_buyerInitOrderComment_URL parameters:parameters success:^(id data) {
        
        if (success) {
//            NSArray * dataArray = [data objectForKey:@"prods"];

            NSError *__autoreleasing *error = nil;
//            NSArray *array = [MTLJSONAdapter modelsOfClass:[OMOrderPurCommentInitProModel class] fromJSONArray:dataArray error:error];
            
            OMOrderPurCommentInitModel *model = [MTLJSONAdapter modelOfClass:[OMOrderPurCommentInitModel class] fromJSONDictionary:data error:error];

            if (failure&&error)
            {
                failure(*error);
            }
            else
            {
                if (success) {
                    success(model);
                }
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
 504107_卖家提交评价
 
 @param orderId 订单id
 @param description 评价买家描述
 @param buyerStar 评价买家星级1-5颗星
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostSelCommitBuyerAddOrderCommentWithOrderId:(NSString *)orderId description:(NSString *)description buyerStar:(NSString *)buyerStar  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * dic = @{
                           @"orderId":orderId,
                           @"buyerStar":buyerStar,
                           };
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:dic];
    if (description)
    {
        [parameters setObject:description forKey:@"description"];
    }
    [self postRequest:Post_HSOM_mtop_deal_seller_sellerAddOrderComment_URL parameters:parameters success:^(id data) {
        
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
 504106_卖家初始化评价
 
 @param orderId 订单id
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)GetSelCommitInitWithOrderId:(NSString *)orderId  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"orderId":orderId,
                                  
                                  };
    
    [self getRequest:Get_HSOM_mtop_deal_seller_sellerInitOrderComment_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            OMOrderSelCommentInitModel *model = [MTLJSONAdapter modelOfClass:[OMOrderSelCommentInitModel class] fromJSONDictionary:data error:error];
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









- (void)getOrderListWithRoleType:(WYTargetRoleType)roleType orderStatus:(NSInteger)status  search:(NSString *)search pageNo:(NSInteger)pageNo pageSize:(NSNumber *)pageSize  success:(CompletePageBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  kHTTP_PAGENO_KEY2:@(pageNo),
                                  kHTTP_PAGESIZE_KEY2:pageSize,
                                  @"roleType" :@(roleType),
                                  @"v" :@"2.0"
                                  };
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:parameters];
    if (search)
    {
        [dic setObject:search forKey:@"search"];
    }
    if (status != 0)
    {
        [dic setObject:@(status) forKey:@"status"];
    }
    [self getRequest:kOrder_Get_orderList_URL parameters:dic success:^(id data) {
        
        if (success) {
            if ([data isEqual:[NSNull null]])
            {
                success (nil,nil);
            }
            else
            {
                NSArray * dataArray = [data objectForKey:@"list"];
                NSError *__autoreleasing *error = nil;
                NSArray *array = [MTLJSONAdapter modelsOfClass:[GetOrderManagerModel class] fromJSONArray:dataArray error:error];
                
                NSDictionary *dic = [data objectForKey:@"page"];
                PageModel *page = [MTLJSONAdapter modelOfClass:[PageModel class] fromJSONDictionary:dic error:nil];
                
                if (failure&&error)
                {
                    failure(*error);
                }
                else
                {
                    success(array,page);
                }
            }
        
        }
    } failure:^(NSError *error) {
        if (failure)
        {
            failure(error);
        }
    }];

}



- (void)getOrderStatusCountWithRoleType :(WYTargetRoleType)roleType  success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"roleType":@(roleType)
                                  };
    [self getRequest:kOrder_Get_orderStatusCount_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            NSArray *array = [MTLJSONAdapter modelsOfClass:[GetOrderStautsCountModel class] fromJSONArray:data error:error];
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
        if (failure)
        {
            failure(error);
        }
    }];

}

- (void)getConfirmOrderWithOrderId:(NSString *)orderId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizOrderId":orderId,
                                  @"v":@"2.0"
                                  };
    [self getRequest:kOrder_Get_getConfirmOrder_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            GetConfirmOrderModel *model = [MTLJSONAdapter modelOfClass:[GetConfirmOrderModel class] fromJSONDictionary:data error:error];
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


- (void)postMdfConfirmOrderWithDictonary:(PostMdfConfirmOrderModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSDictionary * parameters = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];

    [self postRequest:kOrder_Post_mdfConfirmOrder_URL parameters:parameters success:^(id data) {
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



- (void)postRefundOperationWithBizOrderId:(NSString *)bizOrderId operationType:(NSString *)operationType reason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizOrderId":bizOrderId,
                                  @"operationType":operationType,
                                  @"reason":reason
                                  };
    [self postRequest:kOrder_Post_refundOperation_URL parameters:parameters success:^(id data) {
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

- (void)getOrderDeliveryWithBizOrderId:(NSString *)bizOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizOrderId":bizOrderId
                                  };
    [self getRequest:kOrder_Get_orderDelivery_URL parameters:parameters success:^(id data) {
        
        if (success) {
            
            NSError *__autoreleasing *error = nil;
            GetOrderDeliveryModel *model = [MTLJSONAdapter modelOfClass:[GetOrderDeliveryModel class] fromJSONDictionary:data error:error];
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


- (void)postOrderDeliveryWithDictonary:(PostOrderDeliveryModel *)model success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = [MTLJSONAdapter JSONDictionaryFromModel:model error:nil];
    
    [self postRequest:kOrder_Post_orderDelivery_URL parameters:parameters success:^(id data) {
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


-(void)postOrderBuyerConfirmReceiptWithBizOrderId:(NSString *)bizOrderId success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"bizOrderId":bizOrderId
                                  };
    [self postRequest:kOrder_Post_buyer_confirmReceipt_URL parameters:parameters success:^(id data) {

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



- (void)postCloseOrderWithRoleType:(WYTargetRoleType)roleType bizOrderId:(NSString *)bizOrderId closeReason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    
    NSDictionary * parameters = @{
                                  @"roleType":@(roleType),
                                   @"reason":reason,
                                  @"bizOrderId":bizOrderId
                                  };
    [self postRequest:kOrder_Post_closeOrder parameters:parameters success:^(id data) {
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


- (void)postCloseRefundOrderWithBizOrderId:(NSString *)bizOrderId closeReason:(NSString *)reason success:(CompleteBlock)success failure:(ErrorBlock)failure
{
    NSDictionary * parameters = @{
                                  @"reason":reason,
                                  @"bizOrderId":bizOrderId
                                  };
    [self postRequest:kOrder_Post_closeRefundOrder parameters:parameters success:^(id data) {
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
