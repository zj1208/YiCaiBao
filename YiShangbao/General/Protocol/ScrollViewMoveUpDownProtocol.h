//
//  ScrollViewMoveUpDownProtocol.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ScrollViewMoveUpDownProtocol <NSObject>

@optional
/**
 ScrollView 用户滑动代理
 @param moveUp 连续向上滑动一定距离
 */
-(void)jl_scrollViewDidScrollWithMoveUp:(BOOL)moveUp ;

@end
