//
//  MakeBillServiceTableViewCell.m
//  YiShangbao
//
//  Created by light on 2018/1/12.
//  Copyright © 2018年 com.Microants. All rights reserved.
//

#import "MakeBillServiceTableViewCell.h"
#import "WYPublicModel.h"

NSString *const MakeBillServiceTableViewCellID = @"MakeBillServiceTableViewCellID";

@interface MakeBillServiceTableViewCell()

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;


@end

@implementation MakeBillServiceTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData:(WYServiceFunctionInfoModel *)model{
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:model.pic]];
    self.titleLabel.text = model.title;
    self.contentLabel.text = model.desc;
}

@end
