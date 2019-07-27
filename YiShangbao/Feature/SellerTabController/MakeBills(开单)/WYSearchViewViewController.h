//
//  WYSearchViewViewController.h
//  YiShangbao
//
//  Created by light on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYSearchViewViewControllerDelegate <NSObject>
@optional

- (void)searchWord:(NSString *)searchWord;

@end

@interface WYSearchViewViewController : UIViewController

@property (nonatomic, strong) id<WYSearchViewViewControllerDelegate> delegate;
@property (nonatomic, copy) NSString *serachWord;

@end
