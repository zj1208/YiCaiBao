//
//  WYAllCategoryViewController.h
//  YiShangbao
//
//  Created by light on 2017/10/26.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYAllCategoryViewControllerDelegate <NSObject>

- (void)selectedCategory:(NSString *)categoryString categoryId:(NSNumber *)cateId;

@end

@interface WYAllCategoryViewController : UIViewController

@property (nonatomic ,weak) id<WYAllCategoryViewControllerDelegate> delegate;

@end
