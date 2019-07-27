//
//  ShopInfoTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/23.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShopInfoTableViewCell.h"
#import "ShopModel.h"

NSString *const ShopInfoTableViewCellID = @"ShopInfoTableViewCellID";

@interface ShopInfoTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UIImageView *redPointImageView;
@property (weak, nonatomic) IBOutlet UILabel *perfectInfoLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelConstraint;//完善资料Label占宽度

@end

@implementation ShopInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.headImageView.layer.cornerRadius = 20.0;
    self.headImageView.layer.masksToBounds = YES;
    self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    self.redPointImageView.hidden = YES;
    self.perfectInfoLabel.hidden = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateModel:(ShopInfoModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL ossImageWithResizeType:OSSImageResizeType_w100_hX relativeToImgPath:model.iconUrl] placeholderImage:[UIImage imageNamed:@"ic_empty_person"]];
    
    self.nameLabel.text = model.shopName;
    if (model.address.length) {
        self.addressLabel.text = [NSString stringWithFormat:@"地址：%@",model.address];
    }
    self.redPointImageView.hidden = model.shopRed;
    self.perfectInfoLabel.hidden = model.shopRed;
    
    self.labelConstraint.constant = 85 * !model.shopRed;
}

@end
