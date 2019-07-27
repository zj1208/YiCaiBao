//
//  JLDragImageView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/1/26.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, JLDragIVDirectionH) {
    JLDragIVLayoutRight   = 0 ,
    JLDragIVLayoutCenterX = 1,
    JLDragIVLayoutLeft    = 2,
};
typedef NS_ENUM(NSInteger, JLDragIVDirectionV) {
    JLDragIVLayoutBottom  = 0,
    JLDragIVLayoutCenterY = 1,
    JLDragIVLayoutTop     = 2,
};
@class JLDragImageView;
@protocol JLDragImageViewDelegate <NSObject>
@optional
- (void)JLDragImageView:(JLDragImageView *)view tapGes:(UITapGestureRecognizer*)tapGes;
@end
@interface JLDragImageView : UIImageView
- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithCoder:(NSCoder *)aDecoder;

//defoult is JLDragIVLayoutRight
@property(nonatomic)JLDragIVDirectionH layoutDirectionH;
//defoult is JLDragIVLayoutBottom
@property(nonatomic)JLDragIVDirectionV layoutDirectionV;
//添加到父视图设置frame
- (void)showSuperview:(UIView *)view frameOffsetX:(CGFloat)offsetH offsetY:(CGFloat)offsetV Width:(CGFloat)width Height:(CGFloat)height;
//defoult is NO;是否需要跟随手指拖拽出拖拽区域
@property(nonatomic)BOOL jl_outBounds;
//defoult is YES;靠近底部时是否需要自动吸附
@property(nonatomic)BOOL jl_isAdsorption;
//defoult is 40;底部的自动吸附间距
@property(nonatomic)CGFloat jl_adsorption;
//defoult is UIEdgeInsetsZero;拖拽区域距离父视图间距
@property(nonatomic)UIEdgeInsets jl_sectionInset;
@property(nonatomic,strong)UIPanGestureRecognizer *jl_panGes; //拖拽手势
@property(nonatomic,strong)UITapGestureRecognizer *jl_tapGes; // 点击手势
@property(nonatomic,weak)id<JLDragImageViewDelegate>delegate;
@end
