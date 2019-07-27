//
//  ExtendSuccessViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/5/19.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@class ExtendSuccessViewController;
@protocol ExtendSuccessViewControllerDelegate <NSObject>

-(void)ExtendSuccessViewControllerViewWillRemoveFromSuperview:(ExtendSuccessViewController*)extendSuccessViewController;
@end
@interface ExtendSuccessViewController : UIViewController
@property(nonatomic,weak)id<ExtendSuccessViewControllerDelegate>delegate;

-(void)shareWithImage:(NSString*)imageStr Title:(NSString *)title Content:(nullable NSString *)content withUrl:(NSString *)url;


@end
NS_ASSUME_NONNULL_END
