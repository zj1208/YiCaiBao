//
//  WYWriteShopNameViewController.h
//  YiShangbao
//
//  Created by light on 2017/11/1.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYWriteShopNameDelegate <NSObject>

- (void)confirmShopName:(NSString *)name;

@end


@interface WYWriteShopNameViewController : UIViewController

@property (nonatomic ,weak) id<WYWriteShopNameDelegate> delegate;
@property (nonatomic ,strong) NSString *shopName;

//第一次修改商铺名时使用
@property (nonatomic) BOOL isChangeShopName;

@end
