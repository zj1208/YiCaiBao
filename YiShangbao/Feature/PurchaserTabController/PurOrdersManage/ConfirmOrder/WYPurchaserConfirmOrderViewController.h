//
//  WYPurchaserCofirmOrderViewController.h
//  YiShangbao
//
//  Created by light on 2017/9/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPurchaserConfirmOrderViewController : UIViewController

//购物车传参数
@property (nonatomic ,copy) NSString *cartIds;//"购物车id,购物车id"


//直接购买传参数
@property (nonatomic) NSInteger itemId;//产品id
@property (nonatomic) NSInteger quantity;

@end
