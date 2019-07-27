//
//  PurAADVTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/6/7.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "PurAADVTableViewCell.h"
#import "WYAttentionModel.h"

NSString *const PurAADVTableViewCellID = @"PurAADVTableViewCellID";

@interface PurAADVTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UIImageView *picImageView;

@end

@implementation PurAADVTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.layer.cornerRadius = 10.0;
    self.iconImageView.layer.masksToBounds = YES;
    
    self.picImageView.layer.cornerRadius = 2.0;
    self.picImageView.layer.masksToBounds = YES;
    
    self.tagLabel.layer.cornerRadius = 10.0;
    self.tagLabel.layer.masksToBounds = YES;
    self.tagLabel.layer.borderWidth = 0.5;
    self.tagLabel.layer.borderColor = [UIColor colorWithHex:0x999999].CGColor;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(WYAttentionADVModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.aderIcon] placeholderImage:AppPlaceholderShopImage];
    [self.picImageView sd_setImageWithURL:[NSURL URLWithString:model.adPics]];
    self.nameLabel.text = model.aderInfo;
    self.tagLabel.text = [NSString stringWithFormat:@"   %@   ",model.mark];
    self.contentLabel.text = model.adContentInfo;
}

@end
