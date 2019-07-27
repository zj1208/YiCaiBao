//
//  JLDynamicMenuView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/8/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLDynamicMenuCollectionViewCell.h"
#import "JLDynamcMenuProtocol.h"
@class JLDynamicMenuView;

@protocol JLDynamicMenuViewDelegate <NSObject>
@optional
-(void)jl_JLDynamicMenuView:(JLDynamicMenuView *)view willDisplayCell:(JLDynamicMenuCollectionViewCell*)cell cellForItemAtInteger:(NSInteger)integer;
-(void)jl_JLDynamicMenuView:(JLDynamicMenuView *)view didSelectItemAtInteger:(NSInteger)integer;
@end

@protocol JLDynamicMenuViewDataSource <NSObject>
@required
/** 在该代理直接cell样式，数据设置*/
-(void)jl_JLDynamicMenuView:(JLDynamicMenuView *)view cell:(JLDynamicMenuCollectionViewCell*)cell cellForItemAtInteger:(NSInteger)integer;
@end
@interface JLDynamicMenuView : UIView

//cell组间距,defoult is UIEdgeInsetsMake(12.f,LCDScale_iPhone6_Width(20.f),20.f, LCDScale_iPhone6_Width(20.f)); //顶部实际为20（12+jl_IconTop）;
@property (nonatomic) UIEdgeInsets jl_sectionInset;

//cell间水平间距,defoult is LCDScale_iPhone6_Width(20.f);
@property(nonatomic,assign)CGFloat jl_minimumInteritemSpacing;

//cell间垂直间距,defoult is 20.f（12+jl_IconTop);
@property(nonatomic,assign)CGFloat jl_minimumLineSpacing;

//cell布局方向上(每行、列)最多个数,defoult is 4 count
@property(nonatomic,assign)NSInteger jl_maxCount;

//cell上图标距离cell顶部间距，defoult is 8.f
@property(nonatomic,assign)CGFloat jl_IconTop;

//cell上图标大小,defoult is  CGSizeMake(LCDScale_iPhone6_Width(40.f), LCDScale_iPhone6_Width(40.f));
@property(nonatomic)CGSize jl_IconSize;

//cell图标与label间距，defoult is 8.f
@property(nonatomic,assign)CGFloat jl_IconTitleHeight;

//cell上label高度，defoult is 15.f，
@property(nonatomic, assign)CGFloat jl_TitleHeight;

// defoult is NO
@property(nonatomic)BOOL scrollEnabled;
// default is UICollectionViewScrollDirectionVertical
@property (nonatomic) UICollectionViewScrollDirection scrollDirection;
//自定义cell
-(void)setCustomCell:(UICollectionViewCell<JLDynamcMenuProtocol> *)cell isXibBuild:(BOOL)isxib;

@property(nonatomic,strong)NSArray* arrayData;
@property(nonatomic,weak)id<JLDynamicMenuViewDelegate>delegate;
@property(nonatomic,weak)id<JLDynamicMenuViewDataSource>dataSource;

//1.获取当前JLDynamicMenuView高度;
- (CGFloat)getHeightByLayoutAttributesWithContentData:(NSArray*)array;
//2.获取当前JLDynamicMenuView高度;
- (CGFloat)getHeightByCalculationWithContentData:(NSArray*)array;
@end
