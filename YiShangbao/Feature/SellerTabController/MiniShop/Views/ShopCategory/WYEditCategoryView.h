//
//  WYEditCategoryView.h
//  YiShangbao
//
//  Created by light on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYEditCategoryViewDelegate <NSObject>
@optional

- (void)renameCategory;
- (void)deleteCategory;

@end

@interface WYEditCategoryView : UIView

@property (nonatomic ,weak) id<WYEditCategoryViewDelegate> delegate;

@end
