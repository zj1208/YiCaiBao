//
//  OnePickerView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/23.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OnePickerView : UIView
@property(nonatomic, strong)NSArray *allarr; //所有数组数据

-(instancetype)initWithOnePickFrame:(CGRect)rect selectTitle:(NSString *)title;

-(void)showOnePickView:(void(^)(NSDictionary *marketStr))selectStr;
@end
