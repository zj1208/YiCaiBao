//
//  TradeOrderContentCell.h
//  YiShangbao
//
//  Created by simon on 17/1/16.
//  Copyright © 2017年 com.Microants. All rights reserved.
//  报价

#import "BaseTableViewCell.h"
#import "ZXPlaceholdTextView.h"
#import "ZXTextRectTextField.h"

@interface TradeOrderContentCell : BaseTableViewCell<UITextFieldDelegate>
//是否现货容器
@property (weak, nonatomic) IBOutlet UIView *promptContainerView;

//定制按钮
@property (weak, nonatomic) IBOutlet UIButton *promptGoodsBtn;
//现货按钮
@property (weak, nonatomic) IBOutlet UIButton *noPromptGoodsBtn;
//产品单价容器
@property (weak, nonatomic) IBOutlet UIView *priceContainerView;
//起订量容器
@property (weak, nonatomic) IBOutlet UIView *orderContainerView;

// 3.7版本去除
////单价面议
//@property (weak, nonatomic) IBOutlet UIButton *priceNegotiableBtn;
////自己输入价格
//@property (weak, nonatomic) IBOutlet UIButton *actualPriceBtn;

//自己输入价格
@property (weak, nonatomic) IBOutlet ZXTextRectTextField *customPriceField;
//元
@property (weak, nonatomic) IBOutlet UILabel *yuanLab;

@property (weak, nonatomic) IBOutlet ZXPlaceholdTextView *textView;
//剩余字数
@property (weak, nonatomic) IBOutlet UILabel *remaindLab;
//textView容器
@property (weak, nonatomic) IBOutlet UIView *containerTextView;
//外商直采描述
@property (weak, nonatomic) IBOutlet UILabel *foreignDescLabel;

//起订量
@property (weak, nonatomic) IBOutlet ZXTextRectTextField *orderCountField;


@property (nonatomic, strong)UIButton *goodsSelectBtn;
@property (nonatomic, strong)UIButton *priceSelectBtn;

//    现货
- (IBAction)getPromptGoodsAction:(UIButton *)sender;

//    产品单价，3.7版本去除
//- (IBAction)getGoodsPriceAction:(UIButton *)sender;


//获取是否现货
- (NSInteger)getGoodsPromptType;
//获取商品单价
- (NSString *)getSelectedTradePrice;
@end
