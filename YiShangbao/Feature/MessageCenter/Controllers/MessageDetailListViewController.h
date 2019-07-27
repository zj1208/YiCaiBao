//
//  MessageDetailListViewController.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageModel.h"


@interface MessageDetailListViewController : UIViewController

@property(nonatomic, strong) NSNumber *type;
@property(nonatomic, copy) NSString *typeName;


@property(nonatomic, strong)MessageModelSub *fathermodel;

@end
