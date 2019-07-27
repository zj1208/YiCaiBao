//
//  ProductClassViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/11.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^ClassSelectedBlock)(NSString* sysCateIds,NSString* sysCateNames);

@interface ProductClassViewController : UIViewController
@property (nonatomic, copy)ClassSelectedBlock classSelectedBlock;

@property(nonatomic,strong)NSString* sysCateIds;//用户选择类目（id，多个","隔开）
@property(nonatomic,strong)NSString* sysCateNames;//用户选择类目（name，多个","隔开）

//设置至多选择个数
@property(nonatomic,assign)NSInteger maxSelectPuoducts;
//类目获取
@property(nonatomic,strong)NSNumber* level;


@end
