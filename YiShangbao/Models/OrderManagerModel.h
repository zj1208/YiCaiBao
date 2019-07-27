//
//  OrderManagerModel.h
//  YiShangbao
//
//  Created by simon on 2017/9/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"


#pragma mark -504001_获取我的交易订单

//基础订单model

@interface BaseOrderModel : BaseModel

//订单id
@property (nonatomic, copy) NSString *bizOrderId;
//商铺id/买家id
@property (nonatomic, copy) NSString *entityId;
//商铺名称/买家名
@property (nonatomic, copy) NSString *entityName;

//状态-有2个状态，为何？
@property (nonatomic, strong) NSNumber *status;
//状态
@property (nonatomic, copy) NSString *statusV;

//订单原价（产品原价之和)
@property (nonatomic, copy) NSString *price;
//订单最新价格（产品最新价格之和)
@property (nonatomic, copy) NSString *prodsPrice;
//订单差价（上面两个值差） “+￥2.00”，“-￥12.60”
@property (nonatomic, copy) NSString *discount;
//运费
@property (nonatomic, copy) NSString *transFee;
//实际需要支付价格 prodsPrice + transFee
@property (nonatomic, copy) NSString *finalPrice;
//子订单
@property (nonatomic, copy) NSArray *subBizOrders;

//子订单产品总数
@property (nonatomic, strong) NSNumber *prodCount;


//子订单种类总数
@property (nonatomic, strong) NSNumber *subBizOrderNum;

@property (nonatomic, assign) BOOL showMore;

//商铺地址／采购商页面跳转路有
@property (nonatomic, copy) NSString *entityUrl;

//电话号码
@property (nonatomic, copy) NSString *buttonCall;
@end



@interface BaseOrderModelSub : BaseModel

//子订单id
@property (nonatomic, copy) NSString *subBizOrderId;

//产品id
@property (nonatomic, copy) NSString *prodId;

//产品名称
@property (nonatomic, copy) NSString *prodName;

//产品头像
@property (nonatomic, copy) NSString *prodPic;

//数量
@property (nonatomic, strong) NSNumber *quantity;

//规格文案，包含尺寸颜色
@property (nonatomic, copy) NSString *skuInfo;

//订单原价
@property (nonatomic, copy) NSString *price;

//实际需要支付价格 prodsPrice + transFee
// 在修改价格的地方：上次修改的价格
@property (nonatomic, copy) NSString *finalPrice;

//订单差价（上面两个值差） “+￥2.00”，“-￥12.60”
@property (nonatomic, copy) NSString *discount;

//产品总价 finalPrice*quantity
@property (nonatomic, copy) NSString *totalPrice;

//子订单补充状态
@property (nonatomic, strong) id storage;

//@property (nonatomic, copy) NSString *storage;


@end





@interface GetOrderManagerModel : BaseOrderModel

@property (nonatomic, copy) NSArray *buttons;


@end



@interface GetOrderStautsCountModel : BaseModel

@property (nonatomic, copy) NSString *status;
@property (nonatomic, copy) NSString *orderCount;

@end




#pragma mark - 商户确认订单提交参数


@interface PostMdfConfirmOrderModel : BaseModel

//订单id
@property (nonatomic, copy) NSString *bizOrderId;
//运费
@property (nonatomic, strong) NSNumber *transFee;
//订单产品对象
@property (nonatomic, copy) NSArray *orderProd;
//产品总额
@property (nonatomic, copy) NSString *prodsPrice;

@end

@interface PostMdfConfirmOrderModelSub : BaseModel
//子订单
@property (nonatomic, copy) NSString *subBizOrderId;
//新价格
@property (nonatomic, strong) NSNumber *nPrice;
//数量
@property (nonatomic, strong) NSNumber *quantity;

@end


#pragma mrak -504102_确认订单获取

@class GetConfirmOrderModelSub;
@interface GetConfirmOrderModel : BaseModel

//订单id
@property (nonatomic, copy) NSString *bizOrderId;
//产品原价之和
@property (nonatomic, copy) NSString *price;
//产品最新价格之和
@property (nonatomic, copy) NSString *prodsPrice;

//新的产品总额
@property (nonatomic, assign) double nProdsPrice;
// 新的原价总和
@property (nonatomic, assign) double nPrice;

//订单差价（上面两个值差） “+￥2.00”，“-￥12.60”
@property (nonatomic, copy) NSString *discount;
//运费
@property (nonatomic, copy) NSString *transFee;
//实际需要支付价格 prodsPrice + transFee
@property (nonatomic, copy) NSString *finalPrice;
//子订单
@property (nonatomic, copy) NSArray *subBizOrders;

// 上传用的；
@property (nonatomic, copy) NSArray *orderProd;

@end


@interface GetConfirmOrderModelSub : BaseOrderModelSub

//数学原价-price转换的
@property (nonatomic, assign) double floatPrice;

//要上传的修改最后单价--
@property (nonatomic, copy) NSString *nPrice;

@property (nonatomic, assign) double ndiscount;

@property (nonatomic, assign) BOOL isEditing;
@end


#pragma mark - 商户-504110_立即发货接口(供应商)

@interface GetOrderDeliveryModel : BaseModel

//订单id
@property (nonatomic, copy) NSString *bizOrderId;
//订单产品数量
@property (nonatomic, strong) NSNumber *productCount;
//第一个产品的图片
@property (nonatomic, copy) NSString *orderPic;
//收货人
@property (nonatomic, copy) NSString *consignee;
//收货人电话
@property (nonatomic, copy) NSString *consigneePhone;
//收货人地址
@property (nonatomic, copy) NSString *address;
@end



@interface PostOrderDeliveryModel : BaseModel
//订单id
@property (nonatomic, copy) NSString *bizOrderId;
//运输方式1-无需物流,2-需要物流【快递】;当选择需要快递的时候，下面3个参数必填
@property (nonatomic, strong) NSNumber *deliveryType;
//物流公司id
@property (nonatomic, copy) NSString *companyId;
//物流公司名字
@property (nonatomic, copy) NSString *companyName;
//运单号码
@property (nonatomic, copy) NSString *logisticsNum;

@end


