//
//  AddProFreightListViewController.h
//  YiShangbao
//
//  Created by light on 2018/4/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^FreightTemplateBlock)(NSNumber *freightId,NSString *freightName);

@interface AddProFreightListViewController : UIViewController

@property (nonatomic, strong) NSNumber *freightId;
@property (nonatomic, copy)FreightTemplateBlock block;

@end
