//
//  TradeSearchController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/8/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class TradeSearchController;
//@protocol TradeSearchControllerDelegate <NSObject>
//@optional
///**
// 控制器将要dismiss
//
// @param vc 自身
// @param searchKeyword 搜索关键词, nil时表示点击的取消按钮
// */
//-(void)jl_willDismissTradeSearchController:(TradeSearchController*)vc searchKeyword:(nonnull NSString *)searchKeyword;
///**
// 控制器dismiss完成
//
// @param vc 自身
// */
//-(void)jl_didDismissTradeSearchController:(TradeSearchController*)vc;
//@end


@interface TradeSearchController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *naviView; 
@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UITextField *sousuoTextfild;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;

//@property (nonatomic,weak) id<TradeSearchControllerDelegate>delegate;

//设置默认搜索关键字
@property(nonatomic,strong)NSString* searchKeyword ;



@end
