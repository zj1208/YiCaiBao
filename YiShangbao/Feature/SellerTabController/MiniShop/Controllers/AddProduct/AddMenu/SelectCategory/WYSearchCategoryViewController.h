//
//  WYSearchCategoryViewController.h
//  YiShangbao
//
//  Created by light on 2017/10/24.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYSearchCategoryViewControllerDelegate <NSObject>

- (void)selectedCategory:(NSString *)categoryString categoryId:(NSNumber *)cateId;

@end

@interface WYSearchCategoryViewController : UIViewController

@property (nonatomic ,weak) id<WYSearchCategoryViewControllerDelegate> delegate;

@property (nonatomic, strong) NSArray *historyArray;//最近使用类目

@end
