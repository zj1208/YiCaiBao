//
//  WYPurchaserConfirmOrderFooterView.m
//  YiShangbao
//
//  Created by light on 2017/9/4.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserConfirmOrderFooterView.h"
#import "WYPlaceOrderModel.h"

NSString * const WYPurchaserConfirmOrderFooterViewID = @"WYPurchaserConfirmOrderFooterViewID";

@interface WYPurchaserConfirmOrderFooterView()<UITextFieldDelegate>

@property (nonatomic ,strong) UIView *messageView;
@property (nonatomic ,strong) UILabel *messageLabel;
@property (nonatomic ,strong) UITextField *messageTextField;

@property (nonatomic ,strong) UIView *line;
@property (nonatomic ,strong) UILabel *countLabel;
@property (nonatomic ,strong) UILabel *priceLabel;

@property (nonatomic ,strong) UIView *line2;
@property (nonatomic ,strong) UILabel *freightNameLabel;
@property (nonatomic ,strong) UILabel *freightPriceLabel;

@property (nonatomic ,strong) UIButton *reduceQuantityButton;
@property (nonatomic ,strong) UIButton *addQuantityButton;
@property (nonatomic ,strong) UITextField *orderQuantityTextField;



@property (nonatomic ,strong) WYConfirmOrderModel *model;
@property (nonatomic ,strong) WYConfirmOrderGoodsModel *goodsModel;

@end

@implementation WYPurchaserConfirmOrderFooterView

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithReuseIdentifier:reuseIdentifier];
    if (self) {
        
        UIView *backView = [[UIView alloc]init];
        backView.backgroundColor = [UIColor whiteColor];
        [self addSubview:backView];
        [backView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self);
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
        }];
        
        self.line = [[UIView alloc]init];
        self.line.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-45);
            make.height.equalTo(@0.5);
        }];
        
        self.priceLabel = [[UILabel alloc]init];
        self.priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
        self.priceLabel.font = [UIFont systemFontOfSize:16];
        [self addSubview:self.priceLabel];
        [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(8);
            make.right.equalTo(self).offset(-15);
        }];
        
        self.countLabel = [[UILabel alloc]init];
        self.countLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.countLabel.font = [UIFont systemFontOfSize:12];
        [self addSubview:self.countLabel];
        [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.line.mas_bottom).offset(12);
            make.right.equalTo(self.priceLabel.mas_left);
        }];
        
        
        self.line2 = [[UIView alloc]init];
        self.line2.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        [self addSubview:self.line2];
        [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-95);
            make.height.equalTo(@0.5);
        }];

        self.freightNameLabel = [[UILabel alloc]init];
        self.freightNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.freightNameLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.freightNameLabel];
        [self.freightNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.line2.mas_top).offset(-14);
            make.left.equalTo(self).offset(15);
        }];

        self.freightPriceLabel = [[UILabel alloc]init];
        self.freightPriceLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.freightPriceLabel.font = [UIFont systemFontOfSize:13];
        [self addSubview:self.freightPriceLabel];
        [self.freightPriceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.line2.mas_top).offset(-14);
            make.right.equalTo(self).offset(-15);
        }];
        
        self.messageView = [[UIView alloc]init];
//        self.messageView.layer.borderColor = [UIColor colorWithHex:0xF58F23 alpha:0.08].CGColor;
//        self.messageView.layer.borderWidth = 0.5;
        self.messageView.backgroundColor = [UIColor colorWithHex:0xF58F23 alpha:0.08];
        self.messageView.layer.cornerRadius = 4.0;
        self.messageView.layer.masksToBounds = YES;
        [self addSubview:self.messageView];
        [self.messageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.line).offset(-5);
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self).offset(-4);
            make.height.equalTo(@40);
        }];
        
        self.messageLabel = [[UILabel alloc]init];
        self.messageLabel.textColor = [UIColor colorWithHex:0xF58F23];
        self.messageLabel.font = [UIFont systemFontOfSize:13];
        [self.messageView addSubview:self.messageLabel];
        [self.messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.messageView).offset(10);
            make.centerY.equalTo(self.messageView);
        }];
        
        self.messageTextField = [[UITextField alloc]init];
        self.messageTextField.textColor = [UIColor colorWithHex:0xF58F23];
        self.messageTextField.font = [UIFont systemFontOfSize:13];
        [self.messageView addSubview:self.messageTextField];
        [self.messageTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.messageView);
            make.left.equalTo(self.messageView).offset(78);
            make.right.equalTo(self.messageView);
            make.bottom.equalTo(self.messageView);
        }];
        
        UIView *line2 = [[UIView alloc]init];
        line2.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        [self addSubview:line2];
        [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.right.equalTo(self);
            make.bottom.equalTo(self).offset(-10);
            make.height.equalTo(@0.5);
        }];
        
        UIView *backView2 = [[UIView alloc]init];
        backView2.backgroundColor = [UIColor colorWithHex:0xF5F5F5];
        [self addSubview:backView2];
        [backView2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.bottom.equalTo(self);
            make.height.equalTo(@10);
        }];
        
        
        
        //直接购买时修改数量
        self.countView = [[UIView alloc]init];
        [self addSubview:self.countView];
        [self.countView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self);
            make.right.equalTo(self);
            make.height.equalTo(@45);
            make.bottom.equalTo(self.line2.mas_top).offset(-45);
        }];
        
        
        UIView *line3 = [[UIView alloc]init];
        line3.backgroundColor = [UIColor colorWithHex:0xE1E2E3];
        [self.countView addSubview:line3];
        [line3 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countView);
            make.right.equalTo(self.countView);
            make.bottom.equalTo(self.countView);
            make.height.equalTo(@0.5);
        }];
        
        self.addQuantityButton = [[UIButton alloc]init];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
        [self.countView addSubview:self.addQuantityButton];
        [self.addQuantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.countView).offset(-5);
            make.bottom.equalTo(self.countView).offset(-8);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        self.reduceQuantityButton = [[UIButton alloc]init];
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
        [self.countView addSubview:self.reduceQuantityButton];
        [self.reduceQuantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.countView).offset(-64);
            make.bottom.equalTo(self.countView).offset(-8);
            make.width.equalTo(@30);
            make.height.equalTo(@30);
        }];
        
        self.orderQuantityTextField = [[UITextField alloc]init];
        self.orderQuantityTextField.font = [UIFont systemFontOfSize:13];
        self.orderQuantityTextField.textColor = [UIColor colorWithHex:0x2F2F2F];
        self.orderQuantityTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.orderQuantityTextField.textAlignment = NSTextAlignmentCenter;
        [self.countView addSubview:self.orderQuantityTextField];
        [self.orderQuantityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.reduceQuantityButton.mas_right).offset(-6);
            make.right.equalTo(self.addQuantityButton.mas_left).offset(6);
            make.centerY.equalTo(self.reduceQuantityButton);
            make.height.equalTo(self.reduceQuantityButton);
        }];
        
        UILabel *countNameLabel = [[UILabel alloc]init];
        countNameLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
        countNameLabel.font = [UIFont systemFontOfSize:13];
        [self.countView addSubview:countNameLabel];
        [countNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.countView).offset(15);
            make.centerY.equalTo(self.countView);
        }];
        
        countNameLabel.text = @"购买数量";
        self.messageLabel.text = @"买家留言：";
        
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"请备注您想要买的产品规格或其他要求" attributes:
                                          @{NSForegroundColorAttributeName:[UIColor colorWithHex:0xFFBD9D],
                                            NSFontAttributeName:self.messageTextField.font
                                            }];
        self.messageTextField.attributedPlaceholder = attrString;
        self.messageTextField.delegate = self;
        self.orderQuantityTextField.delegate = self;
        [self.orderQuantityTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
        
        [self.reduceQuantityButton addTarget:self action:@selector(reduceQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.addQuantityButton addTarget:self action:@selector(addQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}


- (void)updateData:(id)model{
    
    if ([model isKindOfClass:[WYConfirmOrderModel class]]) {
        WYConfirmOrderModel *goodsModel = model;
        self.model = goodsModel;
        self.freightNameLabel.text = goodsModel.postageLabel;
        self.freightPriceLabel.text = goodsModel.postageFee;
        self.countLabel.text = [self countLabelByTotalQuantityLabel:goodsModel.totalQuantityLabel withTotalQuantity:goodsModel.totalQuantity withTotalPriceLabel:goodsModel.totalPriceLabel];
        self.priceLabel.text = goodsModel.totalPrice;
        self.messageTextField.text = goodsModel.leaveMessage;
        if (self.model.itemList.count > 0){
            self.goodsModel = self.model.itemList[0];
            self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.quantity];
        }
        [self changeCount];
    }
    
}

- (NSString *)countLabelByTotalQuantityLabel:(NSString *)totalQuantityLabel withTotalQuantity:(NSInteger)totalQuantity withTotalPriceLabel:(NSString *)totalPriceLabel{
    NSMutableString *str = [NSMutableString stringWithFormat:@"%@ %@",totalQuantityLabel,totalPriceLabel];
    NSString *resultStr = [str stringByReplacingOccurrencesOfString:@"{totalQuantity}" withString:[NSString stringWithFormat:@"%ld",(long)totalQuantity]];
    return resultStr;
}

- (void)reduceQuantityAction:(UIButton *)sender{
    if (self.orderQuantityTextField.isFirstResponder){
        [self endEditing:YES];
        return ;
    }
    [self endEditing:YES];
//    self.goodsModel.quantity --;
//    self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.quantity - 1];
//    [self changeCount];
    if (self.model.itemList.count > 0 && !self.countView.hidden){
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateQuantity:)]) {
            [self.delegate updateQuantity:self.goodsModel.quantity - 1];
        }
    }
}

- (void)addQuantityAction:(UIButton *)sender{
    if (self.orderQuantityTextField.isFirstResponder){
        [self endEditing:YES];
        return ;
    }
    [self endEditing:YES];
//    self.goodsModel.quantity ++;
//    self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",(long)self.goodsModel.quantity + 1];
//    [self changeCount];
    if (self.model.itemList.count > 0 && !self.countView.hidden){
        if (self.delegate && [self.delegate respondsToSelector:@selector(updateQuantity:)]) {
            [self.delegate updateQuantity:self.goodsModel.quantity + 1];
        }
    }
}

- (void)changeCount{
    if (self.goodsModel.quantity <= self.goodsModel.minQuantity) {
        self.reduceQuantityButton.userInteractionEnabled = NO;
        self.addQuantityButton.userInteractionEnabled = YES;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_dis_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
    }else if (self.goodsModel.quantity >= self.goodsModel.maxQuantity){
        self.reduceQuantityButton.userInteractionEnabled = YES;
        self.addQuantityButton.userInteractionEnabled = NO;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_dis_60"] forState:UIControlStateNormal];
    }else{
        self.reduceQuantityButton.userInteractionEnabled = YES;
        self.addQuantityButton.userInteractionEnabled = YES;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITextFieldDelegate
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (string.length > 0 && textField.text.length >= 40) {
        return NO;
    }
    return YES;
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == self.messageTextField) {
        self.model.leaveMessage = self.messageTextField.text;
    }else if (textField == self.orderQuantityTextField) {
        if (textField.text.integerValue > self.goodsModel.maxQuantity){
            [MBProgressHUD zx_showError:[NSString stringWithFormat:@"本产品最大订购量为%ld，超过不能购买噢",(long)self.goodsModel.maxQuantity] toView:nil];
            textField.text = [NSString stringWithFormat:@"%ld", (long)self.goodsModel.maxQuantity];
        }else if (textField.text.longLongValue < self.goodsModel.minQuantity) {
            [MBProgressHUD zx_showError:[NSString stringWithFormat:@"本产品最小起订量为%ld，起订量以下不能购买噢",(long)self.goodsModel.minQuantity] toView:nil];
            textField.text = [NSString stringWithFormat:@"%ld", (long)self.goodsModel.minQuantity];
        }
//        self.goodsModel.quantity = textField.text.integerValue;
        [self changeCount];
        if (self.model.itemList.count > 0 && !self.countView.hidden){
            if (self.delegate && [self.delegate respondsToSelector:@selector(updateQuantity:)]) {
                [self.delegate updateQuantity:textField.text.integerValue];
            }
        }
    }
}

- (void)textFieldChange:(UITextField *)textField{
    if (textField.text.length > 4) {
        self.orderQuantityTextField.font = [UIFont systemFontOfSize:10];
    }else{
        self.orderQuantityTextField.font = [UIFont systemFontOfSize:13];
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
