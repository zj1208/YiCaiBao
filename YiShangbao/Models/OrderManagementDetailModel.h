//
//  OrderManagementDetailModel.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

//-------订单详情------------
@interface OMDStatusHubModel : BaseModel
@property(nonatomic, copy) NSNumber* seq	;//number	结点 顺序 例如 1，2
@property(nonatomic, copy) NSString*value	;//string	结点名称展示 例如买家下单，卖家确认
@end

@interface OMDSubBizOrdersMode : BaseModel
@property(nonatomic, copy) NSString*subBizOrderId;//	string	子订单id
@property(nonatomic, copy) NSString*discount	;//产品差价 “+￥2.00”，“-￥12.60”
@property(nonatomic, copy) NSString*prodId	;//string	产品id
@property(nonatomic, copy) NSString*prodUrl	;//string	产品H5路径
@property(nonatomic, copy) NSString*prodName;//	string	产品名称
@property(nonatomic, copy) NSString*prodPic	;//string	产品头像
@property(nonatomic, assign) NSInteger quantity	;//number	数量
@property(nonatomic, copy) NSString*skuInfo	;//string	规格文案，包含尺寸颜色
@property(nonatomic, copy) NSString*price	;//string	价格
@property(nonatomic, copy) NSString*finalPrice	;//string	最终价格
@property(nonatomic, copy) NSString*totalPrice	;//string	产品总价 finalPrice*quantity

//@property(nonatomic, copy) NSString*storage ;//	object	补充信息
@end


@interface OMDStatusDescModel : BaseModel
@property(nonatomic, copy) NSString*desc1 ;//	string	订单状态描述第一行
@property(nonatomic, copy) NSString*desc2	;//string	订单状态描述第二行
@property(nonatomic, copy) NSString*pic	;//string	订单状态描述图片
@end



@interface OrderManagementDetailModel : BaseModel

@property(nonatomic, copy) NSArray *statusHubs; //array	状态数组
@property(nonatomic, strong) NSNumber* statusSta	;//目前状态值，对应statusHub中的seq

@property(nonatomic, copy) NSString* bizOrderId; //string	订单id
@property(nonatomic, copy) NSString* entityId; //string	商铺id/采购商id
@property(nonatomic, copy)NSString* entityName; //string	同上
@property(nonatomic, copy)NSString*entityUrl ;  //商铺H5详情/买家Native信息

@property(nonatomic, copy)OMDStatusDescModel* statusDesc; //描述对象

@property(nonatomic, copy)NSString*consignee; //string	收货人
@property(nonatomic, copy)NSString*consigneePhone	;//	string	收货人电话

@property(nonatomic, copy)NSString*address	;//	string	收货人地址

@property(nonatomic, copy)NSString*buyerWords	;//	string	买家留言

@property(nonatomic, copy)NSString*remark	;//	string	备忘(仅卖家可看)

@property(nonatomic, copy)NSString*price		;//string	产品原价之和（产品原价之和)
@property(nonatomic, copy)NSString*prodsPrice	;//	string	产品最新价格之和（产品最新价格之和)
@property(nonatomic, copy)NSString*discount		;//string	产品差价（上面两个值差） “+￥2.00”，“-￥12.60” discount=prodsPrice-price
@property(nonatomic, copy)NSString*transFee		;//string	运费
@property(nonatomic, copy)NSString*promotionFee		;//string	打折价, 目前默认为0
@property(nonatomic, copy)NSString*orderFee		;//string	订单总价 orderFee=prodsPrice + transFee
@property(nonatomic, copy)NSString*finalPrice		;//string	订单实际支付金额 finalPrice=orderFee + promotionFee

@property(nonatomic, copy)NSArray *subBizOrders		;//array	子订单

@property(nonatomic, copy)NSString*createTime	;//	string	下单时间
@property(nonatomic, copy)NSString*confirmTime	;//	string	商家确认时间
@property(nonatomic, copy)NSString*payTime		;//string	支付时间
@property(nonatomic, copy)NSString*deliveryTime		;//string	发货时间
@property(nonatomic, copy)NSString*finishTime	;//	string	完成时间
@property(nonatomic, copy)NSArray*upButtons; //		    上面按钮(退款中)
@property(nonatomic, copy)NSArray*downButtons; //		下面按钮

@property(nonatomic, copy)NSString*buttonCall	;//	string	底部 联系人电话
@property(nonatomic, copy)NSString*buttonComplaint	;//	string	底部 投诉电话
@end
//---------------------

//退款详情按钮model
@interface OMDRefundDetailButtonModel : BaseModel
@property(nonatomic, copy) NSString*name;//	string	名称
@property(nonatomic, copy) NSString*code;//	string	跳转控制
@property(nonatomic, strong) NSNumber*style;//	样式枚举
//@property(nonatomic, copy) NSString*location	;//N	string	位置
//@property(nonatomic, assign) NSInteger router	;//N	string	路由接受 0-Native， 1-H5
@property(nonatomic, copy) NSString*url		;//Y    string	H5
@end

//退款详情model
@interface OMRefundDetailInfoModel : BaseModel
@property(nonatomic, copy)NSString*statusIcon	;//状态图标
@property(nonatomic, copy)NSString*statusDesp	; //状态描述， 例如“退款成功”，“买家发起退款申请”
@property(nonatomic, copy)NSString*statusTimeAbout	;//时间描述 例如“还剩1天23时2分”，“2017年9月1日 08:00”

@property(nonatomic, copy)NSArray*reminders	;//提示语块
@property(nonatomic, copy)NSArray*buttons	; //按钮

@property(nonatomic, copy)NSString*iid	; //退款ID
@property(nonatomic, copy)NSString*bizOrderId	;//订单标示

@property(nonatomic, copy) NSNumber* status;//状态 0-申请,1-撤销,2-拒绝,3-同意,4-完成
@property(nonatomic, copy)NSString*finalPrice	;//退款总金额 finalProdsPrice + transFee
@property(nonatomic, copy)NSArray*subBizOrders	;//子订单

@property(nonatomic, copy)NSString*applyTime	;//申请退款时间
@property(nonatomic, copy)NSString*cancelTime	;//撤销退款时间
@property(nonatomic, copy)NSString*refuseTime	;//拒绝退款时间
@property(nonatomic, copy)NSString*agreeTime	;//同意退款时间
@property(nonatomic, copy)NSString*finishTime	;//同意完成时间
@property(nonatomic, copy)NSString*applyReason	;//申请退款原因
@property(nonatomic, copy)NSString*refuseReason	;//拒绝退款原因
@property(nonatomic, copy)NSString*explain	;    //申请退款说明

@property(nonatomic, copy)NSString*buttonUid		;//string	底部 联系人标识
@property(nonatomic, copy)NSString*buttonCall	;//	string	底部 联系人电话
@property(nonatomic, copy)NSString*buttonComplaint	;//	string	底部 投诉电话

@end
//退款初始化model
@interface OMRefundInitModel : BaseModel
@property(nonatomic, copy)NSString*bizOrderId	;//订单标示
@property(nonatomic, copy)NSString*finalPrice	;//价格
@property(nonatomic, copy)NSString*transFee	;     //运费
@property(nonatomic, copy)NSArray*subBizOrders	; //子订单

@end

//买家评价初始化model
@interface OMOrderPurCommentInitModel : BaseModel
@property(nonatomic, copy)NSArray* prods; // 评价产品
@property(nonatomic, copy)NSArray* list;  // 星级对应的描述[吐槽，较差，一般，满意，超赞]
@end
@interface OMOrderPurCommentInitProModel : BaseModel
@property(nonatomic, copy)NSString*prodId    ;//商品id
@property(nonatomic, copy)NSString*prodPic    ;//商品图片
@end

//卖家评价初始化model
@interface OMOrderSelCommentInitModel : BaseModel
@property(nonatomic, copy)NSString*buyerPic	;//买家头像
@property(nonatomic, copy)NSString*buyerName	;//买家
@property(nonatomic, copy)NSArray* list;  // 星级对应的描述[吐槽，较差，一般，满意，超赞]
@end

