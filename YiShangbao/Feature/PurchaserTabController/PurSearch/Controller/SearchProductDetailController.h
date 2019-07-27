//
//  SearchProductDetailController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/9/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScrollViewMoveUpDownProtocol.h"
/**
 *  cell类型枚举
 */
typedef NS_ENUM(NSInteger,SearchDetailCellType){
    
    SearchDetailCellTypeAllLCDStyle         = 0,  //整屏宽Cell
    
    SearchDetailCellTypeHalfStyle          = 1,  //一半屏宽Cell
    
    SearchDetailCellTypeHeBingStyle        = 2,   //合并相同商家Cell
    
};

@interface SearchProductDetailController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *chanpinshaixuanBackView;//产品筛选容器
@property (weak, nonatomic) IBOutlet UIButton *renzhengBtn;//产品认证状态《已认证》
@property (weak,nonatomic)  IBOutlet UIButton *hebingshangjiaBtn;//合并相同上架
@property (weak, nonatomic) IBOutlet UIButton *styleqiehuan;//样式切换
@property (weak, nonatomic) IBOutlet UIButton *shaixuanBtn;//筛选

@property (weak, nonatomic) IBOutlet UICollectionView *productCollectionView;
@property (nonatomic,weak) id<ScrollViewMoveUpDownProtocol>delegate;


//****跳转需要传入参数*******
@property(nonatomic,strong)NSString*searchKeyword;//搜索关键词，类目搜索的情况设置为类目名称
@property(nonatomic,assign)NSInteger keywordType;//关键词类型 0-搜索 1-类目 2-产品（猜你想找）
@property(nonatomic,strong)NSNumber*catId;//类目id（只有在类目搜索的情况下才需要设置，其他情况为空）

-(void)removeWYSelectedTableViewIfNeed;

@end
