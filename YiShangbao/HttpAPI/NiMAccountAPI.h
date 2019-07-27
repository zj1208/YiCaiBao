//
//  NiMAccountAPI.h
//  YiShangbao
//
//  Created by simon on 17/5/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseHttpAPI.h"
#import "MessageModel.h"

//801002_获取聊天对象用户的IM账户信息接口
static NSString *kNIM_getChatUserIMInfo = @"mtop.im.getChatUserIMInfo";

//801001_获取用户的IM账户信息接口
static NSString *kNIM_getUserIMInfo = @"mtop.im.getUserIMInfo";

//801003_批量发送点对点消息接口
static NSString *kNIM_sendBatchMsg_URL = @"mtop.im.sendBatchMsg";


//801004_获取客服IM账号id接口
static NSString *kNIM_getSupportIMAccid_URL = @"mtop.im.getSupportIMAccid";


typedef NS_ENUM(NSInteger, NIMIDType){
    NIMIDType_User = 0,     //用户／采购商资料
    NIMIDType_Trade =1,      //生意
    NIMIDType_Shop =2,      //商铺／暂时没用
    NIMIDType_NIMAccout = 3, //云信id

    NIMIDType_Seller = 4 ,     //卖家订单id
    NIMIDType_Buyer = 5        //买家订单id

};


@interface NiMAccountAPI : BaseHttpAPI

//接口处理内容
//1、根据请求参数id、type获取相应的uid，根据uid获取相应的IM账户信息，获取到IM账户信息的情况
//3-1、IM账号未激活的情况，推送消息给该用户
//3-2、返回相应的IM账户信息
//4、获取不到IM账户信息的情况，异步调用创建IM账户信息处理，并同步返回相应的错误信息
// type:id类型， aId :对应id
- (void)getChatUserIMInfoWithIDType:(NIMIDType)type thisId:(NSString *)aId success:(CompleteBlock)success failure:(ErrorBlock)failure;

- (void)getChatUserIMInfo2WithIDType:(NIMIDType)type thisId:(NSString *)aId productId:(NSString *)productId success:(CompleteBlock)success failure:(ErrorBlock)failure;


//接口处理内容
//1、根据token从会话信息里获取相应的uid
//2、根据uid获取相应的IM账户信息
//3、获取到IM账户信息的情况
//3-1、激活用户的IM账号
//3-2、返回相应的IM账户信息
//4、获取不到IM账户信息的情况，异步调用创建IM账户信息处理，并同步返回相应的错误信息
- (void)getNIMUserIMInfoWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


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
- (void)postNIMSendBatchMsgToIds:(NSString *)toIds picUrl:(NSString *)picUrl recommendation:(NSString *)recommendation title:(NSString *)title linkUrl:(NSString *)linkUrl addedText:(NSString *)addedText success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 801004_获取客服IM账号id接口

 @param success success description
 @param failure failure description
 */
- (void)getNIMSupportIMAccidWithSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
