//
//  SearchViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//


#import <UIKit/UIKit.h>
@class SearchViewController;
@protocol SearchViewControllerDelegate <NSObject>
@optional
/**
 控制器将要dismiss

 @param vc 自身
 @param keywordType 关键词类型 0-搜索 1-类目 2-产品(猜你想找)
 @param searchKeyword 搜索关键词，类目搜索的情况设置为类目名称
 */
-(void)jl_willDismissSearchViewController:(SearchViewController*)vc keywordType:(NSInteger)keywordType searchKeyword:(NSString*)searchKeyword;
/**
 控制器dismiss完成

 @param vc 自身 如果要保留上次输入状态的话，设置全局变量strong，不需要了可以在此代理nil销毁
 */
-(void)jl_didDismissSearchViewController:(SearchViewController*)vc;

@end

@interface SearchViewController : UIViewController
@property (nonatomic,weak) id<SearchViewControllerDelegate>delegate;

@property (weak, nonatomic) IBOutlet UIView *stateView;
@property (weak, nonatomic) IBOutlet UITextField *sousuoTextfild;
@property (weak, nonatomic) IBOutlet UIButton *quxiaoBtn;

@property (weak, nonatomic) IBOutlet UIView *naviView;
@property (weak, nonatomic) IBOutlet UIView *loginView;
@property (weak, nonatomic) IBOutlet UIButton *loginbtn;

//设置默认自带搜索关键字
@property(nonatomic,strong)NSString* searchKeyword ;

@end
