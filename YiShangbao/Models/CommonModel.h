//
//  CommonModel.h
//  YiShangbao
//
//  Created by simon on 17/1/10.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "BaseModel.h"

@interface CommonModel : BaseModel


@end



@interface AliOSSPicUploadModel : BaseModel

@property (nonatomic) CGFloat h;
@property (nonatomic) CGFloat w;
@property (nonatomic,copy) NSString *p;

@end



@interface  AliOSSPicModel: BaseModel

@property (nonatomic) CGFloat height;
@property (nonatomic) CGFloat width;
@property (nonatomic,copy) NSString *picURL;

@end


@interface WYButtonModel : BaseModel

@property (nonatomic, copy) NSString *buttonTitle;
@property (nonatomic) NSInteger buttonType;
@property (nonatomic ,copy) NSString *url;


@end

@interface EvluateBtnModel : BaseModel

@property (nonatomic, strong) NSNumber *buttonTitle;
@property (nonatomic) NSInteger buttonType;
@property (nonatomic ,copy) NSString *url;

@end


typedef NS_ENUM(NSInteger, ButtonCode)
{
    ButtonCode_confirmOrder1 = 0,//确认订单
    ButtonCode_modifyPrice1 = 1,//修改价格-没有按钮
    ButtonCode_delivery1 = 2, //立即发货
    ButtonCode_handleRefund1 = 3, //处理退款
    ButtonCode_showLogistics1 = 4,//查看物流
    ButtonCode_evaluate1 = 5,//评价
    ButtonCode_evaluated1 = 6,//已评价
    ButtonCode_detail1 = 7,//查看详情
    ButtonCode_closeOrder1 = 8,//关闭订单
    ButtonCode_agreeRefund1 = 9,//同意退款 -退款详情
    ButtonCode_refuseRefund1 = 10,//拒绝退款 -退款详情
    ButtonCode_refundFinish1 = 11,//退款成功 --订单详情有
    
    
    ButtonCode_closeOrder2 = 12,//关闭订单---
    ButtonCode_payOrder2 = 13,//立即支付
    ButtonCode_refund2 = 14,//申请退款
    ButtonCode_detail2 = 15,//查看详情
    ButtonCode_showLogistics2 = 16,//查看物流
    ButtonCode_confirmReceipt2 = 17,//确认收货
    ButtonCode_evaluate2 = 18,//评价
    ButtonCode_evaluated2 = 19,//已评价
    ButtonCode_cancelRefund2 = 20,//撤销退款 - 退款详情
    ButtonCode_refunding2 = 21,//退款中   -订单详情
    ButtonCode_refundFinish2 = 22,//退款成功 -退款详情
    
    ButtonCode_refundAndClose1 = 23,//商户自己主动关闭订单及退款-订单列表+详情

};


@interface OrderButtonModel : BaseModel
//名称
@property (nonatomic, copy) NSString *name;
//样式枚举,1白色，2黄色
@property (nonatomic, strong) NSNumber *style;
//跳转控制,名称的固定code
@property (nonatomic, assign) ButtonCode code;
//按钮位置，down：下，up：上
@property (nonatomic, copy) NSString *location;
//跳转地址-h5
@property (nonatomic , copy) NSString *url;
@end

@interface WYIconModlel : BaseModel
@property (nonatomic, copy)  NSString *scene;   //string    场景枚举
@property (nonatomic, copy)  NSString *iconUrl;   //string    图标url
@property (nonatomic, strong) NSNumber *width;   //int    图标宽
@property (nonatomic, strong) NSNumber *height;   //int    图标高
@end


// 获取主营类目 item
@interface CodeModel : BaseModel

@property (nonatomic, copy) NSString *value;
@property (nonatomic, strong) NSNumber *code;
@end
