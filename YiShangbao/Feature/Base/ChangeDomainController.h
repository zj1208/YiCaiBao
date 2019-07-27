//
//  ChangeDomainController.h
//  YiShangbao
//
//  Created by simon on 17/4/6.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  测试用的切换环境

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ChangeDomainType){
    
    ChangeDomainType_develop = 0,
    ChangeDomainType_test = 1,
    ChangeDomainType_online = 2,
    
};




@interface ChangeDomainController : UIViewController

@end
