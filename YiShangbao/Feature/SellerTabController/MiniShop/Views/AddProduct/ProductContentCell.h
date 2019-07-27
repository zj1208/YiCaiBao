//
//  ProductContentCell.h
//  YiShangbao
//
//  Created by simon on 17/2/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  货源类型／起订量／批发价

#import "BaseTableViewCell.h"
#import "TMDiskManager.h"
#import "ProductModel.h"

@interface ProductContentCell : BaseTableViewCell<UITextFieldDelegate>

// 货源类型
@property (weak, nonatomic) IBOutlet UILabel *productSourceLab;

//有现货
@property (weak, nonatomic) IBOutlet UIButton *promptGoodsBtn;
//可定制，无现货
@property (weak, nonatomic) IBOutlet UIButton *noPromptGoodsBtn;

@property (nonatomic, strong)TMDiskManager *diskManager;

////单价面议
//@property (weak, nonatomic) IBOutlet UIButton *priceNegotiableBtn;
////自己输入价格按钮
//@property (weak, nonatomic) IBOutlet UIButton *actualPriceBtn;
////自己输入价格
//@property (weak, nonatomic) IBOutlet UITextField *customPriceField;

////输入单位
//@property (weak, nonatomic) IBOutlet UITextField *unitField;
////起订量
//@property (weak, nonatomic) IBOutlet UITextField *orderCountField;


@property (nonatomic, strong)UIButton *goodsSelectBtn;
//@property (nonatomic, strong)UIButton *priceSelectBtn;

//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *priceRightLayout;
//@property (weak, nonatomic) IBOutlet NSLayoutConstraint *goodsRightLayout;

- (IBAction)getPromptGoodsAction:(UIButton *)sender;

- (void)setPromptGoodsWithButton:(UIButton *)sender;

//- (IBAction)getGoodsPriceAction:(UIButton *)sender;

//获取是否现货
- (NSInteger)getGoodsPromptType;

////获取商品单价
//- (NSString *)getSelectedTradePrice;

@end
