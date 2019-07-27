//
//  AddProductController.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

// 添加 ，编辑   页面展示及功能；
typedef NS_ENUM(NSInteger ,ControllerDoingType) {
    
    ControllerDoingType_AddProduct = 0,
    ControllerDoingType_EditProduct = 1,
};

// 页面来源跳转控制；
typedef NS_ENUM(NSInteger, AddProudctPushType)
{
    //  其他来源，直接去新的产品管理页面；
    AddProudctPushType_goToNewProductManager = 0,
    //  如果是产品管理页面过来的，点击上架的时候要返回产品管理页面，及选中公开/私密；
    AddProudctPushType_goBackProductManager = 1,
    //  分类设置返回
    AddProudctPushType_goBackShopClassifySetting = 2,
};


// 保存类型
typedef NS_ENUM(NSInteger, ProductSaveAction){
    
    ProductSaveAction_toPrivacy = 0,
    ProductSaveAction_toPublic = 1,
    ProductSaveAction_edit = 2,

};


@interface AddProductController : UIViewController

// 新增产品的时候，用于判断页面来源跳转控制；
@property (nonatomic, assign) AddProudctPushType addProductPushType;

// 页面事件类型：编辑还是新增；
@property (nonatomic, assign) ControllerDoingType controllerDoingType;

// 编辑产品的产品id
@property (nonatomic, copy) NSString *productId;
// 本店分类codeModel数组
@property (nonatomic, copy) NSArray *shopClassifys;

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomContainerView;


//右上角按钮
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
- (IBAction)saveBtnAction:(UIButton *)sender;

@end
