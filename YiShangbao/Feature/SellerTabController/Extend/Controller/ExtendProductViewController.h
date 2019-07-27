//
//  ExtendProductViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExtendModel.h"

@interface ExtendProductViewController : UIViewController

//校验类型 1-推产品 2-库存
@property(nonatomic,strong)NSNumber *numId;

//产品管理-推广时默认选择的产品（非必填，只适用于原生）
@property(nonatomic,strong)ExtendSelectProcuctModel *selProModel;

//重新发布,推广id(非必填，与selProModel不能同时存在，目前只用在了h5)
@property(nonatomic,strong)NSNumber *oldId;

@end
