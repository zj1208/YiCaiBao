//
//  MakeBillsTabController.h
//  YiShangbao
//
//  Created by simon on 2018/1/3.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,OBServiceType) { //服务校验类型
    OBServiceType_enterBill     = 0,  //enterBill:功能进入
    OBServiceType_newBill       = 1,  //newBill:  新建开单(点击开单-新增开单)
    OBServiceType_chart         = 2,  //chart:    报表(点击数据tab)
    OBServiceType_customer      = 3,  //customer: 客户(点击客户-新增客户)
};

typedef NS_ENUM(NSInteger,OBShowType) { //校验弹框类型
    OBShowType_none        = 0, //检查服务使用权限，没钱或试用过期不弹出《续费弹框》
    OBShowType_renewal     = 1, //检查服务使用权限，没钱或试用过期自动弹出《续费弹框》
    OBShowType_buyNow      = 2, //检查服务使用权限，并弹出《立即订购弹框》营销弹框
    OBShowType_must        = 3, //点击开单弹窗横幅，暂不检查服务使用权限，直接获取立即订购信息，弹《立即订购弹框》营销弹框
};

typedef NS_ENUM(NSInteger,CheckBlockType) {
    CheckBlockType_noNet        = 0, //网络请求失败
    CheckBlockType_disable     = 1,  //不允许使用
    CheckBlockType_oK      = 2,      //不需要服务校验免费使用，或者已购买、在试用期内允许使用
};
typedef void(^Success)(CheckBlockType isOk);
@interface MakeBillsTabController : UITabBarController

/**
 校验服务使用权限及自动弹框
 @param type      校验弹框类型
 @param funcName  服务校验类型
 @param succes    YES：不需要服务校验免费使用，或者已购买、在试用期内允许使用
 */
-(void)checkOpenBillTimeIsExpireView:(OBShowType)type checkService:(OBServiceType)funcName succes:(Success)succes;

@end
