//
//  WYShopCategoryTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/12/14.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYShopCategoryTableViewCell.h"
#import "ProductModel.h"

NSString * const WYShopCategoryTableViewCellID = @"WYShopCategoryTableViewCellID";

@interface WYShopCategoryTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;

@property (weak, nonatomic) IBOutlet UIView *buttonView;

@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) IBOutlet UIButton *extendButton;
@property (weak, nonatomic) IBOutlet UIButton *shiftUpButton;
@property (weak, nonatomic) IBOutlet UIButton *shiftDownButton;

@property (nonatomic) NSInteger index;

@end

@implementation WYShopCategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self changeButtonEdgeInsets:self.editButton];
    [self changeButtonEdgeInsets:self.extendButton];
    [self changeButtonEdgeInsets:self.shiftUpButton];
    [self changeButtonEdgeInsets:self.shiftDownButton];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(WYShopCategoryInfoModel *)model index:(NSInteger)index{
    self.index = index;
    self.categoryNameLabel.text = model.name;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%@件产品",model.prods];
    
    if (index == 0) {
        self.buttonView.hidden = YES;
        self.goodsCountLabel.textColor = [UIColor colorWithHex:0xFF5534];
    }else{
        self.buttonView.hidden = NO;
        self.goodsCountLabel.textColor = [UIColor colorWithHex:0xC2C2C2];
    }
}

- (void)changeButtonEdgeInsets:(UIButton *)button{
    CGFloat spacing = 6.0;
    CGSize imageSize = button.imageView.frame.size;
    CGSize titleSize = button.titleLabel.frame.size;
    button.titleEdgeInsets = UIEdgeInsetsMake(0.0, -imageSize.width, -titleSize.height - spacing, 0.0);
    button.imageEdgeInsets = UIEdgeInsetsMake(-imageSize.height, 0.0, 0.0, -titleSize.width);
}

#pragma mark- ButtonAction

- (IBAction)editButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]) {
        [self.delegate selectedType:ShopCategoryOperationTypeEdit index:self.index];
    }
}

- (IBAction)extendButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]) {
        [self.delegate selectedType:ShopCategoryOperationTypeExtend index:self.index];
    }
}

- (IBAction)shiftUpButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]) {
        [self.delegate selectedType:ShopCategoryOperationTypeShiftUp index:self.index];
    }
}

- (IBAction)shiftDownButtonAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectedType:index:)]) {
        [self.delegate selectedType:ShopCategoryOperationTypeShiftDown index:self.index];
    }
}

@end
