//
//  JLStartView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/7.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JLStartView;
@protocol JLStartViewDelegate <NSObject>

/**
 评分点击回掉

 @param JLStartView JLStartView description
 @param score 1-5分
 */
-(void)jl_JLStartView:(JLStartView*)JLStartView didClcikWithScore:(NSInteger)score;

@end
@interface JLStartView : UIView
@property(nonatomic,weak)id<JLStartViewDelegate>delegate;

@property(nonatomic,assign,readonly)CGFloat curryScore; //获取当前评分1-5分

@property(nonatomic,assign)BOOL isCanZero;//评分是否支持0分，用于评分,默认值YES可以

//@property(nonatomic,assign)CGFloat startScore;//0～1,用于“显示评分”时初始化时必须设置，默认满分但是按钮是可以点击的，设置属性后才会关闭按钮点击事件



//简单处理，待优化
@property(nonatomic,assign)BOOL isSeller ;//默认是采购端no，商户端设置yes，只是用于切换不同🌟星星图片
@end
