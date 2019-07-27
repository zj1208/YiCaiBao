//
//  UserExtendModel.h
//  YiShangbao
//
//  Created by simon on 2018/4/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface UserExtendModel : BaseModel

@end


@interface BaseBuyerModel : BaseModel

/**
 用户id －uid
 */
@property (nonatomic,copy) NSString *bizUid;

/**
 求购者名称-nn
 */
@property (nonatomic,copy) NSString *nickName;

/**
 头像-tx
 */
@property (nonatomic,strong) NSURL *headIcon;

/**
 公司名字－cn
 */
@property (nonatomic,copy) NSString *companyName;

//采购商图标
@property (nonatomic, copy) NSArray *buyerBadges;
@end

@interface OnlineCustomerListModel : BaseModel

@property (nonatomic, strong) NSNumber *bizUid;
@property (nonatomic, copy) NSString *headIcon;
@property (nonatomic, copy) NSString *nickName;
@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, strong) NSArray *buyerBadges;

@end


@interface CustomerInfoModel : BaseModel
@property (nonatomic, copy) NSString *icon;//  N    string    用户头像
@property (nonatomic, copy) NSString *nickName;//    N    string    昵称
@property (nonatomic, copy) NSString *companyName;//    Y    string    公司名称
@property (nonatomic, copy) NSString *remark;//    Y    string    备注
@property (nonatomic, copy) NSString *mobile ;//   Y    string    手机
@property (nonatomic, copy) NSString *address ;//   Y    string    地址
@property (nonatomic, copy) NSString *describe;//    Y    string    描述
@property (nonatomic, copy) NSString *buyProducts ;//   Y    String    list集合［衣服，裤子］
@end






#pragma mark -----Share---

@interface WYShareLinkmanModel : BaseModel

@property (nonatomic, copy) NSString *icon;//头像
@property (nonatomic, copy) NSString *nick;//昵称
@property (nonatomic, copy) NSString *remark;
@property (nonatomic, copy) NSString *bizUid;//处理后uid

@property (nonatomic) BOOL isSelected;//APP端多选使用

@end

@interface WYShareLinkmanListModel : BaseModel

@property (nonatomic, copy) NSString *imDay;//最近联系
@property (nonatomic, copy) NSArray *imList;
@property (nonatomic, copy) NSString *fansDay;//关注我的商铺
@property (nonatomic, copy) NSArray *fansList;
@property (nonatomic, copy) NSString *visitorsDay;//最近访问过我的商铺
@property (nonatomic, copy) NSArray *visitorsList;

@end
