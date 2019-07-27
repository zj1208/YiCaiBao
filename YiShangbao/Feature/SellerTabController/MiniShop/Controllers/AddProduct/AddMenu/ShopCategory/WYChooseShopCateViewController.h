//
//  WYChooseShopCateViewController.h
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^SelectedCate)(NSArray * selectedArray);

@interface WYChooseShopCateViewController : UIViewController


- (void)selectedArray:(NSArray *)selectedArray return:(SelectedCate)block;

- (void)moveFromCate:(NSString *)fromCate withProds:(NSString *)prodIds;

@end
