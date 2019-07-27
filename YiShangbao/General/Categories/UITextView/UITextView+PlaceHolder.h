//
//  UITextView+PlaceHolder.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/15.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/runtime.h>
@interface UITextView (PlaceHolder) 
@property (nonatomic, strong) UITextView *placeHolderTextView;
- (void)addPlaceHolder:(NSString *)placeHolder;
- (void)hiddenplaceHolderTextView;
- (void)appearplaceHolderTextView;
@end
