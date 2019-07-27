//
//  WYTimeManager.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#define WYTIMEMANAGER [WYTimeManager shareTimeManager]

#import <Foundation/Foundation.h>

//采购商首页
static NSString * const T_LastRequestPurchaserListData = @"LastRequestPurchaserListData";
//App开屏图下载
static NSString * const AppTimeLastOpenDate = @"AppTimeLastOpenDate";
//
static NSString *const ud_LastLoginDate =  @"ud_LastLoginDate";

@interface WYTimeManager : NSObject
+(WYTimeManager *)shareTimeManager;

/**采购商首页数据请求-后台接口缓存策略参数需要*/
- (NSString *)setCurryTimeToLastRequestPurchaserListData;
- (NSString *)getLastRequestPurchaserListData;

/**App开屏启动时间判断,30分钟更新一次开屏图*/
- (void)setCurryTimeToLastAppStartEvent; //保存当前时间并返回保存后取出的值
- (void)removeLastAppStartEventTime;
- (NSDate *)getLastTimeAppStartEvent;
- (BOOL)isLastAppStartEventEqualMore_30min;

// 最近登陆时间
- (void)setCurrentTimeWithLastLogin;
- (NSDate *)getCurrentTimeWithLastLogin;
- (void)removeCurrentTimeWithLastLogin;

//开单 当天是否点击
- (BOOL)isShowPopMakeBillServiceIsNeedSave:(BOOL)save;
- (BOOL)isShowMakeBillTipViewIsNeedSave:(BOOL)save;

@end
