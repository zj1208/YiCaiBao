//
//  AccountModel.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/8.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface AccountSubmitModel : BaseModel
@property(nonatomic,copy)NSString*estimateArrivalTimeDesc	;//string	预计到账时间说明
@property(nonatomic,copy)NSString*bankName	;//string	银行名称
@property(nonatomic,copy)NSString*bankCardNo	;//string	银行卡号
@property(nonatomic,copy)NSString*amount	;//string	到账金额（格式：￥0.00）
@property(nonatomic,copy)NSString*fee	;//string	手续费（格式：￥0.00）
@end

@interface AccountConfirmPhoneModel : BaseModel
@property(nonatomic,copy)NSString*countryCode	;//string	国家区号
@property(nonatomic,copy)NSString*phone	;//string	手机号


@end
@interface AccountModel : BaseModel

@property(nonatomic,copy)NSString*userCardId	;//string	用户银行卡信息id
@property(nonatomic,copy)NSString*bankId	;//string	银行id
@property(nonatomic,copy)NSString*bankIcon	;//string	银行图标
@property(nonatomic,copy)NSString*bankName	;//string	银行名称
@property(nonatomic,copy)NSString*bankCardNo	;//string	银行卡号
@property(nonatomic,copy)NSString*bankAcctName	;//string	银行账户名

@property(nonatomic,assign)NSInteger canWithdrawAmount	;//long	可提现金额（单位：分）
@property(nonatomic,assign)NSInteger freeQuota	;//long	免费额度（单位：分）

@property(nonatomic,copy)NSString*feeRate	;//string	手续费费率（带小数点的数字，比如：0.001）
@property(nonatomic,copy)NSString*desc	;//string	提现说明
@property(nonatomic,copy)NSString*ruleDescUrl	;//string	提现规则说明Url
@end

@interface DouXinAccountModel : BaseModel

@property (nonatomic, copy) NSString *mobile;//手机号
@property (nonatomic, copy) NSString *inviteSource;//商户编号
@property (nonatomic, copy) NSString *uid;//商户兜信id

@end

