//
//  SearchDetailViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/27.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JLCycleScrollerView.h"

@interface SearchDetailViewController : UIViewController

//隐藏底部“分类查找”按钮，默认NO （从分类查找进来时将隐藏“分类查找”按钮）
@property(nonatomic, assign)BOOL hiddenFenLeiBtn;
//底部分类查找按钮右约束，用于隐藏“分类查找”按钮
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fenleiBtn_trailingLayoutCon;

@property (weak, nonatomic) IBOutlet UIView *ParentView; //上层部分所有控件的父视图

@property (weak, nonatomic) IBOutlet UIView *stateView; //状态栏
@property (weak, nonatomic) IBOutlet UIView *NaviBarView;//自定义导航栏View
@property (weak, nonatomic) IBOutlet UIButton *NaviBackBtn;//导航栏返回按钮
@property (weak, nonatomic) IBOutlet UIButton *NaviSearchBtn;//导航栏搜索按钮

@property (weak, nonatomic) IBOutlet UIView *headerView;//轮播图／主营此商品的商铺有 1234565 家，点击查看  容器
@property (weak, nonatomic) IBOutlet JLCycleScrollerView *JLlunbotuView;//广告轮播
@property (weak, nonatomic) IBOutlet UIView *zhuyinBackView;//主营此商品的商铺有 1234565 家，点击查看  容器
@property (weak, nonatomic) IBOutlet UILabel *numOfShopsLabel;//主营此商品的商铺有 1234565 家，点击查看Label

@property (weak, nonatomic) IBOutlet UIView *chanpin_shangpuView;//产品商铺容器
@property (weak, nonatomic) IBOutlet UIButton *procuctBtn;//产品
@property (weak, nonatomic) IBOutlet UIView *procuctLine;//产品下划线
@property (weak, nonatomic) IBOutlet UIButton *shangPuBtn;//商铺
@property (weak, nonatomic) IBOutlet UIView *shangPuLine;//商铺下划线

@property (weak, nonatomic) IBOutlet UIView *diburongqiView;//底部容器View
@property (weak, nonatomic) IBOutlet UIButton *fenleichazhaoBtn;//分类查找按钮
@property (weak, nonatomic) IBOutlet UIButton *fabuqiugouBtn;//发求购按钮
@property (weak, nonatomic) IBOutlet UILabel *miaoshuLabel;//对结果不满意？试试

//****跳转需要传入参数*******
@property(nonatomic,strong)NSString*searchKeyword;//搜索关键词，类目搜索的情况设置为类目名称
@property(nonatomic,assign)NSInteger keywordType;//关键词类型 0-搜索 1-类目 2-产品（猜你想找）
@property(nonatomic,strong)NSNumber*catId;//类目id（只有在类目搜索(分类查找)的情况下才需要设置，其他情况为空）


@end
