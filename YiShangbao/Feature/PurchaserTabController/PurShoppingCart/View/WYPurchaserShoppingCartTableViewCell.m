//
//  WYPurchaserShoppingCartTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/8/30.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYPurchaserShoppingCartTableViewCell.h"
#import "WYShopCartModel.h"

NSString * const WYPurchaserShoppingCartTableViewCellID = @"WYPurchaserShoppingCartTableViewCellID";

@interface WYPurchaserShoppingCartTableViewCell()<UITextFieldDelegate>

@property (nonatomic ,strong) UIImageView *selectedImageView;
@property (nonatomic ,strong) UIImageView *goodsImageView;

@property (nonatomic ,strong) UILabel *titleLabel;
@property (nonatomic ,strong) UILabel *goodsInfolabel;
@property (nonatomic ,strong) UILabel *minOrderQuantityLabel;//最小订货量
@property (nonatomic ,strong) UILabel *priceLabel;
@property (nonatomic ,strong) UILabel *unitLabel;

@property (nonatomic ,strong) UIButton *selectedButton;
@property (nonatomic ,strong) UIButton *reduceQuantityButton;
@property (nonatomic ,strong) UIButton *addQuantityButton;
@property (nonatomic ,strong) UITextField *orderQuantityTextField;

@property (nonatomic ,weak) WYShopCartGoodsModel *goodsModel;
@property (nonatomic ,strong) NSIndexPath *indexPath;

@end

@implementation WYPurchaserShoppingCartTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) return nil;
    
    self.selectedImageView = [[UIImageView alloc]init];
    [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
    [self addSubview:self.selectedImageView];
    [self.selectedImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(13);
        make.width.equalTo(@16);
        make.height.equalTo(@16);
    }];
    
    
    self.goodsImageView = [[UIImageView alloc]init];
    [self.goodsImageView setImage:AppPlaceholderImage];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.layer.borderColor = [UIColor colorWithHex:0xEEEEEE].CGColor;
    self.goodsImageView.layer.borderWidth = 1.0;
    self.goodsImageView.layer.cornerRadius = 4.0;
    self.goodsImageView.layer.masksToBounds = YES;
    [self addSubview:self.goodsImageView];
    [self.goodsImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self);
        make.left.equalTo(self).offset(42);
        make.width.equalTo(@93);
        make.height.equalTo(@93);
    }];
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.titleLabel.numberOfLines = 2;
    [self addSubview:self.titleLabel];
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.goodsInfolabel = [[UILabel alloc]init];
    self.goodsInfolabel.font = [UIFont systemFontOfSize:11];
    self.goodsInfolabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    [self addSubview:self.goodsInfolabel];
    [self.goodsInfolabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(5);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.minOrderQuantityLabel = [[UILabel alloc]init];
    self.minOrderQuantityLabel.font = [UIFont systemFontOfSize:11];
    self.minOrderQuantityLabel.textColor = [UIColor colorWithHex:0xF5BC23];
    [self addSubview:self.minOrderQuantityLabel];
    [self.minOrderQuantityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.goodsInfolabel.mas_bottom).offset(5);
        make.left.equalTo(self.goodsImageView.mas_right).offset(10);
        make.right.equalTo(self).offset(-15);
    }];
    
    
    self.selectedButton = [[UIButton alloc]init];
    [self addSubview:self.selectedButton];
    [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
        make.width.equalTo(@42);
    }];
    
    self.reduceQuantityButton = [[UIButton alloc]init];
    [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
    [self addSubview:self.reduceQuantityButton];
    [self.reduceQuantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(0);
        make.bottom.equalTo(self).offset(-6);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    self.addQuantityButton = [[UIButton alloc]init];
    [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
    [self addSubview:self.addQuantityButton];
    [self.addQuantityButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.goodsImageView.mas_right).offset(65);
        make.bottom.equalTo(self).offset(-6);
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    
    self.orderQuantityTextField = [[UITextField alloc]init];
    self.orderQuantityTextField.font = [UIFont systemFontOfSize:13];
    self.orderQuantityTextField.textColor = [UIColor colorWithHex:0x2F2F2F];
    self.orderQuantityTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.orderQuantityTextField.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.orderQuantityTextField];
    [self.orderQuantityTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.reduceQuantityButton.mas_right).offset(-6);
        make.right.equalTo(self.addQuantityButton.mas_left).offset(6);
        make.centerY.equalTo(self.reduceQuantityButton);
        make.height.equalTo(self.reduceQuantityButton);
    }];
    
    self.unitLabel = [[UILabel alloc]init];
    self.unitLabel.font = [UIFont systemFontOfSize:13];
    self.unitLabel.textColor = [UIColor colorWithHex:0xB1B1B1];
    self.unitLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.unitLabel];
    [self.unitLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-13);
        make.right.equalTo(self).offset(-15);
    }];
    
    self.priceLabel = [[UILabel alloc]init];
    self.priceLabel.font = [UIFont systemFontOfSize:16];
    self.priceLabel.textColor = [UIColor colorWithHex:0xF58F23];
    self.priceLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.priceLabel];
    [self.priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.left.greaterThanOrEqualTo(self.addQuantityButton.mas_right).offset(-5);
        make.right.equalTo(self.unitLabel.mas_left);
    }];
    
    
    [self.unitLabel setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    
    self.orderQuantityTextField.delegate = self;
    [self.orderQuantityTextField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.selectedButton addTarget:self action:@selector(selectedGoods:) forControlEvents:UIControlEventTouchUpInside];
    [self.reduceQuantityButton addTarget:self action:@selector(reduceQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.addQuantityButton addTarget:self action:@selector(addQuantityAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

- (void)reduceQuantityAction:(UIButton *)sender{
    [MobClick event:kUM_c_slreduce];
    [self endEditing:YES];
    if (self.goodsModel.quantity > self.goodsModel.moq){
        self.goodsModel.quantity --;
    }
    self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",self.goodsModel.quantity];
    [self changeCount];
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsChangeStatus:goodsId:quantity:)]) {
        [self.delegate goodsChangeStatus:ChangeGoodsCountStatusSuccess goodsId:self.goodsModel.cartId quantity:self.goodsModel.quantity];
    }
}

- (void)addQuantityAction:(UIButton *)sender{
    [MobClick event:kUM_c_sladd];
    [self endEditing:YES];
    if (self.goodsModel.quantity < self.maxProductDigit){
        self.goodsModel.quantity ++;
    }
    self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",self.goodsModel.quantity];
    [self changeCount];
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsChangeStatus:goodsId:quantity:)]) {
        [self.delegate goodsChangeStatus:ChangeGoodsCountStatusSuccess goodsId:self.goodsModel.cartId quantity:self.goodsModel.quantity];
    }
}

- (void)selectedGoods:(UIButton *)sender{
    self.goodsModel.isSelected = !self.goodsModel.isSelected;
    [self updateData:self.goodsModel];
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(goodsSelected:indexPath:)]) {
        [self.delegate goodsSelected:self.goodsModel.isSelected indexPath:self.indexPath];
    }
}

- (void)updateData:(id)model indexPath:(NSIndexPath *)indexPath{
    self.indexPath = indexPath;
    [self updateData:model];
}

- (void)updateData:(id)model{
    if ([model isKindOfClass:[WYShopCartGoodsModel class]]) {
        self.goodsModel = model;
        [self.goodsImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w200_hX relativeToImgPath:self.goodsModel.picUrl] placeholderImage:AppPlaceholderImage];
        self.titleLabel.text = self.goodsModel.name;
        self.goodsInfolabel.text = self.goodsModel.spec;
        self.minOrderQuantityLabel.text = [NSString stringWithFormat:@"起订量：%ld",self.goodsModel.moq];
        self.unitLabel.text = [NSString stringWithFormat:@"/%@",self.goodsModel.unit];
        self.priceLabel.text = self.goodsModel.price4Disp;
        self.orderQuantityTextField.text = [NSString stringWithFormat:@"%ld",self.goodsModel.quantity];
        
        if (self.goodsModel.isSelected){
            [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_sel"]];
        }else{
            [self.selectedImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
        }
        
        if (self.orderQuantityTextField.text.length > 4) {
            self.orderQuantityTextField.font = [UIFont systemFontOfSize:10];
        }else{
            self.orderQuantityTextField.font = [UIFont systemFontOfSize:13];
        }
    }
    [self changeCount];
}

#pragma mark - UITextFieldDelegate
//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    
//    NSInteger maxLength = 6;
//    return [UITextField xm_limitRemainText:textField shouldChangeCharactersInRange:range replacementString:string maxLength:maxLength remainTextNum:^(NSInteger remainLength) {
//        
//    }];
//}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    [MobClick event:kUM_c_slinput];
    if (textField.text.integerValue > self.maxProductDigit){
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsChangeStatus:goodsId:quantity:)]) {
            [self.delegate goodsChangeStatus:ChangeGoodsCountStatusFailureByMax goodsId:self.goodsModel.cartId quantity:self.maxProductDigit];
        }
        textField.text = [NSString stringWithFormat:@"%ld", self.maxProductDigit];
    }else if (textField.text.longLongValue < self.goodsModel.moq) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsChangeStatus:goodsId:quantity:)]) {
            [self.delegate goodsChangeStatus:ChangeGoodsCountStatusFailureByMin goodsId:self.goodsModel.cartId quantity:self.goodsModel.moq];
        }
        textField.text = [NSString stringWithFormat:@"%ld", self.goodsModel.moq];
    }else{
        if (self.delegate && [self.delegate respondsToSelector:@selector(goodsChangeStatus:goodsId:quantity:)]) {
            [self.delegate goodsChangeStatus:ChangeGoodsCountStatusSuccess goodsId:self.goodsModel.cartId quantity:textField.text.integerValue];
        }
    }
    self.goodsModel.quantity = textField.text.integerValue;
    [self changeCount];
}

- (void)textFieldChange:(UITextField *)textField{
    if (textField.text.length > 4) {
        self.orderQuantityTextField.font = [UIFont systemFontOfSize:10];
    }else{
        self.orderQuantityTextField.font = [UIFont systemFontOfSize:13];
    }
}

- (void)changeCount{
//    self.minOrderQuantityLabel.textColor = [UIColor colorWithHex:0xF5BC23];
    if (self.goodsModel.quantity <= self.goodsModel.moq) {
//        self.minOrderQuantityLabel.textColor = [UIColor redColor];
//        self.reduceQuantityButton.userInteractionEnabled = NO;
//        self.addQuantityButton.userInteractionEnabled = YES;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_dis_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
    }else if (self.goodsModel.quantity >= self.maxProductDigit){
//        self.reduceQuantityButton.userInteractionEnabled = YES;
//        self.addQuantityButton.userInteractionEnabled = NO;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_dis_60"] forState:UIControlStateNormal];
    }else{
//        self.reduceQuantityButton.userInteractionEnabled = YES;
//        self.addQuantityButton.userInteractionEnabled = YES;
        [self.reduceQuantityButton setImage:[UIImage imageNamed:@"ic_-_nor_60"] forState:UIControlStateNormal];
        [self.addQuantityButton setImage:[UIImage imageNamed:@"ic_+_nor_60"] forState:UIControlStateNormal];
    }
    
    if (self.goodsModel.quantity < self.goodsModel.moq){
        self.minOrderQuantityLabel.textColor = [UIColor redColor];
    }else {
        self.minOrderQuantityLabel.textColor = [UIColor colorWithHex:0xF5BC23];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
