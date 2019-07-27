//
//  UserModel.h
//  
//
//  Created by simon on 15/6/25.
//  Copyright (c) 2015年 sina. All rights reserved.
//

#import "BaseModel.h"

@class RecordModel;

@interface BaseInfoModel : BaseModel

@property(nonatomic, copy) NSString *iconUrl;           //头像url
@property(nonatomic, copy) NSString *nickname;          //昵称
@property(nonatomic, strong) NSNumber *sex;             //性别 -1:未知 0:女 1:男

@end



@interface BuyerInfoModel : BaseModel

@property(nonatomic, strong) NSNumber *sex;         //认证类型 0-未认证 1-个人认证 2-企业认证 3-特邀采购员
@property(nonatomic, copy) NSString *iconUrl;       //头像url
@property(nonatomic, copy) NSString *companyName;   //公司名称
@property(nonatomic, copy) NSString *locationName;  //所在城市
@property(nonatomic, copy) NSString *buyProducts;   //采购产品
@property(nonatomic, copy) NSString *intro;         //个人简介

@end


@interface sellerInfoModel : BaseModel

@property(nonatomic, copy) NSString *shopId;            //商铺id
@property(nonatomic, copy) NSString *shopIconUrl;       //商铺头像url
@property(nonatomic, copy) NSString *shopName;          //商铺名称
@property(nonatomic, strong) NSNumber *authStatus;      //实体认证状态 0-未认证 1-市场认证通过
@property(nonatomic, strong) NSNumber *specialSupplier; //是否为重点供应商 0-否 1-是
@property(nonatomic, copy) NSString *mgrPeriod;         //经营年限
@property(nonatomic, copy) NSString *mgrType;           //经营模式
@property(nonatomic, copy) NSString *address;           //商铺地址
@property(nonatomic, copy) NSString *mainSell;          //主营产品

@end


@interface UserModel : BaseModel

/**
 *  用户ID
 */
@property(nonatomic,strong) NSNumber * userId;
/**
 *  昵称
 */
@property(nonatomic, copy) NSString *nickname;

/**
 *  性别
 */
@property(nonatomic, strong) NSNumber *sex;

/**
 手机号
 */
@property(nonatomic, copy) NSString *phone;

/**
 *  头像url
 */
@property(nonatomic, copy) NSString *headURL;

/**
 *  省份
 */
@property(nonatomic,copy)NSString *province;

/**
 实体认证状态 0-未认证 1-认证通过
 */
@property(nonatomic, strong) NSNumber *authStatus;

/**
 *  城市
 */
@property(nonatomic,copy)NSString *city;

/**
 *  签名
 */
@property(nonatomic, copy) NSString *autograph;

/**
 是否绑定微信 1是0否
 */
@property(nonatomic, strong)  NSNumber *bindWechat;
/**
 是否设置密码 1是0否
 */
@property(nonatomic, strong)  NSNumber *needSetPwd;

//客服qq
@property(nonatomic, copy)NSString *QQ;

//微信是否需要绑定手机号
@property(nonatomic, strong)NSNumber *isNeedBindPhone;




//隐藏手机号码
@property(nonatomic, strong)NSString *nickPhone;

//区号
@property(nonatomic, strong)NSString *countryCode;

//2.0修改
@property(nonatomic, strong) NSDictionary *baseInfo;               //基本信息
@property(nonatomic, strong) NSDictionary *buyerInfo;              //买家身份信息
@property(nonatomic, strong) NSDictionary *sellerInfo;             //卖家身份信息

@property (nonatomic ,strong) NSNumber *score;//积分
@property (nonatomic ,strong) NSString *scoreUrl;//我的积分H5
@property (nonatomic ,strong) RecordModel *record;

@end

@interface RecordModel : BaseModel

@property (nonatomic ,strong) NSNumber *bizCount;//推产品数量
@property (nonatomic ,strong) NSNumber *prodCount;//清库存数量
@property (nonatomic ,strong) NSNumber *stockCount;//接生意数量
@property (nonatomic ,strong) NSNumber *subjectCount;//求购数量

@end



