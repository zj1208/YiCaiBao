//
//  WYButtonsScrollView.h
//  YiShangbao
//
//  Created by light on 2017/10/31.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WYButtonsScrollViewDelegate <NSObject>

- (void)selectedButtonIndex:(NSInteger)index;

@end

@interface WYButtonsScrollView : UIScrollView<UIScrollViewDelegate>

@property (weak, nonatomic) id<WYButtonsScrollViewDelegate> delegateObj;

- (void)buttonsWithArray:(NSArray *)array;
- (void)selectButtonIndex:(NSInteger)index;

@end
