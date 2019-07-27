//
//  FenLeiViewController.h
//  YiShangbao
//
//  Created by 海狮 on 17/6/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,FenLeiViewControllerPushStyle) {
    //默认点击某个分类Cell跳转下一级“搜索结果页”
    FenLeiPushDefault       = 0,
    
    //导航栏右侧不添加搜索按钮，点击某个分类cell时，仍旧跳转下一级“搜索结果页”，若当前分类查找页面上一级是“搜索结果页”时，移除该”搜索结果页”    eg: 从搜索结果页右下角分类查找按钮进入情况
    FenLeiDellocLast        = 1,
    

};
@interface FenLeiViewController : UIViewController
@property(nonatomic,assign)FenLeiViewControllerPushStyle pushstyle;


@property(nonatomic, copy) NSNumber *categroyId;                   //一级类目id,用于路由跳转指定默认定位哪个类目

@end
