//
//  BuyerInfoController.h
//  YiShangbao
//
//  Created by simon on 17/2/9.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef NS_ENUM(NSInteger, WYBOOLChat)
{
    WYBOOLChat_NO = 0,
    WYBOOLChat_YES =1
};


@interface BuyerInfoController : UIViewController

//新接口的bizId
@property (nonatomic, copy) NSString *bizId;

@property (nonatomic, assign) AddOnlineCustomerSourceType sourceType;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;

@property (nonatomic, assign) WYBOOLChat boolChat;


@end
