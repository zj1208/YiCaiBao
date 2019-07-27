//
//  ShareLinkmanTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/4/9.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "ShareLinkmanTableViewCell.h"

#import "WYPublicModel.h"

NSString *const ShareLinkmanTableViewCellID = @"WYShareCollectionViewCellID";

@interface ShareLinkmanTableViewCell ()

@property (weak, nonatomic) IBOutlet UIImageView *selectedImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ShareLinkmanTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.headImageView.layer.cornerRadius = 15.0;
    self.headImageView.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(WYShareLinkmanModel *)model{
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.icon] placeholderImage:AppPlaceholderImage];
    self.nameLabel.text = model.nick;
    if (model.isSelected) {
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_xuanzhongyinhangka"]];
    }else{
        [self.selectedImageView setImage:[UIImage imageNamed:@"ic_weixuanzhongyinhangka"]];
    }
}

@end
