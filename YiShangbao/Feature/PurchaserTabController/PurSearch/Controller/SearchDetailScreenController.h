//
//  SearchDetailScreenController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/14.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SearchDetailScreenController;
@protocol SearchDetailScreenControllerDelegate <NSObject>
@optional

/** 点击”完成“按钮代理 */
-(void)jl_SearchDetailScreenControllerTouchCompleteButton:(SearchDetailScreenController*)vc ;
/** 点击Cell代理（当前需求用不到）*/
-(void)jl_SearchDetailScreenControllerDidSelectItem:(SearchDetailScreenController*)vc ;
/** 移除视图操作代理（完成、取消、点击背景dissmiss） */
-(void)jl_SearchDetailScreenControllerWillRemove:(SearchDetailScreenController*)vc;
@end

@interface SearchDetailScreenController : UIViewController
/** 代理 */
@property (nonatomic,weak) id<SearchDetailScreenControllerDelegate>delegate;
/**是否有选中筛选条件*/
@property(nonatomic, assign ,readonly)BOOL isHaveData;


/*******读取部分业务参数********/
/**
 当前产品筛选条件 所在市场id，多个筛选条件用逗号分隔，可为空
 
 */
@property(nonatomic,strong, readonly) NSString* currySubmarketIdFilter;

/**
 当前产品筛选条件 类目id，多个筛选条件用逗号分隔，可为空<商铺情况下类目id不存在nil>
 
 */
@property(nonatomic,strong, readonly) NSString* curryCatIdFilter;
/**
 产品货源类型 0-全部 1-现货 2-订做<商铺情况下货源类型不存在nil>
 */
@property(nonatomic,assign, readonly) WYSearchProductType productSourceType;


//****需要传入参数*******
@property(nonatomic,strong)NSString*searchKeyword;//搜索关键词，类目搜索的情况设置为类目名称
@property(nonatomic,assign)NSInteger keywordType; //关键词类型 0-搜索 1-类目 2-产品（猜你想找）
@property(nonatomic,strong)NSNumber*catId;        //类目id（只有在类目搜索的情况下才需要设置，其他情况为空）
@property(nonatomic,assign)NSInteger authStatus;  // 认证状态 0-未认证 1-已认证
@property(nonatomic,assign)NSInteger type ;        //筛选条件类型 0-产品 1-商铺
@end
NS_ASSUME_NONNULL_END
