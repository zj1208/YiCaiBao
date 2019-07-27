//
//  SODProductsView.h
//  YiShangbao
//
//  Created by 杨建亮 on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>


//cell类型
typedef NS_ENUM(NSInteger,SODProductsViewCellType) {
    SOD_ProductsCollectionViewCell = 0,             //订单详情产品Cell
    
    SOD_ProductsRefundDetailCollectionViewCell = 1  //退款详情产品Cell
};
@class SODProductsView;
@protocol SODProductsViewDelegate <NSObject>

@optional
-(void)jl_SODProductsView:(SODProductsView*)sodProductsView sourceArray:(NSArray*)array integer:(NSInteger)integer;


@end

@interface SODProductsView : UIView

@property(nonatomic,weak)id<SODProductsViewDelegate>delegate;

@property(nonatomic,assign)SODProductsViewCellType cellType;

-(void)setArray:(NSArray *)array;


- (CGFloat)getCellHeightWithContentData:(NSArray*)array;

@end
