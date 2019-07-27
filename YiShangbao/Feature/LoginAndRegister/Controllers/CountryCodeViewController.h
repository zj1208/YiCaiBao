//
//  CountryCodeViewController.h
//  YiShangbao
//
//  Created by 何可 on 2017/5/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SelectCity)(NSString *cityName);
@interface CountryCodeViewController : UIViewController
@property (nonatomic,strong) SelectCity selectCity;
@end
