//
//  AccountApi.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

// ------资金账号管理-------

#import "BaseHttpAPI.h"

//110002_获取提现信息接口 
static NSString *kAccount_getWithdrawalsInfo_URL = @"mtop.account.getWithdrawalsInfo";

//110003_确认提现申请接口
static NSString *kAccount_confirmWithdrawals_URL = @"mtop.account.confirmWithdrawals";

//110004_提交提现申请接口
static NSString *kAccount_submitWithdrawals_URL = @"mtop.account.submitWithdrawals";

// ------兜信授权-------

//100046_判断是否授权兜信
static NSString *kAccount_checkUserAuhtorized_URL = @"mtop.user.checkUserAuhtorized";

//100047_确认授权
static NSString *kAccount_confirmUserAuthorize_URL = @"mtop.user.confirmUserAuthorize";

//110009_开通兜信账户
static NSString *kAccount_createDouxinAccount_URL = @"mtop.finance.createDouxinAccount";

@interface AccountApi : BaseHttpAPI


/**
 110002_获取提现信息接口

 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)getAccountWithdrawalsInfoSuccess:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 ---------------------110003_确认提现申请接口（1）

 @param userCardId string	用户银行卡信息id
 @param bankId string	银行id
 @param bankCardNo string	银行卡号
 @param bankAcctName string	银行账户名
 @param amount long 提现金额,单位为分
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountConfirmWithdrawalsWithuserCardId:(NSString *)userCardId bankId:(NSString*)bankId bankCardNo:(NSString*)bankCardNo  bankAcctName:(NSString*)bankAcctName amount:(NSInteger)amount success:(CompleteBlock)success failure:(ErrorBlock)failure;
/**
                    110003_确认提现申请接口（2）----------------------------------
 (和上一个接口一样功能，只是传入参数把银行卡整理到一个字典了，方便处理“选择银行卡”的数据模型不一样问题)
 
 @param bankInfoDcit 银行卡信息字典
 @param amount long 提现金额,单位为分
 */
- (void)PostAccountConfirmWithBankInfoDict:(NSDictionary*)bankInfoDcit amount:(NSDecimalNumber*)amount success:(CompleteBlock)success failure:(ErrorBlock)failure;


/**
 -------------------------110004_提交提现申请接口(1)

 @param userCardId string	用户银行卡信息id
 @param bankId string	银行id
 @param bankCardNo string	银行卡号
 @param bankAcctName string	银行账户名
 @param amount long 提现金额
 @param verificationCode 短信验证码
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountSubmitWithdrawalsWithuserCardId:(NSString *)userCardId bankId:(NSString*)bankId bankCardNo:(NSString*)bankCardNo  bankAcctName:(NSString*)bankAcctName amount:(NSDecimalNumber*)amount  verificationCode:(NSString*)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
                         110004_提交提现申请接口(2)--------------------
 (和上一个接口一样功能，只是传入参数把银行卡整理到一个字典了，方便处理“选择银行卡”的数据模型不一样问题)

 @param bankInfoDcit 银行卡信息字典
 @param amount 提现金额,单位为分
 @param verificationCode 短信验证码
 @param success <#success description#>
 @param failure <#failure description#>
 */
- (void)PostAccountSubmitWithBankInfoDict:(NSDictionary*)bankInfoDcit amount:(NSDecimalNumber*)amount  verificationCode:(NSString*)verificationCode success:(CompleteBlock)success failure:(ErrorBlock)failure;



/**
 //100046_判断是否授权兜信

 @param type 类型
 @param success success description
 @param failure failure description
 */
- (void)getCheckUserAuhtorizedWithType:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //100047_确认授权

 @param type 类型
 @param success success description
 @param failure failure description
 */
- (void)postConfirmUserAuthorizeWithType:(NSString *)type success:(CompleteBlock)success failure:(ErrorBlock)failure;

/**
 //110009_开通兜信账户

 @param address 开户时的详细地址
 @param ip 外网ip
 @param latitude 纬度
 @param longitude 经度
 @param success success description
 @param failure failure description
 */
- (void)postCreateDouxinAccountWithAddress:(NSString *)address latitude:(NSString *)latitude longitude:(NSString *)longitude success:(CompleteBlock)success failure:(ErrorBlock)failure;

@end
