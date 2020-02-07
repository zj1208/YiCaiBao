//
//  WYPublichModel.h
//  YiShangbao
//
//  Created by light on 2017/9/5.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface WYPublicModel : BaseModel

@end

@interface WYDefaultDeliveryAddressModel : BaseModel

@property (nonatomic ,strong) NSNumber *addressId;
@property (nonatomic ,strong) NSString *deliveryName;
@property (nonatomic ,strong) NSString *deliveryPhone;
@property (nonatomic ,strong) NSString *provCode;
@property (nonatomic ,strong) NSString *cityCode;
@property (nonatomic ,strong) NSString *townCode;
@property (nonatomic ,strong) NSString *prov;
@property (nonatomic ,strong) NSString *city;
@property (nonatomic ,strong) NSString *town;
@property (nonatomic ,strong) NSString *address;

@end

@interface WYPayWayModel : BaseModel

@property (nonatomic ) NSInteger payWayId;
@property (nonatomic ,strong) NSString *way;
@property (nonatomic ,strong) NSString *intro;
@property (nonatomic ,strong) NSString *icon;
@property (nonatomic ,strong) NSString *pic;

@end


@interface WYWechatPaymentModel : BaseModel

@property (nonatomic ,strong) NSString *appid;
@property (nonatomic ,strong) NSString *partnerid;
@property (nonatomic ,strong) NSString *prepayid;
@property (nonatomic ,strong) NSString *package;
@property (nonatomic ,strong) NSString *noncestr;
@property (nonatomic ,strong) NSString *timestamp;
@property (nonatomic ,strong) NSString *sign;

@end

@interface WYAuthenticationPayInfoModel : BaseModel

@property (nonatomic ,strong) NSNumber *comboId;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *desc;
@property (nonatomic ,copy) NSString *icon;
@property (nonatomic ,copy) NSString *fee;
@property (nonatomic ,copy) NSString *promFee;

@end

@interface WYAuthenticationInfoModel : BaseModel

@property (nonatomic ,strong) WYAuthenticationPayInfoModel *ssView;
@property (nonatomic ,copy) NSString *payJumpUrl;

@end

#pragma mark- 服务下单
@interface WYServicePackagesModel : BaseModel

@property (nonatomic, strong) NSNumber *comboId;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *icon;
@property (nonatomic, copy) NSString *fee;
@property (nonatomic, copy) NSString *promFee;

@end

@interface WYServiceFunctionInfoModel : BaseModel

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *pic;

@end

@interface WYServiceExtMapModel : BaseModel

@property (nonatomic, strong) NSNumber *openBillTrialLeftDay;//剩余天数
@property (nonatomic, copy) NSString *openBillFreeTrialJumpUrl;//跳转url
@property (nonatomic) BOOL enableGoOnButton;
@property (nonatomic, copy) NSString *goOnButtonText;

@end

@interface WYServicePlaceOrderModel : BaseModel

@property (nonatomic, strong) NSArray *comboItemList;
@property (nonatomic, copy) NSString *outOrderId;
@property (nonatomic, strong) NSArray *funcItemInfoList;
@property (nonatomic, strong) WYServiceExtMapModel *extMap;

@end

@interface WYServiceCreatOrderModel : BaseModel

@property (nonatomic, strong) WYServicePackagesModel *ssView;
@property (nonatomic, copy) NSString *orderIds;

@end




