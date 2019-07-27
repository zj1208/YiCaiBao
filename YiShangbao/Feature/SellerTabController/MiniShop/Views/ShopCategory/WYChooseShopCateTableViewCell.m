//
//  WYChooseShopCateTableViewCell.m
//  YiShangbao
//
//  Created by light on 2017/12/15.
//  Copyright © 2017年 com.Microants. All rights reserved.
//

#import "WYChooseShopCateTableViewCell.h"

@interface WYChooseShopCateTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *categoryNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *goodsCountLabel;


@end

@implementation WYChooseShopCateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(WYShopCategoryInfoModel *)model{
    self.categoryNameLabel.text = model.name;
    self.goodsCountLabel.text = [NSString stringWithFormat:@"%@件产品",model.prods];
    [self changeStatus:model];
}

- (void)changeStatus:(WYShopCategoryInfoModel *)model{
    if (model.isSelected) {
        [self.iconImageView setImage:[UIImage imageNamed:@"ic_shijianzhou_yiwancheng"]];
    }else{
        [self.iconImageView setImage:[UIImage imageNamed:@"ic_choose_nor"]];
    }
}

@end
