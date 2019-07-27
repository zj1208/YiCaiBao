//
//  WYTimeManager.m
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/21.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYTimeManager.h"

static NSTimeInterval appStartEventTimeInterval = 30.0*60.0;
//static NSTimeInterval appStartEventTimeInterval = 10.0;

//开单横条
static NSString *WYTipServiceInfoday = @"WYTipServiceInfoday";
//开单弹窗
static NSString *WYPopServiceday = @"WYPopServiceday";

@implementation WYTimeManager
+(WYTimeManager *)shareTimeManager{
    static dispatch_once_t once;
    static WYTimeManager *mInstance;
    dispatch_once(&once, ^{
        mInstance = [[WYTimeManager alloc] init];
    });
    return mInstance;
}

/**------Purchaser------ */
-(NSString*)setCurryTimeToLastRequestPurchaserListData
{
    NSTimeInterval timestamp = [[NSDate date] timeIntervalSince1970];
    double time = timestamp*1000;
    NSInteger timeme = (NSInteger)floor(time);
    NSString* timestampRequestFirstPageTime = [NSString stringWithFormat:@"%ld",timeme];

    [[NSUserDefaults standardUserDefaults] setObject:timestampRequestFirstPageTime forKey:T_LastRequestPurchaserListData];
    [[NSUserDefaults standardUserDefaults] synchronize];

    return [self getLastRequestPurchaserListData];
}
-(NSString *)getLastRequestPurchaserListData
{
    NSString* str =  [[NSUserDefaults standardUserDefaults] objectForKey:T_LastRequestPurchaserListData];
    return str;
}


/**---AppStartEvent----*/
-(void)setCurryTimeToLastAppStartEvent
{
    NSDate*currentDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:AppTimeLastOpenDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
//    return [self getLastTimeAppStartEvent];
}


-(void)removeLastAppStartEventTime
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:AppTimeLastOpenDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

//上次图片下载成功时间
-(NSDate *)getLastTimeAppStartEvent
{
    NSDate* lastDate =  [[NSUserDefaults standardUserDefaults] objectForKey:AppTimeLastOpenDate];
    NSLog(@"AppTimeLastOpenDate=%@",lastDate);
    return lastDate;
}

-(BOOL)isLastAppStartEventEqualMore_30min
{
    NSDate *userLastOpenDate = [self getLastTimeAppStartEvent];
    NSTimeInterval timestamp = [userLastOpenDate timeIntervalSinceNow]; //负数
    if (timestamp <= -appStartEventTimeInterval) {
        return YES;
    }
    return NO;
}


- (void)setCurrentTimeWithLastLogin
{
    NSDate*currentDate = [NSDate date];
    [[NSUserDefaults standardUserDefaults] setObject:currentDate forKey:ud_LastLoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSDate *)getCurrentTimeWithLastLogin
{
    NSDate* lastDate =  [[NSUserDefaults standardUserDefaults] objectForKey:ud_LastLoginDate];
    return lastDate;
}

- (void)removeCurrentTimeWithLastLogin
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:ud_LastLoginDate];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)isShowPopMakeBillServiceIsNeedSave:(BOOL)save{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *currentDateStr = [dateFor stringFromDate:[NSDate date]];
    
    NSString *saveString = [UserDefault objectForKey:WYPopServiceday];
    
    if ([currentDateStr isEqualToString:saveString]) {
        return NO;
    }
    if (save) {
        [UserDefault setObject:currentDateStr forKey:WYPopServiceday];
    }
    return YES;
}

- (BOOL)isShowMakeBillTipViewIsNeedSave:(BOOL)save{
    NSDateFormatter *dateFor = [[NSDateFormatter alloc] init];
    dateFor.dateFormat =@"MM月-dd日";
    NSString *currentDateStr = [dateFor stringFromDate:[NSDate date]];
    NSString *saveString = [UserDefault objectForKey:WYTipServiceInfoday];
    if ([currentDateStr isEqualToString:saveString]) {
        return NO;
    }
    if (save) {
        [UserDefault setObject:currentDateStr forKey:WYTipServiceInfoday];
    }
    return YES;
}
@end
