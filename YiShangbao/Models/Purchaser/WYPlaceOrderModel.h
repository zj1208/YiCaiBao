//
//  WYPlaceOrderModel.h
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@class WYAddressModel;
@class WYOrderSumInfoModel;
@class WYConfirmOrderModel;
@class WYCreatOrderSuccessAddressModel;
@class WYCreatOrderSuccessSumInfoModel;

@interface WYPlaceOrderModel : BaseModel

@end

//确认订单--------

@interface WYConfirmOrderInfoModel : BaseModel

@property (nonatomic ,strong) WYAddressModel *address;
@property (nonatomic ,strong) WYOrderSumInfoModel *orderSumInfo;
@property (nonatomic ,strong) NSArray *orderList;
@property (nonatomic ,strong) NSArray *invalidOrderList;

@end

@interface WYAddressModel : BaseModel

@property (nonatomic ,copy) NSString *fullName;
@property (nonatomic ,copy) NSString *mobile;
@property (nonatomic ,copy) NSString *addressDetail;
@property (nonatomic ,copy) NSDictionary *storage;

@end

@interface WYOrderSumInfoModel : BaseModel

@property (nonatomic ,copy) NSString *sumTotalPriceLabel;
@property (nonatomic ,copy) NSString *sumTotalPrice;
@property (nonatomic ,copy) NSString *tipInfo;

@end

@interface WYConfirmOrderModel : BaseModel

@property (nonatomic ,copy) NSString *shopName;
@property (nonatomic ,copy) NSString *totalQuantityLabel;
@property (nonatomic ) NSInteger totalQuantity;
@property (nonatomic ,copy) NSString *totalPriceLabel;//商品价格标签名称
@property (nonatomic ,copy) NSString *totalPrice;//订单金额
@property (nonatomic ,copy) NSString *postageLabel;//订单邮费标签名称
@property (nonatomic ,copy) NSString *postageFee;//订单邮费金额
@property (nonatomic ,copy) NSArray *itemList;
@property (nonatomic ,copy) NSDictionary *storage;
@property (nonatomic ,copy) NSString *leaveMessage;//自己加的留言


@end

@interface WYConfirmOrderGoodsModel : BaseModel

@property (nonatomic ,copy) NSString *itemPic;
@property (nonatomic ,copy) NSString *itemTitle;
@property (nonatomic ,copy) NSString *itemPrice;
@property (nonatomic ,copy) NSString *skuInfo;
@property (nonatomic ) NSInteger minQuantity;
@property (nonatomic ) NSInteger maxQuantity;
@property (nonatomic ) NSInteger quantity;
@property (nonatomic ,copy) NSDictionary *storage;

@end

@interface WYConfirmInvalidOrderModel : BaseModel

@property (nonatomic ,copy) NSString *shopName;
@property (nonatomic ,copy) NSString *totalQuantityLabel;
@property (nonatomic ) NSInteger totalQuantity;
@property (nonatomic ,copy) NSString *totalPriceLabel;
@property (nonatomic ,copy) NSString *totalPrice;
@property (nonatomic ,strong) NSArray *itemList;
//@property (nonatomic ,copy) NSDictionary *storage;

@end

@interface WYConfirmOrderInvalidGoodsModel : BaseModel

@property (nonatomic ,copy) NSString *itemPic;
@property (nonatomic ,copy) NSString *itemTitle;
@property (nonatomic ,copy) NSString *itemPrice;
@property (nonatomic ,copy) NSString *skuInfo;
@property (nonatomic ) NSInteger quantity;
@property (nonatomic ,copy) NSString *reason;
//@property (nonatomic ,copy) NSDictionary *storage;

@end

//确认订单________结束

//创建订单成功其他信息
@interface WYCreatOrderExtraInfoModel : BaseModel

@property (nonatomic ,copy) NSString *jumpPage;// :orderListPage、payPage 多个商家订单、还是一个商家订单

@end
//创建订单成功
@interface WYCreatOrderSuccessModel : BaseModel

@property (nonatomic ,strong) WYCreatOrderSuccessAddressModel *address;
@property (nonatomic ,strong) WYCreatOrderSuccessSumInfoModel *orderSumInfo;
@property (nonatomic ,copy) NSString *title;
@property (nonatomic ,copy) NSString *subTitle;
@property (nonatomic ,copy) NSString *orderIds;
@property (nonatomic ,strong) WYCreatOrderExtraInfoModel *extraInfo;

@end

@interface WYCreatOrderSuccessAddressModel : BaseModel

@property (nonatomic ,copy) NSString *fullName;
@property (nonatomic ,copy) NSString *mobile;
@property (nonatomic ,copy) NSString *addressDetail;

@end

@interface WYCreatOrderSuccessSumInfoModel : BaseModel

@property (nonatomic ,copy) NSString *sumTotalPriceLabel;
@property (nonatomic ,copy) NSString *sumTotalPrice;
@property (nonatomic ,copy) NSString *tipInfo;

@end
