//
//  SEProductSelectController.h
//  YiShangbao
//
//  Created by 杨建亮 on 2018/4/8.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ProductDidSelectBlock)(NSMutableArray<__kindof ExtendSelectProcuctModel *>* arrayProducts);

@interface SEProductSelectController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *screenContentView;
@property (weak, nonatomic) IBOutlet UILabel *screenLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *screenLabelWidthLay;
@property (weak, nonatomic) IBOutlet UIButton *screenBtn;
@property (weak, nonatomic) IBOutlet UITextField *textfild;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@property (weak, nonatomic) IBOutlet UITableView *productTabView;

@property (weak, nonatomic) IBOutlet UIView *bottomContentView;
@property (weak, nonatomic) IBOutlet UILabel *currySelectLabel;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


//允许选择的最多产品数[0 NSIntegerMax]
@property (nonatomic) NSInteger maxProsucts;
//产品选择后回调
@property (nonatomic,copy) ProductDidSelectBlock productDidSelectBlock;

@end
