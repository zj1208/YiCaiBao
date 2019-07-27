//
//  UserModelExtendAPI.h
//  YiShangbao
//
//  Created by simon on 2018/4/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "UserExtendModel.h"

//100038_获取联系人列表接口
static NSString *kShare_linkmanList_URL = @"mtop.user.getLinkManList";

//100039_我的线上客户列表
static NSString *kUserEx_getOnlineCustomerList = @"mtop.user.getOnlineCustomerList";
//100040_添加采购商客户
static NSString *kUserEx_addOnlineCustomer =@"mtop.user.addOnlineCustomer";
//100041_删除我的客户
static NSString *kUserEx_deleteOnlineCustomer =@"mtop.user.deleteOnlineCustomer";
//100042_获取线上客户信息详情
static NSString *kUserEx_getCustomerOnlineInfo =@"mtop.user.getCustomerOnlineInfo";
//100043_修改线上客户信息
static NSString *kUserEx_updateCustomerOnlineInfo =@"mtop.user.updateCustomerOnlineInfo";


// 添加采购商客户来源类型
typedef NS_ENUM(NSInteger, AddOnlineCustomerSourceType){
    // 粉丝
    AddOnlineCustomerSourceType_Fans = 0,
    // 访客
    AddOnlineCustomerSourceType_Visitor = 1,
    // im
    AddOnlineCustomerSourceType_im = 2,
    // order
    AddOnlineCustomerSourceType_order = 3,
    // 未知类型
    AddOnlineCustomerSourceType_None = -1,

};

// 获取线上客户信息详情
typedef NS_ENUM(NSInteger, GetCustomerOnlineInfoType){
    customerOnlineInfo_Add = 1, // 1-添加客户时
    customerOnlineInfo_look = 2, //2-获取客户详情时
    customerOnlineInfo_Update = 3,// 3-修改客户详情时
};

@interface UserModelExtendAPI : BaseHttpAPI


/**
 //100038_获取联系人列表接口
 
 @param success success description
 @param failure failure description
 */
- (void)getShareLinkmanListSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 //100039_我的线上客户列表
 */
- (void)getOnlineCustomerListWithPageNo:(NSInteger)pageNo pageSize:(NSInteger)pageSize success:(CompletePageBlock)success failure:(ErrorBlock)failure;

/**
 100040_添加采购商客户

 @param buyerBizId 采购商id
 @param source 来源0-粉丝 1-访客 2-IM消息 3-订单
 */
- (void)postAddOnlineCustomerWithBuyerBizId:(NSString *)buyerBizId source:(AddOnlineCustomerSourceType)source  remark:(NSString *)remark mobile:(NSString *)mobile address:(NSString *)address describe:(NSString *)describe success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 100041_删除我的客户

 @param buyerBizId 采购商id
 */
- (void)postDeleteOnlineCustomerWithBuyerBizId:(NSString *)buyerBizId success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100042_获取线上客户信息详情

 @param buyerBizId 采购商组合id
 @param type 1-添加客户时 2-获取客户详情时 3-修改客户详情时
 */
- (void)getCustomerOnlineInfoWithBuyerBizId:(NSString *)buyerBizId type:(GetCustomerOnlineInfoType)type success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 100043_修改线上客户信息

 @param buyerBizId 采购商组合id
 @param remark 备注
 @param mobile 手机
 @param address 地址
 @param describe 描述
 */
- (void)postUpdateCustomerOnlineInfoWithBuyerBizId:(NSString *)buyerBizId remark:(NSString *)remark mobile:(NSString *)mobile address:(NSString *)address describe:(NSString *)describe success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
