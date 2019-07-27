//
//  WYPayDepositViewController.h
//  YiShangbao
//
//  Created by light on 2017/10/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PaySuccessBlock)(void);

@interface WYPayDepositViewController : UIViewController

@property (nonatomic, copy) NSString *comboId;
@property (nonatomic, copy) NSString *orderId;

@property (nonatomic, copy) PaySuccessBlock paySuccessBlock;

@end
