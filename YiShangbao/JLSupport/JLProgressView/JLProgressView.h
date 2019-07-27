//
//  JLProgressView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/2/28.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
NS_ASSUME_NONNULL_BEGIN

@interface JLProgressView : UIView
@property(nonatomic) float jl_progress;                        // 0.0 .. 1.0, default is 0.0. 

-(void)simulationProgress;
-(void)simulationEndProgress:(BOOL)animated completion:(void (^ __nullable)(void))completion;
@end
NS_ASSUME_NONNULL_END
