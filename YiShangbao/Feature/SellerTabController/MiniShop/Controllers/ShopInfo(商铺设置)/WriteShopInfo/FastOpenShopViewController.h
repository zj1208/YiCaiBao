//
//  FastOpenShopViewController.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/20.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, SourceControllerType){
    
    SourceControllerType_Any = 0,           //其它方式直接返回；
//    SourceControllerType_TradeDetail = 1,   //生意详情过来的;
    SourceControllerType_OpenShopGuide = 2, //开店引导过来的;
    
    
//    SourceControllerType_WaiterView = 3, //市场服务
//    SourceControllerType_NowSetting = 4 , //接生意立即设置过来的，已传递未使用，
//    SourceControllerType_Extend     = 5    //推广过来的，已传递未使用
};

@interface FastOpenShopViewController : UIViewController

@property (nonatomic, assign)SourceControllerType soureControllerType;
////如果生意详情过来的，需要把这个数据传给接单页面；
//@property (nonatomic,strong)TradeDetailModel *dataModel;


@end
