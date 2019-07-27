//
//  WYSelectedTableView.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/29.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger,WYSelectedTableViewType){
    
    SelectedTableView_product_renzheng       ,  //产品认证
    
    SelectedTableView_shop_renzheng          ,  //商铺认证
    
    SelectedTableView_shop_maoyileixing         //商铺贸易类型
};

@class WYSelectedTableView;
@protocol WYSelectedTableViewDelegate <NSObject>
-(void)jl_wySelectedTableView:(WYSelectedTableView*)wyselectedTableView type:(WYSelectedTableViewType)type didSelectWithInteget:(NSInteger)integer changed:(BOOL)changed;

-(void)jl_wySelectedTableViewViewWillRemove:(WYSelectedTableView*)wyselectedTableView type:(WYSelectedTableViewType)type;
@end

@interface WYSelectedTableView : UIView
-(instancetype)initWithFrame:(CGRect)frame WithArray:(NSArray*)array;
@property (nonatomic,assign)NSInteger DefaultSelectedInteger; //设置默认选择的cell
@property (nonatomic,strong)NSString *DefaultSelectedTitle;   //根据Title设置默认选择的cell

@property (nonatomic,assign)BOOL firstCellCanSelected;//设置第一个cell能否被选中
@property (nonatomic,weak) id<WYSelectedTableViewDelegate>delegate;
@property (nonatomic,assign)WYSelectedTableViewType type;


//-(void)updateFrame:(CGRect)frame; //处理数据过多时tableview高度显示几个cell


@end
