//
//  WYSelectCityView.h
//  YiShangbao
//
//  Created by 何可 on 2017/1/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYSelectCityView : UIView

-(instancetype)initSelectFrame:(CGRect)rect WithTitle:(NSString *)title;

-(void)showCityView:(void(^)(NSDictionary *provice, NSDictionary *city, NSDictionary *dis))selectDic;

@end
